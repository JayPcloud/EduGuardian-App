import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // FIX: Expanded prevents the text from pushing the right-side icons off-screen
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GOOD MORNING', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant, letterSpacing: 1.2)),
              Text('Mrs. Okafor', 
                maxLines: 1, 
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            ],
          ),
        ),
        const SizedBox(width: Sizes.spaceS),
        Row(
          children: [
            CircleAvatar(
              backgroundColor: colorScheme.surfaceContainerHighest,
              child: Badge(
                  backgroundColor: AppColors.yellowAccent,
                  child: Icon(LucideIcons.bell, size: Sizes.iconM, color: colorScheme.onSurfaceVariant)),
            ),
            const SizedBox(width: Sizes.spaceS),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: Sizes.paddingXS),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                border: Border.all(color: colorScheme.outline),
                borderRadius: BorderRadius.circular(Sizes.radiusCircular),
              ),
              child: Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: colorScheme.primaryContainer, child: Text('E', style: textTheme.labelSmall)),
                  const SizedBox(width: Sizes.spaceXS),
                  Text('Ebele', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const Icon(Icons.keyboard_arrow_down, size: 16),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}