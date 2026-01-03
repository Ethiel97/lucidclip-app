import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/app_colors.dart';
import 'package:lucid_clip/core/theme/app_text_styles.dart';
import 'package:tinycolor2/tinycolor2.dart';

class AppTheme {
  const AppTheme();

  /// Light theme for LucidClip
  ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primarySwatch: AppColors.purpleSwatch,
    scaffoldBackgroundColor: Colors.grey[50],
    canvasColor: Colors.grey[50],
    popupMenuTheme: const PopupMenuThemeData(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(Colors.white),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primarySoft,
      tertiary: Colors.grey[100],
      onSecondary: Colors.black87,
      surface: Colors.white,
      onSurface: Colors.black87,
      outline: Colors.grey[300],
      outlineVariant: Colors.grey[400],
      onTertiary: Colors.black54,
      error: AppColors.danger,
      errorContainer: AppColors.dangerSoft,
      onError: Colors.white,
    ),
    textTheme: _lightTextTheme,
    cardTheme: _lightCardTheme,
    inputDecorationTheme: _lightInputDecorationTheme,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[50],
      elevation: 0,
      centerTitle: false,
      iconTheme: const IconThemeData(color: Colors.black54),
    ),
    iconTheme: const IconThemeData(color: Colors.black54, size: 18),
    dividerColor: Colors.grey[300]?.withValues(alpha: .6),
    listTileTheme: const ListTileThemeData(
      dense: true,
      contentPadding: EdgeInsets.zero,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(999),
    ),
    filledButtonTheme: _lightFilledButtonTheme,
    textButtonTheme: _lightTextButtonTheme,
    chipTheme: _lightChipTheme,
    dialogTheme: _lightDialogTheme,
  );

  /// Dark theme – primary for LucidClip
  ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primarySwatch: AppColors.purpleSwatch,
    scaffoldBackgroundColor: AppColors.bg,
    canvasColor: AppColors.bg,
    popupMenuTheme: PopupMenuThemeData(
      color: AppColors.surface2.toTinyColor().lighten().color,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14)),
      ),
    ),

    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppColors.surface2.toTinyColor().lighten(5).color,
        ),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),

    menuTheme: MenuThemeData(
      style: MenuStyle(
        backgroundColor: WidgetStateProperty.all(
          AppColors.surface2.toTinyColor().lighten(5).color,
        ),
        elevation: WidgetStateProperty.all(8),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: Colors.white,
      secondary: AppColors.primarySoft,
      tertiary: AppColors.surface2,
      onSecondary: Colors.white,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      outline: AppColors.borderSubtle,
      outlineVariant: AppColors.textMuted,
      onTertiary: AppColors.textSecondary,
      error: AppColors.danger,
      errorContainer: AppColors.dangerSoft,
      onError: Colors.white,
    ),
    textTheme: _textTheme,
    cardTheme: _cardTheme,
    inputDecorationTheme: _inputDecorationTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: false,
    ),
    iconTheme: const IconThemeData(color: AppColors.textSecondary, size: 18),
    dividerColor: AppColors.borderSubtle.withValues(alpha: .6),
    listTileTheme: const ListTileThemeData(
      dense: true,
      contentPadding: EdgeInsets.zero,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all(true),
      thickness: WidgetStateProperty.all(6),
      radius: const Radius.circular(999),
    ),
    filledButtonTheme: _filledButtonTheme,
    textButtonTheme: _textButtonTheme,
    chipTheme: _chipTheme,
    dialogTheme: _dialogTheme,
  );

  /// Mapping AppTextStyle → TextTheme
  TextTheme get _textTheme => TextTheme(
    displayLarge: AppTextStyle.displayLarge,
    displayMedium: AppTextStyle.displayMedium,
    displaySmall: AppTextStyle.displaySmall,
    headlineLarge: AppTextStyle.headlineLarge,
    headlineMedium: AppTextStyle.headlineMedium,
    headlineSmall: AppTextStyle.headlineSmall,
    titleLarge: AppTextStyle.headlineSmall,
    titleMedium: AppTextStyle.bodyLarge,
    titleSmall: AppTextStyle.bodyMedium,
    bodyLarge: AppTextStyle.bodyLarge.copyWith(color: AppColors.textPrimary),
    bodyMedium: AppTextStyle.bodyMedium.copyWith(
      color: AppColors.textSecondary,
    ),
    bodySmall: AppTextStyle.bodySmall.copyWith(color: AppColors.textMuted),
    labelLarge: AppTextStyle.labelLarge,
    labelMedium: AppTextStyle.labelMedium,
    labelSmall: AppTextStyle.labelSmall,
  );

  CardThemeData get _cardTheme => CardThemeData(
    color: AppColors.surface,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: EdgeInsets.zero,
  );

  InputDecorationTheme get _inputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surface2,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    hintStyle: AppTextStyle.bodySmall.copyWith(color: AppColors.textMuted),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
  );

  FilledButtonThemeData get _filledButtonTheme => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: AppColors.surface2,
      foregroundColor: AppColors.textPrimary,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      textStyle: AppTextStyle.labelSmall,
    ),
  );

  TextButtonThemeData get _textButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.textSecondary,
      textStyle: AppTextStyle.bodySmall,
    ),
  );

  ChipThemeData get _chipTheme => ChipThemeData(
    backgroundColor: AppColors.primary.withValues(alpha: 0.13),
    labelStyle: AppTextStyle.labelSmall.copyWith(color: AppColors.primary),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
  );

  DialogThemeData get _dialogTheme => DialogThemeData(
    backgroundColor: AppColors.surface,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: AppTextStyle.headlineMedium,
    contentTextStyle: AppTextStyle.bodyMedium,
    barrierColor: AppColors.bg.withValues(alpha: .6),
  );

  // Light theme specific properties
  TextTheme get _lightTextTheme => TextTheme(
    displayLarge: AppTextStyle.displayLarge.copyWith(color: Colors.black87),
    displayMedium: AppTextStyle.displayMedium.copyWith(color: Colors.black87),
    displaySmall: AppTextStyle.displaySmall.copyWith(color: Colors.black87),
    headlineLarge: AppTextStyle.headlineLarge.copyWith(color: Colors.black87),
    headlineMedium: AppTextStyle.headlineMedium.copyWith(color: Colors.black87),
    headlineSmall: AppTextStyle.headlineSmall.copyWith(color: Colors.black87),
    titleLarge: AppTextStyle.headlineSmall.copyWith(color: Colors.black87),
    titleMedium: AppTextStyle.bodyLarge.copyWith(color: Colors.black87),
    titleSmall: AppTextStyle.bodyMedium.copyWith(color: Colors.black87),
    bodyLarge: AppTextStyle.bodyLarge.copyWith(color: Colors.black87),
    bodyMedium: AppTextStyle.bodyMedium.copyWith(color: Colors.black54),
    bodySmall: AppTextStyle.bodySmall.copyWith(color: Colors.black45),
    labelLarge: AppTextStyle.labelLarge.copyWith(color: Colors.black87),
    labelMedium: AppTextStyle.labelMedium.copyWith(color: Colors.black87),
    labelSmall: AppTextStyle.labelSmall.copyWith(color: Colors.black87),
  );

  CardThemeData get _lightCardTheme => CardThemeData(
    color: Colors.white,
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    margin: EdgeInsets.zero,
  );

  InputDecorationTheme get _lightInputDecorationTheme => InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[100],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(999),
      borderSide: const BorderSide(color: AppColors.primary),
    ),
    hintStyle: AppTextStyle.bodySmall.copyWith(color: Colors.black45),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    prefixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
    suffixIconConstraints: const BoxConstraints(minWidth: 24, minHeight: 24),
  );

  FilledButtonThemeData get _lightFilledButtonTheme => FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: Colors.grey[100],
      foregroundColor: Colors.black87,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      textStyle: AppTextStyle.labelSmall,
    ),
  );

  TextButtonThemeData get _lightTextButtonTheme => TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: Colors.black54,
      textStyle: AppTextStyle.bodySmall,
    ),
  );

  ChipThemeData get _lightChipTheme => ChipThemeData(
    backgroundColor: AppColors.primary.withValues(alpha: 0.13),
    labelStyle: AppTextStyle.labelSmall.copyWith(color: AppColors.primary),
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
  );

  DialogThemeData get _lightDialogTheme => DialogThemeData(
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    titleTextStyle: AppTextStyle.headlineMedium.copyWith(color: Colors.black87),
    contentTextStyle: AppTextStyle.bodyMedium.copyWith(color: Colors.black87),
    barrierColor: Colors.black.withValues(alpha: .4),
  );
}
