import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

// Custom ColorScheme extensions so widgets can access
// kCard, kBorder, kBorder2, kTextMuted etc. via Theme
extension AppColors on ColorScheme {
  // Background layers
  Color get bg => brightness == Brightness.dark ? kBg : kBgLight;
  Color get card => brightness == Brightness.dark ? kCard : kCardLight;
  Color get elevated =>
      brightness == Brightness.dark ? kElevated : kElevatedLight;

  // Borders
  Color get border => brightness == Brightness.dark ? kBorder : kBorderLight;
  Color get border2 => brightness == Brightness.dark ? kBorder2 : kBorder2Light;

  // Text
  Color get textPri => brightness == Brightness.dark ? kTextPri : kTextPriLight;
  Color get textSec => brightness == Brightness.dark ? kTextSec : kTextSecLight;
  Color get textMuted =>
      brightness == Brightness.dark ? kTextMuted : kTextMutedLight;

  // Brand (same in both)
  Color get lime => brightness == Brightness.dark ? kLime : kLimeLight;
  Color get orange => kOrange;
  Color get danger => kDanger;
  Color get success => kSuccess;
}

class AppTheme {
  static ThemeData dark() => _build(Brightness.dark);
  static ThemeData light() => _build(Brightness.light);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final bg = isDark ? kBg : kBgLight;
    final surface = isDark ? kSurface : kSurfaceLight;
    final card = isDark ? kCard : kCardLight;
    final border = isDark ? kBorder : kBorderLight;
    final border2 = isDark ? kBorder2 : kBorder2Light;
    final textPri = isDark ? kTextPri : kTextPriLight;
    final textSec = isDark ? kTextSec : kTextSecLight;
    final textMuted = isDark ? kTextMuted : kTextMutedLight;

    final colorScheme = isDark
        ? ColorScheme.dark(
            surface: surface,
            primary: kLime,
            onPrimary: kBg,
            secondary: kOrange,
            onSecondary: textPri,
            error: kDanger,
            onSurface: textPri,
          )
        : ColorScheme.light(
            surface: surface,
            primary: kLimeLight,
            onPrimary: Colors.white,
            secondary: kOrange,
            onSecondary: textPri,
            error: kDanger,
            onSurface: textPri,
          );

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: bg,
      colorScheme: colorScheme,
      cardColor: card,
      dividerColor: border,
      textTheme: GoogleFonts.dmSansTextTheme(
        brightness == Brightness.dark
            ? ThemeData.dark().textTheme
            : ThemeData.light().textTheme,
      ).apply(bodyColor: textPri, displayColor: textPri),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surface,
        labelStyle: TextStyle(color: textSec, fontSize: 11, letterSpacing: 1.2),
        hintStyle: TextStyle(color: textMuted),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border2, width: 0.5),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: border, width: 0.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: isDark ? kLime : kLimeLight, width: 1),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: bg,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        titleTextStyle: TextStyle(
          color: textPri,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: GoogleFonts.dmSans().fontFamily,
        ),
        contentTextStyle: TextStyle(
          color: textSec,
          fontSize: 14,
          fontFamily: GoogleFonts.dmSans().fontFamily,
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: isDark ? 0 : 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: border, width: 0.5),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: isDark ? kCard : const Color(0xFF1A1A1A),
        contentTextStyle: TextStyle(
          color: isDark ? kTextPri : Colors.white,
          fontFamily: GoogleFonts.dmSans().fontFamily,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: surface,
        selectedItemColor: kLime,
        unselectedItemColor: isDark ? kTextMuted : const Color(0xFFAAAAAA),
      ),
      useMaterial3: true,
    );
  }
}
