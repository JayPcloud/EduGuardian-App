import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class AppSnackBar {
  static void show(
    String message, {
    required BuildContext context,
    required Color iconColor,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(Sizes.paddingM),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: iconColor.withOpacity(0.2)),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 22),
              const SizedBox(width: Sizes.spaceM),
              Expanded(
                child: Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void success(String message, {required BuildContext context}) {
    final theme = Theme.of(context);
    show(
      message,
      context: context,
      iconColor: Colors.green.shade600,
      backgroundColor: theme.colorScheme.surface,
      icon: Icons.check_circle_rounded,
    );
  }

  static void error(String message, {required BuildContext context}) {
    final theme = Theme.of(context);
    show(
      message,
      context: context,
      iconColor: theme.colorScheme.error,
      backgroundColor: theme.colorScheme.surface,
      icon: Icons.error_rounded,
    );
  }
}