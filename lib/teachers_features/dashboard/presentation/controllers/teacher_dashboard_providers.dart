import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../edu/data/repositories/teachers_timetable_repository.dart';
import '../../../edu/presentation/controllers/teacher_timetable_providers.dart';
import '../../data/models/teacher_dashboard_models.dart';
import '../../data/repositories/teacher_dashboard_repo.dart';


final activeAcademicSessionProvider = FutureProvider<ActiveAcademicSessionInfo>((ref) async {
  final timetableData = await ref.watch(teacherTimetableProvider.future);
  return ActiveAcademicSessionInfo(
    sessionId: timetableData.session.academicSessionId,
    term: timetableData.session.term.toString(),
  );
});


final teacherDashboardStatsProvider = FutureProvider.autoDispose<TeacherDashboardStatsModel>((ref) async {
  return ref.read(teacherDashboardRepositoryProvider).getStats();
});


final teacherScheduleProvider = FutureProvider.autoDispose<List<TeacherScheduleModel>>((ref) async {
  final timetableData = await ref.read(teacherTimetableRepositoryProvider).getTimetable();
  final now = DateTime.now();
  // Determine current day key
  final dayKey = switch (now.weekday) {
    1 => 'monday',
    2 => 'tuesday',
    3 => 'wednesday',
    4 => 'thursday',
    5 => 'friday',
    _ => null, // Weekend
  };

  if (dayKey == null) return [];

  final List<TeacherScheduleModel> upcomingSchedules = [];

  for (final period in timetableData.grid) {
    // Skip school breaks and unassigned slots
    if (period.isBreak) continue;
    final session = period.days.getSessionForDay(dayKey);
    if (session == null) continue;

    // Parse time range: e.g. "08:00 AM - 08:45 AM"
    final timeParts = period.time.split(' - ');
    final startTimeStr = timeParts[0].trim();
    final endTimeStr = timeParts.length > 1 ? timeParts[1].trim() : '';

    DateTime? startDateTime;
    DateTime? endDateTime;
    try {
      final parsedStart = DateFormat('hh:mm a').parse(startTimeStr);
      startDateTime = DateTime(now.year, now.month, now.day, parsedStart.hour, parsedStart.minute);

      if (endTimeStr.isNotEmpty) {
        final parsedEnd = DateFormat('hh:mm a').parse(endTimeStr);
        endDateTime = DateTime(now.year, now.month, now.day, parsedEnd.hour, parsedEnd.minute);
      }
    } catch (_) {}

    //Exclude periods that have already ended
    if (endDateTime != null && now.isAfter(endDateTime)) {
      continue;
    }

    // Determine status (In Progress vs Upcoming)
    String status = 'Upcoming';
    if (startDateTime != null && endDateTime != null) {
      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        status = 'In Progress';
      }
    }

    // Clean start time for the card (strip AM/PM)
    final cleanStart = startTimeStr.replaceAll(RegExp(r'\s*(AM|PM)', caseSensitive: false), '').trim();
    final cleanParts = cleanStart.split(':');
    final timeH = cleanParts.isNotEmpty ? '${cleanParts[0]}:' : '';
    final timeM = cleanParts.length > 1 ? cleanParts[1] : '';

    // Details formatting: show time period, and only include room if non-empty
    final details = (session.room.isNotEmpty && session.room.toLowerCase() != 'null')
        ? '${period.time} · ${session.room}'
        : period.time;

    upcomingSchedules.add(
      TeacherScheduleModel(
        timeH: timeH,
        timeM: timeM,
        subject: session.subjectName,
        className: session.className,
        details: details,
        status: status,
      ),
    );
  }

  return upcomingSchedules;
});