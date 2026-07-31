import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/more_tile.dart';

class MoreMenuScreen extends StatelessWidget {
  const MoreMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('More', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('View more Menu', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.paddingL),
        child: Container(
          decoration: BoxDecoration(
            color: theme.cardColor,
            border: Border.all(color: theme.colorScheme.outline.withValues(alpha: 0.8)),
            borderRadius: BorderRadius.circular(Sizes.radiusL),
          ),
          child: Column(
            children: [
              MoreMenuTile(
                icon: LucideIcons.thumbsUp, // Behavior icon
                title: 'Behavior',
                onTap: ()=> context.push(AppRoutes.behaviorTimeline),
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
              MoreMenuTile(
                icon: LucideIcons.trendingUp, // Growth icon
                title: 'Growth',
                onTap: ()=> context.push(AppRoutes.growthAndActivity),
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
              MoreMenuTile(
                icon: LucideIcons.medal, // Badge icon
                title: 'Badge',
                onTap: ()=> context.push(AppRoutes.badges),
              ),
              Divider(height: 1, color: theme.colorScheme.outline.withValues(alpha: 0.5)),
              MoreMenuTile(
                icon: LucideIcons.shieldCheck, // Settings icon
                title: 'Settings',
                onTap: ()=> context.push(AppRoutes.settings),
              ),
            ],
          ),
        ),
      ),
    );
  }
}