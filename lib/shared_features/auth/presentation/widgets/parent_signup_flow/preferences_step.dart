import 'package:edu_guardian_app/core/widgets/containers/round_rect_border.dart';
import 'package:flutter/material.dart';
import '../../../../../core/constants/app_sizes.dart';

class PreferencesStep extends StatefulWidget {
  const PreferencesStep({super.key});

  @override
  State<PreferencesStep> createState() => _PreferencesStepState();
}

class _PreferencesStepState extends State<PreferencesStep> {
  bool grades = true;
  bool behavior = true;
  bool attendance = true;
  bool announcements = true;

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
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
              children: [
                TextSpan(
                  text: "alert\nyou about?",
                  style: textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceSm),
          Text(
            'You can change this anytime in Settings.',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: Sizes.spaceL),

          // Linked Accounts Card
          RoundRectBorder(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.person_outline, size: 16, color: colorScheme.primary),
                    const SizedBox(width: Sizes.spaceXS),
                    Text(
                      'LINKED TO YOUR ACCOUNT',
                      style: textTheme.labelSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Sizes.spaceM),
                _buildLinkedChild('Chinedu Okafor', 'JSS 2B - Greenfield International School', textTheme, colorScheme),
                const SizedBox(height: Sizes.spaceM),
                _buildLinkedChild('Ada Okafor', 'Primary 4 - Greenfield International School', textTheme, colorScheme),
              ],
            ),
          ),
          const SizedBox(height: Sizes.spaceL),

          // Switches
          _buildSwitchTile('Grades & reports', 'New scores and term reports', grades, (val) => setState(() => grades = val), textTheme, colorScheme),
          _buildSwitchTile('Behavior alerts', 'Concerning incidents flagged by teachers', behavior, (val) => setState(() => behavior = val), textTheme, colorScheme),
          _buildSwitchTile('Attendance', 'Absentees, late arrivals and early exits', attendance, (val) => setState(() => attendance = val), textTheme, colorScheme),
          _buildSwitchTile('School announcements', 'General news from the school.', announcements, (val) => setState(() => announcements = val), textTheme, colorScheme),
        ],
      ),
    );
  }

  Widget _buildLinkedChild(String name, String details, TextTheme textTheme, ColorScheme colorScheme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor: colorScheme.surface,
          child: Icon(Icons.school_outlined, size: 16, color: colorScheme.outlineVariant),
        ),
        const SizedBox(width: Sizes.spaceS),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
              Text(details, style: textTheme.bodySmall?.copyWith(color: colorScheme.outlineVariant)),
            ],
          ),
        )
      ],
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