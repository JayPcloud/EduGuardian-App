import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../controllers/my_classes_providers.dart';
import '../widgets/class_management_components.dart';
import '../widgets/class_management_shimmer.dart';

class ClassManagementScreen extends ConsumerStatefulWidget {
  const ClassManagementScreen({super.key, required this.classId});

  final String classId; // 🚨 Now takes ID instead of the full model!

  @override
  ConsumerState<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends ConsumerState<ClassManagementScreen> {
  int _selectedTabIndex = 0; // 0: Overview, 1: Students, 2: Attendance, 3: Results

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final classDetailsAsync = ref.watch(teacherClassDetailsProvider(widget.classId));

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
              classDetailsAsync.valueOrNull?.name ?? 'Loading...', // Dynamic
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            if (classDetailsAsync.valueOrNull != null && classDetailsAsync.value!.subjects.isNotEmpty)
              Text(
                classDetailsAsync.value!.subjects.first.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                ),
              ),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.refresh(teacherClassDetailsProvider(widget.classId).future),
        child: classDetailsAsync.when(
          skipLoadingOnRefresh: false,
          loading: () => const ClassDetailsShimmer(),
          error: (err, stack) => AppErrorWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(teacherClassDetailsProvider(widget.classId)),
          ),
          data: (classDetails) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(Sizes.paddingL),
                          child: ClassHeroCard(
                            excellentStudentsCount: classDetails.topOfTheClass.where((e) =>e.percentage>75).length.toString(),
                            attendancePercent: classDetails.attendancePercentage.toString(),
                            totalStudents: classDetails.totalStudents.toString(),
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceXL),
                        _buildTabBar(theme),
                        const SizedBox(height: Sizes.spaceXL),
                        
                        // Render the correct section component based on the selected tab
                        if (_selectedTabIndex == 0) ClassOverviewSection(classDetails: classDetails),
                        if (_selectedTabIndex == 1) ClassStudentsSection(classId: classDetails.id,subject: classDetails.subjects[0].name,), 
                        if (_selectedTabIndex == 2) ClassAttendanceSection(classId: classDetails.id),
                        if (_selectedTabIndex == 3) const ClassResultsSection(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTabBar(ThemeData theme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          const SizedBox(width: Sizes.spaceL,),
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
          color: isSelected ? null : theme.colorScheme.surfaceContainer,
          gradient: isSelected ? AppDecorations.primaryGradient(context) : null,
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

