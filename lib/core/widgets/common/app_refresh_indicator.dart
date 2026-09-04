import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../parents_features/dashboard/presentation/controllers/student_providers.dart';

class AppRefreshIndicator extends ConsumerWidget {
  const AppRefreshIndicator(
      {super.key, required this.onRefresh, required this.child});
  final VoidCallback onRefresh;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return RefreshIndicator(
      color: theme.colorScheme.primary,
      backgroundColor: theme.cardColor,
      strokeWidth: 3.0,
      displacement: 60.0,
      onRefresh: () async {
        if (ref.read(myWardsProvider).hasError) {
          ref.invalidate(myWardsProvider);
        }
        onRefresh();
        return await Future.delayed(Duration(milliseconds: 500));
      },
      child: child,
    );
  }
}
