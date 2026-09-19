import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../../data/models/teacher_class_model.dart';
import '../controllers/my_classes_providers.dart';
import '../widgets/class_management_components.dart';
import '../widgets/class_management_shimmer.dart';

class ClassManagementScreen extends ConsumerStatefulWidget {
  const ClassManagementScreen({super.key, required this.classData});

  final FlattenedClassData classData;

  @override
  ConsumerState<ClassManagementScreen> createState() => _ClassManagementScreenState();
}

class _ClassManagementScreenState extends ConsumerState<ClassManagementScreen> {
  int _selectedTabIndex = 0; // 0: Overview, 1: Students, 2: Attendance, 3: Results
  TeacherSubjectModel? _activeSubject;
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final classDetailsAsync = ref.watch(teacherClassDetailsProvider(widget.classData.parentClass.id));

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
              widget.classData.displayClassName, // 🚨 "JSS 1 A"
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            if (classDetailsAsync.valueOrNull != null && classDetailsAsync.value!.subjects.isNotEmpty)
              Text(
                _activeSubject?.name ?? classDetailsAsync.value!.subjects.first.name,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.outlineVariant,
                ),
              ),
          ],
        ),
        actions: [
          if (classDetailsAsync.valueOrNull != null && classDetailsAsync.value!.subjects.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: Sizes.paddingM),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(Sizes.radiusM),
              ),
              child: PopupMenuButton<TeacherSubjectModel>(
                position: PopupMenuPosition.under,
                icon: Icon(Icons.swap_vert, color: colorScheme.primary),
                tooltip: 'Switch Subject',
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusM)),
                onSelected: (subject) {
                  setState(() {
                    _activeSubject = subject;
                  });
                },
                itemBuilder: (context) {
                  return classDetailsAsync.value!.subjects.map((sub) {
                    final isSelected = (_activeSubject?.id ?? classDetailsAsync.value!.subjects.first.id) == sub.id;
                    return PopupMenuItem(
                      value: sub,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            sub.name,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                              color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                            ),
                          ),
                          if (isSelected) 
                            Icon(Icons.check, size: 16, color: colorScheme.primary),
                        ],
                      ),
                    );
                  }).toList();
                },
              ),
            ),
        ],
      ),
      body:AppRefreshIndicator(
        onRefresh: () => ref.refresh(teacherClassDetailsProvider(widget.classData.parentClass.id).future),
        child: classDetailsAsync.when(
          loading: () => const ClassDetailsShimmer(),
          error: (err, stack) => AppErrorWidget(
            message: err.toString(),
            onRetry: () => ref.invalidate(teacherClassDetailsProvider(widget.classData.parentClass.id)),
          ),
          data: (classDetails) {
            final currentSubject = _activeSubject ?? (classDetails.subjects.isNotEmpty ? classDetails.subjects.first : null);

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
                            excellentStudentsCount: classDetails.topOfTheClass.where((e) => e.percentage > 75).length.toString(),
                            attendancePercent: classDetails.attendancePercentage.toString(),
                            // 🚨 Total students for this specific arm
                            totalStudents: widget.classData.arm.totalStudents.toString(), 
                          ),
                        ),
                        const SizedBox(height: Sizes.spaceXL),
                        _buildTabBar(theme),
                        const SizedBox(height: Sizes.spaceXL),
                        
                        if (_selectedTabIndex == 0) ClassOverviewSection(
                          classDetails: classDetails,
                          armId: widget.classData.arm.id,                     // 🚨 Pass the arm ID
                          subjectId: currentSubject?.id ?? '',
                        ),
                        
                        if (_selectedTabIndex == 1) ClassStudentsSection(
                          classId: widget.classData.parentClass.id, // 🚨 From parent
                          armId: widget.classData.arm.id,           // 🚨 From arm
                          subject: currentSubject?.name ?? 'Unknown',
                        ), 
                        
                        if (_selectedTabIndex == 2) ClassAttendanceSection(
                          classId: widget.classData.parentClass.id,
                          armId: widget.classData.arm.id,
                          totalStudents: widget.classData.arm.totalStudents, // 🚨 Pass dynamic count
                        ),
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

