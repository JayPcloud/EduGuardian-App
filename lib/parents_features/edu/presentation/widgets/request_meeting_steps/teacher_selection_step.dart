import 'package:flutter/material.dart';

import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/containers/selection_tile.dart';


class TeacherSelectionStep extends StatefulWidget {
  const TeacherSelectionStep({super.key});

  @override
  State<TeacherSelectionStep> createState() => _TeacherSelectionStepState();
}

class _TeacherSelectionStepState extends State<TeacherSelectionStep> {
  String _selectedTeacher = 'Mr. Lawal';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.spaceM),
          Text('Which teacher?', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary)),
          const SizedBox(height: Sizes.spaceXS),
          Text('Pick the subject teacher you\'d like to speak with', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
          const SizedBox(height: Sizes.spaceXL),
          
          _buildTeacherTile('Mr. Lawal', 'Mathematics', 'LA', const Color(0xFF1E88E5), 'Tomorrow', theme),
          _buildTeacherTile('Mr. Okeke', 'English Language', 'OK', const Color(0xFFD81B60), 'Fri', theme),
          _buildTeacherTile('Mr. Adeyemi', 'Basic Science', 'AD', const Color(0xFF00ACC1), 'Tomorrow', theme),
          _buildTeacherTile('Mrs. Nwosu', 'Social Studies', 'NW', const Color(0xFF101828), 'Tomorrow', theme),
        ],
      ),
    );
  }

  Widget _buildTeacherTile(String name, String subject, String initials, Color avatarColor, String nextDay, ThemeData theme) {
    final isSelected = _selectedTeacher == name;
    
    return SelectionTile(
      title: name,
      subtitle: subject,
      isSelected: isSelected,
      onTap: () => setState(() => _selectedTeacher = name),
      prefixIcon: CircleAvatar(
        radius: 22,
        backgroundColor: avatarColor,
        child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
      ),
      trailingIcon: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('NEXT', style: theme.textTheme.labelSmall?.copyWith(fontSize: 9, color: theme.colorScheme.outlineVariant, letterSpacing: 0.5)),
              Text(nextDay, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
            ],
          ),
          const SizedBox(width: Sizes.spaceS),
          Icon(
            isSelected ? Icons.check_circle : Icons.circle_outlined,
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.5),
            size: 22,
          ),
        ],
      ),
    );
  }
}