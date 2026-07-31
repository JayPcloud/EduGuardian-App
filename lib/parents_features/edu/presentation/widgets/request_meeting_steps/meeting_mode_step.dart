import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/widgets/containers/selection_tile.dart';

class MeetingModeStep extends StatefulWidget {
  const MeetingModeStep({super.key});

  @override
  State<MeetingModeStep> createState() => _MeetingModeStepState();
}

class _MeetingModeStepState extends State<MeetingModeStep> {
  String _selectedMode = 'Video Call';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Sizes.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Sizes.spaceM),
          Text('How would your like to\nmeet?', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.primary, height: 1.2)),
          const SizedBox(height: Sizes.spaceXS),
          Text('Choose what works best for your schedule', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
          const SizedBox(height: Sizes.spaceXL),
          
          _buildModeTile('Video Call', 'Google Meet link', LucideIcons.video, theme),
          _buildModeTile('In-person', 'At office', LucideIcons.users, theme),
          _buildModeTile('Phone call', 'Teacher will call you', LucideIcons.phone, theme),
        ],
      ),
    );
  }

  Widget _buildModeTile(String title, String subtitle, IconData icon, ThemeData theme) {
    final isSelected = _selectedMode == title;
    
    return SelectionTile(
      title: title,
      subtitle: subtitle,
      isSelected: isSelected,
      onTap: () => setState(() => _selectedMode = title),
      prefixIcon: CircleAvatar(
        radius: 22,
        backgroundColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        child: Icon(icon, color: theme.colorScheme.onSurfaceVariant, size: 20),
      ),
      trailingIcon: isSelected 
          ? Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 22)
          : const SizedBox.shrink(),
    );
  }
}