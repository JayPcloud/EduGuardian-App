import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/api/api_client.dart';

class WardBehaviorRemoteDataSource {
  final ApiClient _client;
  WardBehaviorRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getBehaviors(String studentId, {int page = 1}) async {
    final response = await _client.dio.get(
      'guardian/students/$studentId/behaviors',
      queryParameters: {'page': page},
    );
    return response.data;
  }
}

final wardBehaviorRemoteDataSourceProvider = Provider<WardBehaviorRemoteDataSource>((ref) {
  return WardBehaviorRemoteDataSource(ref.watch(apiClientProvider));
});