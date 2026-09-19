import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';
import '../../../../core/exceptions/error_handler.dart';
import '../data_sources/messaging_remote_datasource.dart';
import '../models/chat_list_models.dart';
import '../models/messaging_models.dart';


class MessagingRepository {

  final MessagingRemoteDataSource remote;
  MessagingRepository({required this.remote});

  Future<List<MessageContactModel>> getContacts() async {
    try {
      final res = await remote.getContacts();
      final data = res['data'] as List? ?? [];
      return data.map((e) => MessageContactModel.fromJson(e)).toList();
    } catch (e) { throw ErrorHandler.parse(e).message; }
  }

  Future<int> getUnreadCount() async {
    try {
      final res = await remote.getUnreadCount();
      return res['data']?['unread_count'] ?? 0;
    } catch (e) { return 0; } // Fail silently for badges
  }

  Future<PaginatedConversationsModel> getConversations({int page = 1}) async {
    try {
      final res = await remote.getConversations(page: page);
      return PaginatedConversationsModel.fromJson(res['data'] ?? {});
    } catch (e) { throw ErrorHandler.parse(e).message; }
  }

 Future<ChatDetailDataModel> getChatDetails(String id, {int page = 1}) async {
    try {
      final res = await remote.getChatDetails(id, page: page);
      return ChatDetailDataModel.fromJson(res['data'] ?? {});
    } on DioException catch (e) {
      // 🚨 Intercept the 403/404 here, before the ErrorHandler converts it!
      if (e.response?.statusCode == 403 || e.response?.statusCode == 404) {
        return ChatDetailDataModel(conversation: null, currentPage: 1, lastPage: 1, messages: []);
      }
      throw ErrorHandler.parse(e).message;
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<ChatMessageModel> sendMessage(String recipientId, String body) async {
    try {
      final res = await remote.sendMessage(recipientId, body);
      return ChatMessageModel.fromJson(res['data']?['message'] ?? {});
    } catch (e) { throw ErrorHandler.parse(e).message; }
  }

  Future<void> markAsRead(String conversationId) async {
    try { await remote.markAsRead(conversationId); } catch (e) { /* Fail silently */ }
  }

}

final messagingRepoProvider = Provider((ref) => MessagingRepository(remote: MessagingRemoteDataSource(ref.watch(apiClientProvider))));