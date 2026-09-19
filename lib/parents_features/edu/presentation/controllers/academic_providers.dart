import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../../data/models/subject_performance_model.dart';
import '../../data/repositories/academic_repository.dart';

// academic_providers.dart

// Holds the currently selected filter values for the UI
class AcademicFilterState {
  final String? classId;
  final String? armId;
  final String? term;
  final String? subjectName;

  AcademicFilterState({this.classId, this.armId, this.term, this.subjectName});

  AcademicFilterState copyWith({
    String? classId,
    String? armId,
    String? term,
    String? subjectName,
    bool clearSubject = false,
  }) {
    return AcademicFilterState(
      classId: classId ?? this.classId,
      armId: armId ?? this.armId,
      term: term ?? this.term,
      subjectName: clearSubject ? null : (subjectName ?? this.subjectName),
    );
  }
}

final academicFilterProvider = StateProvider<AcademicFilterState>((ref) => AcademicFilterState());


final academicPerformanceProvider = FutureProvider<List<SubjectPerformanceModel>>((ref) async {
  await ref.watch(myWardsProvider.future);
  final activeWard = ref.watch(activeWardProvider);
  if (activeWard == null) throw 'No student selected';

  // 🚨 ONLY watch the API-dependent filters so subject changes don't trigger re-fetch
  final term = ref.watch(academicFilterProvider.select((s) => s.term));
  final classId = ref.watch(academicFilterProvider.select((s) => s.classId));
  final armId = ref.watch(academicFilterProvider.select((s) => s.armId));

  final payload = {
    "term": term ?? activeWard.term,
    "class_id": classId ?? activeWard.schoolClass?.id,
    "arm_id": armId ?? activeWard.classArm?.id,
  };

  return ref.read(academicRepositoryProvider).getAcademicPerformance(activeWard.id, payload);
});


