import 'package:flutter/material.dart';
import '../../../../core/constants/app_sizes.dart';

class MoreMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const MoreMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingL),
        child: Row(
          children: [
            CircleAvatar(
              minRadius: 20,
              backgroundColor: theme.colorScheme.outline.withValues(alpha: 0.5),
              child: Icon(icon, size: 20, color: theme.colorScheme.onSurface)),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Text(
                title, 
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 13, color: theme.colorScheme.outlineVariant),
          ],
        ),
      ),
    );
  }
}