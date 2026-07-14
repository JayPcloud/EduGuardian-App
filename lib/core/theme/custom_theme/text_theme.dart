import 'package:flutter/material.dart';

import '../app_colors.dart';


class AppTextTheme {
  static TextTheme get lightTheme => TextTheme(
        displayLarge: AppTypography.textTheme.displayLarge,
        displayMedium: AppTypography.textTheme.displayMedium,
        headlineLarge: AppTypography.textTheme.headlineLarge,
        headlineMedium: AppTypography.textTheme.headlineMedium,
        headlineSmall: AppTypography.textTheme.headlineSmall,
        titleLarge: AppTypography.textTheme.titleLarge,
        titleMedium: AppTypography.textTheme.titleMedium,
        titleSmall: AppTypography.textTheme.titleSmall,
        bodyLarge: AppTypography.textTheme.bodyLarge,
        bodyMedium: AppTypography.textTheme.bodyMedium,
        bodySmall: AppTypography.textTheme.bodySmall,
        labelLarge: AppTypography.textTheme.labelLarge,
        labelMedium: AppTypography.textTheme.labelMedium,
        labelSmall: AppTypography.textTheme.labelSmall,
      );

  static TextTheme get darkTheme => TextTheme();
}


class AppTypography {
  AppTypography._();

  static TextTheme textTheme = TextTheme(
    headlineLarge: _baseStyle(FontWeight.w600, 32),
    headlineMedium: _baseStyle(FontWeight.w600, 24),
    headlineSmall: _baseStyle(FontWeight.w600, 22),
    titleLarge: _baseStyle(FontWeight.w600, 19),
    titleMedium: _baseStyle(FontWeight.w500, 16),
    titleSmall: _baseStyle(FontWeight.w500, 14),
    labelLarge: _baseStyle(FontWeight.w600, 14, color: AppColors.textDark),
    labelMedium:
        _baseStyle(FontWeight.w500, 12, color: AppColors.textDark),
    labelSmall:
        _baseStyle(FontWeight.w500, 11, color: AppColors.textSecondary),
    bodyLarge: _baseStyle(FontWeight.w400, 16),
    bodyMedium: _baseStyle(FontWeight.w400, 14, color: AppColors.textDark),
    bodySmall:
        _baseStyle(FontWeight.w400, 12, color: AppColors.textSecondary),
  );

  static TextStyle _baseStyle(FontWeight weight, double size, {Color? color}) {
    return TextStyle(
      fontFamily: 'Roboto',
      fontWeight: weight,
      fontSize: size,
      color: color ?? AppColors.onBackground,
      letterSpacing: size >= 16 ? -0.15 : 0,
    );
  }
}


