import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';

class AiInsightCard extends StatelessWidget {
  const AiInsightCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        gradient: LinearGradient(colors: [colorScheme.primary, colorScheme.tertiary]),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: Sizes.paddingXS),
            decoration: BoxDecoration(color: AppColors.yellowAccent, borderRadius: BorderRadius.circular(Sizes.radiusS)),
            child: Text('AI INSIGHT', style: textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.primaryColorDark)),
          ),
          const SizedBox(height: Sizes.spaceM),
          RichText(
            text: TextSpan(
              style: textTheme.titleMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600, height: 1.4),
              children: const [
                TextSpan(text: "Ebele's focus in "),
                TextSpan(text: "STEM subjects", style: TextStyle(color: AppColors.yellowAccent)),
                TextSpan(text: " has improved by 14% this week."),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceM),
          Text(
            '"Consistent progress in Mathematics is driving this upward trend."',
            style: textTheme.bodySmall?.copyWith(color: colorScheme.onPrimary.withValues(alpha: 0.8), fontStyle: FontStyle.italic),
          )
        ],
      ),
    );
  }
}