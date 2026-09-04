import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/teacher_dashboard_models.dart';
import '../../data/repositories/teacher_dashboard_repo.dart';

final teacherDashboardStatsProvider = FutureProvider.autoDispose<TeacherDashboardStatsModel>((ref) async {
  return ref.read(teacherDashboardRepositoryProvider).getStats();
});

final teacherScheduleProvider = FutureProvider.autoDispose<List<TeacherScheduleModel>>((ref) async {
  return ref.read(teacherDashboardRepositoryProvider).getTodaySchedule();
});