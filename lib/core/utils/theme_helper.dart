import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../../app.dart';

/// Helper class to get theme-aware colors throughout the app
class ThemeHelper {
  /// Get the current brightness mode
  static bool get isDarkMode => themeNotifier.value == ThemeMode.dark;

  /// Get background color based on current theme
  static Color getBg() => isDarkMode ? kBg : kBgLight;

  /// Get surface color based on current theme
  static Color getSurface() => isDarkMode ? kSurface : kSurfaceLight;

  /// Get card color based on current theme
  static Color getCard() => isDarkMode ? kCard : kCardLight;

  /// Get elevated color based on current theme
  static Color getElevated() => isDarkMode ? kElevated : kElevatedLight;

  /// Get primary border color based on current theme
  static Color getBorder() => isDarkMode ? kBorder : kBorderLight;

  /// Get secondary border color based on current theme
  static Color getBorder2() => isDarkMode ? kBorder2 : kBorder2Light;

  /// Get primary text color based on current theme
  static Color getTextPri() => isDarkMode ? kTextPri : kTextPriLight;

  /// Get secondary text color based on current theme
  static Color getTextSec() => isDarkMode ? kTextSec : kTextSecLight;

  /// Get muted text color based on current theme
  static Color getTextMuted() => isDarkMode ? kTextMuted : kTextMutedLight;
}
