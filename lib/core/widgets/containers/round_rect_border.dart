import 'package:flutter/material.dart';

import '../../constants/app_sizes.dart';

class RoundRectBorder extends StatelessWidget {
  const RoundRectBorder({super.key, required this.child});

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.outline),
              borderRadius: BorderRadius.circular(Sizes.radiusL),
            ),
            child: child,
    );
  }
}

class RoundRectBorderContainer extends StatelessWidget {
  const RoundRectBorderContainer({super.key, required this.child, this.color});
  final Widget child;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Sizes.paddingM),
            decoration: BoxDecoration(
              color: color??Theme.of(context).colorScheme.surface, 
              borderRadius: BorderRadius.circular(Sizes.radiusM),
            ),
            child: child,
    );
  }
}