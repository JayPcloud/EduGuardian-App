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
    
    // Hardcoded color map to match the exact red & orange alert days in your screenshot
    final alertDays = {
      4:  Colors.pink,  // Solid Red
      5: const Color(0xFFFF9800),  // Solid Orange
      18:  Colors.pink, // Solid Red
      21: const Color(0xFFFF9800), // Solid Orange
      29:  Colors.pink, // Solid Red
      31: const Color(0xFFFF9800), // Solid Orange
    };

    return Container(
      padding: const EdgeInsets.all(Sizes.paddingL),
      decoration: BoxDecoration(
        color: theme.cardColor,
        border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: daysOfWeek.map((d) => Text(d, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.outlineVariant))).toList(),
          ),
          const SizedBox(height: Sizes.spaceM),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              final day = index + 1;
              final alertColor = alertDays[day];
              final isGreenText = !alertDays.containsKey(day);

              return Container(
                decoration: BoxDecoration(
                  color: alertColor ?? const Color(0xFFE8F5E9).withValues(alpha: 0.5), // Soft green default bg
                  borderRadius: BorderRadius.circular(Sizes.radiusS),
                ),
                child: Center(
                  child: Text(
                    '$day',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: alertColor != null ? Colors.white : const Color(0xFF2E7D69), // White text on red/orange, green text otherwise
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}