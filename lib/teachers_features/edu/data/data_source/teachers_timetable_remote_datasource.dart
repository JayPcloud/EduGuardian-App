import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class TeacherTimetableRemoteDataSource {
  final ApiClient _client;
  TeacherTimetableRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getTimetable() async {
    // academic_session_id and term are optional and default to active session backend-side
    final response = await _client.dio.get('teacher/timetable');
    return response.data;
  }
}

final teacherTimetableRemoteDataSourceProvider = Provider<TeacherTimetableRemoteDataSource>((ref) {
  return TeacherTimetableRemoteDataSource(ref.watch(apiClientProvider));
});