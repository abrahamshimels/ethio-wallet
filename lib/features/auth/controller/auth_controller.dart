import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../service/auth_service.dart';

/// Controller to handle authentication-related operations
class AuthController {
  final AuthService _authService;

  AuthController({AuthService? authService})
    : _authService = authService ?? AuthService();

  /// Stream to listen for authentication state changes
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  /// Current logged-in user
  User? get currentUser => _authService.currentUser;

  /// Log in using email and password
  /// Returns true if login is successful, false otherwise
  Future<bool> login({required String email, required String password}) async {
    try {
      final user = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user != null;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Login error: $e\n$stackTrace');
      }
      return false;
    }
  }

  /// Register a new user
  /// Returns user UID if successful, null otherwise
  Future<String?> register({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.registerWithEmailAndPassword(
        email: email,
        password: password,
      );
      return user?.uid;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Registration error: $e\n$stackTrace');
      }
      return null;
    }
  }

  /// Log out the current user
  Future<void> logout() async {
    try {
      await _authService.signOut();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Logout error: $e\n$stackTrace');
      }
      rethrow; // Let UI handle critical logout failures
    }
  }

  /// Send email verification to the current user
  Future<bool> sendEmailVerification() async {
    try {
      await _authService.sendEmailVerification();
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Email verification error: $e\n$stackTrace');
      }
      return false;
    }
  }

  /// Send password reset email
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email: email);
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Password reset error: $e\n$stackTrace');
      }
      return false;
    }
  }

  /// Update current user's display name
  Future<bool> updateDisplayName(String displayName) async {
    try {
      await _authService.updateDisplayName(displayName);
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Update display name error: $e\n$stackTrace');
      }
      return false;
    }
  }

  /// Update current user's profile photo URL
  Future<bool> updatePhotoURL(String photoURL) async {
    try {
      await _authService.updatePhotoURL(photoURL);
      return true;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Update photo URL error: $e\n$stackTrace');
      }
      return false;
    }
  }

  // =========================
  // GOOGLE SIGN-IN
  // =========================
  /// Log in using Google account
  /// Returns true if login is successful, false otherwise
  Future<bool> loginWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      return user != null;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('Google Sign-In error: $e\n$stackTrace');
      }
      return false;
    }
  }
}
