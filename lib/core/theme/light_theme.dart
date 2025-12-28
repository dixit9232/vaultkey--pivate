import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'app_typography.dart';

/// Light theme configuration using Material Design 3
class LightTheme {
  LightTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: _colorScheme,
    textTheme: AppTypography.lightTextTheme,
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: _appBarTheme,
    cardTheme: _cardTheme,
    elevatedButtonTheme: _elevatedButtonTheme,
    outlinedButtonTheme: _outlinedButtonTheme,
    textButtonTheme: _textButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
    iconTheme: _iconTheme,
    floatingActionButtonTheme: _fabTheme,
    bottomNavigationBarTheme: _bottomNavTheme,
    dividerTheme: _dividerTheme,
    dialogTheme: _dialogTheme,
    snackBarTheme: _snackBarTheme,
    chipTheme: _chipTheme,
    listTileTheme: _listTileTheme,
    switchTheme: _switchTheme,
    checkboxTheme: _checkboxTheme,
    radioTheme: _radioTheme,
    progressIndicatorTheme: _progressIndicatorTheme,
    pageTransitionsTheme: _pageTransitionsTheme,
  );

  static ColorScheme get _colorScheme => ColorScheme.light(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryLight,
    onPrimaryContainer: AppColors.primaryDark,
    secondary: AppColors.accent,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.accent.withValues(alpha: 0.1),
    onSecondaryContainer: AppColors.accent,
    tertiary: AppColors.info,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error.withValues(alpha: 0.1),
    onErrorContainer: AppColors.error,
    surface: AppColors.surfaceLight,
    onSurface: AppColors.textPrimaryLight,
    surfaceContainerHighest: AppColors.grey100,
    onSurfaceVariant: AppColors.textSecondaryLight,
    outline: AppColors.grey300,
    outlineVariant: AppColors.grey200,
    shadow: AppColors.black.withValues(alpha: 0.1),
  );

  static AppBarTheme get _appBarTheme => const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: true,
    backgroundColor: AppColors.backgroundLight,
    foregroundColor: AppColors.textPrimaryLight,
    iconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    actionsIconTheme: IconThemeData(color: AppColors.textPrimaryLight),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ),
  );

  static CardThemeData get _cardTheme => CardThemeData(
    elevation: 1,
    shadowColor: AppColors.black.withValues(alpha: 0.1),
    color: AppColors.cardLight,
    surfaceTintColor: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    margin: const EdgeInsets.all(8),
  );

  static ElevatedButtonThemeData get _elevatedButtonTheme =>
      ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.grey300,
          disabledForegroundColor: AppColors.grey500,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

  static OutlinedButtonThemeData get _outlinedButtonTheme =>
      OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.grey400,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          minimumSize: const Size(48, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      );

  static TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      disabledForegroundColor: AppColors.grey400,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: const Size(48, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.grey100,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.primary, width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: TextStyle(color: AppColors.grey500),
    prefixIconColor: AppColors.grey600,
    suffixIconColor: AppColors.grey600,
  );

  static IconThemeData get _iconTheme =>
      const IconThemeData(color: AppColors.textPrimaryLight, size: 24);

  static FloatingActionButtonThemeData get _fabTheme =>
      FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.white,
        elevation: 4,
        focusElevation: 6,
        hoverElevation: 8,
        highlightElevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      );

  static BottomNavigationBarThemeData get _bottomNavTheme =>
      const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  static DividerThemeData get _dividerTheme =>
      const DividerThemeData(color: AppColors.grey200, thickness: 1, space: 1);

  static DialogThemeData get _dialogTheme => DialogThemeData(
    backgroundColor: AppColors.surfaceLight,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.grey900,
    contentTextStyle: AppTypography.lightTextTheme.bodyMedium?.copyWith(
      color: AppColors.white,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.grey100,
    selectedColor: AppColors.primary.withValues(alpha: 0.2),
    labelStyle: AppTypography.lightTextTheme.labelMedium,
    secondaryLabelStyle: AppTypography.lightTextTheme.labelMedium,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ListTileThemeData get _listTileTheme => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: Colors.transparent,
    selectedTileColor: AppColors.primary.withValues(alpha: 0.1),
    iconColor: AppColors.grey600,
    textColor: AppColors.textPrimaryLight,
  );

  static SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.white;
      }
      return AppColors.grey400;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey300;
    }),
  );

  static CheckboxThemeData get _checkboxTheme => CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.white),
    side: const BorderSide(color: AppColors.grey400, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );

  static RadioThemeData get _radioTheme => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey400;
    }),
  );

  static ProgressIndicatorThemeData get _progressIndicatorTheme =>
      const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.grey200,
        circularTrackColor: AppColors.grey200,
      );

  static PageTransitionsTheme get _pageTransitionsTheme =>
      const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );
}
