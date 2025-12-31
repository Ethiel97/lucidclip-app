import 'package:flutter/material.dart';

abstract class AppColors {
  /// Transparent
  static const int transparent = 0x00000000;

  /// Brand
  static const primary = Color(0xFF615FFF);
  static const primarySoft = Color(0xFF7C6FFF);

  /// Surfaces & background (LucidClip dark)
  static const bg = Color(0xFF050509);
  static const surface = Color(0xFF101118);
  static const surface2 = Color(0xFF151620);
  static const sidebar = Color(0xFF060710);

  /// Text
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB4B5C4);
  static const textMuted = Color(0xFF7D7E8D);

  /// Borders / strokes
  static const borderSubtle = Color(0xFF202131);

  /// Status
  static const success = Color(0xFF3CCB7A);
  static const successSoft = Color(0xFF8EF0B1);
  static const danger = Color(0xFFFF5C7A);
  static const dangerSoft = Color(0xFFFFA1AC);
  static const warning = Color(0xFFFFC857);
  static const warningSoft = Color(0xFFFFE6A8);

  // Primary swatch material color.
  static const MaterialColor purpleSwatch = MaterialColor(
    0xFF615FFF,
    <int, Color>{
      100: Color(0xFFEDEBFF),
      200: Color(0xFFC2BEFF),
      300: Color(0xFF9A8FFF),
      400: Color(0xFF7C6FFF),
      500: Color(0xFF615FFF),
      600: Color(0xFF4E4CCC),
      700: Color(0xFF3B3999),
    },
  );

  /// Secondary swatch based on surface color
  static const MaterialColor surfaceSwatch = MaterialColor(
    0xFF101118,
    <int, Color>{
      100: Color(0xFF1A1A20),
      200: Color(0xFF2C2C33),
      300: Color(0xFF434347),
      400: Color(0xFF6E6E73),
      500: Color(0xFF101118),
      600: Color(0xFFB3B3B5),
      700: Color(0xFFDADADB),
    },
  );

  /// Neutral swatch based on bg color
  static const MaterialColor bgSwatch = MaterialColor(
    0xFF050509,
    <int, Color>{
      100: Color(0xFF1A1A1E),
      200: Color(0xFF2C2C30),
      300: Color(0xFF434347),
      400: Color(0xFF6E6E72),
      500: Color(0xFF050509),
      600: Color(0xFFB3B3B5),
      700: Color(0xFFDADADB),
    },
  );
}
