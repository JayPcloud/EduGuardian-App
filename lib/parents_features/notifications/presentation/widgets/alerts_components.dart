import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';

// --- SECTION HEADER ---
class AlertSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const AlertSectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Using a muted blue/grey tone matching the design
    final headerColor = theme.colorScheme.primary.withValues(alpha: 0.8); 

    return Row(
      children: [
        Icon(icon, size: 14, color: headerColor),
        const SizedBox(width: Sizes.spaceS),
        Text(
          title,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700, 
            color: headerColor,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }
}

// --- ALERT CARD ---
class AlertCard extends StatelessWidget {
  final String title;
  final String time;
  final String body;

  const AlertCard({
    super.key,
    required this.title,
    required this.time,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title, 
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700, // Kept to w700 maximum as requested
                    color: theme.colorScheme.onPrimaryContainer
                  ),
                ),
              ),
              const SizedBox(width: Sizes.spaceS),
              Text(
                time, 
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outlineVariant
                ),
              ),
            ],
          ),
          const SizedBox(height: Sizes.spaceS),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outlineVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}


class AlertsShimmer extends StatelessWidget {
  const AlertsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section header skeleton
          Container(width: 100, height: 16, color: Colors.white),
          const SizedBox(height: Sizes.spaceM),
          // Skeletons for cards
          ...List.generate(3, (index) => Container(
            margin: const EdgeInsets.only(bottom: Sizes.spaceM),
            height: 90,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.radiusL),
            ),
          )),
        ],
      ),
    );
  }
}