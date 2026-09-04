import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/teacher_classes_remote_data_source.dart';
import '../models/class_management_models.dart';
import '../models/teacher_class_model.dart';

class TeacherClassesRepository {
  final TeacherClassesRemoteDataSource remote;

  TeacherClassesRepository({required this.remote});

  Future<TeacherClassesDataModel> fetchClasses() async {
    try {
      final response = await remote.getClasses();
      return TeacherClassesDataModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<TeacherClassModel> getClassDetails(String classId) async {
    try {
      final response = await remote.getClassDetails(classId);
      return TeacherClassModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<List<TeacherClassStudentModel>> getClassStudents(String classId) async {
    try {
      final response = await remote.getClassStudents(classId);
      final List data = response['data'] ?? [];
      return data.map((s) => TeacherClassStudentModel.fromJson(s)).toList();
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

}

final teacherClassesRepositoryProvider = Provider<TeacherClassesRepository>((ref) {
  return TeacherClassesRepository(remote: ref.watch(teacherClassesRemoteDataSourceProvider));
});