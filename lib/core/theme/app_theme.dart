import 'package:flutter/material.dart';
import 'package:lucid_clip/core/theme/app_colors.dart';
import 'package:lucid_clip/core/theme/app_text_styles.dart';

class AppTheme {
  const AppTheme();

  /// Dark theme – primary for LucidClip
  ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primarySwatch: AppColors.purpleSwatch,
        scaffoldBackgroundColor: AppColors.bg,
        canvasColor: AppColors.bg,
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.primarySoft,
          onSecondary: Colors.white,
          surface: AppColors.surface,
          onSurface: AppColors.textPrimary,
          error: AppColors.danger,
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
        iconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: 18,
        ),
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
        bodyLarge: AppTextStyle.bodyLarge.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyMedium: AppTextStyle.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: AppTextStyle.bodySmall.copyWith(
          color: AppColors.textMuted,
        ),
        labelLarge: AppTextStyle.labelLarge,
        labelMedium: AppTextStyle.labelMedium,
        labelSmall: AppTextStyle.labelSmall,
      );

  CardTheme get _cardTheme => CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
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
          borderSide: const BorderSide(
            color: AppColors.primary,
          ),
        ),
        hintStyle: AppTextStyle.bodySmall.copyWith(
          color: AppColors.textMuted,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      );

  FilledButtonThemeData get _filledButtonTheme => FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.surface2,
          foregroundColor: AppColors.textPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
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
        labelStyle: AppTextStyle.labelSmall.copyWith(
          color: AppColors.primary,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(999),
        ),
      );
}
