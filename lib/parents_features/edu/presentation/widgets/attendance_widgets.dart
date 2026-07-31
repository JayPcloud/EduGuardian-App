import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import 'hero_banner.dart';

class AttendanceRateBanner extends StatelessWidget {
  const AttendanceRateBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return HeroBanner(
      content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TERM ATTENDANCE RATE',
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.8),
                        fontWeight: FontWeight.w600,)),
                const SizedBox(height: Sizes.spaceS),
                Row(
                  children: [
                    Text('90%',
                        style: theme.textTheme.headlineLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 32)),
                    const SizedBox(width: Sizes.spaceM),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Sizes.paddingS, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.yellowAccent, // Hardcoded Gold/Yellow accent
                        borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up, size: 14, color: Colors.black),
                          const SizedBox(width: 2),
                          Text('+8',
                              style: theme.textTheme.labelSmall?.copyWith(
                                  color: Colors.black, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: Sizes.spaceM),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                  child: LinearProgressIndicator(
                    value: 0.90,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    color:  AppColors.yellowAccent,
                    borderRadius: BorderRadius.circular(Sizes.radiusM),
                    minHeight: 6,
                  ),
                )
              ],
            ),
    );
  }
}

class AttendanceStatPillsRow extends StatelessWidget {
  const AttendanceStatPillsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildPill(context, 'PRESENT', '60', const Color(0xFF2E7D32))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'LATE', '2', const Color(0xFFF57F17))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'ABSENT', '8', const Color(0xFFC62828))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'EXCUSED', '1', const Color(0xFF6A1B9A))),
      ],
    );
  }

  Widget _buildPill(BuildContext context, String label, String count, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: Sizes.paddingSm),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline),
        borderRadius: BorderRadius.circular(Sizes.radiusL),
      ),
      child: Column(
        children: [
          Text(label,
              style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outlineVariant,
                  fontSize: 9,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(count,
              style: theme.textTheme.titleLarge?.copyWith(
                  color: color, fontWeight: FontWeight.w700, fontSize: 20)),
        ],
      ),
    );
  }
}

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((d) => Text(
              d, 
              style: theme.textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700, 
                color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6) // Faded matching the design
              )
            )).toList(),
          ),
          const SizedBox(height: Sizes.spaceM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              mainAxisExtent: 45, // Fixed height guarantees the text and dot never overflow vertically
            ),
            itemCount: 35, 
            itemBuilder: (context, index) {
              if (index < 4) return const SizedBox.shrink();

              final day = index - 3;
              Color bgColor;
              Color textColor;
              bool hasDot = true;

              if ([6, 7, 13, 14, 20, 21, 27, 28].contains(day)) {
                bgColor = theme.colorScheme.primaryContainer.withValues(alpha: 0.2);
                textColor = theme.colorScheme.outlineVariant;
                hasDot = false;
              } else if (day == 4 || day == 29) {
                bgColor = const Color(0xFFFFF8E1); 
                textColor = const Color(0xFFFF9800); 
              } else {
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
                        fontWeight: FontWeight.w600,
                        color: textColor,
                      ),
                    ),
                    if (hasDot) ...[
                      const SizedBox(height: 2),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: textColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ]
                  ],
                ),
              );
            },
          ),
          
                   
        ],
      ),
    );
  }

  static Widget buildLegendItem(String label, Color color, ThemeData theme) {
    return Flexible(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.outlineVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}