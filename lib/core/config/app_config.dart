/// Environment configuration enum
enum Environment { development, staging, production }

/// App configuration based on environment
class AppConfig {
  final Environment environment;
  final String appName;
  final String baseUrl;
  final bool enableLogging;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final bool enablePerformanceMonitoring;

  const AppConfig._({
    required this.environment,
    required this.appName,
    required this.baseUrl,
    required this.enableLogging,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    required this.enablePerformanceMonitoring,
  });

  /// Development configuration
  static const AppConfig development = AppConfig._(
    environment: Environment.development,
    appName: 'VaultKey Dev',
    baseUrl: 'http://localhost:8080',
    enableLogging: true,
    enableCrashlytics: false,
    enableAnalytics: false,
    enablePerformanceMonitoring: false,
  );

  /// Staging configuration
  static const AppConfig staging = AppConfig._(
    environment: Environment.staging,
    appName: 'VaultKey Staging',
    baseUrl: 'https://staging-api.vaultkey.app',
    enableLogging: true,
    enableCrashlytics: true,
    enableAnalytics: false,
    enablePerformanceMonitoring: true,
  );

  /// Production configuration
  static const AppConfig production = AppConfig._(
    environment: Environment.production,
    appName: 'VaultKey',
    baseUrl: 'https://api.vaultkey.app',
    enableLogging: false,
    enableCrashlytics: true,
    enableAnalytics: true,
    enablePerformanceMonitoring: true,
  );

  /// Check if running in development
  bool get isDevelopment => environment == Environment.development;

  /// Check if running in staging
  bool get isStaging => environment == Environment.staging;

  /// Check if running in production
  bool get isProduction => environment == Environment.production;
}

/// Global app configuration instance
class ConfigProvider {
  static AppConfig _config = AppConfig.development;

  static AppConfig get config => _config;

  static void setConfig(AppConfig config) {
    _config = config;
  }

  static void setEnvironment(Environment environment) {
    switch (environment) {
      case Environment.development:
        _config = AppConfig.development;
        break;
      case Environment.staging:
        _config = AppConfig.staging;
        break;
      case Environment.production:
        _config = AppConfig.production;
        break;
    }
  }
}
