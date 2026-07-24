import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/router/app_routes.dart';
import '../widgets/messaging_components.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Message', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            Text('8 new messages', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.spaceM),
            child: Row(
              children: [
                _buildFilterChip('All', theme),
                const SizedBox(width: Sizes.spaceS),
                _buildFilterChip('Teachers', theme),
                const SizedBox(width: Sizes.spaceS),
                _buildFilterChip('Admin', theme),
              ],
            ),
          ),
          
          // Messages List
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
              children: [
                ChatListItem(
                  image: 'assets/images/Ellipse 2752 (1).png',
                  name: 'Mrs. Akunne (Ebele\'s Te..',
                  preview: 'Thank you for the update on her',
                  time: '10:24',
                  unreadCount: 2,
                  onTap: ()=> context.push(AppRoutes.chatDetail)
                ),
                ChatListItem(
                  image: 'assets/images/Ellipse 2752 (2).png',
                  name: 'Mr Segun (Chinedu\'s Te..',
                  preview: 'Thank you for the update on her',
                  time: '10:24',
                  unreadCount: 2,
                  onTap: ()=> context.push(AppRoutes.chatDetail),
                ),
                ChatListItem(
                  image: 'assets/images/Ellipse 2752.png',
                  name: 'Mrs. Obi (Ifeanyi\'s Te..',
                  preview: 'Thank you for the update on her',
                  time: '10:24',
                  unreadCount: 2,
                  onTap: ()=> context.push(AppRoutes.chatDetail),
                ),
                ChatListItem(
                  image: 'assets/images/Ellipse 2752 (3).png',
                  name: 'Admin',
                  preview: 'Thank you for the update on her',
                  time: '10:24',
                  unreadCount: 2,
                  onTap:()=> context.push(AppRoutes.chatDetail)
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingXL, vertical: Sizes.paddingS),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline,
          borderRadius: BorderRadius.circular(Sizes.radiusCircular),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}