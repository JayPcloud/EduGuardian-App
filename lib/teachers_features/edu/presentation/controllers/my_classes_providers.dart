import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/class_management_models.dart';
import '../../data/models/teacher_class_model.dart';
import '../../data/repositories/teacher_classes_repositories.dart';

typedef ClassArmParam = ({String classId, String armId});// 🚨 Create a quick type definition for clean code

// Tracks the search bar input
final teacherClassesSearchQueryProvider = StateProvider.autoDispose<String>((ref) => '');

// Holds the currently selected subject for filtering (null means "All")
final selectedSubjectProvider = StateProvider.autoDispose<TeacherSubjectModel?>((ref) => null);

// Fetches the raw API data
final teacherClassesProvider = FutureProvider.autoDispose<TeacherClassesDataModel>((ref) async {
  return ref.read(teacherClassesRepositoryProvider).fetchClasses();
});

// Extracts all unique subjects across all fetched classes for the Tab bar
final uniqueSubjectsProvider = Provider.autoDispose<List<TeacherSubjectModel>>((ref) {
  final dataModel = ref.watch(teacherClassesProvider).valueOrNull;
  if (dataModel == null) return [];

  final Map<String, TeacherSubjectModel> subjectMap = {};
  for (var cls in dataModel.classes) {
    for (var sub in cls.subjects) {
      if (!subjectMap.containsKey(sub.id)) {
        subjectMap[sub.id] = sub;
      }
    }
  }
  return subjectMap.values.toList();
});


// 🚨 NEW FILTER LOGIC: Flattens classes by arms, then filters by Search & Subject
final filteredFlattenedClassesProvider = Provider.autoDispose<List<FlattenedClassData>>((ref) {
  final dataModel = ref.watch(teacherClassesProvider).valueOrNull;
  if (dataModel == null) return [];

  final query = ref.watch(teacherClassesSearchQueryProvider).toLowerCase();
  final selectedSub = ref.watch(selectedSubjectProvider);

  // 1. Flatten into Arms
  List<FlattenedClassData> flattened = [];
  for (var cls in dataModel.classes) {
    for (var arm in cls.arms) {
      flattened.add(FlattenedClassData(parentClass: cls, arm: arm));
    }
  }

  // 2. Filter by Search Query and Selected Subject Tab
  return flattened.where((item) {
    // Search matches class name, arm name, or subject name
    final matchesSearch = query.isEmpty ||
        item.displayClassName.toLowerCase().contains(query) ||
        item.parentClass.subjects.any((s) => s.name.toLowerCase().contains(query));

    // Subject filter matches if "All" is selected, or if the parent class has the selected subject
    final matchesSubject = selectedSub == null ||
        item.parentClass.subjects.any((s) => s.id == selectedSub.id);

    return matchesSearch && matchesSubject;
  }).toList();
});


final teacherClassDetailsProvider = FutureProvider.family.autoDispose<TeacherClassModel, String>((ref, classId) async {
  return ref.read(teacherClassesRepositoryProvider).getClassDetails(classId);
});


final classStudentsProvider = FutureProvider.family.autoDispose<List<TeacherClassStudentModel>, ClassArmParam>((ref, param) async {
  // Destructure the record and pass both IDs to the repo
  return ref.read(teacherClassesRepositoryProvider).getClassStudents(param.classId, param.armId);
});