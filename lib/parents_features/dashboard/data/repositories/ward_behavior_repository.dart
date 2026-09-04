import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/ward_behaviour_remote_data_source.dart';
import '../models/behaviour_model.dart';

class WardBehaviorRepository {
  final WardBehaviorRemoteDataSource remote;

  WardBehaviorRepository({required this.remote});

  Future<PaginatedBehaviorModel> getBehaviors(String studentId, {int page = 1}) async {
    try {
      final response = await remote.getBehaviors(studentId, page: page);
      // 🚨 Pass the 'data' object which contains current_page, last_page, and the inner 'data' array
      return PaginatedBehaviorModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}

final wardBehaviorRepositoryProvider = Provider<WardBehaviorRepository>((ref) {
  return WardBehaviorRepository(remote: ref.watch(wardBehaviorRemoteDataSourceProvider));
});