import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/badges_widgets.dart';

class BadgesScreen extends StatelessWidget {
  const BadgesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: ()=>context.pop(),
          borderRadius: BorderRadius.circular(50),
          child: const Icon(Icons.arrow_back_ios, size: 18)),
        title: Text('Badges', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AchievementBanner(),
            const SizedBox(height: Sizes.spaceL),
            
            Text('Next Milestone', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: Sizes.spaceM),
            const NextMilestoneCard(),
            const SizedBox(height: Sizes.spaceL),

            Text('Badge Gallery', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: Sizes.spaceM),
            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              // Use a custom delegate instead of GridView.count
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: Sizes.spaceM,
                crossAxisSpacing: Sizes.spaceM,
                // Provide a fixed absolute height for the cards (adjust 220 to fit your content)
                mainAxisExtent: 220, 
              ),
              children: const [
                BadgeCardItem(iconImage: AppAssets.mathsGeniusBadge, iconBg: Color(0xFF1E88E5), title: 'Math Genuis', subtitle: 'Scored 90+ in Mathematics', date: 'EARNED MAY \'24'),
                BadgeCardItem(iconImage: AppAssets.perfectAttendanceBadge, iconBg: Color(0xFFFFB300), title: 'Perfect Attendance', subtitle: 'Maintained 100% attendance for a full term.', date: 'EARNED MAY \'24'),
                BadgeCardItem(iconImage: AppAssets.trackStarBadge, iconBg: Color(0xFF2E7D32), title: 'Track Star', subtitle: 'Scored 90+ in Mathematics', date: 'EARNED MAY \'24'),
                BadgeCardItem(iconImage: AppAssets.perfectAttendanceBadge, iconBg: Color(0xFFFFB300), title: 'Perfect Attendance', subtitle: 'Maintained 100% attendance for a full term.', date: 'EARNED MAY \'24'),
              ],
            ),
            const SizedBox(height: Sizes.spaceXL),

            // THE CUTOFF SECTIONS FROM IMAGE 2
            const ParentBadgesSection(),
            const SizedBox(height: Sizes.spaceL),
            const WeeklyLeaderboardCard(),
            const SizedBox(height: Sizes.spaceXL),
          ],
        ),
      ),
    );
  }
}