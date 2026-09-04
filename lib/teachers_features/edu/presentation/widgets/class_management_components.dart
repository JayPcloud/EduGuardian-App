import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:edu_guardian_app/core/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_decorations.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/utility/helper_functions.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../data/models/teacher_class_model.dart';
import '../controllers/my_classes_providers.dart';
import 'edit_grade_dialog.dart';

// --- HERO CARD --------------------------------------------------///
class ClassHeroCard extends StatelessWidget {
  const ClassHeroCard({super.key, required this.attendancePercent, required this.totalStudents, required this.excellentStudentsCount});
  final String totalStudents,attendancePercent, excellentStudentsCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary, 
        gradient: AppDecorations.primaryGradient(context),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Next lesson',
                    style: theme.textTheme.labelMedium?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Today . 10:30',
                    style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: Sizes.spaceS),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(Sizes.radiusXL),
                    ),
                    child: Text(
                      'CLASS TEACHER',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                      ),
                    ),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    totalStudents,
                    style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                  Text(
                    'Students',
                    style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.8)),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: Sizes.spaceSm),
          Divider(height: 1,color: Colors.white.withValues(alpha: 0.4)),
          const SizedBox(height: Sizes.spaceSm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildHeroStat('$attendancePercent%', 'Attendance', theme),
              _buildHeroStat(excellentStudentsCount, 'Excellent', theme),
              _buildHeroStat('2', 'Need support', theme),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildHeroStat(String value, String label, ThemeData theme) {
    return Flexible(
      child: Column(
        children: [
          Text(value, style: theme.textTheme.titleLarge?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
        ],
      ),
    );
  }
}




// --- OVERVIEW SECTION --------------------------------------------------///
class ClassOverviewSection extends StatelessWidget {
  final TeacherClassModel classDetails; // 🚨 Pass in the data

  const ClassOverviewSection({super.key, required this.classDetails});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Actions
          Row(
            spacing: Sizes.spaceXS,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildQuickAction('Attendance', LucideIcons.edit3, const Color(0xFF004D99), theme, isOutlined: true),
              _buildQuickAction('Results', LucideIcons.fileText, const Color(0xFF00ACC1), theme, isOutlined: true),
              _buildQuickAction('Message', LucideIcons.messageSquare, const Color(0xFF8E24AA), theme, isOutlined: true),
              _buildQuickAction('Timetable', LucideIcons.calendar, const Color(0xFF43A047), theme, isOutlined: true),
            ],
          ),
          const SizedBox(height: Sizes.spaceXXL),
          
          // 🚨 Top of the class (Dynamic)
          Text('Top of the class', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: Sizes.spaceM),
          if (classDetails.topOfTheClass.isEmpty)
            const Text("No data available.")
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: Sizes.paddingS),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Column(
                children: classDetails.topOfTheClass.asMap().entries.map((entry) {
                  final index = entry.key;
                  final student = entry.value;
                  final isLast = index == classDetails.topOfTheClass.length - 1;
                  final remark = HelperFunctions.getGradeRemark(student.percentage);
                  return Column(
                    children: [
                      _buildStudentListTile(
                        student.name, 
                        '${student.percentage}% attendance . $remark', 
                        const Color(0xFF00BFA5), 
                        LucideIcons.award, 
                        theme
                      ),
                      if (!isLast) Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                    ],
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: Sizes.spaceXL),
          
          // 🚨 Needs your attention (Dynamic)
          Text('Needs your attention', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: Sizes.spaceM),
          if (classDetails.needsAttention.isEmpty)
            const Text("All students are performing well.")
          else
            Container(
              padding: const EdgeInsets.symmetric(vertical: Sizes.paddingS),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
              ),
              child: Column(
                children: classDetails.needsAttention.asMap().entries.map((entry) {
                  final index = entry.key;
                  final student = entry.value;
                  final isLast = index == classDetails.needsAttention.length - 1;

                  return Column(
                    children: [
                      _buildStudentListTile(
                        student.name, 
                        'Follow up recommended', 
                        const Color(0xFFF44336), 
                        LucideIcons.alertTriangle, 
                        theme, 
                        isAlert: true
                      ),
                      if (!isLast) Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                    ],
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: Sizes.spaceXL),
        ],
      ),
    );
  }

  // Helpers (Untouched logic)
  Widget _buildQuickAction(String label, IconData icon, Color color, ThemeData theme, {bool isOutlined = false, VoidCallback? onTap}) {
    return Expanded(
      child: Column(
        children: [
          InkWell(
            onTap: onTap ?? () {},
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: theme.cardColor,
                border: Border.all(color: theme.colorScheme.outline),
                borderRadius: BorderRadius.circular(Sizes.radiusL),
                boxShadow: AppDecorations.defaultShadow
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
          const SizedBox(height: Sizes.spaceS),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentListTile(String name, String subtitle, Color iconColor, IconData icon, ThemeData theme, {bool isAlert = false}) {
    return ListTile(
      leading: CircleAvatar(
        radius: 18,
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
        backgroundImage: const NetworkImage('https://i.pravatar.cc/150'), // Placeholder
      ),
      title: Text(name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
      subtitle: Text(subtitle, style: theme.textTheme.labelSmall?.copyWith(color: isAlert ? iconColor : theme.colorScheme.outlineVariant)),
      trailing: Icon(icon, color: iconColor, size: 18),
      contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
    );
  }
}



// --- ATTENDANCE SECTION -------------------------------------------------------------///
class ClassAttendanceSection extends StatelessWidget {
  const ClassAttendanceSection({super.key, this.classId});
  final String? classId;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Sizes.paddingL),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(Sizes.radiusL),
              border: Border.all(color: Colors.black12.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Today\'s attendance', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: 4),
                Text('Not submitted', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: Sizes.spaceXS),
                Text('32 students to mark', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurface)),
                const SizedBox(height: Sizes.spaceL),
                ElevatedButton.icon(
                  onPressed: ()=> context.go( AppRoutes.attendance, extra: classId),
                  icon: const Icon(LucideIcons.edit3, size: 14, color: Colors.white),
                  label: Text('Mark Attendance', style: theme.textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004D99),
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceXL),
          
          // Recent Sessions
          Text('Recent Sessions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: Sizes.spaceM),
          _buildRecentSessionRow('Yesterday', '32 present  0 absent', theme),
          Divider(height: 1,color: theme.colorScheme.outline.withValues(alpha: 0.7)), 
          _buildRecentSessionRow('Mon, Nov 18', '32 present  0 absent', theme),
          Divider(height: 1,color: theme.colorScheme.outline.withValues(alpha: 0.7)), 
          _buildRecentSessionRow('Fri, Nov 15', '30 present  2 absent', theme),
          Divider(height: 1,color: theme.colorScheme.outline.withValues(alpha: 0.7)),
        ],
      ),
    );
  }

  Widget _buildRecentSessionRow(String date, String details, ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom:Sizes.paddingS, top: Sizes.paddingS),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(date, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text(details, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
            ],
          ),
        ),
        Icon(Icons.check_circle, color: const Color(0xFF004D99).withValues(alpha: 0.7), size: 20),
      ],
    );
  }
}




// --- RESULTS SECTION -------------------------------------------------------------------------------------///
class ClassResultsSection extends StatelessWidget {
  const ClassResultsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:Sizes.paddingL),
      child: Container(
        padding: const EdgeInsets.all( Sizes.paddingSm),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Column(
          spacing: Sizes.spaceSm,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Result Category', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            _buildResultCategoryRow('Assignment', 'Submitted', const Color(0xFF00BFA5), 1.0, 0.0, theme),
            _buildResultCategoryRow('Test', 'In progress', theme.colorScheme.outlineVariant, 0.7, 0.05, theme),
            _buildResultCategoryRow('Exam', 'Not started', theme.colorScheme.outlineVariant, 0.0, 0.0, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCategoryRow(String title, String subtitle, Color subtitleColor, double blueFill, double yellowFill, ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 2),
                    Text(subtitle, style: theme.textTheme.labelSmall?.copyWith(color: subtitleColor, fontWeight: FontWeight.w600)),
                  ],
                ),
                InkWell(
                  onTap: (){},
                  borderRadius: BorderRadius.circular(Sizes.radiusXL),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: 6),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(Sizes.radiusXL),
                    ),
                    child: Text('Open', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600)),
                  ),
                )
              ],
            ),
            const SizedBox(height: Sizes.spaceM),
            LinearProgressIndicator(
              borderRadius: AppSpacingStyle.allBorderRdMd,
              value: blueFill,
              backgroundColor: theme.colorScheme.surfaceContainer,
            )
          ],
        ),
      ),
    );
  }
}




// --- STUDENTS SECTION ------------------------------------------------------------///
class ClassStudentsSection extends ConsumerWidget {
  final String classId, subject; // 🚨 Accepts the class ID to fetch data
  const ClassStudentsSection({super.key, required this.classId, required this.subject});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final studentsAsync = ref.watch(classStudentsProvider(classId));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
      child: studentsAsync.when(
        skipLoadingOnRefresh: false,
        loading: () => _buildShimmer(theme), // 🚨 Built-in shimmer
        error: (err, stack) => AppErrorWidget(
          message: err.toString(),
          onlyErrorMessage: true,
          onRetry: () => ref.invalidate(classStudentsProvider(classId)),
        ),
        data: (students) {
          if (students.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(Sizes.paddingL),
                child: Text("No students found in this class."),
              ),
            );
          }

          return Column(
            children: students.map((student) {
              return _buildStudentCard(
                name: student.name, 
                studentId: student.regNumber, 
                avatarUrl: 'https://i.pravatar.cc/150?u=${student.id}', // Deterministic placeholder avatar based on ID
                subject:subject,
                theme, 
                context,
              );
            }).toList(),
          );
        },
      ),
    );
  }

  // 🚨 Built-in Shimmer requested
  Widget _buildShimmer(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        children: List.generate(5, (index) => Container(
          margin: const EdgeInsets.only(bottom: Sizes.spaceM),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
          ),
        )),
      ),
    );
  }

  Widget _buildStudentCard(ThemeData theme, BuildContext context, {required String subject, required String name, required String studentId, required String avatarUrl}) {
    return InkWell(
      onTap: () => context.push(AppRoutes.studentProfileScreen),
      borderRadius: BorderRadius.circular(Sizes.radiusXL),
      child: Container(
        margin: const EdgeInsets.only(bottom: Sizes.spaceM),
        padding: const EdgeInsets.all(Sizes.paddingM),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage(avatarUrl),
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
            ),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    studentId,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => EditGradeDialog(
                  configs: [],
                  initialScores: {}, 
                  studentName: name, 
                  subject: subject, 
                  onSaveScore: (String ) {},
                ),
              ),
              borderRadius: BorderRadius.circular(Sizes.radiusXL),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(Sizes.radiusXL),
                ),
                child: Text(
                  'Score',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}