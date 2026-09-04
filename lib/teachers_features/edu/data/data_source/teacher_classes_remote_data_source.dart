import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class TeacherClassesRemoteDataSource {
  final ApiClient _client;
  TeacherClassesRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getClasses() async {
    final response = await _client.dio.get('teacher/classes');
    return response.data;
  }

  Future<Map<String, dynamic>> getClassDetails(String classId) async {
    final response = await _client.dio.get('teacher/classes/$classId');
    return response.data;
  }

  Future<Map<String, dynamic>> getClassStudents(String classId) async {
    final response = await _client.dio.get('teacher/classes/$classId/students');
    return response.data;
  }


}

final teacherClassesRemoteDataSourceProvider = Provider<TeacherClassesRemoteDataSource>((ref) {
  return TeacherClassesRemoteDataSource(ref.watch(apiClientProvider));
});