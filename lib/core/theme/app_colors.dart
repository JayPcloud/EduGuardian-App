import 'package:flutter/material.dart';

/// Centralized color tokens for the app's design system.
class AppColors {
  AppColors._();

  // Brand palette
  // Deep navy — used for the primary CTA button and focused/selected strokes.
  static const Color primary = Color(0xFF0B4C86);
  static const Color primaryDark = Color(0xFF003266);
  static const Color primaryContainer = Color(0xFFDCE7F5);
  static const Color onPrimary = Colors.white;
  static const Color onPrimaryContainer = Color(0xFF07154D);

  // Brighter accent blue — used for highlighted title words, links,
  // field labels and small icon accents ("parent account", "really you"...).
  static const Color accentBlue = Color(0xFF2F6FE0);
  static const Color onAccentBlue = Colors.white;

  static const Color secondary = Color(0xFFEEF2FF);
  static const Color secondaryContainer = Color(0xFFC5F5E4);
  static const Color onSecondary = Colors.white;
  static const Color onSecondaryContainer = Color(0xFF012418);

  static const Color yellowAccent = Color(0xFFFFCC00);
  static const Color accentContainer = Color(0xFFFFE3B2);
  static const Color onAccent = Color(0xFF231400);
  static const Color neutralYellow = Color(0xFFFF8D28);

  static const Color redAccent = Color(0xFFFF383C);
  // Neutrals
  static const Color background = Color(0xFFFCFCFC);
  static const Color dashboardbackground = Color(0xFFF0F7FF);
  static const Color onBackground = Color(0xFF1E1E24);
  static const Color surfaceGray = Color(0xFFF2F4F7);
  static const Color strokes = Color(0xFFE5E7EB);
  static const Color transparent = Colors.transparent;

  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF111418);

  // Text colorsbackground: #64748B;

  static const Color textDark = Color(0xFF1F2937);
  static const Color textPrimary = Color(0xFF64748B);
  static const Color textSecondary = Color(0xFF737986);
  static const Color textTertiary = Color(0xFF9CA3AF);

  // Status colors
  static const successText = Color(0xFF28A745);
  static const successContainer = Color(0xFFE6FBEA);

  static const errorText = Color(0xFFDC3545);
  static const errorContainer = Color(0xFFFDECEC);

  static const pendingText = Color(0xFFFFB300);
  static const pendingContainer = Color(0xFFFFF8E1);

  // Dark mode neutrals
  static const Color darkBackground = Color(0xFF0F1117);
  static const Color darkSurface = Color(0xFF161A23);
  static const Color onDark = Color(0xFFE8EAEE);

  static const Color error = Color(0xFFBA1A1A);
  static const Color inputError = Color(0xFFEF4444);
  static const Color like = Color(0xFFEE2C2C);
  static const Color onError = Colors.white;

  static const Color amber = Colors.amber;
  static const Color success = Color(0xFF02A593);
  //static const Color success = Color(0xFF10B981);

  // Social media colors
  static const Color google = Color(0xFF4285F4);
  static const Color facebook = Color(0xFF1877F2);
}