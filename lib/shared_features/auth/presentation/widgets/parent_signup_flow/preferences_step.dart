import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'package:edu_guardian_app/core/widgets/containers/round_rect_border.dart';

class PreferencesStep extends StatelessWidget {
  final bool initialGrades;
  final bool initialBehavior;
  final bool initialAttendance;
  final bool initialAnnouncements;

  final ValueChanged<bool> onGradesChanged;
  final ValueChanged<bool> onBehaviorChanged;
  final ValueChanged<bool> onAttendanceChanged;
  final ValueChanged<bool> onAnnouncementsChanged;

  const PreferencesStep({
    super.key,
    required this.initialGrades,
    required this.initialBehavior,
    required this.initialAttendance,
    required this.initialAnnouncements,
    required this.onGradesChanged,
    required this.onBehaviorChanged,
    required this.onAttendanceChanged,
    required this.onAnnouncementsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text: "What should we ",
              style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.onSurface),
              children: [
                TextSpan(
                  text: "alert\nyou about?",
                  style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceSm),
          Text('You can change this anytime in Settings.', style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: Sizes.spaceL),

          // Switches
          _buildSwitchTile('Grades & reports', 'New scores and term reports', initialGrades, onGradesChanged, textTheme, colorScheme),
          _buildSwitchTile('Behavior alerts', 'Concerning incidents flagged by teachers', initialBehavior, onBehaviorChanged, textTheme, colorScheme),
          _buildSwitchTile('Attendance', 'Absentees, late arrivals and early exits', initialAttendance, onAttendanceChanged, textTheme, colorScheme),
          _buildSwitchTile('School announcements', 'General news from the school.', initialAnnouncements, onAnnouncementsChanged, textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildSwitchTile(String title, String subtitle, bool value, Function(bool) onChanged, TextTheme textTheme, ColorScheme colorScheme) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
      decoration: BoxDecoration(
        border: Border.all(color: colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(subtitle, style: textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colorScheme.onPrimary,
            activeTrackColor: colorScheme.primary,
          )
        ],
      ),
    );
  }
}