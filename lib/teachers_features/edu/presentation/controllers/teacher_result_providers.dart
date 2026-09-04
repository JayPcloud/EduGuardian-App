import 'dart:async';

import 'package:edu_guardian_app/teachers_features/edu/data/repositories/teacher_result_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/class_management_models.dart';
import '../../data/models/result_models.dart';
import '../../data/repositories/teacher_classes_repositories.dart';
import 'my_classes_providers.dart';


// 1. FILTER STATE
class ResultFilterState {
  final String classId;
  final String className;
  final String classCategory; // Needed to fetch configs
  final String armId;
  final String subjectId;
  final String subjectName;
  final String term;
  final String sessionId;

  ResultFilterState({
    required this.classId, required this.className, required this.classCategory, required this.armId, 
    required this.subjectId, required this.subjectName, required this.term, required this.sessionId,
  });

  ResultFilterState copyWith({
    String? classId, String? className, String? classCategory, String? armId, String? subjectId, String? subjectName, String? term, String? sessionId,
  }) {
    return ResultFilterState(
      classId: classId ?? this.classId, className: className ?? this.className, classCategory: classCategory ?? this.classCategory,
      armId: armId ?? this.armId, subjectId: subjectId ?? this.subjectId, subjectName: subjectName ?? this.subjectName,
      term: term ?? this.term, sessionId: sessionId ?? this.sessionId,
    );
  }
}
final resultFilterProvider = StateProvider<ResultFilterState?>((ref) => null);

// 2. CONFIGS PROVIDER (Reacts to the selected class category)
final resultConfigsProvider = FutureProvider.autoDispose<List<ResultConfigModel>>((ref) async {
  final filter = ref.watch(resultFilterProvider);
  if (filter == null) return [];
  return ref.read(teacherResultRepository).getResultConfigs(filter.classCategory);
});

// 3. DRAFT SCORES PROVIDER (studentId -> configId -> score)
class ResultDraftNotifier extends Notifier<Map<String, Map<String, String>>> {
  @override
  Map<String, Map<String, String>> build() => {};

  void updateScore(String studentId, String configId, String score) {
    final currentStudentDraft = state[studentId] ?? {};
    state = {
      ...state,
      studentId: { ...currentStudentDraft, configId: score }
    };
  }

  void updateStudentRecord({required String studentId, required Map<String, String> result}) {
    final currentStudentDraft = state[studentId] ?? {};
    state = {
      ...state,
      studentId: { ...currentStudentDraft, ...result }
    };
  }

  void initializeFromBackend(List<StudentExistingResultModel> existingRecords, List<ResultConfigModel> configs) {
    final Map<String, Map<String, String>> initialState = {};
    for (var record in existingRecords) {
      final Map<String, String> studentScores = {};
      for (int i = 0; i < configs.length; i++) {
        if (i < record.scores.length && record.scores[i] != null) {
          studentScores[configs[i].id] = record.scores[i].toString();
        }
      }
      initialState[record.studentId] = studentScores;
    }
    // We intentionally bypass `state =` to prevent immediate re-renders during boot
    state = initialState; 
  }
}
final resultDraftProvider = NotifierProvider<ResultDraftNotifier, Map<String, Map<String, String>>>(() => ResultDraftNotifier());

// 4. THE CONTROLLER (Merge Data & Submit)
class ResultEntryController extends AutoDisposeAsyncNotifier<List<TeacherClassStudentModel>> {
  @override
  FutureOr<List<TeacherClassStudentModel>> build() async {
    final filter = ref.watch(resultFilterProvider);
    if (filter == null) return [];

    final repo = ref.read(teacherResultRepository);
    final classRepo = ref.read(teacherClassesRepositoryProvider);
    // Fetch dependencies in parallel
    final studentsFuture = classRepo.getClassStudents(filter.classId);
    final configsFuture = ref.watch(resultConfigsProvider.future);
    final resultsFuture = repo.getExistingResults(
      classId: filter.classId, armId: filter.armId, subjectId: filter.subjectId, sessionId: filter.sessionId, term: filter.term,
    );

    final results = await Future.wait([studentsFuture, configsFuture, resultsFuture]);
    final students = results[0] as List<TeacherClassStudentModel>;
    final configs = results[1] as List<ResultConfigModel>;
    final existingRecords = results[2] as List<StudentExistingResultModel>;

    // Pre-fill the draft state safely in the next tick
    Future.microtask(() => ref.read(resultDraftProvider.notifier).initializeFromBackend(existingRecords, configs));

    return students;
  }

  Future<void> initializeFilters(String? initClassId, String? initArmId, String? initSubjectId) async {
    if (ref.read(resultFilterProvider) != null) return; 

    try {
      final classesData = await ref.read(teacherClassesProvider.future);
      if (classesData.classes.isEmpty) return;

      final selectedClass = initClassId != null 
          ? classesData.classes.firstWhere((c) => c.id == initClassId, orElse: () => classesData.classes.first)
          : classesData.classes.first;
          
      final selectedArmId = initArmId ?? (selectedClass.arms.isNotEmpty ? selectedClass.arms.first.id : '');
      
      final selectedSubject = initSubjectId != null && selectedClass.subjects.any((s) => s.id == initSubjectId)
          ? selectedClass.subjects.firstWhere((s) => s.id == initSubjectId)
          : (selectedClass.subjects.isNotEmpty ? selectedClass.subjects.first : null);

      ref.read(resultFilterProvider.notifier).state = ResultFilterState(
        classId: selectedClass.id,
        className: selectedClass.name,
        classCategory: selectedClass.category, // Needed for fetching configs!
        armId: selectedArmId,
        subjectId: selectedSubject?.id ?? '',
        subjectName: selectedSubject?.name ?? 'N/A',
        term: "1", 
        sessionId: "019f6cf7-16a4-71ea-b726-b93d79d63b4e", 
      );
    } catch (e) {
      print("Failed to initialize result filters: $e");
    }
  }

  // Add this inside ResultEntryController
  int getMissingRecordsCount() {
    final students = state.valueOrNull ?? [];
    final drafts = ref.read(resultDraftProvider);
    final configs = ref.read(resultConfigsProvider).valueOrNull ?? [];

    int missingCount = 0;

    for (var student in students) {
      final studentScores = drafts[student.id] ?? {};
      bool hasMissingScore = false;
      
      for (var config in configs) {
        // If the score for a specific config is missing or empty
        if (!studentScores.containsKey(config.id) || studentScores[config.id]!.isEmpty) {
          hasMissingScore = true;
          break;
        }
      }
      
      if (hasMissingScore) missingCount++;
    }

    return missingCount;
  }

  Future<void> submitBulkResults() async {
    final filter = ref.read(resultFilterProvider);
    final configs = ref.read(resultConfigsProvider).valueOrNull ?? [];
    final drafts = ref.read(resultDraftProvider);

    if (filter == null || configs.isEmpty || drafts.isEmpty) throw 'No data to submit';

    final configIds = configs.map((c) => c.id).toList();

    // Map drafted scores back to strictly ordered array
    final studentsPayload = drafts.entries.map((entry) {
      final studentScores = configIds.map((cid) {
        final scoreStr = entry.value[cid];
        return (scoreStr != null && scoreStr.isNotEmpty) ? num.tryParse(scoreStr) : null;
      }).toList();

      return {
        "student_id": entry.key,
        "scores": studentScores
      };
    }).toList();

    final payload = {
      "school_class_id": filter.classId,
      "class_arm_id": filter.armId,
      "subject_id": filter.subjectId,
      "configs": configIds,
      "students": studentsPayload,
    };
    debugPrint(payload.toString());

    await ref.read(teacherResultRepository).bulkUploadResults(payload);
  }
}

final resultEntryControllerProvider = AsyncNotifierProvider.autoDispose<ResultEntryController, List<TeacherClassStudentModel>>(() {
  return ResultEntryController();
});