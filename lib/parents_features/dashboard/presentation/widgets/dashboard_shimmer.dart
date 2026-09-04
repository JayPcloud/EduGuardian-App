import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/constants/app_sizes.dart';

class DashboardShimmer extends StatelessWidget {
  const DashboardShimmer({super.key});

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
          // Row 1 Stats
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(80)),
              const SizedBox(width: Sizes.spaceM),
              Expanded(child: _buildSkeletonBox(80)),
            ],
          ),
          const SizedBox(height: Sizes.spaceM),
          // Row 2 Stats
          Row(
            children: [
              Expanded(child: _buildSkeletonBox(80)),
              const SizedBox(width: Sizes.spaceM),
              Expanded(child: _buildSkeletonBox(80)),
            ],
          ),
          const SizedBox(height: Sizes.spaceXL),
          
          // Timeline Header
          _buildSkeletonBox(24, width: 150),
          const SizedBox(height: Sizes.spaceM),

          // Timeline Items
          _buildSkeletonTimelineItem(),
          _buildSkeletonTimelineItem(),
          _buildSkeletonTimelineItem(),
        ],
      ),
    );
  }

  Widget _buildSkeletonBox(double height, {double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Sizes.radiusM),
      ),
    );
  }

  Widget _buildSkeletonTimelineItem() {
    return Padding(
      padding: const EdgeInsets.only(bottom: Sizes.spaceM),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSkeletonBox(40, width: 40), // Icon/Dot
          const SizedBox(width: Sizes.spaceM),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSkeletonBox(16, width: 100), // Time
                const SizedBox(height: Sizes.spaceS),
                _buildSkeletonBox(20, width: double.infinity), // Title
                const SizedBox(height: Sizes.spaceXS),
                _buildSkeletonBox(14, width: 150), // Subtitle
              ],
            ),
          ),
        ],
      ),
    );
  }
}