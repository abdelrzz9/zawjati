import 'package:flutter/animation.dart';

/// Size, elevation and motion tokens used across the app.
abstract class AppThemeMetrics {
  AppThemeMetrics._();

  // Radius.
  static const double radiusXs = 4.0;
  static const double radiusSm = 8.0;
  static const double radiusMd = 12.0;
  static const double radiusLg = 16.0;
  static const double radiusXl = 18.0;
  static const double radiusXxl = 24.0;
  static const double radiusPill = 999.0;

  // Spacing. A 4pt-based scale.
  static const double spacing2xs = 2.0;
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0;
  static const double spacing3xl = 56.0;

  // Border widths.
  static const double borderHairline = 0.5;
  static const double borderThin = 1.0;
  static const double borderThick = 1.5;
  static const double borderFocus = 2.0;

  // Elevation. Kept low; a dark UI reads better with hairline borders than
  // heavy drop shadows.
  static const double elevationNone = 0.0;
  static const double elevationLow = 1.0;
  static const double elevationMedium = 3.0;
  static const double elevationHigh = 6.0;

  // Icon sizes.
  static const double iconSm = 18.0;
  static const double iconMd = 22.0;
  static const double iconLg = 28.0;

  // Opacity scale for disabled, muted and overlay states.
  static const double opacityDisabled = 0.38;
  static const double opacityMuted = 0.6;
  static const double opacityHover = 0.08;
  static const double opacityPressed = 0.12;

  // Motion durations.
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationMedium = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);

  // Motion curves. Emphasized easing for entrances, standard for the rest.
  static const Curve curveStandard = Curves.easeInOutCubic;
  static const Curve curveEmphasized = Curves.easeOutCubic;

  // Card and layout measurements.
  static const double activeCardAspectWidth = 358.0;
  static const double activeCardBreakpoint = 350.0;
  static const double statusDotSize = 10.0;
  static const double notifDotSize = 8.0;
  static const double emptyStatePadding = 32.0;

  // Adaptive breakpoint for switching to large-screen layouts.
  static const double largeScreenMinWidth = 600.0;
}
