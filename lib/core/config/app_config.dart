import 'package:flutter/foundation.dart';

import '../../firebase_options.dart';

/// App configuration - Unified for all environments
/// Uses the same Firebase and Supabase configuration across dev, profile, and production
class AppConfig {
  /// App name
  static const String appName = 'VaultKey';

  /// App package identifier
  static const String appId = 'com.auth.vaultkey';

  /// Supabase URL from centralized configuration
  static String get supabaseBaseUrl => SupabaseOptions.supabaseUrl;

  /// Supabase anonymous key from centralized configuration
  static String get supabaseAnonKey => SupabaseOptions.supabaseAnonKey;

  /// Logging is enabled only in debug mode
  static bool get enableLogging => kDebugMode;

  /// Crashlytics is enabled in release mode
  static bool get enableCrashlytics => kReleaseMode;

  /// Analytics is enabled in release mode
  static bool get enableAnalytics => kReleaseMode;

  /// Performance monitoring is enabled in release and profile mode
  static bool get enablePerformanceMonitoring => !kDebugMode;

  /// Check if running in debug mode
  static bool get isDebugMode => kDebugMode;

  /// Check if running in profile mode
  static bool get isProfileMode => kProfileMode;

  /// Check if running in release mode
  static bool get isReleaseMode => kReleaseMode;
}
