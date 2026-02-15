import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyle {
  // =========================
  // Base font families
  // =========================

  /// Safely loads a Google Font with fallback to system font if network fails.
  /// 
  /// This helper prevents app crashes when Google Fonts CDN is unreachable
  /// (e.g., no internet connection, DNS issues, network timeout).
  /// 
  /// If the font fails to load, it falls back to the default system font
  /// with the same styling parameters.
  static TextStyle _safeGoogleFont({
    required TextStyle Function() fontLoader,
    required FontWeight fontWeight,
    required double height,
    required double letterSpacing,
  }) {
    try {
      return fontLoader();
    } catch (e) {
      // Font loading failed (network error, DNS issue, etc.)
      // Return a fallback TextStyle with the same properties
      return TextStyle(
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
      );
    }
  }

  /// UI / Body / Labels (cross-platform safe)
  static final TextStyle _sans = _safeGoogleFont(
    fontLoader: () => GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      height: 1.4,
      letterSpacing: 0,
    ),
    fontWeight: FontWeight.w400,
    height: 1.4,
    letterSpacing: 0,
  );

  /// Display / Headings
  static final TextStyle _display = _safeGoogleFont(
    fontLoader: () => GoogleFonts.manrope(
      fontWeight: FontWeight.w600,
      height: 1.2,
      letterSpacing: -0.4,
    ),
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.4,
  );

  // =========================
  // DISPLAY
  // =========================

  static final TextStyle displayLarge = _display.copyWith(
    fontSize: 48,
    letterSpacing: -1.1,
  );

  static final TextStyle displayMedium = _display.copyWith(
    fontSize: 40,
    letterSpacing: -0.9,
  );

  static final TextStyle displaySmall = _display.copyWith(
    fontSize: 32,
    letterSpacing: -0.7,
  );

  static final TextStyle displayXSmall = _display.copyWith(
    fontSize: 28,
    letterSpacing: -0.5,
  );

  // =========================
  // HEADLINES
  // =========================

  static final TextStyle headlineLarge = _display.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.25,
  );

  static final TextStyle headlineMedium = _display.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static final TextStyle headlineSmall = _display.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.35,
  );

  // =========================
  // BODY
  // =========================

  static final TextStyle bodyLarge = _sans.copyWith(fontSize: 16);

  static final TextStyle bodyMedium = _sans.copyWith(fontSize: 14);

  static final TextStyle bodySmall = _sans.copyWith(fontSize: 12);

  static final TextStyle bodyXSmall = _sans.copyWith(fontSize: 10);

  // =========================
  // LABELS / UI CONTROLS
  // =========================

  static final TextStyle labelXLarge = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle labelLarge = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle labelMedium = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle labelSmall = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle labelXSmall = _sans.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
  );

  // =========================
  // LINKS
  // =========================

  static final TextStyle textLinksLarge = bodyLarge.copyWith(
    decoration: TextDecoration.underline,
  );

  static final TextStyle textLinksMedium = bodyMedium.copyWith(
    decoration: TextDecoration.underline,
  );

  static final TextStyle textLinksSmall = bodySmall.copyWith(
    decoration: TextDecoration.underline,
  );

  // =========================
  // FUNCTIONAL / META
  // =========================

  static final TextStyle functionalSmall = _sans.copyWith(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.2,
  );

  static final TextStyle functionalXSmall = _sans.copyWith(
    fontSize: 8,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.4,
  );
}
