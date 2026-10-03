import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary Colors (StyleBox violet)
  static const Color primaryColor = Color(0xFF5B3DF5);
  static const Color primaryLight = Color(0xFF7C63FF);
  static const Color primaryDark = Color(0xFF3A22B8);

  // Secondary Colors (StyleBox coral)
  static const Color secoundryColor = Color(0xFFFF6B6B);
  static const Color secoundryLight = Color(0xFFFF9A7B);
  static const Color secoundryDark = Color(0xFFE5484D);

  // Accent Colors
  static const Color accentColor = Color(0xFFFF6B6B);
  static const Color successColor = Color(0xFF22C55E);
  static const Color errorColor = Color(0xFFE5484D);
  static const Color warningColor = Color(0xFFF59E0B);

  // Neutral Colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF14121F);
  static const Color lightGrey = Color(0xFFF1EEFB);
  static const Color grey = Color(0xFF9E9AB0);
  static const Color darkGrey = Color(0xFF4A4660);

  // StyleBox surfaces
  static const Color background = Color(0xFFF7F6FB);
  static const Color surface = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF5B3DF5), Color(0xFF9B6BFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFFFF6B6B), Color(0xFFFF9A7B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sunsetGradient = LinearGradient(
    colors: [Color(0xFF5B3DF5), Color(0xFFFF6B6B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
