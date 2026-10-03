// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

const _kFont = 'Cairo';

OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color, width: width),
    );

ThemeData LightColorTheme() {
  return ThemeData(
    useMaterial3: true,
    fontFamily: _kFont,
    brightness: Brightness.light,
    scaffoldBackgroundColor: KlightModeBgColor,
    primaryColor: KprimaryColor,
    colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      primary: KprimaryColor,
      onPrimary: Colors.white,
      primaryContainer: KprimaryColorLight,
      onPrimaryContainer: KprimaryColorDark,
      secondary: KaccentColor,
      onSecondary: Colors.white,
      surface: KlightModeCardColor,
      onSurface: KlightModeTextColor,
      onSurfaceVariant: KlightModeTextSecondary,
      error: Color(0xFFE5484D),
      onError: Colors.white,
    ).copyWith(
      surfaceContainer: KlightModeCardColor,
      surfaceContainerHighest: KprimaryColorLight,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: KlightModeBgColor,
      foregroundColor: KlightModeTextColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: KlightModeCardColor,
    dividerColor: KdividerColor,
    hintColor: KlightModeTextSecondary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: KlightModeCardColor,
      selectedItemColor: KprimaryColor,
      unselectedItemColor: KlightModeTextSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: KprimaryColor,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: KprimaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: KprimaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KlightModeCardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _inputBorder(KdividerColor),
      enabledBorder: _inputBorder(KdividerColor),
      focusedBorder: _inputBorder(KprimaryColor, width: 1.6),
      hintStyle: const TextStyle(color: KlightModeTextSecondary),
    ),
  );
}

// ========== Dark Theme ==========
ThemeData DarkColorTheme() {
  const darkPrimary = Color(0xFF7C63FF);
  return ThemeData(
    useMaterial3: true,
    fontFamily: _kFont,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: KdarkModeBgColor,
    primaryColor: darkPrimary,
    colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      primary: darkPrimary,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFF2A2350),
      onPrimaryContainer: KdarkModeTextColor,
      secondary: KaccentColor,
      onSecondary: Colors.white,
      surface: KdarkModeCardColor,
      onSurface: KdarkModeTextColor,
      onSurfaceVariant: KdarkModeTextSecondary,
      error: Color(0xFFFF6369),
      onError: Colors.white,
    ).copyWith(
      surfaceContainer: KdarkModeCardColor,
      surfaceContainerHighest: const Color(0xFF2A2350),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: KdarkModeBgColor,
      foregroundColor: KdarkModeTextColor,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
    ),
    cardColor: KdarkModeCardColor,
    dividerColor: const Color(0xFF2A2838),
    hintColor: KdarkModeTextSecondary,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: KdarkModeCardColor,
      selectedItemColor: darkPrimary,
      unselectedItemColor: KdarkModeTextSecondary,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: darkPrimary,
      foregroundColor: Colors.white,
      shape: CircleBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkPrimary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: KdarkModeCardColor,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: _inputBorder(const Color(0xFF2A2838)),
      enabledBorder: _inputBorder(const Color(0xFF2A2838)),
      focusedBorder: _inputBorder(darkPrimary, width: 1.6),
      hintStyle: const TextStyle(color: KdarkModeTextSecondary),
    ),
  );
}
