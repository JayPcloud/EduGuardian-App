import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/enums/enums.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';
import '../../../../core/widgets/common/app_refresh_indicator.dart';
import '../../../auth/presentation/controllers/role_provider.dart';

import '../../data/models/chat_route_model.dart';
import '../controllers/chat_list_providers.dart';
import '../widgets/messaging_components.dart';


class MessagesScreen extends ConsumerStatefulWidget {
  const MessagesScreen({super.key});

  @override
  ConsumerState<MessagesScreen> createState() => _MessagesScreenConsumerState();
}

class _MessagesScreenConsumerState extends ConsumerState<MessagesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(conversationsProvider.notifier).loadMore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTeacher = ref.read(roleProvider) == UserRole.teacher;
    
    // Watch state
    final selectedFilter = ref.watch(messagingFilterProvider);
    final unreadCountAsync = ref.watch(unreadMessagesCountProvider);
    final conversationsAsync = ref.watch(conversationsProvider);
    final unifiedList = ref.watch(unifiedChatListProvider);
    final isFetchingMore = ref.read(conversationsProvider.notifier).isFetchingMore;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Message', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700, color: theme.colorScheme.onPrimaryContainer)),
            // 🚨 Dynamic Unread Count
            Text(
              unreadCountAsync.valueOrNull != null && unreadCountAsync.value! > 0 
                  ? '${unreadCountAsync.value} new messages' 
                  : 'No new messages', 
              style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outlineVariant)
            ),
          ],
        ),
      ),
      body: AppRefreshIndicator(
        onRefresh: () {
          ref.invalidate(unreadMessagesCountProvider);
          ref.invalidate(messagingContactsProvider);
          ref.invalidate(conversationsProvider);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Filter Chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.spaceM),
              child: Row(
                children: [
                  _buildFilterChip('All', theme, selectedFilter),
                  const SizedBox(width: Sizes.spaceS),
                  _buildFilterChip(isTeacher ? 'Parents' : 'Teachers', theme, selectedFilter),
                  const SizedBox(width: Sizes.spaceS),
                  _buildFilterChip('Admin', theme, selectedFilter),
                ],
              ),
            ),
            
            // Messages List
            Expanded(
              child: conversationsAsync.when(
                skipLoadingOnRefresh: false,
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                  child: ChatListShimmer(),
                ),
                error: (err, stack) => AppErrorWidget(
                  message: err.toString(),
                  onRetry: () => ref.invalidate(conversationsProvider),
                ),
                data: (_) {
                  if (unifiedList.isEmpty) {
                    return const Center(child: Text("No conversations or contacts found."));
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL),
                    itemCount: unifiedList.length + (isFetchingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == unifiedList.length) {
                        return const Padding(
                          padding: EdgeInsets.all(Sizes.paddingL), 
                          child: Center(child: CircularProgressIndicator())
                        );
                      }

                      final item = unifiedList[index];
                      return ChatListItem(
                        image: 'https://i.pravatar.cc/150?u=${item.id}', // Placeholder based on ID
                        name: item.name,
                        preview: item.preview,
                        time: item.time,
                        unreadCount: item.unreadCount,
                        onTap: () {
                          context.push(AppRoutes.chatDetail, extra: {
                            'id': item.id,
                            'recipientName': item.name,
                            'recipientRole': item.role,
                            'unreadCount': item.unreadCount,
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, ThemeData theme, String selectedFilter) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => ref.read(messagingFilterProvider.notifier).state = label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingXL, vertical: Sizes.paddingS),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withValues(alpha: 0.8),
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