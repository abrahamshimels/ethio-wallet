// lib/routes/auth_guard.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ethio_wallet/core/constants/app_routes.dart';
import 'package:ethio_wallet/features/auth/service/auth_service.dart';

/// Global auth guard (industry standard)
class AuthGuard {
  final AuthService _authService = AuthService();

  /// Correct GoRouter redirect signature
  String? redirect(BuildContext context, GoRouterState state) {
    final bool loggedIn = _authService.isLoggedIn;
    final String currentPath = state.uri.path;

    const authRoutes = [
      AppRoutes.onboarding,
      AppRoutes.signIn,
      AppRoutes.signUp,
      AppRoutes.forgetPassword,
      AppRoutes.verifyEmail,
    ];

    final bool isAuthRoute = authRoutes.contains(currentPath);

    // ❌ Not logged in → block protected routes
    if (!loggedIn && !isAuthRoute) {
      return AppRoutes.signIn;
    }

    // ✅ Logged in → block auth routes
    if (loggedIn && isAuthRoute) {
      return AppRoutes.home;
    }

    return null;
  }
}
