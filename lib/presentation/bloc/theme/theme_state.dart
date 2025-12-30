import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Theme mode options
enum AppThemeMode {
  /// Follow system theme
  system,

  /// Always use light theme
  light,

  /// Always use dark theme
  dark,
}

/// Theme state
class ThemeState extends Equatable {
  /// Current theme mode
  final AppThemeMode themeMode;

  /// Current brightness resolved from theme mode and system
  final Brightness brightness;

  /// Whether using high contrast
  final bool highContrast;

  /// Primary color seed
  final Color primaryColor;

  /// Whether dynamic colors are enabled (Material You)
  final bool dynamicColorsEnabled;

  const ThemeState({this.themeMode = AppThemeMode.system, this.brightness = Brightness.light, this.highContrast = false, this.primaryColor = const Color(0xFF6750A4), this.dynamicColorsEnabled = true});

  /// Get Flutter ThemeMode from AppThemeMode
  ThemeMode get flutterThemeMode {
    switch (themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  /// Check if dark mode is active
  bool get isDarkMode => brightness == Brightness.dark;

  ThemeState copyWith({AppThemeMode? themeMode, Brightness? brightness, bool? highContrast, Color? primaryColor, bool? dynamicColorsEnabled}) {
    return ThemeState(themeMode: themeMode ?? this.themeMode, brightness: brightness ?? this.brightness, highContrast: highContrast ?? this.highContrast, primaryColor: primaryColor ?? this.primaryColor, dynamicColorsEnabled: dynamicColorsEnabled ?? this.dynamicColorsEnabled);
  }

  @override
  List<Object?> get props => [themeMode, brightness, highContrast, primaryColor, dynamicColorsEnabled];
}
