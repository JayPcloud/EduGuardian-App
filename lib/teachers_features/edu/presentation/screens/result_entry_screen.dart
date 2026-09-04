import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/buttons/outlined_border_button.dart';
import '../../../../core/widgets/common/success_dialog.dart';
import '../../../../core/widgets/common/warning_dialog.dart';
import '../controllers/my_classes_providers.dart';
import '../controllers/teacher_result_providers.dart';
import '../widgets/academic_components.dart';
import '../widgets/attendance_components.dart';


class ResultEntryScreen extends ConsumerStatefulWidget {
  const ResultEntryScreen({super.key, this.classId, this.armId, this.subjectId});
  
  final String? classId;
  final String? armId;
  final String? subjectId;

  @override
  ConsumerState<ResultEntryScreen> createState() => _ResultEntryScreenState();
}

class _ResultEntryScreenState extends ConsumerState<ResultEntryScreen> {
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(resultEntryControllerProvider.notifier).initializeFilters(
      widget.classId, widget.armId, widget.subjectId
    ));
  }

  void _checkBeforeSubmit() {
    // 🚨 Clean: Ask the controller for the business logic result
    final missingCount = ref.read(resultEntryControllerProvider.notifier).getMissingRecordsCount();

    if (missingCount > 0) {
      WarningDialog.show(
        context,
        title: 'Incomplete Records',
        message: '$missingCount student(s) have missing scores. Are you sure you want to submit anyway?',
        primaryButtonText: 'Yes, Submit',
        secondaryButtonText: 'Cancel',
        onPrimaryPressed: () {
          Navigator.pop(context); // Close warning dialog
          _handleSubmit(); // Proceed to submit
        },
      );
    } else {
      _handleSubmit(); // All clear, submit immediately
    }
  }
  
  Future<void> _handleSubmit() async {
    setState(() => _isSubmitting = true);
    try {
      await ref.read(resultEntryControllerProvider.notifier).submitBulkResults();
      if (mounted) {
        SuccessDialog.show(
          context, 
          title: 'Scores Saved', 
          buttonText: 'Done', 
          message: 'Records have been successfully uploaded and saved.', 
          onButtonPressed: () => context.pop(),
        );
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filter = ref.watch(resultFilterProvider);
    final studentsAsync = ref.watch(resultEntryControllerProvider);
    final configsAsync = ref.watch(resultConfigsProvider);

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
            Text('Result Entry', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('First Term', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      body: filter == null 
        ? const Center(child: CircularProgressIndicator())
        : Column(
        children: [
          Expanded(
            child: Column(
              children: [
                // Filters
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.spaceM),
                  child: Row(
                    children: [
                      TeachersAttendanceFilterDropdown(
                        label: 'CLASS',
                        initialValue: filter.className,
                        items: ref.watch(teacherClassesProvider).when(
                            data: (data) => data.classes.map((c) => c.name).toList(), 
                            error: (err, st)=>[], loading: ()=>[]),
                        onSelected: (val) {
                          final classes = ref.read(teacherClassesProvider).valueOrNull?.classes ?? [];
                          final selectedCls = classes.firstWhere((c) => c.name == val);
                          ref.read(resultFilterProvider.notifier).state = filter.copyWith(
                            classId: selectedCls.id, className: selectedCls.name, classCategory: selectedCls.category,
                            armId: selectedCls.arms.isNotEmpty ? selectedCls.arms.first.id : '',
                            subjectName: selectedCls.subjects.isNotEmpty ? selectedCls.subjects.first.name : 'N/A',
                            subjectId: selectedCls.subjects.isNotEmpty ? selectedCls.subjects.first.id : '',
                          );
                        },
                      ),
                      const SizedBox(width: Sizes.spaceM),
                      TeachersAttendanceFilterDropdown(
                        label: 'SUBJECT',
                        initialValue: filter.subjectName,
                        items: ref.read(teacherClassesProvider).valueOrNull?.classes
                            .firstWhere((c) => c.id == filter.classId, orElse: () => ref.read(teacherClassesProvider).value!.classes.first)
                            .subjects.map((s) => s.name).toList() ?? [],
                        onSelected: (val) {
                          final classes = ref.read(teacherClassesProvider).valueOrNull?.classes ?? [];
                          final currentCls = classes.firstWhere((c) => c.id == filter.classId);
                          final subj = currentCls.subjects.firstWhere((s) => s.name == val);
                          ref.read(resultFilterProvider.notifier).state = filter.copyWith(subjectName: subj.name, subjectId: subj.id);
                        },
                      ),
                    ],
                  ),
                ),
                
                // Expandable & Scrollable Table
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: colorScheme.outline),
                        borderRadius: BorderRadius.circular(Sizes.radiusL),
                      ),
                      child: Column(
                        children: [
                          // 🚨 DYNAMIC HEADER based on API configs
                          configsAsync.when(
                            loading: () => const LinearProgressIndicator(),
                            error: (e, s) => const SizedBox.shrink(),
                            data: (configs) => Container(
                              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingS),
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer.withValues(alpha: 0.6),
                                borderRadius: const BorderRadius.only(topRight: Radius.circular(Sizes.radiusM), topLeft: Radius.circular(Sizes.radiusM)),
                              ),
                              child: Row(
                                children: [
                                  Expanded(flex: 3, child: Text('STUDENTS', style: _headerStyle(theme))),
                                  const SizedBox(width: Sizes.spaceS),
                                  // Map configs to header columns
                                  ...configs.map((config) {
                                    final initials = config.assessmentType.replaceAll(RegExp(r'[^A-Z]'), ''); // e.g. "First CA" -> "FCA", "Exam" -> "E"
                                    return Expanded(
                                      flex: 2, 
                                      child: Text(
                                        initials.isEmpty ? config.assessmentType.substring(0, 2).toUpperCase() : initials, 
                                        style: _headerStyle(theme)
                                      )
                                    );
                                  }),
                                  const SizedBox(width: Sizes.spaceS),
                                  Expanded(flex: 1, child: Text('TOTAL', style: _headerStyle(theme), textAlign: TextAlign.center)),
                                ],
                              ),
                            ),
                          ),
                          
                          // 🚨 DYNAMIC Scrollable Table List
                          Expanded(
                            child: studentsAsync.when(
                              loading: () => const Center(child: CircularProgressIndicator()),
                              error: (e, s) => Center(child: Text('Failed to load students: $e')),
                              data: (students) {
                                final configs = configsAsync.valueOrNull ?? [];
                                if (students.isEmpty || configs.isEmpty) return const SizedBox.shrink();

                                return ListView.separated(
                                  padding: EdgeInsets.zero,
                                  itemCount: students.length,
                                  separatorBuilder: (_, __) => Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.1)),
                                  itemBuilder: (context, index) {
                                    return ResultEntryRow(
                                      student: students[index],
                                      configs: configs,
                                    );
                                  },
                                );
                              }
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Pinned Bottom Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedBorderButton(
                    label: 'Save draft',
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved locally!'))),
                  ),
                ),
                const SizedBox(width: Sizes.spaceM),
                Expanded(
                  child: Expanded(
                  child: PrimaryButton(
                    label: 'Submit',
                    isLoading: _isSubmitting,
                    onPressed: _checkBeforeSubmit, // 🚨 Call the pre-check instead of _handleSubmit directly
                  ),
                ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  TextStyle _headerStyle(ThemeData theme) {
    return theme.textTheme.labelSmall!.copyWith(
      color: theme.colorScheme.outlineVariant,
      fontWeight: FontWeight.w700,
      fontSize: 10,
    );
  }
}