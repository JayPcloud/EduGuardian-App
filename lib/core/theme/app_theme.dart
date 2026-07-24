import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';
import 'app_colors.dart';
import 'custom_theme/input_decoration_theme.dart';
import 'custom_theme/text_theme.dart';

/// Builds the light and dark ThemeData used across the app.
class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme => ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: _lightColorScheme,
        scaffoldBackgroundColor: AppColors.background,
        primaryColorDark: AppColors.primaryDark,
        textTheme: AppTypography.textTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.primaryDark,
          surfaceTintColor: Colors.transparent,
          centerTitle: false,
          elevation: 0,
          
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.yellowAccent,
          foregroundColor: AppColors.onAccent,
          shape: StadiumBorder(),
        ),
        dividerColor: AppColors.strokes,
        cardColor: AppColors.surface,
        inputDecorationTheme: AppInputDecorationTheme.light,
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.radiusXS),
          ),
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.success
                : AppColors.strokes,
          ),
        ),
        switchTheme: SwitchThemeData(
          trackColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.strokes,
          ),
          thumbColor:
              const WidgetStatePropertyAll<Color>(AppColors.onPrimary),
          trackOutlineColor:
              const WidgetStatePropertyAll<Color>(Colors.transparent),
        ),
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith(
            (states) => states.contains(WidgetState.selected)
                ? AppColors.primary
                : AppColors.strokes,
          ),
        ),
      );

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.accentBlue,
    onTertiary: AppColors.onAccentBlue,
    tertiaryContainer: AppColors.accentContainer,
    onTertiaryContainer: AppColors.onAccent,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    surfaceContainerHighest: AppColors.surface,
    onSurfaceVariant: AppColors.textPrimary,
    outlineVariant: AppColors.textSecondary,
    outline: AppColors.strokes,
    shadow: Colors.black12,
    inverseSurface: AppColors.primaryDark,
    onInverseSurface: AppColors.onPrimary,
    inversePrimary: AppColors.primaryDark,
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: _darkColorScheme,
        scaffoldBackgroundColor: AppColors.darkBackground,
        textTheme: AppTypography.textTheme.apply(
          bodyColor: AppColors.onDark,
          displayColor: AppColors.onDark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: AppColors.onDark,
          centerTitle: false,
          elevation: 0,
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: AppColors.yellowAccent,
          foregroundColor: AppColors.onAccent,
          shape: StadiumBorder(),
        ),
        dividerColor: AppColors.strokes.withValues(alpha: 0.3),
        cardColor: AppColors.darkSurface,
        inputDecorationTheme: AppInputDecorationTheme.dark,
      );

  static const ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryDark,
    onPrimaryContainer: AppColors.onPrimary,
    secondary: AppColors.secondaryContainer,
    onSecondary: AppColors.onSecondaryContainer,
    secondaryContainer: AppColors.secondary,
    onSecondaryContainer: AppColors.onSecondary,
    tertiary: AppColors.accentContainer,
    onTertiary: AppColors.onAccent,
    tertiaryContainer: AppColors.yellowAccent,
    onTertiaryContainer: AppColors.onAccent,
    error: AppColors.error,
    onError: AppColors.onError,
    surface: AppColors.darkSurface,
    onSurface: AppColors.onDark,
    surfaceContainerHighest: Color(0xFF282C34),
    onSurfaceVariant: AppColors.onDark,
    outline: Colors.white12,
    shadow: Colors.black,
    inverseSurface: AppColors.surface,
    onInverseSurface: AppColors.onSurface,
    inversePrimary: AppColors.primary,
  );
}