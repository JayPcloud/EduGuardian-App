import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class DashboardActionCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final String? pillText;
  final Color? pillTextColor;
  final Color? pillBgColor;
  final VoidCallback? onPressed;

  const DashboardActionCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.pillText,
    this.pillTextColor,
    this.pillBgColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(bottom: Sizes.spaceM),
        padding: const EdgeInsets.all(Sizes.paddingM),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(Sizes.radiusL),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(Sizes.paddingSm),
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(Sizes.radiusM),
              ),
              child: Icon(icon, color: iconColor, size: Sizes.iconM),
            ),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (pillText != null && pillTextColor != null && pillBgColor != null) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 2),
                      decoration: BoxDecoration(
                        color: pillBgColor,
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                      ),
                      child: Text(
                        pillText!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: pillTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 9,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXS),
                  ],
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceXS),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.outlineVariant,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}