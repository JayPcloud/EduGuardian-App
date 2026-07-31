import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/teacher_dashboard_components.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TeacherDashboardHeader(),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.spaceL),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats Row
                  Row(
                    children: const [
                      StatCard(count: '5', label: 'Classes', icon: LucideIcons.building, iconColor: Color(0xFF1E88E5), bgColor: Color(0xFFE3F2FD)),
                      StatCard(count: '140', label: 'Students', icon: LucideIcons.users, iconColor: Color(0xFFD81B60), bgColor: Color(0xFFFCE4EC)),
                      StatCard(count: '2', label: 'Subjects', icon: LucideIcons.bookOpen, iconColor: Color(0xFFFF9800), bgColor: Color(0xFFFFF3E0)),
                      StatCard(count: '2/5', label: 'Marked', icon: LucideIcons.edit2, iconColor: Color(0xFF43A047), bgColor: Color(0xFFE8F5E9)),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceXXL),
                  
                  // Quick Actions
                  Text('Quick Actions', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                  const SizedBox(height: Sizes.spaceM),
                  Row(
                    spacing: Sizes.spaceSm,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      QuickActionBtn(
                        onTap: ()=> context.go(AppRoutes.attendance),
                        label: 'Attendance', icon: LucideIcons.edit3, iconColor: Colors.white, bgColor: Color(0xFF285287)), // Deep blue matching your design
                      QuickActionBtn(
                        onTap: ()=>context.push(AppRoutes.resultEntry),
                        label: 'Results', icon: LucideIcons.fileText, iconColor: Color(0xFF00ACC1), bgColor: Color(0xFFE0F7FA)),
                      QuickActionBtn(
                        onTap: ()=> context.go(AppRoutes.messaging),
                        label: 'Message', icon: LucideIcons.messageSquare, iconColor: Color(0xFF8E24AA), bgColor: Color(0xFFF3E5F5)),
                      QuickActionBtn(
                        onTap: ()=>context.push(AppRoutes.teachersTimeTable),
                        label: 'Timetable', icon: LucideIcons.calendar, iconColor: Color(0xFF43A047), bgColor: Color(0xFFE8F5E9)),
                    ],
                  ),
                  const SizedBox(height: Sizes.spaceXXL),

                  // Today's Schedule
                  Text('Today\'s Schedule', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                  const SizedBox(height: Sizes.spaceM),
                  
                  const ScheduleCard(timeH: '08:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', details: '32 students   Room 202', status: 'Upcoming'),
                  const ScheduleCard(timeH: '08:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', details: '32 students   Room 202', status: 'Upcoming'),
                  const ScheduleCard(timeH: '08:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', details: '32 students   Room 202', status: 'Upcoming'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}