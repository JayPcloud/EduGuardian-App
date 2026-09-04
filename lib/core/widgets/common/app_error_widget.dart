import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../parents_features/dashboard/presentation/controllers/student_providers.dart';
import '../../constants/app_sizes.dart';

class AppErrorWidget extends ConsumerWidget {
  final String message;
  final VoidCallback onRetry;
  final bool onlyErrorMessage;

  const AppErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.onlyErrorMessage = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!onlyErrorMessage)
              Container(
                padding: const EdgeInsets.all(Sizes.paddingM),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  LucideIcons.alertTriangle,
                  size: 32,
                  color: colorScheme.error,
                ),
              ),
            const SizedBox(height: Sizes.spaceM),
            if (!onlyErrorMessage)
              Text(
                'Oops! Something went wrong.',
                textAlign: TextAlign.center,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
            const SizedBox(height: Sizes.spaceS),
            Text(
              message,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            const SizedBox(height: Sizes.spaceL),
            TextButton.icon(
              onPressed: () {
                if (ref.read(myWardsProvider).hasError) {
                  ref.invalidate(myWardsProvider);
                }
                onRetry();
              },
              icon: Icon(LucideIcons.refreshCcw,
                  size: 16, color: colorScheme.primary),
              label: Text(
                'Try Again',
                style: textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: Sizes.paddingL,
                  vertical: Sizes.paddingS,
                ),
                backgroundColor:
                    colorScheme.primaryContainer.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Sizes.radiusL),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
