import 'package:flutter/material.dart';

/// Centralized color palette for the app.
///
/// multAI is a photo product: people open it to find themselves in event
/// galleries. So the chrome is deliberately quiet. A neutral ink canvas lets
/// the photos be the only real color on screen, and a single electric indigo
/// carries every primary action. One canvas, one accent, no competing hues.
abstract class AppThemeColors {
  AppThemeColors._();

  // Accent: electric indigo. The only saturated color the UI itself uses.
  static const Color primaryAccent = Color(0xFF6E56F8);
  static const Color secondaryAccent = Color(0xFF5B44E0);
  static const Color accent = Color(0xFF8B78FF);

  // Neutral ink ramp. A cool near-neutral with a faint violet undertone so it
  // sits naturally next to the indigo accent. Lower numbers are deeper.
  static const Color neutral950 = Color(0xFF08080B);
  static const Color neutral900 = Color(0xFF0B0B0F);
  static const Color neutral850 = Color(0xFF111116);
  static const Color neutral800 = Color(0xFF16161C);
  static const Color neutral700 = Color(0xFF1E1E26);
  static const Color neutral600 = Color(0xFF262630);
  static const Color neutral500 = Color(0xFF33333F);
  static const Color neutral400 = Color(0xFF4A4A57);
  static const Color neutral300 = Color(0xFF6B6B78);
  static const Color neutral200 = Color(0xFF9A9AA6);
  static const Color neutral100 = Color(0xFFC4C4CE);
  static const Color neutral0 = Color(0xFFF4F4F6);

  // Surfaces and backgrounds.
  static const Color background = neutral900;
  static const Color surface = neutral800;
  static const Color surfaceHigh = neutral700;
  static const Color card = neutral800;
  static const Color onboardingBackground = Color(0xFF0E0E14);
  static const Color splashBackground = neutral950;
  static const Color readingBackground = neutral900;

  // Event cards. Flat surface with a hairline border, no tint.
  static const Color activeCardBackground = neutral800;
  static const Color activeCardBorder = neutral600;
  static const Color archivedCardBackground = neutral850;
  static const Color archivedCardBorder = neutral700;
  static const Color cardDateText = neutral200;
  static const Color archivedTitle = neutral200;
  static const Color archivedDate = neutral300;

  static const double activeCardBackgroundOpacity = 0.4;
  static const double archivedCardBackgroundOpacity = 0.1;
  static const double archivedCardBorderOpacity = 0.4;

  // Text colors.
  static const Color primaryText = neutral0;
  static const Color secondaryText = neutral100;
  static const Color hintText = neutral300;
  static const Color subtitleText = neutral200;

  // Brand accent moments (splash, onboarding). Kept on the indigo accent.
  static const Color dividerText = neutral300;
  static const Color divider = neutral700;
  static const Color gradientOverlay = Color(0x336E56F8);

  // Gradient stops for premium buttons and headers.
  static const Color gradientAccentStart = Color(0xFF8B78FF);
  static const Color gradientAccentEnd = Color(0xFF5B44E0);

  @Deprecated('Use primaryAccent instead')
  static const Color gold = primaryAccent;

  @Deprecated('Use gradientAccentStart instead')
  static const Color gradientGoldStart = gradientAccentStart;

  @Deprecated('Use gradientAccentEnd instead')
  static const Color gradientGoldEnd = gradientAccentEnd;

  // Neutral scrim for image-behind-text treatments (fades photos into the base).
  static const Color scrim = Color(0xCC08080B);

  // Interactive elements.
  static const Color button = primaryAccent;
  static const Color selected = Color(0xFF1E1A33);
  static const Color border = neutral600;
  static const Color inputFill = neutral850;
  static const Color inputBorder = neutral500;
  static const Color formCard = Color(0x1A6E56F8);

  // Status colors, tuned for a dark UI.
  static const Color success = Color(0xFF34D399);
  static const Color error = Color(0xFFF87171);
  static const Color warning = Color(0xFFFBBF24);
  static const Color info = primaryAccent;
  static const Color activeEventDot = Color(0xFF34D399);

  // Utility colors.
  static const Color highlight = accent;
  static const Color bookmark = primaryAccent;
  static const Color google = Color(0xFF4285F4);
  static const Color apple = Color(0xFFFFFFFF);
  static const Color overlay = Color(0x99000000);
  static const Color shimmer = neutral700;
  static const Color photoSlot = neutral600;
  static const Color tipsBackground = Color(0x14FFFFFF);
  static const Color enrollDisabled = Color(0x33262630);

  // Elevation shadows, tuned soft for a dark UI.
  static const Color shadowSoft = Color(0x40000000);
  static const Color shadowMedium = Color(0x59000000);

  // Tabs.
  static const Color tabUnselectedText = neutral200;
  static const Color tabDivider = Color.fromRGBO(255, 255, 255, 0.08);
}
