import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/teacher_dashboard_remote_data_source.dart';
import '../models/teacher_dashboard_models.dart';

class TeacherDashboardRepository {
  final TeacherDashboardRemoteDataSource remote;

  TeacherDashboardRepository({required this.remote});

  Future<TeacherDashboardStatsModel> getStats() async {
    try {
      final response = await remote.getStats();
      return TeacherDashboardStatsModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  // 🚨 DUMMY DATA FOR SCHEDULE (Until API is ready)
  Future<List<TeacherScheduleModel>> getTodaySchedule() async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network load
    return [
      TeacherScheduleModel(timeH: '08:', timeM: '30', subject: 'Mathematics', className: 'JSS 3A', details: '32 students  Room 202', status: 'Upcoming'),
      TeacherScheduleModel(timeH: '10:', timeM: '15', subject: 'Physics', className: 'SSS 1B', details: '28 students  Lab 1', status: 'Upcoming'),
      TeacherScheduleModel(timeH: '12:', timeM: '00', subject: 'Further Math', className: 'SSS 3A', details: '15 students  Room 304', status: 'Upcoming'),
    ];
  }
}

final teacherDashboardRepositoryProvider = Provider<TeacherDashboardRepository>((ref) {
  return TeacherDashboardRepository(remote: ref.watch(teacherDashboardRemoteDataSourceProvider));
});