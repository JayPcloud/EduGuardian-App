import 'package:flutter/material.dart';
import '../../constants/app_sizes.dart';

class MainNavigationShell extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            _buildNavItem(0, Icons.home_filled, 'Home', theme),
            _buildNavItem(1, Icons.menu_book_rounded, 'Academic', theme),
            _buildNavItem(2, Icons.cases_rounded, 'Attendance', theme),
            _buildNavItem(3, Icons.workspace_premium_rounded, 'Badges', theme),
            _buildNavItem(4, Icons.grid_view_rounded, 'Settings', theme),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, ThemeData theme) {
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
            Icon(
              icon,
              color: color,
              size: isSelected ? 26 : 24,
            ),
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