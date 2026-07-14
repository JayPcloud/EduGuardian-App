import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';

class HeroBanner extends StatelessWidget {
  const HeroBanner({super.key, required this.content});
  final Widget content;
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      clipBehavior: Clip.hardEdge, 
      decoration: BoxDecoration(
        color: colorScheme.primary, 
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.tertiary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Sizes.radiusXL),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -55,
            right: -40,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFFCC00).withValues(alpha: 0.25), 
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Sizes.paddingL),
            child: content
          ),
        ],
      ),
    );
  }
}