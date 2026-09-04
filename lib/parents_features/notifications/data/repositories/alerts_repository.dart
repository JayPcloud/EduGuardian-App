import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../data_source/alerts_remote_data_source.dart';
import '../models/alert_model.dart';


class AlertsRepository {
  final AlertsRemoteDataSource remote;

  AlertsRepository({required this.remote});

  Future<PaginatedAnnouncementModel> getAnnouncements({int page = 1}) async {
    try {
      final response = await remote.getAnnouncements(page: page);
      return PaginatedAnnouncementModel.fromJson(response['data'] ?? {});
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> markAllAsRead() async {
    try {
      await remote.markAllAsRead();
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}

final alertsRepositoryProvider = Provider<AlertsRepository>((ref) {
  return AlertsRepository(remote: ref.watch(alertsRemoteDataSourceProvider));
});