import 'package:flutter/material.dart';

/// Palette of the app: teal on a soft lavender page.
class AppColors {
  static const Color primary = Color(0xFF00796B);
  static const Color primarySoft = Color(0xFFE0F2F1);

  static const Color text = Color(0xFF1C1B22);
  static const Color muted = Color(0xFF6E6C7A);
  static const Color hint = Color(0xFFA3A1AD);
  static const Color border = Color(0xFFE8E5F0);
  static const Color surface = Colors.white;
  static const Color background = Color(0xFFF7F5FC);

  static const Color danger = Color(0xFFD32F2F);
  static const Color dangerSoft = Color(0xFFFDE7E7);
}

class AppTheme {
  static const String fontFamily = 'IBMPlexSansArabic';

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: fontFamily,
    scaffoldBackgroundColor: AppColors.background,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.light,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      error: AppColors.danger,
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.text,
        minimumSize: const Size.fromHeight(50),
        side: const BorderSide(color: AppColors.border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        textStyle: const TextStyle(
          fontFamily: fontFamily,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: AppColors.text,
      contentTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontSize: 14,
        color: Colors.white,
      ),
    ),
  );
}
