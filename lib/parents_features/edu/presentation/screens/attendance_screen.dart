import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/containers/attendance_calendar_grid.dart';
import '../widgets/attendance_widgets.dart';

class ParentsAttendanceScreen extends StatelessWidget {
  const ParentsAttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AttendanceRateBanner(),
            const SizedBox(height: Sizes.spaceL),
            const AttendanceStatPillsRow(),
            const SizedBox(height: Sizes.spaceXXL),
            Text('Attendance Calendar', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: Sizes.spaceM),
            const AttendanceCalendarGrid(),            
            const SizedBox(height: Sizes.spaceXL),
          ],
        ),
      ),
    );
  }
}