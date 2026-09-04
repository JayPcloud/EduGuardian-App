import 'package:edu_guardian_app/teachers_features/edu/presentation/widgets/edit_grade_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utility/helper_functions.dart';
import '../../data/models/class_management_models.dart';
import '../../data/models/result_models.dart';
import '../controllers/teacher_result_providers.dart';

// --- TIMETABLE DATE SELECTOR ---
class DateSelectorChip extends StatelessWidget {
  final String day;
  final String date;
  final bool isSelected;
  final VoidCallback onTap;

  const DateSelectorChip({
    super.key,
    required this.day,
    required this.date,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: Sizes.spaceM),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF003366) : theme.colorScheme.primaryContainer.withValues(alpha: 0.5), // Deep Navy for selected
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Column(
          children: [
            Text(
              day, 
              style: theme.textTheme.labelMedium?.copyWith(
                color: isSelected ? Colors.white70 : theme.colorScheme.outlineVariant,
                fontWeight: FontWeight.w600,
              )
            ),
            const SizedBox(height: 4),
            Text(
              date, 
              style: theme.textTheme.titleLarge?.copyWith(
                color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                fontWeight: FontWeight.w700,
              )
            ),
          ],
        ),
      ),
    );
  }
}

// --- TIMETABLE CARD ---
class TimetableCard extends StatelessWidget {
  final String timeH;
  final String timeM;
  final String subject;
  final String className;
  final String duration;
  final String studentCount;

  const TimetableCard({
    super.key,
    required this.timeH,
    required this.timeM,
    required this.subject,
    required this.className,
    required this.duration,
    required this.studentCount,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.7)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Time Column
          Column(
            children: [
              Text(timeH, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text(timeM, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(width: Sizes.spaceM),
          // Vertical Divider
          Container(height: 50, width: 1, color: theme.colorScheme.outline),
          const SizedBox(width: Sizes.spaceM),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(subject, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)),
                Text(className, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                const SizedBox(height: Sizes.spaceM),
                Row(
                  children: [
                    // Duration Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA), // Light Cyan
                        borderRadius: BorderRadius.circular(Sizes.radiusM),
                      ),
                      child: Text(
                        duration,
                        style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF00ACC1), fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: Sizes.spaceS),
                    // Student Count Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: 4),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(Sizes.radiusM),
                      ),
                      child: Text(
                        studentCount,
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- RESULT ENTRY ROW ---
class ResultEntryRow extends ConsumerWidget {
  final TeacherClassStudentModel student;
  final List<ResultConfigModel> configs;

  const ResultEntryRow({super.key, required this.student, required this.configs});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final drafts = ref.watch(resultDraftProvider);
    final studentDrafts = drafts[student.id] ?? {};

    // Calculate Total strictly based on the draft map for real-time grading!
    num totalScore = 0;
    for (var score in studentDrafts.values) {
      totalScore += num.tryParse(score) ?? 0;
    }

    final gradeInfo = HelperFunctions.calculateGrade(totalScore);

    return Padding(
      padding: const EdgeInsets.all(Sizes.paddingM),
      child: Row(
        children: [
          // Student Info 
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                Text(
                  student.regNumber,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outlineVariant,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: Sizes.spaceS),
          
          // 🚨 DYNAMIC Inputs mapping the configs
          ...configs.map((config) {
            final currentVal = studentDrafts[config.id] ?? '';
            return Expanded(
              flex: 2, 
              child: _buildGradeInput(
                context,
                value: currentVal.isEmpty ? '-' : currentVal, 
                theme: theme, ref: ref, 
                studentDrafts: studentDrafts
                ),
                
            );
          }),
          
          const SizedBox(width: Sizes.spaceS),
          
          // Total & Grade
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(totalScore.toString(), style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                Text(
                  drafts[student.id]==null?'-':
                  gradeInfo.letter, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700, color: gradeInfo.color)),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildGradeInput(context,{required String value, required ThemeData theme, required WidgetRef ref, required Map<String, String> studentDrafts}) {
    return GestureDetector(
      onTap: () {
        // Read the subject name from the current filter to pass to the dialog
        final subjectName = ref.read(resultFilterProvider)?.subjectName ?? 'Subject';
        
        EditGradeDialog.show(
          context,
          studentName: student.name,
          subject: subjectName,
          configs: configs,
          initialScores: studentDrafts,
          onSaveScore: (Map<String, String> updatedScores) {
            // Using the updateStudentRecord method we created in the controller earlier
            ref.read(resultDraftProvider.notifier).updateStudentRecord(
              studentId: student.id, 
              result: updatedScores
            );
          },
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: Sizes.spaceXS),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(Sizes.radiusS),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.keyboard_arrow_up, size: 10, color: theme.colorScheme.outlineVariant),
                Icon(Icons.keyboard_arrow_down, size: 10, color: theme.colorScheme.outlineVariant),
              ],
            )
          ],
        ),
      ),
    );
  }
}