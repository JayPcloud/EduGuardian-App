import 'package:edu_guardian_app/teachers_features/edu/presentation/widgets/student_profile_components/student_growth_section.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/student_profile_components/student_attendance_tab_section.dart';
import '../widgets/student_profile_components/student_badges_section.dart';
import '../widgets/student_profile_components/student_hero_card.dart';
import '../widgets/student_profile_components/student_overview_section.dart';
import '../widgets/student_profile_components/students_result_section.dart';

class StudentProfileScreen extends StatefulWidget {
  const StudentProfileScreen({super.key});

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  // 0: Overview, 1: Attendance, 2: Results, 3: Badges
  int _selectedTabIndex = 0; 

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18, color: colorScheme.onPrimaryContainer),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Ifeoma Eze',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(LucideIcons.share, color: colorScheme.onPrimaryContainer, size: 20),
            onPressed: () {},
          ),
          const SizedBox(width: Sizes.spaceS),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                    child: const StudentHeroCard(),
                  ),
                  const SizedBox(height: Sizes.spaceXL),
                  _buildTabBar(theme),
                  const SizedBox(height: Sizes.spaceXL),
                  
                  // Render the correct section component based on the selected tab
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                    child: Column(
                      children: [
                        if (_selectedTabIndex == 0) const StudentOverviewSection(),
                        if (_selectedTabIndex == 1) const StudentAttendanceTabSection(),
                        if (_selectedTabIndex == 2) const StudentResultsSection(),
                        if (_selectedTabIndex == 3) const StudentBadgesSection(),
                        if (_selectedTabIndex == 4) const StudentGrowthSection(),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Horizontal scrollable tab bar
  Widget _buildTabBar(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: Sizes.spaceL,),
          _buildTabChip('Overview', 0, theme),
          _buildTabChip('Attendance', 1, theme),
          _buildTabChip('Results', 2, theme),
          _buildTabChip('Badges', 3, theme),
          _buildTabChip('Growth', 4, theme), // Extra tab shown partially in design
        ],
      ),
    );
  }

  Widget _buildTabChip(String label, int index, ThemeData theme) {
    final isSelected = _selectedTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTabIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: Sizes.spaceS),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected?null:theme.colorScheme.surfaceContainer,
          gradient: isSelected? AppDecorations.primaryGradient(context):null,
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? Colors.white : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}