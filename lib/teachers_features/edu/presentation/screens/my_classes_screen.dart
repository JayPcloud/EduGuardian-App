import 'package:edu_guardian_app/core/constants/spacing_style.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';

class MyClassesScreen extends StatelessWidget {
  const MyClassesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        toolbarHeight: 80, // Gives room for the two lines of text
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Classes', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.onPrimaryContainer)),
            Text('5 Classes · 140 Students', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Search classes or subjects',
                hintStyle: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer),
                prefixIcon: Icon(LucideIcons.search, size: 18, color: theme.colorScheme.onPrimaryContainer),
              ),
            ),
          ),
          const SizedBox(height: Sizes.spaceL),

          // Classes List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
              itemCount: 4,
              itemBuilder: (context, index) {
                return _buildClassCard(theme);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(ThemeData theme) {
    return InkWell(
      borderRadius: AppSpacingStyle.allBorderRdL,
      // onTap: (){},
      child: Container(
        margin: const EdgeInsets.only(bottom: Sizes.spaceM),
        padding: const EdgeInsets.all(Sizes.paddingL),
        decoration: BoxDecoration(
          color: theme.cardColor,
          border: Border.all(color: theme.colorScheme.outline),
          borderRadius: BorderRadius.circular(Sizes.radiusXL),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: const Color(0xFFE3F2FD), // Light blue
              child: Text(
                'JS',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF004D99), // Deep blue
                ),
              ),
            ),
            const SizedBox(width: Sizes.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('JSS 3A', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
                      Icon(Icons.arrow_forward_ios, size: 14, color: theme.colorScheme.outlineVariant),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('Mathematics', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.outlineVariant)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(LucideIcons.users, size: 14, color: theme.colorScheme.outlineVariant),
                      const SizedBox(width: 4),
                      Text('32 students   Room 202', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Next: Today 10:30',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF004D99), // Deep blue
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}