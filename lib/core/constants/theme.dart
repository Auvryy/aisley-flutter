import 'package:flutter/material.dart';
import 'colors.dart';

class AisleyTheme {
  AisleyTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AisleyColors.lightCanvas,
    colorScheme: const ColorScheme.light(
      primary: AisleyColors.accentPink,
      secondary: AisleyColors.electricSky,
      surface: AisleyColors.lightSurface,
      error: AisleyColors.roseDanger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AisleyColors.textDarkPrimary,
      outline: AisleyColors.lightBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AisleyColors.lightSurface,
      foregroundColor: AisleyColors.textDarkPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AisleyColors.textDarkPrimary,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: AisleyColors.lightSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AisleyColors.lightBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: AisleyColors.lightBorder,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.lightBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.lightBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.accentPink, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.roseDanger, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AisleyColors.lightTextMuted,
        fontSize: 13,
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AisleyColors.obsidianCanvas,
    colorScheme: const ColorScheme.dark(
      primary: AisleyColors.accentPink,
      secondary: AisleyColors.electricSky,
      surface: AisleyColors.obsidianSurface,
      error: AisleyColors.roseDanger,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: AisleyColors.textLightPrimary,
      outline: AisleyColors.obsidianBorder,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AisleyColors.obsidianSurface,
      foregroundColor: AisleyColors.textLightPrimary,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        color: AisleyColors.textLightPrimary,
        letterSpacing: -0.5,
      ),
    ),
    cardTheme: CardThemeData(
      color: AisleyColors.obsidianSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AisleyColors.obsidianBorder, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: AisleyColors.obsidianBorder,
      thickness: 1,
      space: 1,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AisleyColors.obsidianSurface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.obsidianBorder, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.obsidianBorder, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.accentPink, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AisleyColors.roseDanger, width: 1.5),
      ),
      hintStyle: const TextStyle(
        color: AisleyColors.obsidianTextMuted,
        fontSize: 13,
      ),
    ),
  );
}
