import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_client.dart';


class TeacherResultRemoteDataSource {
  final ApiClient _client;
  TeacherResultRemoteDataSource( this._client);
  
  // --- IN REMOTE DATA SOURCE ---
  Future<Map<String, dynamic>> getResultConfigs(String category) async {
    final response = await _client.dio.get('result-configurations', queryParameters: {'category': category});
    return response.data;
  }

  Future<Map<String, dynamic>> getExistingResults({
    required String classId, required String armId, required String subjectId, required String sessionId, required String term,
  }) async {
    final response = await _client.dio.get(
      'results/class/$classId/arm/$armId/subject/$subjectId',
      queryParameters: {'academic_session_id': sessionId, 'term': term},
    );
    return response.data;
  }

  Future<void> bulkUploadResults(Map<String, dynamic> payload) async {
    await _client.dio.post('results/bulk-manual', data: payload);
  }
  
}

final teacherResultRemoteDataSourceProvider = Provider<TeacherResultRemoteDataSource>((ref){
  return TeacherResultRemoteDataSource(ref.watch(apiClientProvider));
});