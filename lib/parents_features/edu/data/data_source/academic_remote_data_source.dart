import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';

class AcademicRemoteDataSource {
   final ApiClient _client;
  AcademicRemoteDataSource(this._client);
  
  Future<Map<String, dynamic>> getAcademicPerformance(String studentId, Map<String, dynamic> payload) async {
    final response = await _client.dio.get('guardian/students/$studentId/performance', data: payload);
    return response.data;
  }

  Future<Map<String, dynamic>> getAttendance(String studentId) async {
    final response = await _client.dio.get('guardian/students/$studentId/attendance');
    return response.data;
  }

}

final academicRemoteDataSourceProvider = Provider<AcademicRemoteDataSource>((ref) {
  return AcademicRemoteDataSource(ref.watch(apiClientProvider));
});