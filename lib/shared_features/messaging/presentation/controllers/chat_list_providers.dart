import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../data/models/chat_list_models.dart';
import '../../data/models/messaging_models.dart';
import '../../data/repositories/messaging_repository.dart';

class UnreadMessagesCountNotifier extends AutoDisposeAsyncNotifier<int> {
  @override
  FutureOr<int> build() async {
    return ref.read(messagingRepoProvider).getUnreadCount();
  }

  void increment(int amount) {
    final currentCount = state.valueOrNull ?? 0;
    state = AsyncData(currentCount + amount);
  }

  // Optimistic update function
  void decrement(int amount) {
    final currentCount = state.valueOrNull ?? 0;
    final newCount = currentCount - amount;
    // Ensure it never drops below 0
    state = AsyncData(newCount > 0 ? newCount : 0);
  }
}


// PAGINATED CONVERSATIONS
class ConversationsNotifier extends AutoDisposeAsyncNotifier<PaginatedConversationsModel> {
  bool _isFetchingMore = false;

  @override
  FutureOr<PaginatedConversationsModel> build() async {
    return ref.read(messagingRepoProvider).getConversations(page: 1);
  }

  bool get isFetchingMore => _isFetchingMore;

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    final currentData = state.valueOrNull;
    if (currentData == null || currentData.currentPage >= currentData.lastPage) return;

    _isFetchingMore = true;
    try {
      final nextData = await ref.read(messagingRepoProvider).getConversations(page: currentData.currentPage + 1);
      state = AsyncData(currentData.copyWith(
        currentPage: nextData.currentPage,
        conversations: [...currentData.conversations, ...nextData.conversations],
      ));
    } finally {
      _isFetchingMore = false;
    }
  }

  void markConversationAsReadLocal(String conversationId) {
    final currentData = state.valueOrNull;
    if (currentData == null) return;

    final updatedConversations = currentData.conversations.map((conv) {
      if (conv.id == conversationId) {
        // Return a fresh instance with unreadCount = 0
        return ConversationModel(
          id: conv.id,
          otherUser: conv.otherUser,
          lastMessage: conv.lastMessage,
          unreadCount: 0, 
        );
      }
      return conv;
    }).toList();

    // Update the state memory using your existing copyWith
    state = AsyncData(currentData.copyWith(
      conversations: updatedConversations,
    ));
  }

  void handleNewBackgroundMessageLocal(String conversationId, ChatMessageModel newMessage) {
    final currentData = state.valueOrNull;
    if (currentData == null) return;

    final updatedConversations = currentData.conversations.map((conv) {
      if (conv.id == conversationId) {
        return ConversationModel(
          id: conv.id,
          otherUser: conv.otherUser,
          // Update the preview text
          lastMessage: MessageSnippetModel(body: newMessage.body, sentAt: newMessage.createdAt),
          // Bump the unread count
          unreadCount: conv.unreadCount + 1, 
        );
      }
      return conv;
    }).toList();

    // 🚨 Move the updated conversation to the TOP of the recent chats list
    final targetIndex = updatedConversations.indexWhere((c) => c.id == conversationId);
    if (targetIndex != -1) {
      final target = updatedConversations.removeAt(targetIndex);
      updatedConversations.insert(0, target);
    }

    state = AsyncData(currentData.copyWith(conversations: updatedConversations));
  }


  void updateLastMessage(String conversationId, ChatMessageModel newMessage) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final conversations = [...currentState.conversations]; 
    final index = conversations.indexWhere((c) => c.id == conversationId);

    if (index != -1) {
      final conv = conversations[index];
      
      // 🚨 Map ONLY the fields your MessageSnippetModel actually requires
      final newSnippet = MessageSnippetModel(
        body: newMessage.body,
        sentAt: newMessage.createdAt, // Or whatever your timestamp field is called
      );
      
      // Copy the conversation with the new snippet
      final updatedConv = conv.copyWith(lastMessage: newSnippet);
      
      // Remove it from its old position and bump it to the top
      conversations.removeAt(index);
      conversations.insert(0, updatedConv);

      state = AsyncData(currentState.copyWith(conversations: conversations));
    }
  }
  

}


// 🚨 Tracks the ID of the chat screen currently visible to the user
final activeChatIdProvider = StateProvider<String?>((ref) => null);

// 1. FILTER STATE
final messagingFilterProvider = StateProvider.autoDispose<String>((ref) => 'All');

// 2. CONTACTS
final messagingContactsProvider = FutureProvider.autoDispose<List<MessageContactModel>>((ref) async {
  return ref.read(messagingRepoProvider).getContacts();
});

// 3. UNREAD COUNT
final unreadMessagesCountProvider = AsyncNotifierProvider.autoDispose<UnreadMessagesCountNotifier, int>(() {
  return UnreadMessagesCountNotifier();
});

final conversationsProvider = AsyncNotifierProvider.autoDispose<ConversationsNotifier, PaginatedConversationsModel>(() => ConversationsNotifier());

// 4. 🚨 THE MERGER: Combines Conversations & Contacts based on Filter
final unifiedChatListProvider = Provider.autoDispose<List<ChatListItemData>>((ref) {
  final filter = ref.watch(messagingFilterProvider);
  final conversationsData = ref.watch(conversationsProvider).valueOrNull;
  final contacts = ref.watch(messagingContactsProvider).valueOrNull ?? [];

  if (conversationsData == null) return [];

  // Map UI filter string to backend role string
  String targetRole = 'all';
  if (filter == 'Parents') targetRole = 'parent';
  if (filter == 'Teachers') targetRole = 'teacher';
  if (filter == 'Admin') targetRole = 'admin';

  // 1. Filter Conversations
  final filteredConversations = conversationsData.conversations.where((conv) {
    if (targetRole == 'all') return true;
    return conv.otherUser.role == targetRole;
  }).toList();

  final List<ChatListItemData> unifiedList = [];
  final Set<String> usersInConversations = {};

  // Add Conversations to list
  for (var conv in filteredConversations) {
    usersInConversations.add(conv.otherUser.id);
    
    String timeStr = '';
    if (conv.lastMessage?.sentAt != null) {
      final localTime = conv.lastMessage!.sentAt!.toLocal();
      timeStr = DateFormat('hh:mm a').format(localTime);
    }

    unifiedList.add(ChatListItemData(
      id: conv.id,
      name: conv.otherUser.name, // The backend handles the "(Ebele's Parent)" formatting
      preview: conv.lastMessage?.body ?? 'No messages yet',
      time: timeStr,
      unreadCount: conv.unreadCount,
      isConversation: true,
      role: conv.otherUser.role
    ));
  }

  // 2. Add remaining Contacts ONLY IF conversations are fully loaded
  // This prevents UI jumping while the user is still paginating through recent chats
  if (conversationsData.currentPage >= conversationsData.lastPage) {
    final filteredContacts = contacts.where((c) {
      if (targetRole != 'all' && c.role != targetRole) return false;
      return !usersInConversations.contains(c.id); // Deduplicate
    }).toList();

    for (var contact in filteredContacts) {
      unifiedList.add(ChatListItemData(
        id: contact.id, // Using contact ID since there is no conversation ID yet
        name: contact.name,
        preview: 'Tap to start messaging',
        time: '',
        unreadCount: 0,
        isConversation: false,
        role: contact.role
      ));
    }
  }

  return unifiedList;
});