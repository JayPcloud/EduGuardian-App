import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/teachers_timetable_remote_datasource.dart';
import '../models/teachers_timetable_model.dart';


class TeacherTimetableRepository {
  final TeacherTimetableRemoteDataSource remote;
  TeacherTimetableRepository({required this.remote});

  Future<TeacherTimetableDataModel> getTimetable() async {
    try {
      final response = await remote.getTimetable();
      return TeacherTimetableDataModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}

final teacherTimetableRepositoryProvider = Provider<TeacherTimetableRepository>((ref) {
  return TeacherTimetableRepository(remote: ref.watch(teacherTimetableRemoteDataSourceProvider));
});