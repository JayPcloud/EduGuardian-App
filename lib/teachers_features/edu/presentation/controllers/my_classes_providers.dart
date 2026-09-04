import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/class_management_models.dart';
import '../../data/models/teacher_class_model.dart';
import '../../data/repositories/teacher_classes_repositories.dart';

// Tracks the search bar input
final teacherClassesSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

// Fetches the raw API data
final teacherClassesProvider = FutureProvider.autoDispose<TeacherClassesDataModel>((ref) async {
  return ref.read(teacherClassesRepositoryProvider).fetchClasses();
});

// Filters the classes based on the search query
final filteredTeacherClassesProvider = Provider.autoDispose<List<TeacherClassModel>>((ref) {
  final dataModel = ref.watch(teacherClassesProvider).valueOrNull;
  if (dataModel == null) return [];

  final query = ref.watch(teacherClassesSearchQueryProvider).toLowerCase();
  if (query.isEmpty) return dataModel.classes;

  return dataModel.classes.where((cls) {
    final matchesClass = cls.name.toLowerCase().contains(query);
    final matchesSubject = cls.subjects.any((s) => s.name.toLowerCase().contains(query));
    return matchesClass || matchesSubject;
  }).toList();
});


final teacherClassDetailsProvider = FutureProvider.family.autoDispose<TeacherClassModel, String>((ref, classId) async {
  return ref.read(teacherClassesRepositoryProvider).getClassDetails(classId);
});

final classStudentsProvider = FutureProvider.family.autoDispose<List<TeacherClassStudentModel>, String>((ref, classId) async {
  return ref.read(teacherClassesRepositoryProvider).getClassStudents(classId);
});