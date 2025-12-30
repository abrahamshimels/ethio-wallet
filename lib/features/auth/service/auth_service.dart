import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Stream to listen to authentication changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// Current logged-in user
  User? get currentUser => _auth.currentUser;

  // =========================
  // EMAIL / PASSWORD METHODS
  // =========================
  Future<User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<User?> registerWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    } else {
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email is already verified or user is not signed in.',
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
    }
  }

  Future<void> updatePhotoURL(String photoURL) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
      await user.reload();
    }
  }

  Future<void> updateEmail(String email) async {
    final user = currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(email);
    }
  }

  Future<void> updatePassword(String password) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePassword(password);
    }
  }

  Future<void> deleteUser() async {
    final user = currentUser;
    if (user != null) {
      await user.delete();
    }
  }

  Future<void> reauthenticate({
    required String email,
    required String password,
  }) async {
    final user = currentUser;
    if (user != null) {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);
    }
  }

  // =========================
  // GOOGLE SIGN-IN (WEB / MOBILE)
  // =========================
  Future<User?> signInWithGoogle() async {
    try {
      // 🌐 Web
      if (kIsWeb) {
        final GoogleAuthProvider provider = GoogleAuthProvider();
        provider.addScope('email');
        provider.setCustomParameters({'prompt': 'select_account'});

        final UserCredential userCredential = await _auth.signInWithPopup(
          provider,
        );
        return userCredential.user;
      }

      // 📱 Android / iOS
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // User cancelled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      // General error (network, popup blocked, etc.)
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    }
  }

  // =========================
  // PRIVATE ERROR HANDLER
  // =========================
  FirebaseAuthException _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return FirebaseAuthException(
          code: e.code,
          message: 'No user found for that email.',
        );
      case 'wrong-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'Incorrect password provided.',
        );
      case 'email-already-in-use':
        return FirebaseAuthException(
          code: e.code,
          message: 'The account already exists for that email.',
        );
      case 'weak-password':
        return FirebaseAuthException(
          code: e.code,
          message: 'The password provided is too weak.',
        );
      default:
        return e;
    }
  }
}
