import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class TeacherDashboardRemoteDataSource {
  final ApiClient _client;
  TeacherDashboardRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getStats() async {
    final response = await _client.dio.get('teacher/dashboard');
    return response.data;
  }
}

final teacherDashboardRemoteDataSourceProvider = Provider<TeacherDashboardRemoteDataSource>((ref) {
  return TeacherDashboardRemoteDataSource(ref.watch(apiClientProvider));
});