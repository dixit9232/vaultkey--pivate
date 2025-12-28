/// App-wide constants
class AppConstants {
  AppConstants._();

  // App Information
  static const String appName = 'VaultKey';
  static const String appVersion = '1.0.0';
  static const String packageName = 'com.auth.vaultkey';

  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration otpValidDuration = Duration(seconds: 30);
  static const Duration clipboardClearDuration = Duration(seconds: 30);
  static const Duration sessionTimeout = Duration(minutes: 5);

  // Limits
  static const int maxLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;
  static const int maxAuthenticators = 100;
  static const int otpDigits = 6;
  static const int otpPeriod = 30;

  // Storage Keys
  static const String encryptionKeyAlias = 'vaultkey_master_key';
  static const String themePreferenceKey = 'theme_mode';
  static const String localePreferenceKey = 'locale';
  static const String biometricEnabledKey = 'biometric_enabled';
  static const String firstLaunchKey = 'first_launch';

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 300);
  static const Duration longAnimation = Duration(milliseconds: 500);

  // Touch Targets
  static const double minTouchTarget = 48.0;

  // Breakpoints
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1200;
}
