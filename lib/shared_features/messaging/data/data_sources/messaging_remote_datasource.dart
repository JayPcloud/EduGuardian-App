import '../../../../core/api/api_client.dart';

class MessagingRemoteDataSource {
  final ApiClient _client;
  MessagingRemoteDataSource(this._client);

  Future<Map<String, dynamic>> getContacts() async => (await _client.dio.get('messages/contacts')).data;
  
  Future<Map<String, dynamic>> getUnreadCount() async => (await _client.dio.get('messages/unread-count')).data;
  
  Future<Map<String, dynamic>> getConversations({int page = 1}) async => (await _client.dio.get('messages', queryParameters: {'page': page})).data;
  
  Future<Map<String, dynamic>> getChatDetails(String id, {int page = 1}) async {
    return (await _client.dio.get('messages/$id', queryParameters: {'page': page})).data;
  }

  Future<Map<String, dynamic>> sendMessage(String recipientId, String body) async {
    return (await _client.dio.post('messages', data: {"recipient_id": recipientId, "body": body})).data;
  }

  Future<void> markAsRead(String conversationId) async {
    await _client.dio.put('messages/$conversationId/read');
  }

}