import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/class_management_components.dart';

class ClassManagementScreen extends StatefulWidget {
  const ClassManagementScreen({super.key});

  @override
  State<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends State<ClassManagementScreen> {
  int _selectedTabIndex = 0; // 0: Overview, 1: Students, 2: Attendance, 3: Results

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
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'JSS 3A',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'Mathematics',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outlineVariant,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(Sizes.paddingL),
                    child: const ClassHeroCard(),
                  ),
                  const SizedBox(height: Sizes.spaceXL),
                  _buildTabBar(theme),
                  const SizedBox(height: Sizes.spaceXL),
                  
                  // Render the correct section component based on the selected tab
                  if (_selectedTabIndex == 0) const ClassOverviewSection(),
                  if (_selectedTabIndex == 1) const ClassStudentsSection(), // <-- PLUGGED IN HERE
                  if (_selectedTabIndex == 2) const ClassAttendanceSection(),
                  if (_selectedTabIndex == 3) const ClassResultsSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Keeping the TabBar here since it directly controls this screen's state
  Widget _buildTabBar(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          SizedBox(width: Sizes.spaceL,),
          _buildTabChip('Overview', 0, theme),
          _buildTabChip('Students', 1, theme),
          _buildTabChip('Attendance', 2, theme),
          _buildTabChip('Results', 3, theme),
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
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}