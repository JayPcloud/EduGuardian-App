import 'package:edu_guardian_app/parents_features/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/exceptions/error_handler.dart';
import '../models/dashboard_stats_models.dart';


class DashboardRepository {
  final DashboardRemoteDataSource remote;

  DashboardRepository({required this.remote});

  Future<DashboardStatsModel> getDashboardStats(String studentId) async {
    try {
      final response = await remote.getDashboardStats(studentId);
      return DashboardStatsModel.fromJson(response['data']);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  // DUMMY IMPLEMENTATION FOR TIMELINE (Until Backend is ready)
  Future<List<TimelineItemModel>> getTodayTimeline(String studentId) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network latency
    return [
      TimelineItemModel(
        time: '09:00 AM', 
        title: 'Morning Assembly & Devotion', 
        subtitle: 'Main Hall · Mrs Adanna',
        isDone: true,
      ),
      TimelineItemModel(
        time: 'IN PROGRESS', 
        title: 'Mathematics — Simultaneous Equations', 
        subtitle: 'JSS 2 D · Mr. Lawal',
        isActive: true,
      ),
      TimelineItemModel(
        time: '02:00 PM', 
        title: 'Inter-House Football Practice', 
        subtitle: 'School Field · Green House',
        isFaded: true,
      ),
    ];
  }
}

final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(remote: ref.watch(dashboardRemoteDataSourceProvider));
});