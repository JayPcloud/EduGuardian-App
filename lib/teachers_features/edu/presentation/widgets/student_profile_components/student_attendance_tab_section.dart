// ==========================================
// TAB 2: ATTENDANCE SECTION
// ==========================================
import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/buttons/primary_button.dart';
import '../../../../../core/widgets/containers/attendance_calendar_grid.dart';

class StudentAttendanceTabSection extends StatelessWidget {
  const StudentAttendanceTabSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Active Term Summary
        Container(
  padding: const EdgeInsets.all(Sizes.paddingL),
  decoration: BoxDecoration(
    color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.2),
    borderRadius: BorderRadius.circular(Sizes.radiusXL),
    border: Border.all(color: theme.colorScheme.outline), // Softened the border slightly to match
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // 1. Active Term Pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFF00BFA5).withValues(alpha: 0.1), // Soft tint background
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
          ),
          child: Text(
            'Active Term',
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF00BFA5),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: Sizes.spaceM),
        
        // 2. Tightly packed row with a vertical divider
        Row(
          children: [
            Text(
              'JSS2 -Attendace',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant),
            ),
            const SizedBox(width: 8),
            
            // Vertical Divider
            Container(
              height: 14,
              width: 1.5,
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.4),
            ),
            
            const SizedBox(width: 8),
            Text(
              'Rate:',
              style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant),
            ),
            Text(
              '96%',
              style: theme.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF00BFA5),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceL),
        
        // Stats Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildTermStat('PRESENT', '60', const Color(0xFF4CAF50), theme),
            _buildTermStat('LATE', '2', const Color(0xFFFFB300), theme),
            _buildTermStat('ABSENT', '8', const Color(0xFFF44336), theme),
            _buildTermStat('EXCUSED', '1', const Color(0xFF2196F3), theme),
          ],
            )
          ],
        ),
      ),
        const SizedBox(height: Sizes.spaceXL),

        // Today's Attendance
        Text('Today\'s Attendance', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: Sizes.spaceM),
        Container(
          padding: const EdgeInsets.all(Sizes.paddingL),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
            border: Border.all(color: theme.colorScheme.outline),
            boxShadow: AppDecorations.defaultShadow,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=9'),
                  ),
                  const SizedBox(width: Sizes.spaceM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ifeoma Eze', maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                        Text('EDU/JSS3A/001', maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                      ],
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  // TRULY responsive: scales the row of circles down if they run out of space
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      children: [
                        _buildStatusCircle('P', const Color(0xFF00BFA5), true),
                        const SizedBox(width: 6),
                        _buildStatusCircle('A', const Color(0xFFF44336), false),
                        const SizedBox(width: 6),
                        _buildStatusCircle('L', const Color(0xFFFFC107), false),
                        const SizedBox(width: 6),
                        _buildStatusCircle('E', const Color(0xFF2196F3), false),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: Sizes.spaceL),
              PrimaryButton(
                label: 'Save',
                onPressed: () {},
              ),
            ],
          ),
          ),
        const SizedBox(height: Sizes.spaceXL),

        // Attendance Calendar
        Text('Attendance Calendar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: Sizes.spaceM),
        const AttendanceCalendarGrid(), 
        const SizedBox(height: Sizes.spaceL),
      ],
    );
  }

  Widget _buildTermStat(String label, String value, Color color, ThemeData theme) {
    return Column(
      children: [
        Text(label, style: theme.textTheme.labelSmall?.copyWith(fontSize: 10, color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildStatusCircle(String letter, Color activeColor, bool isActive) {
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: isActive ? activeColor : const Color(0xFFEEEEEE),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF9E9E9E),
            fontSize: 10,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}