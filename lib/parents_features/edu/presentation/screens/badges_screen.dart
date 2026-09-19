import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../controllers/badges_provider.dart';
import '../widgets/badges_widgets.dart';
// Import badgesProvider and activeWardProvider here

class BadgesScreen extends ConsumerWidget {
  const BadgesScreen({super.key});

  // Helper to give dynamic colors if the logo is missing based on "Rare", "Epic", etc.
  Color _getBadgeColor(String type) {
    switch (type.toLowerCase()) {
      case 'rare': return const Color(0xFF1E88E5);
      case 'epic': return const Color(0xFF8E24AA);
      case 'legendary': return const Color(0xFFFFB300);
      default: return const Color(0xFF2E7D32);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final badgesAsync = ref.watch(badgesProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => context.pop(),
          borderRadius: BorderRadius.circular(50),
          child: const Icon(Icons.arrow_back_ios, size: 18),
        ),
        title: Text('Badges', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // 🚨 ENTIRE STUDENT SECTION WRAPPED IN ASYNC
            badgesAsync.when(
              skipLoadingOnRefresh: false,
              loading: () => const StudentBadgesSectionShimmer(),
              error: (err, stack) => AppErrorWidget(
                message: err.toString(),
                onRetry: () => ref.invalidate(badgesProvider),
              ),
              data: (badges) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🚨 PASS TOTAL BADGES TO YOUR BANNER
                    AchievementBanner(totalBadges: badges.length.toString()), 
                    const SizedBox(height: Sizes.spaceL),
                    
                    Text('Next Milestone', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: Sizes.spaceM),
                    const NextMilestoneCard(),
                    const SizedBox(height: Sizes.spaceL),

                    Text('Badge Gallery (${badges.length})', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: Sizes.spaceM),
                    
                    if (badges.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: Text("No badges earned yet.", style: TextStyle(color: Colors.grey))),
                      )
                    else
                      GridView(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: Sizes.spaceM,
                          crossAxisSpacing: Sizes.spaceM,
                          mainAxisExtent: 220, 
                        ),
                        children: badges.map((badge) {
                          final color = _getBadgeColor(badge.type);
                          
                          String dateStr = 'JUST EARNED';
                          if (badge.awardedAt != null) {
                            dateStr = DateFormat("MMM ''yy").format(badge.awardedAt!).toUpperCase();
                          }

                          return BadgeCardItem(
                            iconImage: badge.logo ?? AppAssets.mathsGeniusBadge, 
                            iconBg: color, 
                            title: badge.name, 
                            subtitle: badge.description, 
                            date: 'EARNED $dateStr',
                          );
                        }).toList(),
                      ),
                  ],
                );
              },
            ),
            
            const SizedBox(height: Sizes.spaceXL),

            // 🚨 STATIC SECTIONS (Outside the .when block)
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