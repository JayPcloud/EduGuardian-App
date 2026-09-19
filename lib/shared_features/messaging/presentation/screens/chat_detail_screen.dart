import 'package:edu_guardian_app/core/utility/helper_functions.dart'; // Adjust path
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/widgets/common/app_error_widget.dart';

import '../../../../core/widgets/common/snackbar.dart';
import '../../data/models/chat_route_model.dart';
import '../../data/repositories/messaging_repository.dart';
import '../controllers/chat_detail_providers.dart';
import '../controllers/chat_list_providers.dart';
import '../widgets/messaging_components.dart';

class ChatDetailScreen extends ConsumerStatefulWidget {
  final ChatRouteArgs args;

  const ChatDetailScreen({
    super.key, required this.args,
  });

  @override
  ConsumerState<ChatDetailScreen> createState() => _ChatDetailScreenState();
}

class _ChatDetailScreenState extends ConsumerState<ChatDetailScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isSending = false;
  bool _showScrollToBottomBtn = false;
  late final StateController<String?> _activeChatNotifier;

  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeChatIdProvider.notifier).state = widget.args.id;
      if (widget.args.unreadCount > 0) {
        ref.read(messagingRepoProvider).markAsRead(widget.args.id);
        // Optimistic local state updates
        ref.read(conversationsProvider.notifier).markConversationAsReadLocal(widget.args.id);
        ref.read(unreadMessagesCountProvider.notifier).decrement(widget.args.unreadCount);
      }
    });

    _activeChatNotifier = ref.read(activeChatIdProvider.notifier);

    _scrollController.addListener(() {
      // 🚨 FIX 1: Fetch older messages when reaching the TOP (maxScrollExtent)
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
        ref.read(chatDetailProvider(widget.args).notifier).loadMore();
      }
      // Show the "Scroll down" button when the user scrolls up past 400 pixels
      if (_scrollController.position.pixels > 400) {
        if (!_showScrollToBottomBtn) setState(() => _showScrollToBottomBtn = true);
      } else {
        if (_showScrollToBottomBtn) setState(() => _showScrollToBottomBtn = false);
      }
    });

  }

  void _scrollToBottom({bool animated = false}) {
    if (_scrollController.hasClients) {
      // 🚨 FIX 2: In a reversed list, 0.0 is the BOTTOM of the chat.
      if (animated) {
        _scrollController.animateTo(0.0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        _scrollController.jumpTo(0.0);
      }
    }
  }

  @override
  void dispose() {
    Future.microtask(() => _activeChatNotifier.state = null);
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handleSend(String recipientIdFallback) async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() => _isSending = true);
    try {
      await ref.read(chatDetailProvider(widget.args).notifier).sendMessage(text, recipientIdFallback);
      _messageController.clear();
      // Wait for UI to paint the new bubble, then scroll down
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom(animated: true));
    } catch (e) {
      if (mounted) AppSnackBar.error('Failed to send: $e', context: context);
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final chatAsync = ref.watch(chatDetailProvider(widget.args));
    final isFetchingMore = ref.read(chatDetailProvider(widget.args).notifier).isFetchingMore;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              chatAsync.valueOrNull?.conversation?.otherUser.name ?? widget.args.recipientName, 
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600, color: colorScheme.onPrimaryContainer)
            ),
            Text(
              (chatAsync.valueOrNull?.conversation?.otherUser.role ?? widget.args.recipientRole), 
              style: theme.textTheme.labelSmall?.copyWith(color: colorScheme.outlineVariant)
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                chatAsync.when(
                  skipLoadingOnRefresh: false,
                  loading: () => const ChatDetailShimmer(), // Or your Shimmer
                  error: (err, stack) => AppErrorWidget(
                    message: err.toString(),
                    onRetry: () => ref.invalidate(chatDetailProvider(widget.args)),
                  ),
                  data: (data) {
                    if (data.messages.isEmpty) {
                      return const Center(child: Text("No messages yet. Say hello!", style: TextStyle(color: Colors.grey)));
                    }

                    final initialUnreadCount = widget.args.unreadCount;
                
                    return ListView.builder(
                      controller: _scrollController,
                      reverse: true, // 🚨 Chat standard: flips the list, puts index 0 at the bottom
                      padding: const EdgeInsets.symmetric(horizontal: Sizes.paddingL, vertical: Sizes.paddingM),
                      itemCount: data.messages.length + (isFetchingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        
                        // 1. Pagination Loader goes at the very end of the array (which renders at the TOP of the screen)
                        if (index == data.messages.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: Sizes.paddingL),
                            child: Center(child: CircularProgressIndicator()), // Or your ModernChatLoader
                          );
                        }

                        final message = data.messages[index];
                        
                        // 🚨 2. CRITICAL DATE GROUPING FOR REVERSED LISTS
                        // Because it's reversed, the message physically ABOVE this one on the screen is index + 1
                        final olderMessage = (index + 1 < data.messages.length) ? data.messages[index + 1] : null;
                        
                        // We show the header if there is no older message (absolute top of chat)
                        // OR if the older message happened on a different day.
                        final bool showDateHeader = olderMessage == null || 
                            !HelperFunctions.isSameDay(message.createdAt, olderMessage.createdAt);

                        final bool showUnreadBanner = initialUnreadCount > 0 && index == (initialUnreadCount - 1);

                        String timeStr = '';
                        if (message.createdAt != null) {
                          timeStr = DateFormat('hh:mm a').format(message.createdAt!.toLocal());
                        }

                        return Column(
                          children: [
                            // 3. The Date Header goes FIRST in the column so it renders ABOVE the bubble
                            if (showDateHeader) ...[
                              const SizedBox(height: Sizes.spaceL),
                              Center(
                                child: Row(
                                  spacing: Sizes.spaceSm,
                                  children: [
                                    Expanded(child: Divider(height: 0.1,color:theme.colorScheme.outline)),
                                    Text(
                                      HelperFunctions.getGroupDateHeader(message.createdAt),
                                      style: theme.textTheme.labelSmall?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Expanded(child: Divider(height: 0.5,color: theme.colorScheme.outline,)),
                                  ],
                                ),
                              ),
                              const SizedBox(height: Sizes.spaceM),
                            ],

                            if (showUnreadBanner && !message.isMine) 
                              Center(child: UnreadMessagesBanner(count: initialUnreadCount)),
                            
                            // 4. The actual Chat Bubble
                            Align(
                              alignment: message.isMine ? Alignment.centerRight : Alignment.centerLeft,
                              child: ChatBubble(
                                text: message.body,
                                time: timeStr,
                                isSender: message.isMine,
                                isRead: message.readAt != null, // 🚨 Evaluates if backend returned a read timestamp
                                hasReceived: message.hasReceived, // 🚨 Ready for when backend supports it
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),

                if (_showScrollToBottomBtn)
                  Positioned(
                    bottom: Sizes.spaceM,
                    right: Sizes.paddingM,
                    child: FloatingActionButton.small(
                      heroTag: 'scrollToBottomFAB',
                      backgroundColor: theme.colorScheme.surface,
                      elevation: 4,
                      onPressed: _scrollToBottom,
                      child: Icon(
                        size: Sizes.iconM,
                        Icons.keyboard_double_arrow_down_rounded, 
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Modern Bottom Input Area (Unchanged)
          Container(
            padding: const EdgeInsets.only(left: Sizes.paddingM, right: Sizes.paddingM, top: Sizes.paddingS, bottom: Sizes.paddingL),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              border: Border(top: BorderSide(color: colorScheme.outline.withValues(alpha: 0.2))),
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(bottom: 4.0),
                  //   child: InkWell(
                  //     onTap: () {},
                  //     borderRadius: BorderRadius.circular(50),
                  //     child: CircleAvatar(
                  //       radius: 20,
                  //       backgroundColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                  //       child: Icon(Icons.add, color: colorScheme.onSurfaceVariant),
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(width: Sizes.spaceS),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      maxLines: 4,
                      minLines: 1,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _handleSend(
                        chatAsync.when(data: (data)=>data.conversation?.otherUser.id??widget.args.id, 
                        error: (_,__)=>'', loading:()=> '')
                      ),
                      onChanged: (val){setState(() {});},
                      style: theme.textTheme.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.outlineVariant),
                        filled: true,
                        fillColor: colorScheme.surfaceContainer,
                        contentPadding: const EdgeInsets.symmetric(horizontal: Sizes.paddingM, vertical: Sizes.paddingSm),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL), borderSide: BorderSide(color: colorScheme.outline)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(Sizes.radiusXL), borderSide: BorderSide(color: colorScheme.primary)),
                      ),
                    ),
                  ),
                  const SizedBox(width: Sizes.spaceS),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: InkWell(
                      onTap:()=> _isSending ? null : _handleSend(
                        chatAsync.when(data: (data)=>data.conversation?.otherUser.id??widget.args.id, 
                        error: (_,__)=>'', loading:()=> '')
                      ),
                      borderRadius: BorderRadius.circular(50),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primary.withValues(alpha: _isSending||_messageController.text.isEmpty?0.6:null),
                        child: _isSending 
                          ? const SizedBox(height: 16, width: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Icon(LucideIcons.send, color: Colors.white, size: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}