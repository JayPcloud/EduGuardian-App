import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/academic_remote_data_source.dart';
import '../models/attendance_model.dart';
import '../models/subject_performance_model.dart';


class AcademicRepository {
  final AcademicRemoteDataSource remote;

  AcademicRepository({required this.remote});

  Future<List<SubjectPerformanceModel>> getAcademicPerformance(String studentId, Map<String, dynamic> payload) async {
    try {
      final response = await remote.getAcademicPerformance(studentId, payload);
      final List data = response['data'] ?? [];
      return data.map((s) => SubjectPerformanceModel.fromJson(s)).toList();
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<AttendanceDataModel> getAttendance(String studentId) async {
    try {
      final response = await remote.getAttendance(studentId);
      return AttendanceDataModel.fromJson(response['data']);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
  
}

final academicRepositoryProvider = Provider<AcademicRepository>((ref) {
  return AcademicRepository(remote: ref.watch(academicRemoteDataSourceProvider));
});