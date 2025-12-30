import 'package:ethio_wallet/features/auth/ui/forget_password.dart';
import 'package:ethio_wallet/features/auth/ui/verify-email.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/constants/app_routes.dart';
import '../core/widgets/bottom_nav.dart';
import '../features/auth/ui/sign_in_page.dart';
import '../features/auth/ui/sign_up_page.dart';
import '../features/exchange/ui/exchange_page.dart';
import '../features/home/ui/home_page.dart';
import '../features/onboarding/ui/onboarding_page.dart';
import '../features/profile/ui/edit_profile_page.dart';
import '../features/profile/ui/profile_page.dart';
import '../features/wallet/ui/wallet_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.onboarding,
  routes: [
    GoRoute(
      path: AppRoutes.onboarding,
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: AppRoutes.signIn,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: AppRoutes.verifyEmail,
      builder: (context, state) => const VerifyEmailPage(),
    ),
    GoRoute(
      path: AppRoutes.forgetPassword,
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    StatefulShellRoute.indexedStack(
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state, navigationShell) =>
          BottomNavScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          navigatorKey: _shellNavigatorKey,
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.exchange,
              builder: (context, state) => const ExchangePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.wallet,
              builder: (context, state) => const WalletPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) =>  ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  builder: (context, state) => const EditProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
