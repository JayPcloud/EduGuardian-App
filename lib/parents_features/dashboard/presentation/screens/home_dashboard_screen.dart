import 'package:edu_guardian_app/core/widgets/common/app_error_widget.dart';
import 'package:edu_guardian_app/core/widgets/common/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../controllers/dashboard_providers.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/dashboard_action_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_timeline_item.dart';
import '../widgets/home_header.dart';
import '../widgets/dashboard_shimmer.dart'; 


class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    // 🚨 Listen to the API Providers
    final statsAsync = ref.watch(parentDashboardStatsProvider);
    final timelineAsync = ref.watch(parentTimelineProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.brightness == Brightness.light
          ? AppColors.dashboardbackground
          : null,
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () {
            ref.invalidate(parentDashboardStatsProvider);
            ref.invalidate(parentTimelineProvider);
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Sizes.paddingL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HomeHeader(),
                const SizedBox(height: Sizes.spaceL),
          
                const AiInsightCard(),
                const SizedBox(height: Sizes.spaceL),
          
                // 🚨 DYNAMIC STATS WIRING WITH SHIMMER
                statsAsync.when(
                  skipLoadingOnRefresh: false,
                  loading: () => const DashboardShimmer(), // Shows beautiful skeleton
                  error: (error, stack) => AppErrorWidget(message: error.toString(), onlyErrorMessage: true, onRetry:()=> ref.invalidate(parentDashboardStatsProvider)),
                  data: (stats) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(child: DashboardStatCard(label: 'GPA SCORE', value: stats.gpaScore)),
                          const SizedBox(width: Sizes.spaceM),
                          Expanded(child: DashboardStatCard(label: 'ATTENDANCE', value: '${stats.attendancePercentage}%')),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceM),
                      Row(
                        children: [
                          Expanded(child: DashboardStatCard(label: 'REMARK', value: stats.gpaRemark, isAccent: true)),
                          const SizedBox(width: Sizes.spaceM),
                          Expanded(child: DashboardStatCard(label: 'AVERAGE', value: stats.average)),
                        ],
                      ),
                      const SizedBox(height: Sizes.spaceXL),
          
                      Text("Today's Timeline", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: Sizes.spaceM),
          
                      // 🚨 DYNAMIC TIMELINE WIRING
                      timelineAsync.when(
                        loading: () => const SizedBox.shrink(), // Shimmer handles this above already
                        error: (err, stack) => const Text('Failed to load timeline. Pull to refresh page'),
                        data: (timelineItems) {
                          if (timelineItems.isEmpty) {
                            return const Text("No activities scheduled for today.");
                          }
                          return Column(
                            children: timelineItems.asMap().entries.map((entry) {
                              int index = entry.key;
                              var item = entry.value;
                              return DashboardTimelineItem(
                                time: item.time,
                                title: item.title,
                                subtitle: item.subtitle,
                                isDone: item.isDone,
                                isActive: item.isActive,
                                isFaded: item.isFaded,
                                isFirst: index == 0,
                                isLast: index == timelineItems.length - 1,
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
          
                const SizedBox(height: Sizes.spaceL),
          
                // STATIC ACTION CARDS (Untouched)
                 DashboardActionCard(
                  onPressed: ()=>context.push(AppRoutes.behaviorTimeline),
                  icon: LucideIcons.bookOpen,
                  iconColor: const Color(0xFF00BFA5),
                  iconBgColor: const Color(0xFFC4FCEF),
                  title: '14 Positive Recognitions',
                  subtitle: 'Excellent teamwork during science',
                  pillText: 'BEHAVIOURAL CONDUCT',
                  pillTextColor: const Color(0xFF009688),
                  pillBgColor: const Color(0xFFE0F7FA),
                ),
          
                DashboardActionCard(
                  onPressed: ()=>context.push(AppRoutes.growthAndActivity),
                  icon: LucideIcons.bookmark,
                  iconColor: const Color(0xFFD81B60),
                  iconBgColor: const Color(0xFFF8BBD0).withValues(alpha: 0.5),
                  title: 'Growth & Activity',
                  subtitle: "Check your child's growth and activity beyond the classroom",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}