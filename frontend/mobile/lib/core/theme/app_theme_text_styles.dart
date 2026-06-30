import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_theme_colors.dart';

/// Typography tokens for the app.
abstract class AppThemeTextStyles {
  AppThemeTextStyles._();

  static TextStyle get appBarTitleStyle => GoogleFonts.raleway(
    color: AppThemeColors.primaryText,
    fontSize: 20,
    fontWeight: FontWeight.w600,
  );

  static TextStyle get buttonTextStyle => GoogleFonts.raleway(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  static TextStyle get inputHintStyle =>
      GoogleFonts.montserrat(color: AppThemeColors.hintText, fontSize: 14);

  static TextStyle get inputLabelStyle => GoogleFonts.raleway(
    color: AppThemeColors.secondaryText,
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );

  static TextStyle get splashLargeText => GoogleFonts.playfairDisplay(
    color: AppThemeColors.primaryText,
    fontSize: 48,
    height: 1.0,
    fontWeight: FontWeight.normal,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get splashMediumText => GoogleFonts.playfairDisplay(
    color: AppThemeColors.subtitleText,
    fontSize: 18,
    height: 1.55,
    fontStyle: FontStyle.italic,
  );

  static TextStyle get onboardingLargeText => GoogleFonts.raleway(
    color: AppThemeColors.primaryText,
    fontSize: 36,
    fontWeight: FontWeight.w700,
    height: 1.15,
    letterSpacing: -0.5,
    fontStyle: FontStyle.normal,
  );

  static TextStyle get onboardingMediumText => GoogleFonts.montserrat(
    color: AppThemeColors.subtitleText,
    fontSize: 18,
    height: 1.5,
    fontStyle: FontStyle.normal,
  );

  static TextTheme get textTheme => TextTheme(
    displayLarge: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 32,
      fontWeight: FontWeight.bold,
      height: 1.15,
      letterSpacing: -0.5,
    ),
    displayMedium: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 28,
      fontWeight: FontWeight.bold,
      height: 1.2,
      letterSpacing: -0.4,
    ),
    displaySmall: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 24,
      fontWeight: FontWeight.bold,
      height: 1.3,
      letterSpacing: -0.3,
    ),
    headlineLarge: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 22,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineMedium: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.3,
    ),
    headlineSmall: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleLarge: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleMedium: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    titleSmall: GoogleFonts.raleway(
      color: AppThemeColors.secondaryText,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      height: 1.4,
    ),
    bodyLarge: GoogleFonts.montserrat(
      color: AppThemeColors.primaryText,
      fontSize: 18,
      fontWeight: FontWeight.normal,
      height: 1.6,
    ),
    bodyMedium: GoogleFonts.montserrat(
      color: AppThemeColors.primaryText,
      fontSize: 16,
      fontWeight: FontWeight.normal,
      height: 1.5,
    ),
    bodySmall: GoogleFonts.raleway(
      color: AppThemeColors.secondaryText,
      fontSize: 14,
      fontWeight: FontWeight.normal,
      height: 1.4,
    ),
    labelLarge: GoogleFonts.raleway(
      color: AppThemeColors.primaryText,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.1,
    ),
    labelMedium: GoogleFonts.raleway(
      color: AppThemeColors.secondaryText,
      fontSize: 12,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
    labelSmall: GoogleFonts.raleway(
      color: AppThemeColors.hintText,
      fontSize: 10,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );
}
