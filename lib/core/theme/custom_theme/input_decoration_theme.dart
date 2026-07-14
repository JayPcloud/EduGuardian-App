import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../app_colors.dart';
import 'text_theme.dart';

class AppInputDecorationTheme {
  AppInputDecorationTheme._();

  static InputDecorationTheme light = InputDecorationTheme(
    filled: true,
    fillColor: AppColors.surfaceGray,
    contentPadding: const EdgeInsets.symmetric(
      horizontal: Sizes.paddingM,
      vertical: Sizes.paddingM,
    ),
    prefixIconColor: AppColors.textSecondary,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.inputBorderRadius),
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: Sizes.inputBorderWidth,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.inputBorderRadius),
      borderSide: const BorderSide(
        color: Colors.transparent,
        width: Sizes.inputBorderWidth,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.inputBorderRadius),
      borderSide: const BorderSide(
        color: AppColors.primary,
        width: Sizes.inputBorderWidth,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.inputBorderRadius),
      borderSide: const BorderSide(
        color: AppColors.inputError,
        width: Sizes.inputBorderWidth,
      ),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(Sizes.inputBorderRadius),
      borderSide: const BorderSide(
        color: AppColors.inputError,
        width: Sizes.inputBorderWidth,
      ),
    ),
    labelStyle: AppTypography.textTheme.bodyMedium
        ?.copyWith(color: AppColors.textSecondary),
    hintStyle: AppTypography.textTheme.bodyMedium
        ?.copyWith(color: AppColors.textTertiary),
    errorStyle: const TextStyle(color: AppColors.inputError),
  );

  static InputDecorationTheme dark = light.copyWith(
    fillColor: AppColors.darkSurface,
  );
}