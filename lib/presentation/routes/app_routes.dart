/// Route path constants
class AppRoutes {
  AppRoutes._();

  // Root routes
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String home = '/home';

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String verifyEmail = '/verify-email';

  // Main app routes
  static const String authenticators = '/authenticators';
  static const String addAuthenticator = '/authenticators/add';
  static const String scanQR = '/authenticators/scan';
  static const String manualEntry = '/authenticators/manual';
  static const String authenticatorDetails = '/authenticators/:id';

  // Settings routes
  static const String settings = '/settings';
  static const String appearance = '/settings/appearance';
  static const String security = '/settings/security';
  static const String backup = '/settings/backup';
  static const String about = '/settings/about';
  static const String profile = '/settings/profile';

  // Lock screen
  static const String lockScreen = '/lock';
  static const String biometric = '/biometric';
}

/// Route names for named navigation
class RouteNames {
  RouteNames._();

  static const String splash = 'splash';
  static const String onboarding = 'onboarding';
  static const String home = 'home';
  static const String login = 'login';
  static const String register = 'register';
  static const String forgotPassword = 'forgotPassword';
  static const String authenticators = 'authenticators';
  static const String addAuthenticator = 'addAuthenticator';
  static const String scanQR = 'scanQR';
  static const String manualEntry = 'manualEntry';
  static const String authenticatorDetails = 'authenticatorDetails';
  static const String settings = 'settings';
  static const String appearance = 'appearance';
  static const String security = 'security';
  static const String backup = 'backup';
  static const String about = 'about';
  static const String profile = 'profile';
  static const String lockScreen = 'lockScreen';
  static const String biometric = 'biometric';
}
