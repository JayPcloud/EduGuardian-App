import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🚨 Added Riverpod
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart'; // 🚨 Added Error Widget
import '../../../../core/widgets/common/app_refresh_indicator.dart'; // 🚨 Added Refresh Indicator
import '../controllers/teacher_dashboard_providers.dart';
import '../widgets/teacher_dashboard_components.dart';

class TeacherDashboardScreen extends ConsumerWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final statsAsync = ref.watch(teacherDashboardStatsProvider);
    final scheduleAsync = ref.watch(teacherScheduleProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: AppRefreshIndicator(
        onRefresh: () {
          ref.invalidate(teacherDashboardStatsProvider);
          ref.invalidate(teacherScheduleProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(), // Ensures pull-to-refresh works even if list is short
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TeacherDashboardHeader(), // 🚨 Moved to ConsumerWidget below
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.spaceL),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🚨 DYNAMIC STATS ROW
                    statsAsync.when(
                      skipLoadingOnRefresh: false, // 🚨 As requested
                      loading: () => const TeacherStatsShimmer(),
                      error: (err, stack) => AppErrorWidget(
                        message: err.toString(),
                        onlyErrorMessage: true, // 🚨 As requested for sections
                        onRetry: () => ref.invalidate(teacherDashboardStatsProvider),
                      ),
                      data: (stats) => Row(
                        children: [
                          StatCard(count: stats.totalClassAssigned.toString(), label: 'Classes', icon: LucideIcons.building, iconColor: const Color(0xFF1E88E5), bgColor: const Color(0xFFE3F2FD)),
                          StatCard(count: stats.totalStudents.toString(), label: 'Students', icon: LucideIcons.users, iconColor: const Color(0xFFD81B60), bgColor: const Color(0xFFFCE4EC)),
                          StatCard(count: stats.totalSubjectsAssigned.toString(), label: 'Subjects', icon: LucideIcons.bookOpen, iconColor: const Color(0xFFFF9800), bgColor: const Color(0xFFFFF3E0)),
                          const StatCard(count: '2/5', label: 'Marked', icon: LucideIcons.edit2, iconColor: Color(0xFF43A047), bgColor: Color(0xFFE8F5E9)), // Static until API supports it
                        ],
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXXL),
                    
                    // Quick Actions (Untouched)
                    Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                    const SizedBox(height: Sizes.spaceM),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        QuickActionBtn(
                          onTap: ()=> context.go(AppRoutes.attendance),
                          label: 'Attendance', icon: LucideIcons.edit3, iconColor: Colors.white, bgColor: const Color(0xFF285287)), 
                        const SizedBox(width: Sizes.spaceSm),
                        QuickActionBtn(
                          onTap: ()=>context.push(AppRoutes.resultEntry),
                          label: 'Results', icon: LucideIcons.fileText, iconColor: const Color(0xFF00ACC1), bgColor: const Color(0xFFE0F7FA)),
                        const SizedBox(width: Sizes.spaceSm),
                        QuickActionBtn(
                          onTap: ()=> context.go(AppRoutes.messaging),
                          label: 'Message', icon: LucideIcons.messageSquare, iconColor: const Color(0xFF8E24AA), bgColor: const Color(0xFFF3E5F5)),
                        const SizedBox(width: Sizes.spaceSm),
                        QuickActionBtn(
                          onTap: ()=>context.push(AppRoutes.teachersTimeTable),
                          label: 'Timetable', icon: LucideIcons.calendar, iconColor: const Color(0xFF43A047), bgColor: const Color(0xFFE8F5E9)),
                      ],
                    ),
                    const SizedBox(height: Sizes.spaceXXL),

                    // 🚨 DYNAMIC TODAY'S SCHEDULE
                    Text('Today\'s Schedule', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                    const SizedBox(height: Sizes.spaceM),
                    
                    scheduleAsync.when(
                      skipLoadingOnRefresh: false, // 🚨 As requested
                      loading: () => const TeacherScheduleShimmer(),
                      error: (err, stack) => AppErrorWidget(
                        message: err.toString(),
                        onlyErrorMessage: true, 
                        onRetry: () => ref.invalidate(teacherScheduleProvider),
                      ),
                      data: (schedules) {
                        if (schedules.isEmpty) {
                          return const Text("No classes scheduled for today.");
                        }
                        return Column(
                          children: schedules.map((item) => ScheduleCard(
                            timeH: item.timeH,
                            timeM: item.timeM,
                            subject: item.subject,
                            className: item.className,
                            details: item.details,
                            status: item.status,
                          )).toList(),
                        );
                      }
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}