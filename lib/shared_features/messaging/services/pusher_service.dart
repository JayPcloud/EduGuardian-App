import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pusher_channels_flutter/pusher_channels_flutter.dart';
import '../../../core/api/api_client.dart';
import '../data/models/chat_route_model.dart';
import '../data/models/messaging_models.dart';
import '../data/repositories/messaging_repository.dart';
import '../presentation/controllers/chat_detail_providers.dart';
import '../presentation/controllers/chat_list_providers.dart';


final pusherServiceProvider = Provider<PusherService>((ref) {
  return PusherService(ref);
});

class PusherService {
  final Ref ref;
  PusherChannelsFlutter? _pusher;

  PusherService(this.ref);

  Future<void> initGlobalChannel(String userId) async {
    debugPrint('Pusher init Called for user: $userId');
    
    try {
      debugPrint('//---------------------INITIALIZING PUSHER-----------------------//');
      _pusher = PusherChannelsFlutter.getInstance();
      
      await _pusher!.init(
        apiKey: "862e447b1d8ad26d83cc", 
        cluster: "eu", 
        onAuthorizer: (String channelName, String socketId, dynamic options) async {
          final response = await ref.read(apiClientProvider).post(
            '/api/broadcasting/auth', 
            data: {
              "socket_id": socketId,
              "channel_name": channelName,
            }
          );
          return response.data; 
        },
      );
      
      await _pusher!.connect();

      await _pusher!.subscribe(
        channelName: 'private-user.$userId',
        onEvent: _handleGlobalEvent,
      );
    } catch (e) {
      debugPrint("Pusher init error: $e");
    }
  }

  void _handleGlobalEvent(PusherEvent event) {
  if (event.eventName == 'MessageSent') {
    final payload = jsonDecode(event.data);
    debugPrint(payload.toString());
    final newMessage = ChatMessageModel.fromJson(payload['message'] ?? payload);
    final conversationId = payload['conversation_id']?.toString() ?? '';

    final activeChatId = ref.read(activeChatIdProvider);

    // Create lookup key (recipientName/role do not affect Riverpod lookup due to your == override)
    final chatKey = ChatRouteArgs(
      id: conversationId,
      recipientName: '',
      recipientRole: '',
      unreadCount: 0,
    );

    if (activeChatId == conversationId) {
      // 1. User is on this screen -> Inject message live
      ref.read(chatDetailProvider(chatKey).notifier).injectRealTimeMessage(newMessage);

      ref.read(messagingRepoProvider).markAsRead(conversationId);
      ref.read(conversationsProvider.notifier).updateLastMessage(conversationId, newMessage);
    }else {
      // 2. User is elsewhere -> Update badge and conversation list
      ref.read(unreadMessagesCountProvider.notifier).increment(1);
      ref.read(conversationsProvider.notifier).updateLastMessage(conversationId, newMessage);

      //Check if the chat is already cached in the background
      if (ref.exists(chatDetailProvider(chatKey))) {
        // It has been opened before! Silently inject the message into the existing cache.
        // When they open the chat, it will load instantly with the new message already there.
        ref.read(chatDetailProvider(chatKey).notifier).injectRealTimeMessage(newMessage);
      } 
      // If it doesn't exist, we do nothing. The next time they open it, 
      // the build() method will naturally fetch the fresh data from the API anyway.
    }
  }

}

  void disconnect() {
    _pusher?.disconnect();
  }
}