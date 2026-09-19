import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart'; // 🚨 Ensure this is in pubspec.yaml

import '../../data/models/chat_route_model.dart';
import '../../data/models/messaging_models.dart';
import '../../data/repositories/messaging_repository.dart';
import 'chat_list_providers.dart';

class ChatDetailNotifier extends FamilyAsyncNotifier<ChatDetailDataModel, ChatRouteArgs> {
  bool _isFetchingMore = false;
  PusherChannelsFlutter? _pusher;

  @override
  FutureOr<ChatDetailDataModel> build(ChatRouteArgs arg) async {
    if (arg.id.isEmpty) {
      return ChatDetailDataModel(conversation: null, currentPage: 1, lastPage: 1, messages: []);
    }
    
    final data = await ref.read(messagingRepoProvider).getChatDetails(arg.id, page: 1);
    
    // if (data.conversation != null) {
    //   _initPusher(data.conversation!.id);
    // }
    // data.messages.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));
    
    return data;
  }


  void injectRealTimeMessage(ChatMessageModel newMessage) {
    final currentData = state.valueOrNull;
    if (currentData == null) return;
    
    // Prevent duplicate
    if (currentData.messages.any((m) => m.id == newMessage.id)) return;
    
    // Prepend to bottom of screen
    state = AsyncData(currentData.copyWith(
      messages: [newMessage, ...currentData.messages], 
    ));
  }

  // 🚨 PUSHER IMPLEMENTATION
  void _initPusher(String conversationId) async {
    try {
      _pusher = PusherChannelsFlutter.getInstance();
      await _pusher!.init(
        apiKey: "862e447b1d8ad26d83cc", 
        cluster: "eu", 
      );
      
      await _pusher!.subscribe(
        channelName: 'chat.$conversationId',
        onEvent: (event) {
          if (event.eventName == 'message.sent' || event.eventName == 'NewMessage') {
            final payload = jsonDecode(event.data);
            final newMessage = ChatMessageModel.fromJson(payload['message'] ?? payload);
            
            final currentData = state.valueOrNull;
            if (currentData == null) return;
            
            if (currentData.messages.any((m) => m.id == newMessage.id)) return;
            
            // 🚨 FIX 1: PREPEND the message so it shows up at index 0 (bottom of screen)
            state = AsyncData(currentData.copyWith(
              messages: [newMessage, ...currentData.messages], 
            ));
            
            // 🚨 FIX 2: Check if the user is actually looking at this screen
            final activeChatId = ref.read(activeChatIdProvider);
            
            if (activeChatId == conversationId) {
              // User is looking right at it -> Mark as read
              ref.read(messagingRepoProvider).markAsRead(conversationId);
            } else {
              // User is somewhere else in the app -> Update badges and previews
              ref.read(unreadMessagesCountProvider.notifier).increment(1);
              ref.read(conversationsProvider.notifier).handleNewBackgroundMessageLocal(conversationId, newMessage);
            }
          }
        },
      );
      await _pusher!.connect();
    } catch (e) {
      debugPrint("Pusher initialization error: $e");
    }
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    final currentData = state.valueOrNull;
    if (currentData == null || currentData.currentPage >= currentData.lastPage) return;

    _isFetchingMore = true;
    try {
      final nextData = await ref.read(messagingRepoProvider).getChatDetails(arg.id, page: currentData.currentPage + 1);
      
      // 🚨 FIX: Sort DESCENDING
      // nextData.messages.sort((a, b) => (b.createdAt ?? DateTime.now()).compareTo(a.createdAt ?? DateTime.now()));

      state = AsyncData(currentData.copyWith(
        currentPage: nextData.currentPage,
        // 🚨 Appending to the end of the array pushes them to the TOP of the screen
        messages: [...currentData.messages, ...nextData.messages],
      ));
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<ChatMessageModel?> sendMessage(String body, String recipientIdFallback) async {
    final currentData = state.valueOrNull;
    if (currentData == null || body.trim().isEmpty) return null;
    
    final recipientId = currentData.conversation?.otherUser.id ?? recipientIdFallback;

    try {
      final sentMessage = await ref.read(messagingRepoProvider).sendMessage(recipientId, body);
      
      state = AsyncData(currentData.copyWith(
        // 🚨 Prepending to index 0 puts the new message at the BOTTOM of the screen
        messages: [sentMessage, ...currentData.messages],
      ));

      // 🚨 UPDATE THE GLOBAL CHAT LIST PREVIEW
      if (currentData.conversation != null) {
        // If it's an existing conversation, update it locally for a smooth UI transition
        ref.read(conversationsProvider.notifier).updateLastMessage(
          currentData.conversation!.id, 
          sentMessage,
        );
      } else {
        // If it was a brand new chat (first time messaging this contact), 
        // invalidate the provider so it fetches the newly created conversation ID from the backend.
        ref.invalidate(conversationsProvider);
      }
      return sentMessage;
    } catch (e) {
      throw e.toString();
    }
  }


  void markAsRead() async {
      // 🚨 MARK AS READ MOVED HERE: Runs every time you enter the screen!
      if (arg.unreadCount > 0) {
        // Fire & forget remote API call
        ref.read(messagingRepoProvider).markAsRead(arg.id);
        
        // Optimistic local state updates
        ref.read(conversationsProvider.notifier).markConversationAsReadLocal(arg.id);
        ref.read(unreadMessagesCountProvider.notifier).decrement(arg.unreadCount);
      }
  }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
  
  
  // @override
  // void dispose() {
  //   _pusher?.disconnect();
  //   super.dispose();
  // }
  
  bool get isFetchingMore => _isFetchingMore;
}

final chatDetailProvider = AsyncNotifierProvider.family<ChatDetailNotifier, ChatDetailDataModel, ChatRouteArgs?>(() {
  return ChatDetailNotifier();
});