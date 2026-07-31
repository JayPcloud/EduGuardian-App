import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import 'hero_banner.dart';

class AchievementBanner extends StatelessWidget {
  const AchievementBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return HeroBanner(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your achievement', style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: Sizes.spaceL),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('TOTAL BADGES', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('12', style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('POINT', style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('2450', style: theme.textTheme.headlineMedium?.copyWith(color: colorScheme.onPrimary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class NextMilestoneCard extends StatelessWidget {
  const NextMilestoneCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Text('🏃‍♂️', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: Sizes.spaceS),
                    Flexible(child: Text('Master Scientist', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer),)),
                  ],
                ),
              ),
              Text('75%', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),
          ClipRRect(
            borderRadius: BorderRadius.circular(Sizes.radiusCircular),
            child: LinearProgressIndicator( borderRadius: BorderRadius.circular(Sizes.radiusM), value: 0.75, backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5), color: theme.colorScheme.primary, minHeight: 6),
          ),
          const SizedBox(height: Sizes.spaceS),
          Text('Earn 3 more scores above 90 in science subjects to unlock', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 11)),
        ],
      ),
    );
  }
}

class BadgeCardItem extends StatelessWidget {
  final String iconImage;
  final Color iconBg;
  final String title;
  final String subtitle;
  final String date;

  const BadgeCardItem({super.key, required this.iconImage, required this.iconBg, required this.title, required this.subtitle, required this.date});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(child: CircleAvatar(radius: 20, backgroundColor: iconBg, child: Image.asset(iconImage,))),
          const SizedBox(height: Sizes.spaceXS),
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),textAlign: TextAlign.center,),
          const SizedBox(height: Sizes.spaceXS),
          Text(subtitle, textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 10)),
          const SizedBox(height: Sizes.spaceSm),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: const Color(0xFFFAF3DE), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
            child: Text(date, style: TextStyle(color: AppColors.onPrimaryContainer, fontSize: 9, fontWeight: FontWeight.w600),textAlign: TextAlign.center),
          )
        ],
      ),
    );
  }
}

// --- THESE ARE THE BOTTOM CUTOFFS FROM IMAGE 2 ---
class ParentBadgesSection extends StatelessWidget {
  const ParentBadgesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Parent badges', style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.outlineVariant)),
        const SizedBox(height: Sizes.spaceS),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildTag('🛡️ Most Active Parent', const Color(0xFFFFF8E1), theme),
            _buildTag('⚡ Quick Responder', const Color(0xFFECEFF1), theme),
            _buildTag('🤝 PTA Supporter', const Color(0xFFFFF8E1), theme),
          ],
        )
      ],
    );
  }

  Widget _buildTag(String text, Color bg, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
      child: Text(text, style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 11, fontWeight: FontWeight.w700)),
    );
  }
}

class WeeklyLeaderboardCard extends StatelessWidget {
  const WeeklyLeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final leaders = [
      {'rank': '1', 'name': 'Mrs. Okafor (You)', 'pts': '1280', 'isYou': true},
      {'rank': '2', 'name': 'Mr. Adebayo', 'pts': '1210', 'isYou': false},
      {'rank': '3', 'name': 'Mrs. Nwosu', 'pts': '1180', 'isYou': false},
      {'rank': '4', 'name': 'Alhaji Ibrahim', 'pts': '1095', 'isYou': false},
      {'rank': '5', 'name': 'Mrs. Eze', 'pts': '1020', 'isYou': false},
    ];

    bool isTop3(String rank)=> rank == '1' || rank== '2' || rank=='3';
    
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.8)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        children: [
          Row(
            spacing: Sizes.spaceM,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text('Weekly leaderboard', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600))),
              Text('Updates Mon 8 AM', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),
          ...leaders.map((item) {
            final isYou = item['isYou'] as bool;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: isYou ? const Color(0xFFECEFF1).withValues(alpha: 0.8) : Colors.transparent, // Soft amber glow for "You"
                borderRadius: BorderRadius.circular(Sizes.radiusM),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isTop3(item['rank'] as String) ? const Color(0xFFE9AC04) : theme.colorScheme.outline.withValues(alpha: 0.5),
                    child: Text(item['rank'] as String, style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontSize: 11, fontWeight: FontWeight.w600)),
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(child: Text(item['name'] as String, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer))),
                  Text(item['pts'] as String, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}