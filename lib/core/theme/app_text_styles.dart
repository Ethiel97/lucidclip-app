import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class AppTextStyle {
  // Base families
  static final TextStyle _sans = GoogleFonts.sora(
    fontWeight: FontWeight.w400,
    height: 1.25,
    letterSpacing: 0,
  );

  static final TextStyle _flare = GoogleFonts.inter(
    fontWeight: FontWeight.w500,
    height: 1.1,
    letterSpacing: 0,
  );

  /// DISPLAY
  static final TextStyle displayLarge = _flare.copyWith(
    fontSize: 48,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static final TextStyle displayMedium = _flare.copyWith(
    fontSize: 40,
    fontWeight: FontWeight.w500,
    letterSpacing: -1,
  );

  static final TextStyle displaySmall = _flare.copyWith(
    fontSize: 32,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.75,
  );

  static final TextStyle displayXSmall = _flare.copyWith(
    fontSize: 28,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.5,
  );

  /// HEADLINES
  static final TextStyle headlineLarge = _sans.copyWith(
    fontSize: 30,
    fontWeight: FontWeight.w600,
    height: 1.15,
    letterSpacing: -0.4,
  );

  static final TextStyle headlineMedium = _sans.copyWith(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: -0.2,
  );

  static final TextStyle headlineSmall = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  /// BODY
  static final TextStyle bodyLarge = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.35,
  );

  static final TextStyle bodyMedium = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static final TextStyle bodySmall = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  static final TextStyle bodyXSmall = _sans.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 1.3,
  );

  /// LABELS
  static final TextStyle labelXLarge = _sans.copyWith(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static final TextStyle labelLarge = _sans.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final TextStyle labelMedium = _sans.copyWith(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final TextStyle labelSmall = _sans.copyWith(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.25,
  );

  static final TextStyle labelXSmall = _sans.copyWith(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  /// LINKS
  static final TextStyle textLinksLarge = bodyLarge.copyWith(
    decoration: TextDecoration.underline,
  );

  static final TextStyle textLinksMedium = bodyMedium.copyWith(
    decoration: TextDecoration.underline,
  );

  static final TextStyle textLinksSmall = bodySmall.copyWith(
    decoration: TextDecoration.underline,
  );

  /// FUNCTIONAL (sections "PINNED", "RECENT", etc.)
  static final TextStyle functionalSmall = _sans.copyWith(
    fontSize: 9,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: 1.1,
  );

  static final TextStyle functionalXSmall = _sans.copyWith(
    fontSize: 8,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.3,
  );
}
