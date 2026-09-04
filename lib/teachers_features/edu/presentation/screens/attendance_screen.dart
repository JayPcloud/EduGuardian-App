import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'dart:async';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/buttons/outlined_border_button.dart';
import '../../../../core/widgets/buttons/primary_button.dart';
import '../../../../core/widgets/common/success_dialog.dart';
import '../../../../core/widgets/inputs/custom_date_picker.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../controllers/my_classes_providers.dart';
import '../controllers/teacher_attendance_provider.dart';
import '../widgets/attendance_components.dart';

class TeachersAttendanceScreen extends ConsumerStatefulWidget {
  const TeachersAttendanceScreen({super.key, this.classId});
  final String? classId;

  @override
  ConsumerState<TeachersAttendanceScreen> createState() => _TeachersAttendanceScreenState();
}

class _TeachersAttendanceScreenState extends ConsumerState<TeachersAttendanceScreen> {
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(teacherAttendanceRecordsProvider.notifier).loadMore();
      }
    });

    // Initialize default filters
    Future.microtask(() => 
      ref.read(teacherAttendanceRecordsProvider.notifier).initializeFilters(widget.classId)
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      ref.read(attendanceSearchProvider.notifier).state = query;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filter = ref.watch(attendanceFilterProvider);
    final recordsAsync = ref.watch(teacherAttendanceRecordsProvider);
    final metricsAsync = ref.watch(teacherAttendanceMetricsProvider);
    final drafts = ref.watch(attendanceDraftProvider);
    final isFetchingMore = ref.read(teacherAttendanceRecordsProvider.notifier).isFetchingMore;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        // toolbarHeight: 80,
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, size: 18, color: colorScheme.onPrimaryContainer),
        //   onPressed: () => context.pop(),
        // ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer)),
            Text('Term 1', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () {
          ref.invalidate(teacherAttendanceRecordsProvider);
          ref.invalidate(teacherAttendanceMetricsProvider);
        },
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: filter == null 
                  ? const Center(child: Padding(padding: EdgeInsets.all(32), child: CircularProgressIndicator()))
                  : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: Sizes.spaceS),
                    // Filters (Dummy UI mapping, adapt to real state logic as needed)
                    // 1. Dropdown Filters (RESTORED & WIRED)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM,),
                    child: Row(
                      children: [
                        TeachersAttendanceFilterDropdown(
                          label: 'CLASS',
                          initialValue: filter.className,
                          // Map dynamic class names from the provider
                          items: ref.watch(teacherClassesProvider).when(
                            data: (data) => data.classes.map((c) => c.name).toList(), 
                            error: (err, st)=>[], loading: ()=>[]),
                          onSelected: (val) {
                            final classes = ref.read(teacherClassesProvider).valueOrNull?.classes ?? [];
                            final selectedCls = classes.firstWhere((c) => c.name == val);
                            ref.read(attendanceFilterProvider.notifier).state = filter.copyWith(
                              classId: selectedCls.id,
                              className: selectedCls.name,
                              armId: selectedCls.arms.isNotEmpty ? selectedCls.arms.first.id : '',
                              subjectName: selectedCls.subjects.isNotEmpty ? selectedCls.subjects.first.name : 'N/A',
                            );
                          },
                        ),
                        const SizedBox(width: Sizes.spaceM),
                        DatePickerDropDown(
                          initialValue: filter.date,
                          onDateSelected: (pickedDate) {
                            //TODO: Edit picked date
                            final formatted = DateFormat('yyyy-MM-dd').format(pickedDate.copyWith(month: 7));
                            ref.read(attendanceFilterProvider.notifier).state = filter.copyWith(date: formatted);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Sizes.spaceM),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM),
                    child: Row(
                      children: [
                        TeachersAttendanceFilterDropdown(
                          label: 'SUBJECT',
                          initialValue: filter.subjectName,
                          // Get subjects for the currently selected class
                          items: ref.read(teacherClassesProvider).valueOrNull?.classes
                              .firstWhere((c) => c.id == filter.classId, orElse: () => ref.read(teacherClassesProvider).value!.classes.first)
                              .subjects.map((s) => s.name).toList() ?? [],
                          onSelected: (val) {
                             ref.read(attendanceFilterProvider.notifier).state = filter.copyWith(subjectName: val);
                          },
                        ),
                        const SizedBox(width: Sizes.spaceM),
                        const TeachersAttendanceFilterDropdown(
                          label: 'SESSION',
                          initialValue: 'Morning',
                          items: [], 
                        ),
                      ],
                    ),
                  ),
                    const SizedBox(height: Sizes.spaceXL),

                    // Search
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceM),
                      child: TextFormField(
                        onChanged: _onSearchChanged,
                        decoration: InputDecoration(
                          hintText: 'Search Student',
                          hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outlineVariant),
                          prefixIcon: Icon(LucideIcons.search, size: 18, color: colorScheme.outlineVariant),
                          fillColor: theme.colorScheme.primaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXL),

                    // Quick Actions
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          const SizedBox(width: Sizes.spaceM),
                         TeachersAttendanceQuickAction(label: 'All present', bgColor: Color(0xFFE0F7FA), textColor: Color(0xFF00ACC1),
                          onTap: () {
                              final ids = recordsAsync.valueOrNull?.records.map((r) => r.studentId).toList() ?? [];
                              ref.read(attendanceDraftProvider.notifier).markAll(ids, 'present');
                            },
                          ),
                          
                          const SizedBox(width: Sizes.spaceS),
                           TeachersAttendanceQuickAction(
                            onTap: () {
                              final ids = recordsAsync.valueOrNull?.records.map((r) => r.studentId).toList() ?? [];
                              ref.read(attendanceDraftProvider.notifier).markAll(ids, 'absent');
                            },
                            label: 'All absent', bgColor: Color(0xFFFFEBEE), textColor: Color(0xFFE53935)),
                          const SizedBox(width: Sizes.spaceS),
                           TeachersAttendanceQuickAction(
                            onTap: () {
                              final ids = recordsAsync.valueOrNull?.records.map((r) => r.studentId).toList() ?? [];
                              ref.read(attendanceDraftProvider.notifier).markAll(ids, 'late');
                            },
                            label: 'Late', bgColor: Color(0xFFFFF8E1), textColor: Color(0xFFFFB300)),
                          const SizedBox(width: Sizes.spaceS),
                           TeachersAttendanceQuickAction(
                            onTap: ()=>ref.read(attendanceDraftProvider.notifier).resetAll(),
                            label: 'Reset', bgColor: Color(0xFFEEEEEE), textColor: Color(0xFF757575)),
                        ],
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXL),

                    // Metrics
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceM),
                      child: metricsAsync.when(
                        skipLoadingOnRefresh: false,
                        loading: () => const LinearProgressIndicator(),
                        error: (err, stack) => Text('Error loading stats', style: TextStyle(color: theme.colorScheme.error)),
                        data: (metrics) => Row(
                          children: [
                            TeachersAttendanceStatCard(letter: 'P', count: metrics.presentCount.toString(), color: const Color(0xFF00BFA5)),
                            const SizedBox(width: Sizes.spaceS),
                            TeachersAttendanceStatCard(letter: 'A', count: metrics.absentCount.toString(), color: const Color(0xFFF44336)),
                            const SizedBox(width: Sizes.spaceS),
                            TeachersAttendanceStatCard(letter: 'L', count: metrics.lateCount.toString(), color: const Color(0xFFFFC107)),
                            const SizedBox(width: Sizes.spaceS),
                            TeachersAttendanceStatCard(letter: 'E', count: metrics.excusedCount.toString(), color: const Color(0xFF2196F3)),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: Sizes.spaceXL),
                    
                    // Students List
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.spaceM),
                      child: recordsAsync.when(
                        skipLoadingOnRefresh: false,
                        loading: () => const TeacherAttendanceShimmer(),
                        error: (err, stack) => AppErrorWidget(
                          message: err.toString(),
                          onlyErrorMessage: true,
                          onRetry: () => ref.invalidate(teacherAttendanceRecordsProvider),
                        ),
                        data: (paginatedData) {
                          final records = paginatedData.records;
                          if (records.isEmpty) return const Center(child: Text("No records found."));

                          return Column(
                            children: [
                              ...records.map((record) {
                                // 🚨 Use the local drafted status if it exists, otherwise fallback to DB status
                                final activeStatus = drafts[record.studentId] ?? record.status.toLowerCase();
                                
                                return GestureDetector(
                                  // 🚨 Clicking anywhere on the card toggles the draft state
                                  onTap: () {
                                    // A simple rotation for demonstration: P -> A -> L -> P
                                    // String nextStatus = 'present';
                                    // if (activeStatus == 'present') nextStatus = 'absent';
                                    // else if (activeStatus == 'absent') nextStatus = 'late';
                                    // ref.read(attendanceDraftProvider.notifier).markStudent(record.studentId, nextStatus);
                                  },
                                  child: StudentAttendanceCard(
                                    name: record.student.fullName,
                                    studentId: record.student.regNumber,
                                    avatarUrl: record.student.photo, // Map this appropriately
                                    currentStatus: activeStatus.isEmpty ? 'A' : activeStatus[0].toUpperCase(),
                                    onStatusTap: (status) {
                                    ref.read(attendanceDraftProvider.notifier).markStudent(record.studentId, status);
                                    } ,
                                  ),
                                );
                              }),
                              if (isFetchingMore) const Padding(padding: EdgeInsets.all(Sizes.paddingL), child: CircularProgressIndicator()),
                            ],
                          );
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Navigation
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingM),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.1))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedBorderButton(
                      label: 'Save draft',
                      onPressed: () {
                        // ref.read(attendanceDraftProvider.notifier).saveDraftToLocal(filter!.date, filter.classId);
                        SuccessDialog.show(
                          context, 
                          title: 'Attendance saved', 
                          buttonText: 'Continue Marking', 
                          message: '${drafts.length} students attendance drafted securely.', 
                          onButtonPressed: () => context.pop(),
                        );
                      },
                    )
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Submit',
                      isLoading: _isSubmitting,
                      onPressed: () async {
                        setState(() => _isSubmitting = true);
                        try {
                          // 🚨 One clean line calling the controller
                          await ref.read(teacherAttendanceRecordsProvider.notifier).submitAttendance();
                          if (mounted) {
                            SuccessDialog.show(
                              context, 
                              title: 'Attendance Submitted', 
                              buttonText: 'Done', 
                              message: 'Parents have been notified in the parents app.', 
                              onButtonPressed: () => context.pop()
                            );
                          }
                        } catch (e) {
                          if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed: $e')));
                        } finally {
                          if (mounted) setState(() => _isSubmitting = false);
                        }
                      },
                    )
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}