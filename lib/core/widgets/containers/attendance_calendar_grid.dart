import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class AttendanceCalendarGrid extends StatelessWidget {
  const AttendanceCalendarGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final daysOfWeek = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(Icons.arrow_back_ios, size: 16, color: theme.colorScheme.outlineVariant),
              Text('May 2026', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              Icon(Icons.arrow_forward_ios, size: 16, color: theme.colorScheme.outlineVariant),
            ],
          ),
          const SizedBox(height: Sizes.spaceL),
          // Days Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((d) => Text(
              d, 
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700, 
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6)
              )
            )).toList(),
          ),
          const SizedBox(height: Sizes.spaceM),
          // Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 48, // Fixed height guarantees the text and dot never overflow vertically
            ),
            itemCount: 35, 
            itemBuilder: (context, index) {
              if (index < 4) return const SizedBox.shrink();

              final day = index - 3;
              Color bgColor;
              Color textColor;
              bool hasDot = true;

              // Matching the design in the screenshot exactly
              if ([6, 7, 13, 14, 20, 21, 27, 28].contains(day)) {
                // No record / Future
                bgColor = theme.colorScheme.surfaceContainer.withValues(alpha:0.3);
                textColor = theme.colorScheme.outlineVariant;
                hasDot = false;
              } else if (day == 4 || day == 29) {
                // Late (Yellow/Orange)
                bgColor = const Color(0xFFFFF8E1); 
                textColor = const Color(0xFFFFB300); 
              } else {
                // Present (Green)
                bgColor = const Color(0xFFE8F5E9); 
                textColor = const Color(0xFF00BFA5); 
              }

              return Container(
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(Sizes.radiusS),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    if (hasDot) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(color: textColor, shape: BoxShape.circle),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: Sizes.spaceL),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem('Present', const Color(0xFF00BFA5), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Late', const Color(0xFFFFB300), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Absent', const Color(0xFFF44336), theme),
              const SizedBox(width: Sizes.spaceM),
              _buildLegendItem('Excused', const Color(0xFF2196F3), theme),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color, ThemeData theme) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 4),
          Flexible(child: Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant, fontSize: 10))),
        ],
      ),
    );
  }
}