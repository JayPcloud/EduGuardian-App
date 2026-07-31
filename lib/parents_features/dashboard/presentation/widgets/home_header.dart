import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_sizes.dart';
import '../../../../../core/theme/app_colors.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../core/router/app_routes.dart';

class HomeHeader extends StatefulWidget {
  const HomeHeader({super.key});

  @override
  State<HomeHeader> createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  // State to track the selected child
  String _selectedChild = 'Ebele Okafor';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('GOOD MORNING', style: textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant, letterSpacing: 1.2)),
              Text(
                'Mrs. Okafor',
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
              onTap: () =>context.push(AppRoutes.alerts),
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
            PopupMenuButton<String>(
              position: PopupMenuPosition.under,
              offset: const Offset(0, 10), // Pushes the menu perfectly below the button
              color: theme.cardColor,
              elevation: 8,
              shadowColor: Colors.black26,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL)),
              onSelected: (value) {
                setState(() => _selectedChild = value);
              },
              itemBuilder: (context) {
                return [
                  _buildChildMenuItem('Ebele Okafor', 'JSS 2 — Diamond', 'EO', const Color(0xFF4A7499), theme),
                  const PopupMenuDivider(height: 1),
                  _buildChildMenuItem('Chinedu Okafor', 'Primary 5 — Gold', 'CO', const Color(0xFFD4A345), theme),
                  const PopupMenuDivider(height: 1),
                  _buildChildMenuItem('Amaka Okafor', 'SSS 2 — Science', 'AO', const Color(0xFFD4A345), theme),
                ];
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
                      child: Text(_selectedChild[0], style: textTheme.labelSmall)
                    ),
                    const SizedBox(width: Sizes.spaceXS),
                    // Displays only the first name
                    Text(_selectedChild.split(' ')[0], style: textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const Icon(Icons.keyboard_arrow_down, size: 16),
                  ],
                ),
              ),
            )
          ],
        )
      ],
    );
  }

  // Helper method to build the custom child list items
  PopupMenuItem<String> _buildChildMenuItem(String name, String details, String initials, Color avatarColor, ThemeData theme) {
    final isSelected = _selectedChild == name;

    return PopupMenuItem<String>(
      value: name,
      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingS),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: avatarColor,
            child: Text(initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
          ),
          const SizedBox(width: Sizes.spaceM),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                name, 
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700, 
                  color: theme.colorScheme.onPrimaryContainer
                )
              ),
              const SizedBox(height: 2),
              Text(
                details, 
                style: theme.textTheme.labelSmall?.copyWith(
                  color: const Color(0xFF6B8DB0) // Matched the bluish-grey text from the design
                )
              ),
            ],
          ),
          const SizedBox(width: Sizes.spaceXL),
          // Checkmark for selected item
          if (isSelected) 
            Icon(Icons.check, color: theme.colorScheme.primary, size: 20)
          else 
            const SizedBox(width: 20), // Placeholder to keep alignment
        ],
      ),
    );
  }
}