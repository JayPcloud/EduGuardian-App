import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart'; // Adjust path to your ApiClient

class DashboardRemoteDataSource {
  final ApiClient _client;
  DashboardRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getDashboardStats(String studentId) async {
    final response = await _client.dio.get('guardian/students/$studentId/dashboard');
    return response.data;
  }

  Future<Map<String, dynamic>> getTimeline(String studentId) async {
    final response = await _client.dio.get('guardian/students/$studentId/timetable');
    return response.data;
  }
  
  
}

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDataSource>((ref) {
  return DashboardRemoteDataSource(ref.watch(apiClientProvider));
});