import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../shared_features/auth/presentation/controllers/auth_status_controller.dart';
import '../../data/models/student_model.dart';
import '../controllers/student_providers.dart';

class HomeHeader extends ConsumerWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    // 🚨 Reactive State
    final activeWard = ref.watch(activeWardProvider);
    final wardsAsync = ref.watch(myWardsProvider);
    final currentUser = ref.watch(authStatusNotifierProvider).value;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GOOD MORNING', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant, letterSpacing: 1.2)),
              Text(
                currentUser?.name ?? 'Parent',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700, color: colorScheme.onPrimaryContainer),
              ),
            ],
          ),
        ),
        const SizedBox(width: Sizes.spaceS),
        Row(
          children: [
            InkWell(
              onTap: () => context.push(AppRoutes.alerts),
              customBorder: RoundedRectangleBorder(borderRadius: AppSpacingStyle.allBorderRdMd),
              child: CircleAvatar(
                backgroundColor: colorScheme.surfaceContainerHighest,
                child: Badge(
                  backgroundColor: AppColors.yellowAccent,
                  child: Icon(LucideIcons.bell, size: Sizes.iconM, color: colorScheme.onSurfaceVariant),
                ),
              ),
            ),
            const SizedBox(width: Sizes.spaceS),
            
            // The Dropdown Trigger & Menu
            wardsAsync.when(
              loading: () => Shimmer.fromColors(
                baseColor: theme.brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[300]!,
                highlightColor: theme.brightness == Brightness.dark ? Colors.grey[700]! : Colors.grey[100]!,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                  ),
                ),
              ),
              error: (err, stack) => const Icon(Icons.error, color: Colors.red),
              data: (wards) {
                // if (wards.isEmpty || activeWard == null) return const SizedBox.shrink();

                return PopupMenuButton<WardModel>(
                  position: PopupMenuPosition.under,
                  offset: const Offset(0, 10),
                  color: theme.cardColor,
                  elevation: 8,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
                  onSelected: (selectedWard) {
                    // 🚨 Instantly updates the global active ward
                    ref.read(activeWardProvider.notifier).setWard(selectedWard);
                  },
                  itemBuilder: (context) {
                    return wards.map((ward) {
                      return PopupMenuItem<WardModel>(
                        value: ward,
                        padding: EdgeInsets.zero,
                        child: _buildChildMenuItem(ward, activeWard?.id??'null', const Color(0xFF4A7499), theme),
                      );
                    }).toList();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingS, vertical: Sizes.paddingXS),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      border: Border.all(color: colorScheme.outline),
                      borderRadius: BorderRadius.circular(Sizes.radiusCircular),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 12, 
                          backgroundColor: colorScheme.primaryContainer, 
                          child: Text(activeWard?.initials??'null', style: textTheme.labelSmall)
                        ),
                        const SizedBox(width: Sizes.spaceXS),
                        Text(activeWard?.firstName??'null', style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                        const Icon(Icons.keyboard_arrow_down, size: 16),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        )
      ],
    );
  }

  Widget _buildChildMenuItem(WardModel ward, String activeWardId, Color avatarColor, ThemeData theme) {
    final isSelected = activeWardId == ward.id;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor,
            child: Text(ward.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: Sizes.spaceM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ward.fullName, 
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700, 
                  color: theme.colorScheme.onPrimaryContainer
                )
              ),
              const SizedBox(height: 2),
              Text(
                '${ward.classCategory} — Term ${ward.term}', 
                style: theme.textTheme.labelSmall?.copyWith(color: const Color(0xFF6B8DB0))
              ),
            ],
          ),
          const SizedBox(width: Sizes.spaceXL),
          if (isSelected) 
            Icon(Icons.check, color: theme.colorScheme.primary, size: 20)
          else 
            const SizedBox(width: 20),
        ],
      ),
    );
  }
}