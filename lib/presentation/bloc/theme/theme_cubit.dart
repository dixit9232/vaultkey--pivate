import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/local/local_datasource.dart';
import 'theme_state.dart';

/// Keys for theme storage
class ThemeKeys {
  static const String themeMode = 'theme_mode';
  static const String highContrast = 'high_contrast';
  static const String primaryColor = 'primary_color';
  static const String dynamicColors = 'dynamic_colors';
}

/// Cubit for managing app theme
class ThemeCubit extends Cubit<ThemeState> {
  final LocalDataSource? _localDataSource;

  ThemeCubit({LocalDataSource? localDataSource}) : _localDataSource = localDataSource, super(const ThemeState());

  /// Initialize theme from storage and system
  Future<void> initTheme() async {
    try {
      if (_localDataSource != null) {
        final themeModeStr = await _localDataSource.getSecureValue(ThemeKeys.themeMode);
        final highContrastStr = await _localDataSource.getSecureValue(ThemeKeys.highContrast);
        final primaryColorStr = await _localDataSource.getSecureValue(ThemeKeys.primaryColor);
        final dynamicColorsStr = await _localDataSource.getSecureValue(ThemeKeys.dynamicColors);

        final themeMode = _parseThemeMode(themeModeStr);
        final brightness = _resolveBrightness(themeMode);

        emit(state.copyWith(themeMode: themeMode, brightness: brightness, highContrast: highContrastStr == 'true', primaryColor: primaryColorStr != null ? Color(int.parse(primaryColorStr)) : const Color(0xFF6750A4), dynamicColorsEnabled: dynamicColorsStr != 'false'));
      } else {
        // Use system brightness
        final brightness = _resolveBrightness(AppThemeMode.system);
        emit(state.copyWith(brightness: brightness));
      }
    } catch (e) {
      // Use defaults on error
      final brightness = _resolveBrightness(AppThemeMode.system);
      emit(state.copyWith(brightness: brightness));
    }
  }

  /// Set theme mode
  Future<void> setThemeMode(AppThemeMode mode) async {
    final brightness = _resolveBrightness(mode);
    emit(state.copyWith(themeMode: mode, brightness: brightness));

    try {
      await _localDataSource?.setSecureValue(ThemeKeys.themeMode, mode.name);
    } catch (_) {
      // Ignore save errors
    }
  }

  /// Toggle between light and dark mode
  Future<void> toggleTheme() async {
    final newMode = state.themeMode == AppThemeMode.light ? AppThemeMode.dark : AppThemeMode.light;
    await setThemeMode(newMode);
  }

  /// Set high contrast mode
  Future<void> setHighContrast(bool enabled) async {
    emit(state.copyWith(highContrast: enabled));

    try {
      await _localDataSource?.setSecureValue(ThemeKeys.highContrast, enabled.toString());
    } catch (_) {
      // Ignore save errors
    }
  }

  /// Set primary color
  Future<void> setPrimaryColor(Color color) async {
    emit(state.copyWith(primaryColor: color));

    try {
      await _localDataSource?.setSecureValue(ThemeKeys.primaryColor, color.value.toString());
    } catch (_) {
      // Ignore save errors
    }
  }

  /// Set dynamic colors enabled
  Future<void> setDynamicColorsEnabled(bool enabled) async {
    emit(state.copyWith(dynamicColorsEnabled: enabled));

    try {
      await _localDataSource?.setSecureValue(ThemeKeys.dynamicColors, enabled.toString());
    } catch (_) {
      // Ignore save errors
    }
  }

  /// Update brightness based on system change (for system mode)
  void onSystemBrightnessChanged() {
    if (state.themeMode == AppThemeMode.system) {
      final brightness = _resolveBrightness(AppThemeMode.system);
      emit(state.copyWith(brightness: brightness));
    }
  }

  /// Parse theme mode from string
  AppThemeMode _parseThemeMode(String? value) {
    switch (value) {
      case 'light':
        return AppThemeMode.light;
      case 'dark':
        return AppThemeMode.dark;
      default:
        return AppThemeMode.system;
    }
  }

  /// Resolve brightness from theme mode
  Brightness _resolveBrightness(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return Brightness.light;
      case AppThemeMode.dark:
        return Brightness.dark;
      case AppThemeMode.system:
        return SchedulerBinding.instance.platformDispatcher.platformBrightness;
    }
  }
}
