import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../buttons/primary_button.dart';
import '../buttons/outlined_border_button.dart';

class WarningDialog extends StatelessWidget {
  final String title;
  final String message;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const WarningDialog({
    super.key,
    required this.title,
    required this.message,
    this.primaryButtonText = 'Yes',
    this.secondaryButtonText = 'No',
    required this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required String message,
    String primaryButtonText = 'Yes',
    String secondaryButtonText = 'No',
    required VoidCallback onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) => WarningDialog(
        title: title,
        message: message,
        primaryButtonText: primaryButtonText,
        secondaryButtonText: secondaryButtonText,
        onPrimaryPressed: onPrimaryPressed,
        onSecondaryPressed: onSecondaryPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusL)),
      backgroundColor: theme.cardTheme.color,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingXL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Warning Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF8E1), // Light Amber
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                size: 48,
                color: Color(0xFFFFB300), // Amber
              ),
            ),
            const SizedBox(height: Sizes.spaceL),
            
            Text(title, style: theme.textTheme.titleLarge, textAlign: TextAlign.center),
            const SizedBox(height: Sizes.spaceM),
            Text(message, style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            const SizedBox(height: Sizes.spaceXL),
            
            // Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedBorderButton(
                    label: secondaryButtonText,
                    onPressed: onSecondaryPressed ?? () => Navigator.pop(context),
                  ),
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  child: PrimaryButton(
                    label: primaryButtonText,
                    onPressed: onPrimaryPressed,
                    trailingIcon: null,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}