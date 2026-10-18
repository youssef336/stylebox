import 'package:flutter/material.dart';

/// StyleBox "Atelier" palette for the store dashboard.
///
/// Bordeaux wine + champagne gold on warm ivory, shared with the customer
/// app so both products read as one fashion brand.
abstract class AppColors {
  // Primary Colors (StyleBox Bordeaux)
  static const Color primaryColor = Color(0xFF8E2C48);
  static const Color primaryLight = Color(0xFFB0506B);
  static const Color primaryDark = Color(0xFF5E1A2F);
  static const Color primaryContainer = Color(0xFFF6E8EC); // Blush tint

  // Secondary Colors (StyleBox champagne gold)
  static const Color secoundryColor = Color(0xFFC39A5B);
  static const Color secoundryLight = Color(0xFFE0C38F);
  static const Color secoundryDark = Color(0xFFA07A3E);
  static const Color secondaryContainer = Color(0xFFF5ECDD);

  // Accent & status colors
  static const Color accentColor = Color(0xFFC39A5B);
  static const Color successColor = Color(0xFF2E7D5B);
  static const Color errorColor = Color(0xFFC2362F);
  static const Color warningColor = Color(0xFFD08A2E);

  // Neutral Colors (warm, taupe-based)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF1E1816); // Espresso ink
  static const Color lightGrey = Color(0xFFF3EEEA); // Linen (field fill)
  static const Color grey = Color(0xFFA39890);
  static const Color darkGrey = Color(0xFF5C524C);
  static const Color textSecondary = Color(0xFF7A6F69); // Taupe
  static const Color divider = Color(0xFFEDE5E0);

  // StyleBox surfaces
  static const Color background = Color(0xFFFAF7F4); // Warm ivory
  static const Color surface = Color(0xFFFFFFFF);

  // Shape tokens
  static const double radiusSmall = 10;
  static const double radiusField = 12;
  static const double radiusCard = 18;

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5E1A2F), Color(0xFF8E2C48), Color(0xFFB0506B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFA07A3E), Color(0xFFC39A5B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFF8E2C48), Color(0xFFC39A5B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
