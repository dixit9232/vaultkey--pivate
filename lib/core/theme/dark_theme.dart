import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';
import 'app_typography.dart';

/// Dark theme configuration using Material Design 3
class DarkTheme {
  DarkTheme._();

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: _colorScheme,
    textTheme: AppTypography.darkTextTheme,
    scaffoldBackgroundColor: AppColors.backgroundDark,
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

  static ColorScheme get _colorScheme => ColorScheme.dark(
    primary: AppColors.primary,
    onPrimary: AppColors.white,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.primaryLight,
    secondary: AppColors.accent,
    onSecondary: AppColors.white,
    secondaryContainer: AppColors.accent.withValues(alpha: 0.2),
    onSecondaryContainer: AppColors.accent,
    tertiary: AppColors.info,
    onTertiary: AppColors.white,
    error: AppColors.error,
    onError: AppColors.white,
    errorContainer: AppColors.error.withValues(alpha: 0.2),
    onErrorContainer: AppColors.error,
    surface: AppColors.surfaceDark,
    onSurface: AppColors.textPrimaryDark,
    surfaceContainerHighest: AppColors.grey800,
    onSurfaceVariant: AppColors.textSecondaryDark,
    outline: AppColors.grey600,
    outlineVariant: AppColors.grey700,
    shadow: AppColors.black.withValues(alpha: 0.3),
  );

  static AppBarTheme get _appBarTheme => const AppBarTheme(
    elevation: 0,
    scrolledUnderElevation: 1,
    centerTitle: true,
    backgroundColor: AppColors.backgroundDark,
    foregroundColor: AppColors.textPrimaryDark,
    iconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    actionsIconTheme: IconThemeData(color: AppColors.textPrimaryDark),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  static CardThemeData get _cardTheme => CardThemeData(
    elevation: 2,
    shadowColor: AppColors.black.withValues(alpha: 0.3),
    color: AppColors.cardDark,
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
          disabledBackgroundColor: AppColors.grey700,
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
          disabledForegroundColor: AppColors.grey600,
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
      disabledForegroundColor: AppColors.grey600,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      minimumSize: const Size(48, 48),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.grey800,
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
    prefixIconColor: AppColors.grey400,
    suffixIconColor: AppColors.grey400,
  );

  static IconThemeData get _iconTheme =>
      const IconThemeData(color: AppColors.textPrimaryDark, size: 24);

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
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey500,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        showSelectedLabels: true,
        showUnselectedLabels: true,
      );

  static DividerThemeData get _dividerTheme =>
      const DividerThemeData(color: AppColors.grey700, thickness: 1, space: 1);

  static DialogThemeData get _dialogTheme => DialogThemeData(
    backgroundColor: AppColors.surfaceDark,
    elevation: 8,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
  );

  static SnackBarThemeData get _snackBarTheme => SnackBarThemeData(
    backgroundColor: AppColors.grey100,
    contentTextStyle: AppTypography.darkTextTheme.bodyMedium?.copyWith(
      color: AppColors.black,
    ),
    behavior: SnackBarBehavior.floating,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  );

  static ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.grey800,
    selectedColor: AppColors.primary.withValues(alpha: 0.3),
    labelStyle: AppTypography.darkTextTheme.labelMedium,
    secondaryLabelStyle: AppTypography.darkTextTheme.labelMedium,
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  static ListTileThemeData get _listTileTheme => ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    tileColor: Colors.transparent,
    selectedTileColor: AppColors.primary.withValues(alpha: 0.2),
    iconColor: AppColors.grey400,
    textColor: AppColors.textPrimaryDark,
  );

  static SwitchThemeData get _switchTheme => SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.white;
      }
      return AppColors.grey600;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey700;
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
    side: const BorderSide(color: AppColors.grey500, width: 2),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  );

  static RadioThemeData get _radioTheme => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.primary;
      }
      return AppColors.grey500;
    }),
  );

  static ProgressIndicatorThemeData get _progressIndicatorTheme =>
      const ProgressIndicatorThemeData(
        color: AppColors.primary,
        linearTrackColor: AppColors.grey700,
        circularTrackColor: AppColors.grey700,
      );

  static PageTransitionsTheme get _pageTransitionsTheme =>
      const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      );
}
