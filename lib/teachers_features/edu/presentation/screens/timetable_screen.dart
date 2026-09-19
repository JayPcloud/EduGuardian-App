import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../controllers/teacher_timetable_providers.dart';
import '../widgets/academic_components.dart';


class WeekDayInfo {
  final String label; 
  final String dateStr; 
  final String fullKey; 

  WeekDayInfo({required this.label, required this.dateStr, required this.fullKey});
}

class TeachersTimetableScreen extends ConsumerStatefulWidget {
  const TeachersTimetableScreen({super.key});

  @override
  ConsumerState<TeachersTimetableScreen> createState() => _TeachersTimetableScreenState();
}

class _TeachersTimetableScreenState extends ConsumerState<TeachersTimetableScreen> {
  late List<WeekDayInfo> _currentWeekDates;
  final ScrollController _dateScrollController = ScrollController(); 
  static const double _chipWidth = 72.0; // Approximate width + margin per chip

  @override
  void initState() {
    super.initState();
    _calculateCurrentWeek();

    // Auto-scroll to selected day after layout renders
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentDay();
    });
  }

  @override
  void dispose() {
    _dateScrollController.dispose(); // Added
    super.dispose();
  }

  void _calculateCurrentWeek() {
    final now = DateTime.now();
    // Calculate the most recent Monday
    final monday = now.subtract(Duration(days: now.weekday - 1));
    
    _currentWeekDates = [
      WeekDayInfo(label: 'Mon', dateStr: DateFormat('dd').format(monday), fullKey: 'monday'),
      WeekDayInfo(label: 'Tue', dateStr: DateFormat('dd').format(monday.add(const Duration(days: 1))), fullKey: 'tuesday'),
      WeekDayInfo(label: 'Wed', dateStr: DateFormat('dd').format(monday.add(const Duration(days: 2))), fullKey: 'wednesday'),
      WeekDayInfo(label: 'Thu', dateStr: DateFormat('dd').format(monday.add(const Duration(days: 3))), fullKey: 'thursday'),
      WeekDayInfo(label: 'Fri', dateStr: DateFormat('dd').format(monday.add(const Duration(days: 4))), fullKey: 'friday'),
    ];
  }

  void _scrollToCurrentDay() {
    final selectedDay = ref.read(selectedTimetableDayProvider);
    final selectedIndex = _currentWeekDates.indexWhere((d) => d.fullKey == selectedDay);

    if (selectedIndex > 0 && _dateScrollController.hasClients) {
      // Offset by index, centering roughly on screen
      final targetOffset = (selectedIndex * _chipWidth).clamp(
        0.0,
        _dateScrollController.position.maxScrollExtent,
      );

      _dateScrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final selectedDay = ref.watch(selectedTimetableDayProvider);
    final timetableAsync = ref.watch(teacherTimetableProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 18, color: colorScheme.onPrimaryContainer),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Timetable',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: colorScheme.onPrimaryContainer,
              ),
            ),
            Text(
              'Term ${timetableAsync.valueOrNull?.session.term} · Active Week',
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.outlineVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.refresh(teacherTimetableProvider.future),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.spaceM),
            
            // Horizontal Date Selector
            SingleChildScrollView(
              controller: _dateScrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
              child: Row(
                children: _currentWeekDates.map((dayInfo) {
                  return DateSelectorChip(
                    day: dayInfo.label,
                    date: dayInfo.dateStr,
                    isSelected: selectedDay == dayInfo.fullKey,
                    onTap: () => ref.read(selectedTimetableDayProvider.notifier).state = dayInfo.fullKey,
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: Sizes.spaceXL),
            
            // Timetable List
            Expanded(
              child: timetableAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                  child: TeacherTimetableShimmer(),
                ),
                error: (err, stack) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(teacherTimetableProvider),
                ),
                data: (data) {
                  // Filter grid to only show periods that are a Break OR have a session on the selected day
                  final daySchedule = data.grid.where((period) {
                    if (period.isBreak) return true;
                    return period.days.getSessionForDay(selectedDay) != null;
                  }).toList();

                  if (daySchedule.isEmpty) {
                    return const Center(child: Text("No classes scheduled for this day."));
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                    itemCount: daySchedule.length,
                    itemBuilder: (context, index) {
                      final period = daySchedule[index];
                      
                      // Safely parse the time string (e.g. "08:00 AM - 08:45 AM")
                      String timeH = '';
                      String timeM = '';
                      try {
                        final startTimeStr = period.time.split(' - ')[0]; // e.g. "08:00 AM"
                        // Remove AM/PM and trim
                        final cleanTime = startTimeStr.replaceAll(RegExp(r'\s*(AM|PM)', caseSensitive: false), '').trim();
                        final timeParts = cleanTime.split(':');
                        timeH = '${timeParts[0]}:';
                        timeM = timeParts[1];
                      } catch (_) {
                        timeH = period.time;
                      }

                      // Render Break
                      if (period.isBreak) {
                        return TimetableCard(
                          timeH: timeH,
                          timeM: timeM,
                          subject: period.periodName, // "School Break"
                          className: '-',
                          duration: period.time, // Show full range for break
                          studentCount: '-',
                        );
                      }

                      // Render Class Session
                      final session = period.days.getSessionForDay(selectedDay)!;
                      return TimetableCard(
                        timeH: timeH,
                        timeM: timeM,
                        subject: session.subjectName,
                        className: session.className,
                        duration: period.time, // Passing the full time range as duration string
                        studentCount: session.room, // Mapping room to studentCount since API doesn't provide count
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TeacherTimetableShimmer extends StatelessWidget {
  const TeacherTimetableShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDark ? Colors.grey[700]! : Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: List.generate(5, (index) => Container(
            margin: const EdgeInsets.only(bottom: Sizes.spaceM),
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Sizes.radiusXL),
            ),
          )),
        ),
      ),
    );
  }
}