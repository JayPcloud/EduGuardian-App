import 'package:flutter/material.dart';

class AppDecorations {
  // Private constructor to prevent accidental instantiation
  AppDecorations._();

  // --------------------------------------------------------
  // SHADOWS
  // --------------------------------------------------------
  // Static variable because it doesn't depend on the Theme/Context
  static final List<BoxShadow> defaultShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.03),
      blurRadius: 10,
      offset: const Offset(0, 4),
    ),
  ];

  // --------------------------------------------------------
  // GRADIENTS
  // --------------------------------------------------------
  // Static method because it needs BuildContext to read the active Theme
  static LinearGradient primaryGradient(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return LinearGradient(
      colors: [colorScheme.primary, colorScheme.tertiary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}