import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';
import '../../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.height,
    this.onPressed,
    this.trailingIcon = Icons.arrow_forward,
    this.isLoading = false,
    this.isEnabled = true,
  });

  final String label;
  final double? height;
  final VoidCallback? onPressed;
  final IconData? trailingIcon;
  final bool isLoading;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool enabled = isEnabled && !isLoading && onPressed != null;

    return Container(
      width: double.infinity,
      height: height??50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Sizes.radiusXXL),
        gradient: enabled
            ? LinearGradient(
                // Keep it strictly horizontal for that smooth pill look
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  // Deepen the left side smoothly (no harsh stops)
                  AppColors.primaryDark,
                  Color(0xff0064CC),
                ],
              )
            : null,
        color: enabled ? null : theme.colorScheme.primary.withValues(alpha: 0.5),
      ),
      child: ElevatedButton(
        onPressed: enabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent, // Prevents default shadow from muddying the gradient
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.buttonBorderRadius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: Sizes.iconM,
                height: Sizes.iconM,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: theme.colorScheme.onPrimary,
                ),
              )
            : FittedBox(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (trailingIcon != null) ...[
                      const SizedBox(width: Sizes.spaceS),
                      Icon(trailingIcon, size: Sizes.iconM, color:theme.colorScheme.onPrimary),
                    ],
                  ],
                ),
            ),
      ),
    );
  }
}