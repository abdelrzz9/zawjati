import 'package:flutter/material.dart';
import 'app_theme_colors.dart';
import 'app_theme_data.dart';
import 'app_theme_metrics.dart';
import 'app_theme_text_styles.dart';

export 'app_theme_colors.dart';
export 'app_theme_data.dart';
export 'app_theme_metrics.dart';
export 'app_theme_text_styles.dart';

abstract class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => AppThemeData.lightTheme;
  static ThemeData get darkTheme => AppThemeData.darkTheme;
  static ThemeData get amoledTheme => AppThemeData.amoledTheme;

  // Colors (dark mode defaults)
  static const Color primaryColor = AppThemeColors.primaryAccent;
  static const Color primaryAccent = AppThemeColors.primaryAccent;
  static const Color secondaryColor = AppThemeColors.secondaryAccent;
  static const Color secondaryAccent = AppThemeColors.secondaryAccent;
  static const Color accentColor = AppThemeColors.accent;
  static const Color backgroundColor = AppThemeColors.background;
  static const Color surfaceColor = AppThemeColors.surface;
  static const Color cardColor = AppThemeColors.card;
  static const Color primaryTextColor = AppThemeColors.primaryText;
  static const Color secondaryTextColor = AppThemeColors.secondaryText;
  static const Color hintTextColor = AppThemeColors.hintText;
  static const Color subtitleTextColor = AppThemeColors.subtitleText;
  static const Color dividerColor = AppThemeColors.divider;
  static const Color buttonColor = AppThemeColors.button;
  static const Color selectedColor = AppThemeColors.selected;
  static const Color borderColor = AppThemeColors.border;
  static const Color inputFillColor = AppThemeColors.inputFill;
  static const Color inputBorderColor = AppThemeColors.inputBorder;
  static const Color successColor = AppThemeColors.success;
  static const Color errorColor = AppThemeColors.error;
  static const Color warningColor = AppThemeColors.warning;
  static const Color infoColor = AppThemeColors.info;
  static const Color googleColor = AppThemeColors.google;
  static const Color appleColor = AppThemeColors.apple;
  static const Color overlayColor = AppThemeColors.overlay;
  static const Color shimmerColor = AppThemeColors.shimmer;

  // Metrics
  static const double radiusXs = AppThemeMetrics.radiusXs;
  static const double radiusSm = AppThemeMetrics.radiusSm;
  static const double radiusMd = AppThemeMetrics.radiusMd;
  static const double radiusLg = AppThemeMetrics.radiusLg;
  static const double radiusXl = AppThemeMetrics.radiusXl;
  static const double radiusXxl = AppThemeMetrics.radiusXxl;
  static const double radiusPill = AppThemeMetrics.radiusPill;
  static const double spacing2xs = AppThemeMetrics.spacing2xs;
  static const double spacingXs = AppThemeMetrics.spacingXs;
  static const double spacingSm = AppThemeMetrics.spacingSm;
  static const double spacingMd = AppThemeMetrics.spacingMd;
  static const double spacingLg = AppThemeMetrics.spacingLg;
  static const double spacingXl = AppThemeMetrics.spacingXl;
  static const double spacingXxl = AppThemeMetrics.spacingXxl;
  static const double spacing3xl = AppThemeMetrics.spacing3xl;
  static const Duration durationFast = AppThemeMetrics.durationFast;
  static const Duration durationMedium = AppThemeMetrics.durationMedium;
  static const Duration durationSlow = AppThemeMetrics.durationSlow;
  static const Curve curveStandard = AppThemeMetrics.curveStandard;
  static const Curve curveEmphasized = AppThemeMetrics.curveEmphasized;
  static const double largeScreenMinWidth = AppThemeMetrics.largeScreenMinWidth;

  // Text styles
  static TextStyle get splashLargeText => AppThemeTextStyles.splashLargeText;
  static TextStyle get splashMediumText => AppThemeTextStyles.splashMediumText;
  static TextStyle get onboardingLargeText => AppThemeTextStyles.onboardingLargeText;
  static TextStyle get onboardingMediumText => AppThemeTextStyles.onboardingMediumText;
}
