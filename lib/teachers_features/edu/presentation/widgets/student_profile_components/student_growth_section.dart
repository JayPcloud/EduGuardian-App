// ==========================================
// TAB 5: GROWTH SECTION (Functional)
// ==========================================
import 'package:edu_guardian_app/core/constants/app_decorations.dart';
import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'add_activity_dialog.dart';

class StudentGrowthSection extends StatefulWidget {
  const StudentGrowthSection({super.key});

  @override
  State<StudentGrowthSection> createState() => _StudentGrowthSectionState();
}

class _StudentGrowthSectionState extends State<StudentGrowthSection> {
  // Functional State for Radar
  final Map<String, int> _radarScores = {
    'Critical Thinking': 3,
    'Team Work': 4,
    'Emotional IQ': 2,
    'Creativity': 3,
    'Leadership': 3,
  };

  // Functional State for Activities
  final List<ActivityItem> _activities = [
    ActivityItem(
      title: 'Football',
      role: 'Midfielder-Green House',
      tags: ['MVP', 'Inter-House'],
      icon: Icons.sports_soccer,
    ),
    ActivityItem(
      title: 'Football',
      role: 'Midfielder-Green House',
      tags: ['MVP', 'Inter-House'],
      icon: Icons.sports_soccer,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // DEVELOPMENT RADAR
        Container(
          padding: const EdgeInsets.all(Sizes.paddingL),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(Sizes.radiusXL),
            border: Border.all(color: colorScheme.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Development Radar', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const SizedBox(height: 2),
              Text('Rate metrics on a 1.0 - 5.0 scale', style: theme.textTheme.labelMedium?.copyWith(color: colorScheme.outlineVariant)),
              const SizedBox(height: Sizes.spaceXL),
              
              // Map through the metrics
              ..._radarScores.keys.map((metric) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: Sizes.spaceM),
                  child: _buildRadarMetricCard(metric, _radarScores[metric]!, theme),
                );
              }),
            ],
          ),
        ),
        
        const SizedBox(height: Sizes.spaceXL),

        // ACTIVITIES HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Activities', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            FilledButton(
              onPressed: () => _showAddActivityDialog(context),
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF004D99),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
              ),
              child: const Text('Add'),
            ),
          ],
        ),
        const SizedBox(height: Sizes.spaceM),

        // ACTIVITIES LIST
        ..._activities.asMap().entries.map((entry) {
          final index = entry.key;
          final activity = entry.value;
          return Padding(
            padding: const EdgeInsets.only(bottom: Sizes.spaceM),
            child: _buildActivityCard(index, activity, theme),
          );
        }),
        const SizedBox(height: Sizes.spaceXL),
      ],
    );
  }

  Widget _buildRadarMetricCard(String title, int currentScore, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Sizes.radiusL),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700)),
              Text('$currentScore / 5', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: const Color(0xFF004D99))),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),
          Row(
            children: List.generate(5, (index) {
              final score = index + 1;
              final isSelected = score == currentScore;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() => _radarScores[title] = score);
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ?null : theme.colorScheme.surfaceContainer,
                      gradient: isSelected ?AppDecorations.primaryGradient(context) :null,
                      borderRadius: BorderRadius.circular(Sizes.radiusXXL),
                    ),
                    child: Center(
                      child: Text(
                        '$score',
                        style: TextStyle(
                          color: isSelected ? Colors.white : theme.colorScheme.onSurface,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCard(int index, ActivityItem activity, ThemeData theme) {
    // Automatically converts the stored IconData into the correct Emoji
    String emoji = '⭐';
    if (activity.icon == Icons.sports_soccer) emoji = '⚽';
    else if (activity.icon == Icons.menu_book) emoji = '📚';
    else if (activity.icon == Icons.palette) emoji = '🎨';
    else if (activity.icon == Icons.groups) emoji = '👥';

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Emoji without the grey circular background
          Padding(
            padding: const EdgeInsets.only(top: 2.0),
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700)),
                Text(activity.role, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                const SizedBox(height: 8),
                // Calls the new single-container tags widget
                _buildTagsContainer(activity.tags, theme),
              ],
            ),
          ),
          const SizedBox(width: Sizes.spaceS),
          InkWell(
            onTap: () {
              setState(() => _activities.removeAt(index));
            },
            child: Text(
              'Delete',
              style: theme.textTheme.labelMedium?.copyWith(color: const Color(0xFFFF5252), fontWeight: FontWeight.w600),
            ),
          )
        ],
      ),
    );
  }

  // Replaces _buildTag. Puts all tags inside one responsive yellow container.
  Widget _buildTagsContainer(List<String> tags, ThemeData theme) {
    if (tags.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1), // Light yellow tint
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      // Wrap ensures the tags drop to the next line if the screen gets too narrow
      child: Wrap(
        spacing: 12, // Horizontal space between tags
        runSpacing: 6, // Vertical space if they wrap
        children: tags.map((tag) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 4,
                height: 4,
                decoration: const BoxDecoration(color: Color(0xFFFFB300), shape: BoxShape.circle),
              ),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  tag,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF1E4C7A),
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _showAddActivityDialog(BuildContext context) async {
    final newActivity = await showDialog<ActivityItem>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AddActivityDialog(),
    );

    if (newActivity != null) {
      setState(() => _activities.insert(0, newActivity));
    }
  }
}
