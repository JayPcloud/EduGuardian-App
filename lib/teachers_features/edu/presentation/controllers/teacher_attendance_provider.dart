import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/teachers_attendance_models.dart';
import '../../data/repositories/teacher_attendance_repository.dart';
import 'my_classes_providers.dart';


// 1. FILTER STATE PROVIDER
class AttendanceFilterState {
  final String classId;
  final String className;
  final String armId;
  final String subjectName; 
  final String date;
  final String term;
  final String sessionId;

  AttendanceFilterState({
    required this.classId, required this.className, required this.armId, required this.subjectName, required this.date, required this.term, required this.sessionId,
  });

  AttendanceFilterState copyWith({
    String? classId, String? className, String? armId, String? subjectName, String? date, String? term, String? sessionId,
  }) {
    return AttendanceFilterState(
      classId: classId ?? this.classId,
      className: className ?? this.className,
      armId: armId ?? this.armId,
      subjectName: subjectName ?? this.subjectName,
      date: date ?? this.date,
      term: term ?? this.term,
      sessionId: sessionId ?? this.sessionId,
    );
  }

  Map<String, dynamic> toPayload() => {
    "academic_session_id": sessionId,
    "term": term,
    "date": date,
    "school_class_id": classId,
    "class_arm_id": armId,
  };
}


// 2. DRAFT ATTENDANCE PROVIDER (student_id -> status)
class AttendanceDraftNotifier extends Notifier<Map<String, String>> {
  @override
  Map<String, String> build() => {};

  void markStudent(String studentId, String status) {
    state = {...state, studentId: status.toLowerCase()};
  }

  void markAll(List<String> studentIds, String status) {
    final newState = Map<String, String>.from(state);
    for (var id in studentIds) {
      newState[id] = status.toLowerCase();
    }
    state = newState;
  }

  void resetAll() {
    state = {};
  }
  
  // Call this to save locally (Hive)
  Future<void> saveDraftToLocal(String date, String classId) async {
    // TODO: Put `state` into a Hive box using key '${classId}_$date'
  }
  
}


// 3. PAGINATED RECORDS NOTIFIER
class TeacherAttendanceRecordsNotifier extends AutoDisposeAsyncNotifier<PaginatedTeacherAttendanceModel> {
  bool _isFetchingMore = false;

  @override
  FutureOr<PaginatedTeacherAttendanceModel> build() async {
    final filter = ref.watch(attendanceFilterProvider);
    final search = ref.watch(attendanceSearchProvider);
    if (filter == null) throw 'Select a class to view attendance';

    final data = await ref.read(teacherAttendanceRepositoryProvider).getRecords(filter.toPayload(), page: 1, search: search);
    
    // Auto-populate draft state with existing backend data on load
    Future.microtask(() {
      final draftNotifier = ref.read(attendanceDraftProvider.notifier);
      for (var record in data.records) {
        draftNotifier.markStudent(record.studentId, record.status);
      }
    });
    
    return data;
  }

  // 🚨 EXTRACTED INIT LOGIC
  Future<void> initializeFilters(String? initialClassId) async {
    // If it's already initialized, do nothing
    if (ref.read(attendanceFilterProvider) != null) return; 

    try {
      final classesData = await ref.read(teacherClassesProvider.future);
      if (classesData.classes.isEmpty) return;

      // Pre-select passed classId or default to the first one
      final selectedClass = initialClassId != null 
          ? classesData.classes.firstWhere((c) => c.id == initialClassId, orElse: () => classesData.classes.first)
          : classesData.classes.first;

      ref.read(attendanceFilterProvider.notifier).state = AttendanceFilterState(
        classId: selectedClass.id,
        className: selectedClass.name,
        armId: selectedClass.arms.isNotEmpty ? selectedClass.arms.first.id : '',
        subjectName: selectedClass.subjects.isNotEmpty ? selectedClass.subjects.first.name : 'N/A',
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        term: "1", // TODO: Make dynamic from active session data
        sessionId: "019f6cf7-16a4-71ea-b726-b93d79d63b4e", // TODO: Make dynamic
      );
    } catch (e) {
      // Handle or log error gracefully if classes fail to load
      debugPrint("Failed to initialize filters: $e");
    }
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    final currentData = state.valueOrNull;
    if (currentData == null || currentData.currentPage >= currentData.lastPage) return;

    _isFetchingMore = true;
    try {
      final filter = ref.read(attendanceFilterProvider);
      final search = ref.read(attendanceSearchProvider);
      final nextData = await ref.read(teacherAttendanceRepositoryProvider)
          .getRecords(filter!.toPayload(), page: currentData.currentPage + 1, search: search);

      state = AsyncData(currentData.copyWith(
        currentPage: nextData.currentPage,
        records: [...currentData.records, ...nextData.records],
      ));
      
      // Auto-populate drafts for the new page
      final draftNotifier = ref.read(attendanceDraftProvider.notifier);
      for (var record in nextData.records) {
        draftNotifier.markStudent(record.studentId, record.status);
      }
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> submitAttendance() async {
    final filter = ref.read(attendanceFilterProvider);
    final drafts = ref.read(attendanceDraftProvider);
    if (filter == null || drafts.isEmpty) throw 'Nothing to submit';

    try {
      final payload = filter.toPayload();
      payload['students'] = drafts.entries.map((e) => {
        "student_id": e.key,
        "status": e.value
      }).toList();

      await ref.read(teacherAttendanceRepositoryProvider).markAttendance(payload);
    } catch (e) {
      rethrow;
    }
  }

  bool get isFetchingMore => _isFetchingMore;
}



//Providers

final attendanceDraftProvider = NotifierProvider<AttendanceDraftNotifier, Map<String, String>>(() => AttendanceDraftNotifier());

final attendanceFilterProvider = StateProvider<AttendanceFilterState?>((ref) => null);
final attendanceSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final teacherAttendanceRecordsProvider = AsyncNotifierProvider.autoDispose<TeacherAttendanceRecordsNotifier, PaginatedTeacherAttendanceModel>(() {
  return TeacherAttendanceRecordsNotifier();
});

// 4. METRICS PROVIDER
final teacherAttendanceMetricsProvider = FutureProvider.autoDispose<TeacherAttendanceMetricsModel>((ref) async {
  final filter = ref.watch(attendanceFilterProvider);
  if (filter == null) throw 'Select a class to view metrics';
  return ref.read(teacherAttendanceRepositoryProvider).getMetrics(filter.toPayload());
});