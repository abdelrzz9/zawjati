import 'package:flutter/material.dart';

import 'app_theme_colors.dart';
import 'app_theme_metrics.dart';
import 'app_theme_text_styles.dart';

/// ThemeData factory for the app.
abstract class AppThemeData {
  AppThemeData._();

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      primaryColor: AppThemeColors.primaryAccent,
      scaffoldBackgroundColor: AppThemeColors.background,
      cardColor: AppThemeColors.card,
      splashFactory: InkRipple.splashFactory,
      colorScheme: const ColorScheme.dark(
        primary: AppThemeColors.primaryAccent,
        secondary: AppThemeColors.secondaryAccent,
        surface: AppThemeColors.surface,
        surfaceContainerHighest: AppThemeColors.surfaceHigh,
        error: AppThemeColors.error,
        outline: AppThemeColors.inputBorder,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppThemeColors.primaryText,
        onSurfaceVariant: AppThemeColors.secondaryText,
        onError: Colors.black,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppThemeColors.background,
        foregroundColor: AppThemeColors.primaryText,
        elevation: AppThemeMetrics.elevationNone,
        scrolledUnderElevation: AppThemeMetrics.elevationNone,
        centerTitle: false,
        titleTextStyle: AppThemeTextStyles.appBarTitleStyle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppThemeColors.button,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppThemeColors.button.withValues(
            alpha: AppThemeMetrics.opacityDisabled,
          ),
          disabledForegroundColor: Colors.white70,
          elevation: AppThemeMetrics.elevationNone,
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
          ),
          textStyle: AppThemeTextStyles.buttonTextStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppThemeColors.primaryText,
          side: const BorderSide(
            color: AppThemeColors.inputBorder,
            width: AppThemeMetrics.borderThick,
          ),
          minimumSize: const Size.fromHeight(54),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
          ),
          backgroundColor: Colors.transparent,
          textStyle: AppThemeTextStyles.buttonTextStyle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppThemeColors.primaryAccent,
          textStyle: AppThemeTextStyles.buttonTextStyle,
        ),
      ),
      textTheme: AppThemeTextStyles.textTheme,
      inputDecorationTheme: InputDecorationTheme(
        border: _inputBorder(AppThemeColors.inputBorder),
        enabledBorder: _inputBorder(AppThemeColors.inputBorder),
        focusedBorder: _inputBorder(
          AppThemeColors.primaryAccent,
          width: AppThemeMetrics.borderFocus,
        ),
        errorBorder: _inputBorder(AppThemeColors.error),
        focusedErrorBorder: _inputBorder(
          AppThemeColors.error,
          width: AppThemeMetrics.borderFocus,
        ),
        filled: true,
        fillColor: AppThemeColors.inputFill,
        hintStyle: AppThemeTextStyles.inputHintStyle,
        labelStyle: AppThemeTextStyles.inputLabelStyle,
        prefixIconColor: AppThemeColors.hintText,
        suffixIconColor: AppThemeColors.hintText,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppThemeMetrics.spacingMd,
          vertical: AppThemeMetrics.spacingMd,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppThemeColors.card,
        elevation: AppThemeMetrics.elevationNone,
        shadowColor: AppThemeColors.shadowSoft,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
          side: const BorderSide(
            color: AppThemeColors.activeCardBorder,
            width: AppThemeMetrics.borderHairline,
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppThemeColors.surface,
        selectedColor: AppThemeColors.selected,
        side: const BorderSide(
          color: AppThemeColors.inputBorder,
          width: AppThemeMetrics.borderHairline,
        ),
        labelStyle: AppThemeTextStyles.textTheme.labelLarge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppThemeColors.surfaceHigh,
        contentTextStyle: AppThemeTextStyles.textTheme.bodyMedium,
        actionTextColor: AppThemeColors.primaryAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppThemeColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: AppThemeColors.inputBorder,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppThemeMetrics.radiusXxl),
          ),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppThemeColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: AppThemeMetrics.elevationHigh,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusXl),
        ),
        titleTextStyle: AppThemeTextStyles.textTheme.headlineSmall,
        contentTextStyle: AppThemeTextStyles.textTheme.bodyMedium,
      ),
      dividerTheme: const DividerThemeData(
        color: AppThemeColors.divider,
        thickness: AppThemeMetrics.borderHairline,
        space: AppThemeMetrics.spacingMd,
      ),
      iconTheme: const IconThemeData(
        color: AppThemeColors.secondaryText,
        size: AppThemeMetrics.iconMd,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppThemeColors.primaryAccent,
        linearTrackColor: AppThemeColors.inputBorder,
      ),
    );
  }

  static OutlineInputBorder _inputBorder(
    Color color, {
    double width = AppThemeMetrics.borderThin,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  static ThemeData get darkTheme => lightTheme;
}
