import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:ethio_wallet/core/network/api_client.dart';
import 'package:ethio_wallet/core/storage/token_storage.dart';



class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TokenStorage _tokenStorage = TokenStorage();

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

      final user = result.user;
      await _logAuthSuccess(user, method: 'email/password');
      if (user != null) await _syncWithBackend(user);

      return user;
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

      final user = result.user;
      await _logAuthSuccess(user, method: 'email/password (register)');
      if (user != null) await _syncWithBackend(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      debugPrint('🚪 User signed out');
    }
    await _auth.signOut();
    await _tokenStorage.deleteToken();
  }

  Future<void> sendEmailVerification() async {
    final user = currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
      if (kDebugMode) {
        debugPrint('📧 Verification email sent to ${user.email}');
      }
    } else {
      throw FirebaseAuthException(
        code: 'email-already-verified',
        message: 'Email is already verified or user is not signed in.',
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    await _auth.sendPasswordResetEmail(email: email);
    if (kDebugMode) {
      debugPrint('🔑 Password reset email sent to $email');
    }
  }

  Future<void> updateDisplayName(String displayName) async {
    final user = currentUser;
    if (user != null) {
      await user.updateDisplayName(displayName);
      await user.reload();
      if (kDebugMode) {
        debugPrint('✏️ Display name updated: $displayName');
      }
    }
  }

  Future<void> updatePhotoURL(String photoURL) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePhotoURL(photoURL);
      await user.reload();
      if (kDebugMode) {
        debugPrint('🖼️ Photo URL updated');
      }
    }
  }

  Future<void> updateEmail(String email) async {
    final user = currentUser;
    if (user != null) {
      await user.verifyBeforeUpdateEmail(email);
      if (kDebugMode) {
        debugPrint('📧 Email update verification sent to $email');
      }
    }
  }

  Future<void> updatePassword(String password) async {
    final user = currentUser;
    if (user != null) {
      await user.updatePassword(password);
      if (kDebugMode) {
        debugPrint('🔐 Password updated');
      }
    }
  }

  Future<void> deleteUser() async {
    final user = currentUser;
    if (user != null) {
      await user.delete();
      if (kDebugMode) {
        debugPrint('🗑️ User deleted: ${user.uid}');
      }
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
      if (kDebugMode) {
        debugPrint('🔁 User re-authenticated');
      }
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

        final user = userCredential.user;
        await _logAuthSuccess(user, method: 'google (web)');
        if (user != null) await _syncWithBackend(user);

        return user;
      }

      // 📱 Android / iOS
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        if (kDebugMode) {
          debugPrint('❌ Google sign-in cancelled by user');
        }
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

      final user = userCredential.user;
      await _logAuthSuccess(user, method: 'google (mobile)');
      if (user != null) await _syncWithBackend(user);

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    } catch (e) {
      throw FirebaseAuthException(
        code: 'google-sign-in-failed',
        message: e.toString(),
      );
    }
  }

  bool get isLoggedIn => FirebaseAuth.instance.currentUser != null;

  // =========================
  // BACKEND SYNC
  // =========================
  Future<void> _syncWithBackend(User user) async {
    try {
      final idToken = await user.getIdToken();
      
      final response = await ApiClient.dio.post(
        '/auth/exchange',
        data: {'firebaseToken': idToken},
      );

      final token = response.data['token'];
      if (token != null) {
        await _tokenStorage.saveToken(token);
        if (kDebugMode) {
          debugPrint('✅ Backend token synced and stored');
        }
      }
    } catch (e) {
      debugPrint('❌ Backend sync failed: $e');
      // Optional: signOut if backend sync fails to enforce consistency
      // await signOut();
      rethrow;
    }
  }

  // =========================
  // PRIVATE HELPERS
  // =========================
  Future<void> _logAuthSuccess(User? user, {required String method}) async {
    if (user == null || !kDebugMode) return;

    final token = await user.getIdToken();

    debugPrint('✅ Auth success via $method');
    debugPrint('👤 uid: ${user.uid}');
    debugPrint('📧 email: ${user.email}');
    debugPrint('🔑 provider: ${user.providerData.map((p) => p.providerId)}');
    debugPrint('🔥 Firebase ID Token:\n$token');
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
