import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/constants/app_sizes.dart';

class ClassDetailsShimmer extends StatelessWidget {
  const ClassDetailsShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[850]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 140, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusXL))),
            const SizedBox(height: Sizes.spaceXL),
            Row(children: List.generate(4, (index) => Container(margin: const EdgeInsets.only(right: Sizes.spaceS), height: 40, width: 80, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL))))),
            const SizedBox(height: Sizes.spaceXL),
            Container(height: 200, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(Sizes.radiusL))),
          ],
        ),
      ),
    );
  }
}