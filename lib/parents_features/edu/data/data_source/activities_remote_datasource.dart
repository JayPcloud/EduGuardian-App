import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

// --- REMOTE DATA SOURCE ---
class ActivitiesRemoteDataSource {
  final ApiClient _client;
  ActivitiesRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getBadges(String studentId) async {
    final response = await _client.dio.get('guardian/students/$studentId/badges');
    return response.data;
  }
}

final activitiesRemoteDataSourceProvider = Provider<ActivitiesRemoteDataSource>((ref) {
  return ActivitiesRemoteDataSource(ref.watch(apiClientProvider));
});