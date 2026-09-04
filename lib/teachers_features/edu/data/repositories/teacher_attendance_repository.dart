import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/teacher_attendance_remote_data_source.dart';
import '../models/teachers_attendance_models.dart';

class TeacherAttendanceRepository {
  final TeacherAttendanceRemoteDataSource remote;
  TeacherAttendanceRepository({required this.remote});

  Future<PaginatedTeacherAttendanceModel> getRecords(Map<String, dynamic> payload, {int page = 1, String search = ''}) async {
    try {
      final response = await remote.getRecords(payload, page: page, search: search);
      return PaginatedTeacherAttendanceModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<TeacherAttendanceMetricsModel> getMetrics(Map<String, dynamic> payload) async {
    try {
      final response = await remote.getMetrics(payload);
      return TeacherAttendanceMetricsModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> markAttendance(Map<String, dynamic> payload) async {
    try {
      await remote.markAttendance(payload);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}

final teacherAttendanceRepositoryProvider = Provider<TeacherAttendanceRepository>((ref) {
  return TeacherAttendanceRepository(remote: ref.watch(teacherAttendanceRemoteDataSourceProvider));
});