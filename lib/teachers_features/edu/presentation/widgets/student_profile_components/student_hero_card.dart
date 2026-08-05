import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';

// --- HERO PROFILE CARD ---
class StudentHeroCard extends StatelessWidget {
  const StudentHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 36,
            backgroundImage: const NetworkImage('https://i.pravatar.cc/150?img=9'), // Ifeoma's avatar
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
          ),
          const SizedBox(width: Sizes.spaceL),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        'Ifeoma Eze',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                        maxLines: 2, overflow: TextOverflow.ellipsis
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(Sizes.radiusS),
                      ),
                      child: Text(
                        'Active',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: const Color(0xFF00ACC1),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'EDU/JSS3A/001 - JSS 3A',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer, // Brand Blue
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2, overflow: TextOverflow.ellipsis
                ),
                const SizedBox(height: 8),
                FittedBox(
                  child: Row(
                    children: [
                      Text('Age: 15', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                      const SizedBox(width: Sizes.spaceL),
                      Text('Female', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)), // Matching your screenshot exactly
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}