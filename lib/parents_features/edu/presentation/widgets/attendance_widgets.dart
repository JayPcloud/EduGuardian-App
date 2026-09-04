import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/theme/app_colors.dart';
import 'hero_banner.dart';

class AttendanceRateBanner extends StatelessWidget {
  final int percentage;
  
  const AttendanceRateBanner({super.key, required this.percentage});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return HeroBanner(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('TERM ATTENDANCE RATE',
              style: theme.textTheme.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: Sizes.spaceS),
          Row(
            children: [
              Text('$percentage%',
                  style: theme.textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 32)),
              const SizedBox(width: Sizes.spaceM),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: Sizes.paddingS, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.yellowAccent, 
                  borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, size: 14, color: Colors.black),
                    const SizedBox(width: 2),
                    Text('+0', // 🚨 Leaving trend hardcoded to 0 since API doesn't provide it yet
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
              value: percentage / 100, // 🚨 Dynamic Value
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
  final int present;
  final int late;
  final int absent;
  final int excused;

  const AttendanceStatPillsRow({
    super.key, 
    required this.present, 
    required this.late, 
    required this.absent, 
    required this.excused
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildPill(context, 'PRESENT', present.toString(), const Color(0xFF2E7D32))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'LATE', late.toString(), const Color(0xFFF57F17))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'ABSENT', absent.toString(), const Color(0xFFC62828))),
        const SizedBox(width: Sizes.spaceS),
        Expanded(child: _buildPill(context, 'EXCUSED', excused.toString(), const Color(0xFF6A1B9A))),
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



class AttendanceShimmer extends StatelessWidget {
  const AttendanceShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Banner Skeleton
          Container(
            height: 140,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL)),
          ),
          const SizedBox(height: Sizes.spaceL),
          // Pills Skeleton
          Row(
            children: List.generate(4, (index) => Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < 3 ? Sizes.spaceS : 0),
                height: 60,
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL)),
              ),
            )),
          ),
          const SizedBox(height: Sizes.spaceXXL),
          // Title Skeleton
          Container(height: 24, width: 150, color: Colors.white),
          const SizedBox(height: Sizes.spaceM),
          // Calendar Grid Skeleton
          Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL)),
          ),
        ],
      ),
    );
  }
}

