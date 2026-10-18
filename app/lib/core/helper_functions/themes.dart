// ignore_for_file: non_constant_identifier_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:stylebox/constant.dart';

/// StyleBox "Atelier" design system.
///
/// Bordeaux + champagne on warm ivory (light) or espresso (dark), Cairo with
/// editorial weights and tracking, pill-shaped actions, softly-shadowed
/// cards and linen-filled, borderless fields.
const _kFont = 'Cairo';

OutlineInputBorder _inputBorder(Color color, {double width = 1}) =>
    OutlineInputBorder(
      borderRadius: BorderRadius.circular(KradiusField),
      borderSide: color == Colors.transparent
          ? BorderSide.none
          : BorderSide(color: color, width: width),
    );

TextTheme _textTheme(Color primaryText, Color secondaryText) {
  return TextTheme(
    displaySmall: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.6,
      height: 1.15,
      color: primaryText,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.4,
      color: primaryText,
    ),
    headlineSmall: TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.3,
      color: primaryText,
    ),
    titleLarge: TextStyle(
      fontSize: 19,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
      color: primaryText,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    titleSmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: primaryText,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: primaryText,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      height: 1.5,
      color: primaryText,
    ),
    bodySmall: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: secondaryText,
    ),
    labelLarge: const TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.6,
    ),
    labelMedium: TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.8,
      color: secondaryText,
    ),
    labelSmall: TextStyle(
      fontSize: 11,
      fontWeight: FontWeight.w600,
      letterSpacing: 1.2,
      color: secondaryText,
    ),
  );
}

ThemeData _buildTheme({
  required Brightness brightness,
  required ColorScheme scheme,
  required Color background,
  required Color card,
  required Color field,
  required Color divider,
  required Color text,
  required Color textSecondary,
}) {
  final isDark = brightness == Brightness.dark;
  final pill = const StadiumBorder();
  const buttonText = TextStyle(
    fontFamily: _kFont,
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.6,
  );

  return ThemeData(
    useMaterial3: true,
    fontFamily: _kFont,
    brightness: brightness,
    colorScheme: scheme,
    primaryColor: scheme.primary,
    scaffoldBackgroundColor: background,
    canvasColor: background,
    cardColor: card,
    dividerColor: divider,
    hintColor: textSecondary,
    splashFactory: InkSparkle.splashFactory,
    textTheme: _textTheme(text, textSecondary),
    iconTheme: IconThemeData(color: text, size: 22),
    dividerTheme: DividerThemeData(color: divider, thickness: 1, space: 1),
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      foregroundColor: text,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        fontFamily: _kFont,
        fontSize: 18,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.2,
        color: text,
      ),
      iconTheme: IconThemeData(color: text),
    ),
    cardTheme: CardThemeData(
      color: card,
      surfaceTintColor: Colors.transparent,
      elevation: isDark ? 0 : 1.5,
      shadowColor: const Color(0xFF5E1A2F).withOpacity(0.10),
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KradiusCard),
        side: isDark ? BorderSide(color: divider) : BorderSide.none,
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: field,
      selectedColor: scheme.primary,
      side: BorderSide.none,
      shape: pill,
      labelStyle: TextStyle(
        fontFamily: _kFont,
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: text,
      ),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: card,
      selectedItemColor: scheme.primary,
      unselectedItemColor: textSecondary,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: const TextStyle(
        fontFamily: _kFont,
        fontWeight: FontWeight.w700,
        fontSize: 11,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: _kFont,
        fontWeight: FontWeight.w500,
        fontSize: 11,
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      indicatorColor: scheme.primaryContainer,
      elevation: 0,
      labelTextStyle: WidgetStatePropertyAll(
        TextStyle(
          fontFamily: _kFont,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: text,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      elevation: 2,
      shape: const StadiumBorder(),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        minimumSize: const Size(64, 52),
        textStyle: buttonText,
        shape: pill,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        elevation: 0,
        minimumSize: const Size(64, 52),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        textStyle: buttonText,
        shape: pill,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        minimumSize: const Size(64, 52),
        side: BorderSide(color: text.withOpacity(0.85), width: 1.2),
        textStyle: buttonText,
        shape: pill,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: scheme.primary,
        textStyle: buttonText.copyWith(fontSize: 14),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: field,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      border: _inputBorder(Colors.transparent),
      enabledBorder: _inputBorder(Colors.transparent),
      focusedBorder: _inputBorder(scheme.primary, width: 1.4),
      errorBorder: _inputBorder(scheme.error),
      focusedErrorBorder: _inputBorder(scheme.error, width: 1.4),
      hintStyle: TextStyle(color: textSecondary, fontWeight: FontWeight.w500),
      prefixIconColor: textSecondary,
      suffixIconColor: textSecondary,
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: isDark ? card : KlightModeTextColor,
      contentTextStyle: TextStyle(
        fontFamily: _kFont,
        color: isDark ? text : Colors.white,
        fontWeight: FontWeight.w500,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KradiusSmall),
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      showDragHandle: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: card,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(KradiusCard),
      ),
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(color: scheme.primary),
  );
}

ThemeData LightColorTheme() {
  final scheme =
      const ColorScheme.light(
        brightness: Brightness.light,
        primary: KprimaryColor,
        onPrimary: Colors.white,
        primaryContainer: KprimaryColorLight,
        onPrimaryContainer: KprimaryColorDark,
        secondary: KaccentColor,
        onSecondary: Colors.white,
        secondaryContainer: KaccentColorLight,
        onSecondaryContainer: Color(0xFF5A4220),
        tertiary: KlightModeTextColor,
        onTertiary: Colors.white,
        surface: KlightModeCardColor,
        onSurface: KlightModeTextColor,
        onSurfaceVariant: KlightModeTextSecondary,
        outline: KdisabledColor,
        outlineVariant: KdividerColor,
        error: Color(0xFFC2362F),
        onError: Colors.white,
      ).copyWith(
        surfaceContainer: KlightModeCardColor,
        surfaceContainerLow: KlightModeBgColor,
        surfaceContainerHighest: KlightModeFieldColor,
      );

  return _buildTheme(
    brightness: Brightness.light,
    scheme: scheme,
    background: KlightModeBgColor,
    card: KlightModeCardColor,
    field: KlightModeFieldColor,
    divider: KdividerColor,
    text: KlightModeTextColor,
    textSecondary: KlightModeTextSecondary,
  );
}

// ========== Dark Theme ==========
ThemeData DarkColorTheme() {
  const darkContainer = Color(0xFF3B2129);
  final scheme =
      const ColorScheme.dark(
        brightness: Brightness.dark,
        primary: KdarkModePrimary,
        onPrimary: Color(0xFF2A0D17),
        primaryContainer: darkContainer,
        onPrimaryContainer: KdarkModeTextColor,
        secondary: KaccentColor,
        onSecondary: Color(0xFF2A1E0C),
        secondaryContainer: Color(0xFF3A3020),
        onSecondaryContainer: Color(0xFFF5ECDD),
        tertiary: KdarkModeTextColor,
        onTertiary: KdarkModeBgColor,
        surface: KdarkModeCardColor,
        onSurface: KdarkModeTextColor,
        onSurfaceVariant: KdarkModeTextSecondary,
        outline: Color(0xFF5A4E49),
        outlineVariant: KdarkModeDivider,
        error: Color(0xFFFF7A70),
        onError: Color(0xFF2A0D0B),
      ).copyWith(
        surfaceContainer: KdarkModeCardColor,
        surfaceContainerLow: KdarkModeBgColor,
        surfaceContainerHighest: const Color(0xFF2C2522),
      );

  return _buildTheme(
    brightness: Brightness.dark,
    scheme: scheme,
    background: KdarkModeBgColor,
    card: KdarkModeCardColor,
    field: const Color(0xFF2C2522),
    divider: KdarkModeDivider,
    text: KdarkModeTextColor,
    textSecondary: KdarkModeTextSecondary,
  );
}
