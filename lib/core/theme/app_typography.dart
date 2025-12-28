import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

/// App typography using Google Fonts
/// Headers: Montserrat (Bold/SemiBold)
/// Body: Inter (Regular/Medium)
/// Monospace: JetBrains Mono (for OTP codes)
class AppTypography {
  AppTypography._();

  // Base text styles
  static TextStyle get _baseTextStyle => GoogleFonts.inter();
  static TextStyle get _headerTextStyle => GoogleFonts.montserrat();
  static TextStyle get _monoTextStyle => GoogleFonts.jetBrainsMono();

  // Light Theme Typography
  static TextTheme get lightTextTheme => TextTheme(
    // Display styles
    displayLarge: _headerTextStyle.copyWith(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
      letterSpacing: -0.25,
    ),
    displayMedium: _headerTextStyle.copyWith(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryLight,
    ),
    displaySmall: _headerTextStyle.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),

    // Headline styles
    headlineLarge: _headerTextStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    headlineMedium: _headerTextStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    headlineSmall: _headerTextStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),

    // Title styles
    titleLarge: _headerTextStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryLight,
    ),
    titleMedium: _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.15,
    ),
    titleSmall: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.1,
    ),

    // Body styles
    bodyLarge: _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.5,
    ),
    bodyMedium: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.25,
    ),
    bodySmall: _baseTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryLight,
      letterSpacing: 0.4,
    ),

    // Label styles
    labelLarge: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.1,
    ),
    labelMedium: _baseTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryLight,
      letterSpacing: 0.5,
    ),
    labelSmall: _baseTextStyle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondaryLight,
      letterSpacing: 0.5,
    ),
  );

  // Dark Theme Typography
  static TextTheme get darkTextTheme => TextTheme(
    // Display styles
    displayLarge: _headerTextStyle.copyWith(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
      letterSpacing: -0.25,
    ),
    displayMedium: _headerTextStyle.copyWith(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimaryDark,
    ),
    displaySmall: _headerTextStyle.copyWith(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),

    // Headline styles
    headlineLarge: _headerTextStyle.copyWith(
      fontSize: 32,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    headlineMedium: _headerTextStyle.copyWith(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    headlineSmall: _headerTextStyle.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),

    // Title styles
    titleLarge: _headerTextStyle.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimaryDark,
    ),
    titleMedium: _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.15,
    ),
    titleSmall: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.1,
    ),

    // Body styles
    bodyLarge: _baseTextStyle.copyWith(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.5,
    ),
    bodyMedium: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.25,
    ),
    bodySmall: _baseTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondaryDark,
      letterSpacing: 0.4,
    ),

    // Label styles
    labelLarge: _baseTextStyle.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.1,
    ),
    labelMedium: _baseTextStyle.copyWith(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: AppColors.textPrimaryDark,
      letterSpacing: 0.5,
    ),
    labelSmall: _baseTextStyle.copyWith(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: AppColors.textSecondaryDark,
      letterSpacing: 0.5,
    ),
  );

  // OTP Code Style - Monospace font for better readability
  static TextStyle get otpCodeStyle => _monoTextStyle.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w600,
    letterSpacing: 8,
    color: AppColors.otpCodeColor,
  );

  static TextStyle get otpCodeStyleSmall => _monoTextStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    letterSpacing: 6,
    color: AppColors.otpCodeColor,
  );
}
