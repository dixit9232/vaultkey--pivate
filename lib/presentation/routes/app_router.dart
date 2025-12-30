import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/auth/email_verification_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/authenticator/add_authenticator_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/scanner/qr_scanner_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/splash/splash_screen.dart';
import 'app_routes.dart';

/// App router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

  /// GoRouter instance
  static final GoRouter router = GoRouter(navigatorKey: _rootNavigatorKey, initialLocation: AppRoutes.splash, debugLogDiagnostics: true, routes: _routes, errorBuilder: _errorBuilder, redirect: _redirect);

  /// All app routes
  static final List<RouteBase> _routes = [
    // Splash screen
    GoRoute(path: AppRoutes.splash, name: RouteNames.splash, builder: (context, state) => const SplashScreen()),

    // Onboarding screen
    GoRoute(path: AppRoutes.onboarding, name: RouteNames.onboarding, builder: (context, state) => const OnboardingScreen()),

    // Auth routes
    GoRoute(path: AppRoutes.login, name: RouteNames.login, builder: (context, state) => const LoginScreen()),
    GoRoute(path: AppRoutes.register, name: RouteNames.register, builder: (context, state) => const RegisterScreen()),
    GoRoute(path: AppRoutes.forgotPassword, name: RouteNames.forgotPassword, builder: (context, state) => const ForgotPasswordScreen()),
    GoRoute(path: AppRoutes.emailVerification, name: RouteNames.emailVerification, builder: (context, state) => const EmailVerificationScreen()),

    // Home screen
    GoRoute(path: AppRoutes.home, name: RouteNames.home, builder: (context, state) => const HomeScreen()),

    // Authenticator routes
    GoRoute(path: AppRoutes.addAuthenticator, name: RouteNames.addAuthenticator, builder: (context, state) => const AddAuthenticatorScreen()),
    GoRoute(path: AppRoutes.scanQR, name: RouteNames.scanQR, builder: (context, state) => const QRScannerScreen()),

    // Settings routes
    GoRoute(path: AppRoutes.settings, name: RouteNames.settings, builder: (context, state) => const SettingsScreen()),
  ];

  /// Error page builder
  static Widget _errorBuilder(BuildContext context, GoRouterState state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.uri.toString(), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: () => context.go(AppRoutes.home), child: const Text('Go Home')),
          ],
        ),
      ),
    );
  }

  /// Global redirect logic
  static String? _redirect(BuildContext context, GoRouterState state) {
    // TODO: Implement auth state checking
    // final isLoggedIn = authBloc.state.isAuthenticated;
    // final isLoggingIn = state.matchedLocation == AppRoutes.login;
    // final isRegistering = state.matchedLocation == AppRoutes.register;
    // final isSplash = state.matchedLocation == AppRoutes.splash;
    //
    // if (!isLoggedIn && !isLoggingIn && !isRegistering && !isSplash) {
    //   return AppRoutes.login;
    // }
    //
    // if (isLoggedIn && (isLoggingIn || isRegistering)) {
    //   return AppRoutes.home;
    // }

    return null;
  }
}
