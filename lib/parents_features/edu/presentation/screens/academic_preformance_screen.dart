import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../controllers/academic_providers.dart';
import '../widgets/academic_widgets.dart';


class AcademicPerformanceScreen extends ConsumerWidget {
  const AcademicPerformanceScreen({super.key});

  // Helper to map grades to colors dynamically
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

    final performanceAsync = ref.watch(academicPerformanceProvider);
    final term = ref.watch(activeWardProvider)?.term;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Academic Performance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Term $term · Week 8', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: ()=> ref.invalidate(academicPerformanceProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dropdowns (Untouched)
              FittedBox(
                child: Row(
                  children: [
                    AcademicFilterDropdown(
                      initialLabel: 'Class',
                      items: const ['JSS 1', 'JSS 2', 'JSS 3', 'SSS 1', 'SSS 2', 'SSS 3'],
                      onSelected: (val) {
                        // TODO: Handle class filter
                      },
                    ),
                    const SizedBox(width: Sizes.spaceS),
                    AcademicFilterDropdown(
                      initialLabel: 'Term',
                      isBlueText: true,
                      items: const ['1st Term', '2nd Term', '3rd Term'],
                      onSelected: (val) {
                        // TODO: Handle term filter
                      },
                    ),
                    const SizedBox(width: Sizes.spaceS),
                    AcademicFilterDropdown(
                      initialLabel: 'Subject',
                      items: const ['Mathematics', 'English Language', 'Chemistry', 'Physics', 'Business Studies', 'Accounting'],
                      onSelected: (val) {
                        // TODO: Handle subject filter
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Sizes.spaceXL),
              Text('Subjects', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: Sizes.spaceM),
        
              // 🚨 WIRING API DATA TO UI
              performanceAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const AcademicShimmer(),
                error: (err, stack) => AppErrorWidget(
                    message: err.toString(),
                    onRetry: () {
                      // This forces Riverpod to fetch the data again!
                      ref.invalidate(academicPerformanceProvider);
                    },
                  ),
                data: (subjects) {
                  if (subjects.isEmpty) {
                    return const Center(child: Text("No academic records found."));
                  }
                  return Column(
                    children: subjects.map((subject) {
                      final color = _getGradeColor(subject.grade, colorScheme);
                      return _buildSubjectCard(
                        title: subject.subjectName,
                        score: subject.percentage,
                        grade: subject.grade, // Pass the actual grade
                        trend: 0, // Default trend since API doesn't provide it yet
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
      // bottomNavigationBar: Padding(
      //   padding: const EdgeInsets.all(Sizes.paddingL),
      //   child: PrimaryButton(
      //     label: 'Request a meeting with teacher', 
      //     onPressed: () => context.push(AppRoutes.requestMeeting),
      //   )
      // ),
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