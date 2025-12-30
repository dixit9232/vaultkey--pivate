import 'package:equatable/equatable.dart';

/// App settings state
class SettingsState extends Equatable {
  /// Selected language code
  final String languageCode;

  /// Whether biometric authentication is enabled
  final bool biometricEnabled;

  /// Whether auto-lock is enabled
  final bool autoLockEnabled;

  /// Auto-lock timeout in seconds
  final int autoLockTimeout;

  /// Whether to show OTP codes on the main screen
  final bool showOtpCodes;

  /// Whether to copy OTP code on tap
  final bool copyOnTap;

  /// Whether haptic feedback is enabled
  final bool hapticFeedbackEnabled;

  /// Whether notifications are enabled
  final bool notificationsEnabled;

  /// Whether screenshot protection is enabled
  final bool screenshotProtectionEnabled;

  /// Whether the settings are loading
  final bool isLoading;

  /// Error message if any
  final String? errorMessage;

  /// Success message if any
  final String? successMessage;

  const SettingsState({
    this.languageCode = 'en',
    this.biometricEnabled = false,
    this.autoLockEnabled = true,
    this.autoLockTimeout = 60,
    this.showOtpCodes = true,
    this.copyOnTap = true,
    this.hapticFeedbackEnabled = true,
    this.notificationsEnabled = true,
    this.screenshotProtectionEnabled = true,
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
  });

  /// Get auto-lock timeout label
  String get autoLockTimeoutLabel {
    if (autoLockTimeout < 60) {
      return '$autoLockTimeout seconds';
    } else if (autoLockTimeout == 60) {
      return '1 minute';
    } else {
      return '${autoLockTimeout ~/ 60} minutes';
    }
  }

  SettingsState copyWith({
    String? languageCode,
    bool? biometricEnabled,
    bool? autoLockEnabled,
    int? autoLockTimeout,
    bool? showOtpCodes,
    bool? copyOnTap,
    bool? hapticFeedbackEnabled,
    bool? notificationsEnabled,
    bool? screenshotProtectionEnabled,
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return SettingsState(
      languageCode: languageCode ?? this.languageCode,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      autoLockEnabled: autoLockEnabled ?? this.autoLockEnabled,
      autoLockTimeout: autoLockTimeout ?? this.autoLockTimeout,
      showOtpCodes: showOtpCodes ?? this.showOtpCodes,
      copyOnTap: copyOnTap ?? this.copyOnTap,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      screenshotProtectionEnabled: screenshotProtectionEnabled ?? this.screenshotProtectionEnabled,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [languageCode, biometricEnabled, autoLockEnabled, autoLockTimeout, showOtpCodes, copyOnTap, hapticFeedbackEnabled, notificationsEnabled, screenshotProtectionEnabled, isLoading, errorMessage, successMessage];
}
