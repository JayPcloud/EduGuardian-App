import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class TeacherAttendanceRemoteDataSource {
  final ApiClient _client;
  TeacherAttendanceRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getRecords(Map<String, dynamic> payload, {int page = 1, String search = ''}) async {
    final Map<String, dynamic> queryParams = {'page': page};
    if (search.isNotEmpty) queryParams['search'] = search;
    
    final response = await _client.dio.get('attendance/records', data: payload, queryParameters: queryParams);
    return response.data;
  }

  Future<Map<String, dynamic>> getMetrics(Map<String, dynamic> payload) async {
    final response = await _client.dio.get('attendance/metrics', data: payload);
    return response.data;
  }

  Future<void> markAttendance(Map<String, dynamic> payload) async {
    await _client.dio.post('attendance/mark', data: payload);
  }
}

final teacherAttendanceRemoteDataSourceProvider = Provider<TeacherAttendanceRemoteDataSource>((ref) {
  return TeacherAttendanceRemoteDataSource(ref.watch(apiClientProvider));
});