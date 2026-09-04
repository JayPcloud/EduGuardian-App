import 'package:edu_guardian_app/core/constants/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared_features/auth/presentation/controllers/role_provider.dart';
import '../../constants/app_sizes.dart';
import '../../enums/enums.dart';

class MainNavigationShell extends ConsumerWidget {
  final Widget child;
  final int currentIndex;
  final Function(int) onTabChanged;

  const MainNavigationShell({
    super.key,
    required this.child,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isTeacher = ref.read(roleProvider)==UserRole.teacher;
    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).padding.bottom + Sizes.paddingS,
          top: Sizes.paddingS,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(Sizes.radiusXL)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _buildNavItem(0, [AppAssets.homeNav, AppAssets.homeGreyNav], 'Home', theme),
            _buildNavItem(1, [AppAssets.academicNav, AppAssets.academicGreyNav], isTeacher?'Classes':'Academic', theme),
            _buildNavItem(2, [AppAssets.attendanceNav, AppAssets.attendanceGreyNav], 'Attendance', theme),
            _buildNavItem(3, [AppAssets.chatNav, AppAssets.chatGreyNav], 'Message', theme),
            _buildNavItem(4, [AppAssets.moreNav, AppAssets.moreGreyNav], isTeacher?'Profile':'More', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, List<String> assets, String label, ThemeData theme) {
    final isSelected = currentIndex == index;
    final color = isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.outlineVariant;

    // Wrap the entire item in Expanded so they share the row space dynamically
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabChanged(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              isSelected?assets[0]:assets[1],
              height: isSelected ? 26 : 24,
            ),
            // Icon(
            //   icon,
            //   color: color,
            //   size: isSelected ? 26 : 24,
            // ),
            const SizedBox(height: Sizes.spaceXS),
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                fontSize: 10,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // This keeps text safe if it gets too tight!
              textAlign: TextAlign.center,     // Keep the label centered
            ),
          ],
        ),
      ),
    );
  }
}