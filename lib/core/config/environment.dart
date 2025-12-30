import 'package:flutter/foundation.dart';

/// Environment types for the application
enum Environment {
  /// Development environment - for local development and testing
  development,

  /// Production environment - for live app store releases
  production,
}

/// Environment configuration for VaultKey
///
/// This class manages environment-specific settings for Firebase, Supabase,
/// feature flags, and other configuration values.
///
/// Usage:
/// ```dart
/// // Set environment at app startup (main.dart)
/// EnvironmentConfig.setEnvironment(Environment.development);
///
/// // Access configuration values
/// if (EnvironmentConfig.isDevelopment) {
///   // Development-only code
/// }
/// ```
class EnvironmentConfig {
  static Environment _current = Environment.development;

  /// Current environment
  static Environment get current => _current;

  /// Set the current environment (call this in main.dart before runApp)
  static void setEnvironment(Environment env) {
    _current = env;
  }

  /// Initialize environment from build-time configuration
  ///
  /// Use with: `flutter run --dart-define=ENVIRONMENT=production`
  static void initFromBuildConfig() {
    const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    _current = envString == 'production' ? Environment.production : Environment.development;
  }

  // ============================================
  // Environment Checks
  // ============================================

  /// Check if running in development environment
  static bool get isDevelopment => _current == Environment.development;

  /// Check if running in production environment
  static bool get isProduction => _current == Environment.production;

  /// Check if running in debug mode (Flutter's kDebugMode)
  static bool get isDebugMode => kDebugMode;

  /// Check if running in release mode (Flutter's kReleaseMode)
  static bool get isReleaseMode => kReleaseMode;

  /// Check if running in profile mode (Flutter's kProfileMode)
  static bool get isProfileMode => kProfileMode;

  // ============================================
  // Firebase Configuration
  // ============================================

  /// Firebase project ID for current environment
  /// Uses vaultkey-616bf for both dev and prod (single Firebase project)
  static String get firebaseProjectId {
    switch (_current) {
      case Environment.development:
        return 'vaultkey-616bf'; // Development uses same project
      case Environment.production:
        return 'vaultkey-616bf'; // Production Firebase project
    }
  }

  /// Whether to use Firebase Local Emulator Suite (dev only)
  static bool get useFirebaseEmulator => isDevelopment && const bool.fromEnvironment('USE_EMULATOR', defaultValue: false);

  /// Firebase emulator host (for local development)
  static String get firebaseEmulatorHost => 'localhost';

  /// Firestore emulator port
  static int get firestoreEmulatorPort => 8080;

  /// Firebase Auth emulator port
  static int get authEmulatorPort => 9099;

  /// Firebase Storage emulator port
  static int get storageEmulatorPort => 9199;

  // ============================================
  // Supabase Configuration
  // ============================================

  /// Supabase project URL for current environment
  /// Uses ejigscnhdcphprouthub.supabase.co for both environments
  static String get supabaseUrl {
    switch (_current) {
      case Environment.development:
        return const String.fromEnvironment('SUPABASE_DEV_URL', defaultValue: 'https://ejigscnhdcphprouthub.supabase.co');
      case Environment.production:
        return const String.fromEnvironment('SUPABASE_PROD_URL', defaultValue: 'https://ejigscnhdcphprouthub.supabase.co');
    }
  }

  /// Supabase anonymous key for current environment
  static String get supabaseAnonKey {
    switch (_current) {
      case Environment.development:
        return const String.fromEnvironment('SUPABASE_DEV_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqaWdzY25oZGNwaHByb3V0aHViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1OTIyNDgsImV4cCI6MjA4MjE2ODI0OH0.JSv_VTIk0v9QZp7KrjwXf0xr2C0fx-w_5QunYAR92co');
      case Environment.production:
        return const String.fromEnvironment('SUPABASE_PROD_ANON_KEY', defaultValue: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVqaWdzY25oZGNwaHByb3V0aHViIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjY1OTIyNDgsImV4cCI6MjA4MjE2ODI0OH0.JSv_VTIk0v9QZp7KrjwXf0xr2C0fx-w_5QunYAR92co');
    }
  }

  // ============================================
  // Feature Flags
  // ============================================

  /// Enable verbose logging (dev only)
  static bool get enableLogging => isDevelopment || kDebugMode;

  /// Enable Crashlytics crash reporting (prod only)
  static bool get enableCrashlytics => isProduction && kReleaseMode;

  /// Enable Firebase Analytics (prod only)
  static bool get enableAnalytics => isProduction;

  /// Enable Performance Monitoring (prod only)
  static bool get enablePerformanceMonitoring => isProduction;

  /// Enable Remote Config (both environments, different configs)
  static bool get enableRemoteConfig => true;

  /// Enable certificate pinning (prod only for security)
  static bool get enableCertificatePinning => isProduction;

  // ============================================
  // In-App Purchase Configuration
  // ============================================

  /// Whether to use sandbox/test environment for IAP
  static bool get iapSandboxMode => isDevelopment;

  /// Enable IAP debug logging
  static bool get enableIAPLogging => isDevelopment;

  /// Verify receipts on server (always true, but different endpoints per env)
  static bool get verifyReceiptsOnServer => true;

  // ============================================
  // API & Network Configuration
  // ============================================

  /// API request timeout duration
  static Duration get apiTimeout => const Duration(seconds: 30);

  /// Connection timeout duration
  static Duration get connectionTimeout => const Duration(seconds: 15);

  /// Maximum retry attempts for failed requests
  static int get maxRetryAttempts => isDevelopment ? 1 : 3;

  // ============================================
  // Security Configuration
  // ============================================

  /// Session timeout duration (user)
  static Duration get userSessionTimeout => const Duration(minutes: 5);

  /// Session timeout duration (admin)
  static Duration get adminSessionTimeout => const Duration(minutes: 30);

  /// Biometric authentication timeout
  static Duration get biometricTimeout => const Duration(seconds: 30);

  /// Maximum failed login attempts before lockout
  static int get maxFailedLoginAttempts => 5;

  /// Initial lockout duration (after 5 failed attempts)
  static Duration get initialLockoutDuration => const Duration(seconds: 30);

  /// Extended lockout duration (after 10 failed attempts)
  static Duration get extendedLockoutDuration => const Duration(minutes: 5);

  // ============================================
  // Debug & Development Tools
  // ============================================

  /// Show debug banner
  static bool get showDebugBanner => isDevelopment;

  /// Enable Flutter DevTools
  static bool get enableDevTools => isDevelopment;

  /// Enable network request logging
  static bool get enableNetworkLogging => isDevelopment;

  /// Enable BLoC observer for state debugging
  static bool get enableBlocObserver => isDevelopment;

  // ============================================
  // App Information
  // ============================================

  /// App name
  static String get appName => 'VaultKey';

  /// App identifier
  static String get appId => 'com.auth.vaultkey';

  /// Environment display name (for debugging)
  static String get environmentName {
    switch (_current) {
      case Environment.development:
        return 'Development';
      case Environment.production:
        return 'Production';
    }
  }

  /// Get a summary of current configuration (for debugging)
  static Map<String, dynamic> get configSummary => {
    'environment': environmentName,
    'isDebugMode': isDebugMode,
    'isReleaseMode': isReleaseMode,
    'enableLogging': enableLogging,
    'enableCrashlytics': enableCrashlytics,
    'enableAnalytics': enableAnalytics,
    'iapSandboxMode': iapSandboxMode,
    'firebaseProjectId': firebaseProjectId,
  };
}
