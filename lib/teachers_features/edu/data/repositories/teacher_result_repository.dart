import 'package:edu_guardian_app/teachers_features/edu/data/data_source/teacher_result_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/exceptions/error_handler.dart';
import '../models/result_models.dart';

class TeacherResultRepository {
  final TeacherResultRemoteDataSource remote;
  TeacherResultRepository(this.remote);
  
  Future<List<ResultConfigModel>> getResultConfigs(String category) async {
    try {
      final response = await remote.getResultConfigs(category);
      final data = response['data'] as List? ?? [];
      return data.map((e) => ResultConfigModel.fromJson(e)).toList();
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<List<StudentExistingResultModel>> getExistingResults({
    required String classId, required String armId, required String subjectId, required String sessionId, required String term,
  }) async {
    try {
      final response = await remote.getExistingResults(classId: classId, armId: armId, subjectId: subjectId, sessionId: sessionId, term: term);
      final data = response['data'] as List? ?? [];
      return data.map((e) => StudentExistingResultModel.fromJson(e)).toList();
    } catch (e) {
      // If 404 or no records found, return empty so we can generate fresh blank inputs
      return []; 
    }
  }

  Future<void> bulkUploadResults(Map<String, dynamic> payload) async {
    try {
      await remote.bulkUploadResults(payload);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}


final teacherResultRepository = Provider<TeacherResultRepository>((ref){
  return TeacherResultRepository(ref.watch(teacherResultRemoteDataSourceProvider));
});