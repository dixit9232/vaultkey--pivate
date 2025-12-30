import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local/local_datasource.dart';
import 'settings_state.dart';

/// Keys for secure storage settings
class SettingsKeys {
  static const String biometricEnabled = 'biometric_enabled';
  static const String autoLockEnabled = 'auto_lock_enabled';
  static const String autoLockTimeout = 'auto_lock_timeout';
  static const String languageCode = 'language_code';
  static const String showOtpCodes = 'show_otp_codes';
  static const String copyOnTap = 'copy_on_tap';
  static const String hapticFeedback = 'haptic_feedback';
  static const String notifications = 'notifications';
  static const String screenshotProtection = 'screenshot_protection';
}

/// Cubit for managing app settings
class SettingsCubit extends Cubit<SettingsState> {
  final LocalDataSource? _localDataSource;

  SettingsCubit({LocalDataSource? localDataSource}) : _localDataSource = localDataSource, super(const SettingsState());

  /// Load settings from local storage
  Future<void> loadSettings() async {
    emit(state.copyWith(isLoading: true));

    try {
      if (_localDataSource != null) {
        final biometricEnabled = await _localDataSource.getSecureValue(SettingsKeys.biometricEnabled);
        final autoLockEnabled = await _localDataSource.getSecureValue(SettingsKeys.autoLockEnabled);
        final autoLockTimeout = await _localDataSource.getSecureValue(SettingsKeys.autoLockTimeout);
        final languageCode = await _localDataSource.getSecureValue(SettingsKeys.languageCode);

        emit(state.copyWith(isLoading: false, biometricEnabled: biometricEnabled == 'true', autoLockEnabled: autoLockEnabled != 'false', autoLockTimeout: int.tryParse(autoLockTimeout ?? '60') ?? 60, languageCode: languageCode ?? 'en'));
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load settings: $e'));
    }
  }

  /// Update language
  Future<void> setLanguage(String languageCode) async {
    emit(state.copyWith(languageCode: languageCode, clearSuccess: true));

    try {
      await _localDataSource?.setSecureValue(SettingsKeys.languageCode, languageCode);
      emit(state.copyWith(successMessage: 'Language updated'));
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save language'));
    }
  }

  /// Toggle biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    emit(state.copyWith(biometricEnabled: enabled, clearSuccess: true));

    try {
      await _localDataSource?.setSecureValue(SettingsKeys.biometricEnabled, enabled.toString());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save biometric setting'));
    }
  }

  /// Toggle auto-lock
  Future<void> setAutoLockEnabled(bool enabled) async {
    emit(state.copyWith(autoLockEnabled: enabled, clearSuccess: true));

    try {
      await _localDataSource?.setSecureValue(SettingsKeys.autoLockEnabled, enabled.toString());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save auto-lock setting'));
    }
  }

  /// Set auto-lock timeout
  Future<void> setAutoLockTimeout(int seconds) async {
    emit(state.copyWith(autoLockTimeout: seconds, clearSuccess: true));

    try {
      await _localDataSource?.setSecureValue(SettingsKeys.autoLockTimeout, seconds.toString());
    } catch (e) {
      emit(state.copyWith(errorMessage: 'Failed to save auto-lock timeout'));
    }
  }

  /// Toggle show OTP codes
  void setShowOtpCodes(bool enabled) {
    emit(state.copyWith(showOtpCodes: enabled));
  }

  /// Toggle copy on tap
  void setCopyOnTap(bool enabled) {
    emit(state.copyWith(copyOnTap: enabled));
  }

  /// Toggle haptic feedback
  void setHapticFeedbackEnabled(bool enabled) {
    emit(state.copyWith(hapticFeedbackEnabled: enabled));
  }

  /// Toggle notifications
  void setNotificationsEnabled(bool enabled) {
    emit(state.copyWith(notificationsEnabled: enabled));
  }

  /// Toggle screenshot protection
  void setScreenshotProtectionEnabled(bool enabled) {
    emit(state.copyWith(screenshotProtectionEnabled: enabled));
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  /// Clear success message
  void clearSuccess() {
    emit(state.copyWith(clearSuccess: true));
  }
}
