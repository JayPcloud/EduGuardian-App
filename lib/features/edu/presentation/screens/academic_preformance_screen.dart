import 'package:edu_guardian_app/core/widgets/buttons/primary_button.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class AcademicPerformanceScreen extends StatelessWidget {
  const AcademicPerformanceScreen({super.key});

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
            Text('Academic Performance', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer)),
            Text('Term 2 · Week 8', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdowns
            FittedBox(
              child: Row(
                children: [
                  _buildDropdown('Class', theme),
                  const SizedBox(width: Sizes.spaceS),
                  _buildDropdown('Term', theme),
                  const SizedBox(width: Sizes.spaceS),
                  _buildDropdown('Subject', theme),
                ],
              ),
            ),
            const SizedBox(height: Sizes.spaceXL),
            Text('Subjects', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: Sizes.spaceM),

            // Subject List
            _buildSubjectCard('Mathematics', 68, 8, colorScheme.onPrimaryContainer, theme),
            _buildSubjectCard('Basic Science', 68, 8, Colors.cyan, theme), // Teal/Cyan
            _buildSubjectCard('English Language', 68, 8, colorScheme.onPrimaryContainer, theme),
            _buildSubjectCard('Civil Education', 68, 8, Colors.deepPurpleAccent, theme), 
            _buildSubjectCard('Civil Education', 68, 8, Colors.deepPurpleAccent, theme), 
            _buildSubjectCard('Civil Education', 68, 8, Colors.purpleAccent, theme), 
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        // USE YOUR CUSTOM PrimaryButton HERE
        child: PrimaryButton(label: 'Request a meeting with teacher', onPressed: (){},)
      ),
    );
  }

  Widget _buildDropdown(String label, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingSm, vertical: Sizes.paddingXS),
      decoration: BoxDecoration(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(Sizes.radiusCircular)),
      child: Row(
        children: [
          Text(label, style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
          const SizedBox(width: Sizes.spaceXS),
          Icon(Icons.keyboard_arrow_down, size: 16, color: theme.colorScheme.primary),
        ],
      ),
    );
  }

  Widget _buildSubjectCard(String title, int score, int trend, Color barColor, ThemeData theme) {
    return Container(
      margin: const EdgeInsets.only(bottom: Sizes.spaceM),
      padding: const EdgeInsets.all(Sizes.paddingM),
      decoration: BoxDecoration(border: Border.all(color: theme.colorScheme.outline), borderRadius: BorderRadius.circular(Sizes.radiusL)),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: barColor, radius: 20, child: Text('E', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(child: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600))),
                    Text(score.toString(), style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                  ],
                ),
                const SizedBox(height: Sizes.spaceS),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                        child: LinearProgressIndicator(value: score / 100, backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5), color: barColor, minHeight: 6,borderRadius: BorderRadius.circular(Sizes.radiusS),),
                      ),
                    ),
                    const SizedBox(width: Sizes.spaceM),
                    Row(
                      children: [
                        Icon(Icons.trending_up, size: 14, color: theme.colorScheme.outlineVariant),
                        const SizedBox(width: 2),
                        Text('+$trend', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontWeight: FontWeight.w600)),
                      ],
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}