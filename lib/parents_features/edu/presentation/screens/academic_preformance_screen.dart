import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../../../dashboard/data/models/student_model.dart';
import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../controllers/academic_providers.dart';
import '../widgets/academic_widgets.dart';


class AcademicPerformanceScreen extends ConsumerWidget {
  const AcademicPerformanceScreen({super.key});

  Color _getGradeColor(String grade, ColorScheme colorScheme) {
    switch (grade.toUpperCase()) {
      case 'A': return Colors.green;
      case 'B': return Colors.cyan;
      case 'C': return Colors.deepPurpleAccent;
      case 'D': return Colors.orange;
      case 'E': return Colors.deepOrange;
      case 'F': return Colors.red;
      default: return colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final activeWard = ref.watch(activeWardProvider);
    final performanceAsync = ref.watch(academicPerformanceProvider);
    final filterState = ref.watch(academicFilterProvider);
    final filterNotifier = ref.read(academicFilterProvider.notifier);

    final Map<String, PreviousClassModel> classMap = {};
    
    if (activeWard?.schoolClass != null) {
      final className = '${activeWard!.schoolClass!.name} ${activeWard.classArm?.name ?? ''}'.trim();
      classMap[className] = PreviousClassModel(
        schoolClass: activeWard.schoolClass,
        classArm: activeWard.classArm,
      );
    }
    
    // Add previous classes ONLY if they aren't already in the map
    for (var prev in activeWard?.previousClasses ?? <PreviousClassModel>[]) {
      if (prev.schoolClass != null) {
        final className = '${prev.schoolClass!.name} ${prev.classArm?.name ?? ''}'.trim();
        if (!classMap.containsKey(className)) {
          classMap[className] = prev;
        }
      }
    }
    
    final classNamesList = classMap.keys.toList();
    final currentClassName = filterState.classId == null 
        ? ('${activeWard?.schoolClass?.name ?? ''} ${activeWard?.classArm?.name ?? ''}'.trim().isNotEmpty ? '${activeWard?.schoolClass?.name ?? ''} ${activeWard?.classArm?.name ?? ''}'.trim() : 'Class') 
        : classNamesList.firstWhere(
            (k) => classMap[k]?.schoolClass?.id == filterState.classId, 
            orElse: () => 'Class'
          );

    // 2. TERM MAPPING
    final termMap = {
      '1st Term': '1',
      '2nd Term': '2',
      '3rd Term': '3'
    };
    final currentTermLabel = termMap.entries
        .firstWhere((e) => e.value == (filterState.term ?? activeWard?.term), orElse: () => const MapEntry('Term', '1'))
        .key;

    // 3. DYNAMIC SUBJECT LIST (Extracted from loaded API data)
    final allLoadedSubjects = performanceAsync.valueOrNull ?? [];
    final subjectNames = ['All Subjects', ...allLoadedSubjects.map((e) => e.subjectName).toSet().toList()];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Performance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('$currentClassName · $currentTermLabel', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.invalidate(academicPerformanceProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FittedBox(
                child: Row(
                  children: [
                    // CLASS DROPDOWN
                    if (classNamesList.isNotEmpty)
                      AcademicFilterDropdown(
                        initialLabel: currentClassName,
                        items: classNamesList,
                        onSelected: (val) {
                          final selectedClassData = classMap[val];
                          filterNotifier.state = filterState.copyWith(
                            classId: selectedClassData?.schoolClass?.id,
                            armId: selectedClassData?.classArm?.id,
                            clearSubject: true, // Reset subject when class changes
                          );
                        },
                      ),
                    const SizedBox(width: Sizes.spaceS),
                    
                    // TERM DROPDOWN
                    AcademicFilterDropdown(
                      initialLabel: currentTermLabel,
                      isBlueText: true,
                      items: termMap.keys.toList(),
                      onSelected: (val) {
                        filterNotifier.state = filterState.copyWith(
                          term: termMap[val],
                          clearSubject: true, // Reset subject when term changes
                        );
                      },
                    ),
                    const SizedBox(width: Sizes.spaceS),
                    
                    // SUBJECT DROPDOWN
                    AcademicFilterDropdown(
                      initialLabel: filterState.subjectName ?? 'Subject',
                      items: subjectNames,
                      onSelected: (val) {
                        filterNotifier.state = filterState.copyWith(subjectName: val);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceXL),
              Text('Subjects', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: Sizes.spaceM),
        
              // 🚨 WIRING API DATA TO UI
              // 🚨 WIRING API DATA TO UI
              performanceAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const AcademicShimmer(),
                error: (err, stack) => AppErrorWidget(
                    message: err.toString(),
                    onRetry: () => ref.invalidate(academicPerformanceProvider),
                  ),
                data: (subjects) {
                  
                  // 🚨 APPLY LOCAL SUBJECT FILTERING HERE
                  final filteredSubjects = (filterState.subjectName == null || filterState.subjectName == 'All Subjects') 
                      ? subjects 
                      : subjects.where((s) => s.subjectName == filterState.subjectName).toList();

                  if (filteredSubjects.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 40),
                      child: Center(child: Text("No academic records found for this selection.", style: TextStyle(color: Colors.grey))),
                    );
                  }
                  
                  return Column(
                    children: filteredSubjects.map((subject) {
                      final color = _getGradeColor(subject.grade, colorScheme);
                      return _buildSubjectCard(
                        title: subject.subjectName,
                        score: subject.percentage,
                        grade: subject.grade,
                        trend: 0, 
                        barColor: color,
                        theme: theme,
                      );
                    }).toList(),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Adjusted slightly to accept `grade` string instead of hardcoded 'E'
  Widget _buildSubjectCard({
    required String title, 
    required int score, 
    required String grade, 
    required int trend, 
    required Color barColor, 
    required ThemeData theme
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(Sizes.radiusL)),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: barColor, 
            radius: 20, 
            child: Text(grade, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                    Text(score.toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                  ],
                ),
                const SizedBox(height: Sizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                        child: LinearProgressIndicator(
                          value: score / 100, 
                          backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5), 
                          color: barColor, 
                          minHeight: 6,
                          borderRadius: BorderRadius.circular(Sizes.radiusS),
                        ),
                      ),
                    ),
                    const SizedBox(width: Sizes.spaceM),
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 14, color: theme.colorScheme.outlineVariant),
                        const SizedBox(width: 2),
                        Text('+$trend', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}