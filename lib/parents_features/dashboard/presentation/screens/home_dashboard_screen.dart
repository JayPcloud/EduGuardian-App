import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../widgets/ai_insight_card.dart';
import '../widgets/dashboard_action_card.dart';
import '../widgets/dashboard_stat_card.dart';
import '../widgets/dashboard_timeline_item.dart';
import '../widgets/home_header.dart';

class ParentDashboardScreen extends StatelessWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.colorScheme.brightness == Brightness.light
          ? AppColors.dashboardbackground
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeHeader(),
              const SizedBox(height: Sizes.spaceL),
              
              const AiInsightCard(),
              const SizedBox(height: Sizes.spaceL),

              Row(
                children: [
                  Expanded(child: DashboardStatCard(label: 'GPA SCORE', value: '3.82')),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(child: DashboardStatCard(label: 'ATTENDANCE', value: '96%')),
                ],
              ),
              const SizedBox(height: Sizes.spaceM),
              Row(
                children: [
                  Expanded(child: DashboardStatCard(label: 'GPA SCORE', value: 'Excellent', isAccent: true)),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(child: DashboardStatCard(label: 'GPA SCORE', value: '4')),
                ],
              ),
              const SizedBox(height: Sizes.spaceXL),

              Text("Today's Timeline", style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: Sizes.spaceM),

              const DashboardTimelineItem(
                  time: '09:00 AM', title: 'Morning Assembly & Devotion', subtitle: 'Main Hall · Mrs Adanna',
                  isDone: true, isFirst: true, isLast: false),
              const DashboardTimelineItem(
                  time: 'IN PROGRESS', title: 'Mathematics — Simultaneous Equations', subtitle: 'JSS 2 D · Mr. Lawal',
                  isDone: false, isActive: true, isFirst: false, isLast: false),
              const DashboardTimelineItem(
                  time: '09:00 AM', title: 'Inter-House Football Practice', subtitle: 'School Field · Green House',
                  isDone: false, isFirst: false, isLast: true, isFaded: true),
              
              const SizedBox(height: Sizes.spaceL),

               DashboardActionCard(
                onPressed: ()=>context.push(AppRoutes.behaviorTimeline),
                icon: LucideIcons.bookOpen,
                iconColor: Color(0xFF00BFA5),
                iconBgColor: Color(0xFFC4FCEF),
                title: '14 Positive Recognitions',
                subtitle: 'Excellent teamwork during science',
                pillText: 'BEHAVIOURAL CONDUCT',
                pillTextColor: Color(0xFF009688),
                pillBgColor: Color(0xFFE0F7FA),
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
    );
  }
}