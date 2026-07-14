import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../widgets/attendance_widgets.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

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
            const SizedBox(height: Sizes.spaceXL),
            Text('May 2026', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: Sizes.spaceM),
            const AttendanceCalendarGrid(),
            const SizedBox(height: Sizes.spaceXL),
          ],
        ),
      ),
    );
  }
}