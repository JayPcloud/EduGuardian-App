import 'package:edu_guardian_app/core/widgets/common/app_refresh_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/containers/attendance_calendar_grid.dart';
import '../../../../core/widgets/common/app_error_widget.dart'; // 🚨 The new error widget!
import '../controllers/attendance_providers.dart';
import '../widgets/attendance_widgets.dart';


class ParentsAttendanceScreen extends ConsumerWidget {
  const ParentsAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final attendanceAsync = ref.watch(parentAttendanceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Attendance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: colorScheme.onPrimaryContainer)),
            Text('Term 2 · Week 8', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () => ref.invalidate(parentAttendanceProvider),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(Sizes.paddingL),
          child: attendanceAsync.when(
            skipLoadingOnRefresh: false,
            loading: () => const AttendanceShimmer(),
            error: (err, stack) => AppErrorWidget(
              message: err.toString(),
              onRetry: () => ref.invalidate(parentAttendanceProvider),
            ),
            data: (attendanceData) {
              final summary = attendanceData.summary;
        
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AttendanceRateBanner(percentage: summary.percentage),
                  const SizedBox(height: Sizes.spaceL),
                  
                  AttendanceStatPillsRow(
                    present: summary.totalPresent,
                    late: summary.totalLate,
                    absent: summary.totalAbsent,
                    excused: summary.totalExcused,
                  ),
                  
                  const SizedBox(height: Sizes.spaceXXL),
                  Text('Attendance Calendar', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: Sizes.spaceM),
                  
                  // 🚨 Optional: Pass attendanceData.statusMap down into this grid if it supports parameters!
                  AttendanceCalendarGrid(statusMap: attendanceData.statusMap),           
                  
                  const SizedBox(height: Sizes.spaceXL),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}