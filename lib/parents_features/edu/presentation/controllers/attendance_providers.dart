import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../../data/models/attendance_model.dart';
import '../../data/repositories/academic_repository.dart';

final parentAttendanceProvider = FutureProvider<AttendanceDataModel>((ref) async {
  // Wait for the wards to finish loading so we don't throw an error on boot
  await ref.watch(myWardsProvider.future);

  final activeWard = ref.watch(activeWardProvider);
  if (activeWard == null) throw 'No student records found.';

  return ref.read(academicRepositoryProvider).getAttendance(activeWard.id);
});