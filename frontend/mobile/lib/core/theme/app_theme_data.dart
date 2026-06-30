import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colors.dart';

class AppThemeData {
  AppThemeData._();

  static ThemeData get lightTheme => _buildTheme(
    brightness: Brightness.light,
    primaryColor: AppColors.primary,
    surfaceColor: AppColors.lightSurface,
    backgroundColor: AppColors.lightBackground,
    textColor: AppColors.lightText,
    subtitleColor: AppColors.lightSubtitle,
    cardColor: AppColors.lightCard,
    borderColor: AppColors.lightBorder,
    errorColor: AppColors.error,
  );

  static ThemeData get darkTheme => _buildTheme(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    surfaceColor: AppColors.darkSurface,
    backgroundColor: AppColors.darkBackground,
    textColor: AppColors.darkText,
    subtitleColor: AppColors.darkSubtitle,
    cardColor: AppColors.darkCard,
    borderColor: AppColors.darkBorder,
    errorColor: AppColors.error,
  );

  static ThemeData get amoledTheme => _buildTheme(
    brightness: Brightness.dark,
    primaryColor: AppColors.primary,
    surfaceColor: AppColors.amoledSurface,
    backgroundColor: AppColors.amoledBackground,
    textColor: AppColors.amoledText,
    subtitleColor: AppColors.amoledSubtitle,
    cardColor: AppColors.amoledCard,
    borderColor: AppColors.amoledBorder,
    errorColor: AppColors.error,
  );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color primaryColor,
    required Color surfaceColor,
    required Color backgroundColor,
    required Color textColor,
    required Color subtitleColor,
    required Color cardColor,
    required Color borderColor,
    required Color errorColor,
  }) {
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: primaryColor,
      onPrimary: Colors.white,
      secondary: primaryColor.withValues(alpha: 0.8),
      onSecondary: Colors.white,
      surface: surfaceColor,
      onSurface: textColor,
      error: errorColor,
      onError: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: GoogleFonts.poppinsTextTheme(
        ThemeData(brightness: brightness).textTheme,
      ).copyWith(
        headlineLarge: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: textColor,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: textColor,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: borderColor, width: 0.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primaryColor, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: errorColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        labelStyle: TextStyle(color: subtitleColor),
        hintStyle: TextStyle(color: subtitleColor.withValues(alpha: 0.7)),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
        iconTheme: IconThemeData(color: textColor),
      ),
      dividerTheme: DividerThemeData(
        color: borderColor,
        thickness: 0.5,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: surfaceColor,
        selectedColor: primaryColor.withValues(alpha: 0.2),
        labelStyle: TextStyle(color: textColor, fontSize: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: borderColor),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
