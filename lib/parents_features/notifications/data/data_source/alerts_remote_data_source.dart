import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class AlertsRemoteDataSource {
  final ApiClient _client;
  AlertsRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getAnnouncements({int page = 1}) async {
    final response = await _client.dio.get(
      'guardian/announcements',
      queryParameters: {'page': page},
    );
    return response.data;
  }

  Future<void> markAllAsRead() async {
    await _client.dio.post('guardian/announcements/read-all');
  }
}

final alertsRemoteDataSourceProvider = Provider<AlertsRemoteDataSource>((ref) {
  return AlertsRemoteDataSource(ref.watch(apiClientProvider));
});