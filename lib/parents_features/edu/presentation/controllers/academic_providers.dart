import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../../data/models/subject_performance_model.dart';
import '../../data/repositories/academic_repository.dart';

final academicPerformanceProvider = FutureProvider<List<SubjectPerformanceModel>>((ref) async {
  await ref.watch(myWardsProvider.future);
  final activeWard = ref.watch(activeWardProvider);
  if (activeWard == null) throw 'No student selected';

  // Construct the payload using the active student's attached data
  final payload = {
    "term": activeWard.term,
    "class_id": activeWard.schoolClassId,
    "arm_id": activeWard.classArmId,
  };

  return ref.read(academicRepositoryProvider).getAcademicPerformance(activeWard.id, payload);
});