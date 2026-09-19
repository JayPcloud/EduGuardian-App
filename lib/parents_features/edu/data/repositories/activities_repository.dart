import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/activities_remote_datasource.dart';
import '../models/badge_model.dart';

class ActivitiesRepository {
  final ActivitiesRemoteDataSource remote;
  ActivitiesRepository({required this.remote});

  Future<List<BadgeModel>> getBadges(String studentId) async {
    try {
      final response = await remote.getBadges(studentId);
      final List data = response['data'] ?? [];
      return data.map((b) => BadgeModel.fromJson(b)).toList();
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}

final activitiesRepositoryProvider = Provider<ActivitiesRepository>((ref) {
  return ActivitiesRepository(remote: ref.watch(activitiesRemoteDataSourceProvider));
});