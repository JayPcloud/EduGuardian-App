import 'package:edu_guardian_app/parents_features/dashboard/data/repositories/dashboard_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/dashboard_stats_models.dart';
import 'student_providers.dart';


final parentDashboardStatsProvider = FutureProvider<DashboardStatsModel>((ref) async {
  await ref.watch(myWardsProvider.future);
  final studentId = ref.watch(activeWardProvider)?.id;
  if (studentId == null) throw 'No student selected.';
  
  return ref.read(dashboardRepositoryProvider).getDashboardStats(studentId);
});

final parentTimelineProvider = FutureProvider<List<TimelineItemModel>>((ref) async {
  await ref.watch(myWardsProvider.future);
  final studentId = ref.watch(activeWardProvider)?.id;
  if (studentId == null) return [];
  
  return ref.read(dashboardRepositoryProvider).getTodayTimeline(studentId);
});