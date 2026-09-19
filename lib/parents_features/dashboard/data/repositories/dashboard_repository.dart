import 'dart:math' as math;
import 'package:intl/intl.dart';
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
    try {
      // 1. Fetch data from your endpoint
      final response = await remote.getTimeline(studentId); // Make sure you added this to your remote data source
      final grid = response['data']['grid'] as List;

      final now = DateTime.now();
      final todayKey = DateFormat('EEEE').format(now).toLowerCase(); // e.g., 'monday'
      
      List<TimelineItemModel> rawTimeline = [];

      // 2. Parse today's schedule
      for (var item in grid) {
        final isBreak = item['is_break'] == true;
        final dayData = item['days'][todayKey];

        // Skip if it's not a break AND there's no class scheduled for today
        if (!isBreak && dayData == null) continue;

        final timeString = item['time'] as String; // e.g., "08:00 AM - 08:45 AM"
        final times = timeString.split(' - ');
        if (times.length != 2) continue;

        final startTime = _parseTime(times[0]);
        final endTime = _parseTime(times[1]);

        final isDone = now.isAfter(endTime);
        final isActive = now.isAfter(startTime) && now.isBefore(endTime);
        final isFuture = now.isBefore(startTime);

        String title = isBreak ? item['period_name'] : dayData['subject_name'];
        String subtitle = isBreak ? 'Break Time' : '${dayData['room']} · ${dayData['teacher_name']}';

        rawTimeline.add(TimelineItemModel(
          time: isActive ? 'IN PROGRESS' : times[0],
          title: title,
          subtitle: subtitle,
          isDone: isDone,
          isActive: isActive,
          isFaded: isFuture, // Fade future items
        ));
      }

      if (rawTimeline.isEmpty) return [];

      // 3. SLIDING WINDOW OPTIMIZATION
      int cogIndex = rawTimeline.indexWhere((item) => item.isActive); // Center of Gravity
      
      if (cogIndex == -1) {
        // If nothing is active, find the first future event
        cogIndex = rawTimeline.indexWhere((item) => !item.isDone);
      }
      
      if (cogIndex == -1) {
        // If school is completely over, focus on the end of the day
        cogIndex = rawTimeline.length - 1;
      }

      // Calculate the optimal starting index for a 4-item window
      int startIdx = cogIndex - 1; // Default: 1 previous, 1 active, 2 future
      
      // Clamp bounds so we don't throw OutOfRange exceptions
      if (startIdx < 0) startIdx = 0; 
      if (startIdx + 4 > rawTimeline.length) startIdx = rawTimeline.length - 4;
      if (startIdx < 0) startIdx = 0; // Re-clamp in case total items < 4

      // 4. Return the perfect 4-item slice
      return rawTimeline.sublist(startIdx, math.min(startIdx + 4, rawTimeline.length));
      
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  // Helper to convert "08:00 AM" into today's DateTime for comparison
  DateTime _parseTime(String timeStr) {
    final now = DateTime.now();
    final timeFormat = DateFormat('hh:mm a');
    final parsedTime = timeFormat.parse(timeStr);
    return DateTime(now.year, now.month, now.day, parsedTime.hour, parsedTime.minute);
  
  }
}


final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository(remote: ref.watch(dashboardRemoteDataSourceProvider));
});