import 'chat_list_models.dart';

class ChatMessageModel {
  final String id;
  final String body;
  final String senderId;
  final String senderName;
  final bool isMine;
  final DateTime? createdAt;
  final DateTime? readAt; // 🚨 Added
  final bool hasReceived;

  ChatMessageModel({
    required this.id, required this.body, 
    required this.senderId, required this.senderName, 
    required this.isMine, this.createdAt,
    this.readAt,
    this.hasReceived = false,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id']?.toString() ?? '',
      body: json['body'] ?? '',
      senderId: json['sender_id']?.toString() ?? '',
      senderName: json['sender_name'] ?? 'Unknown',
      isMine: json['is_mine'] ?? false,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
      readAt: json['read_at'] != null ? DateTime.tryParse(json['read_at']) : null,
      hasReceived: json['has_received'] ?? false,
    );
  }
}

class ChatDetailDataModel {
  final ConversationModel? conversation; 
  final int currentPage;
  final int lastPage;
  final List<ChatMessageModel> messages;

  ChatDetailDataModel({
    this.conversation, required this.currentPage, required this.lastPage, required this.messages,
  });

  factory ChatDetailDataModel.fromJson(Map<String, dynamic> json) {
    final msgData = json['messages'] ?? {};
    final dataList = msgData['data'] as List? ?? [];
    
    return ChatDetailDataModel(
      conversation: json['conversation'] != null ? ConversationModel.fromJson(json['conversation']) : null,
      currentPage: msgData['current_page'] ?? 1,
      lastPage: msgData['last_page'] ?? 1,
      // Reversing the list assuming the API returns oldest-first on a page, 
      // so the newest message is at index 0 for our reversed ListView.
      messages: dataList.map((x) => ChatMessageModel.fromJson(x)).toList(), 
    );
  }

  ChatDetailDataModel copyWith({
    ConversationModel? conversation, int? currentPage, int? lastPage, List<ChatMessageModel>? messages,
  }) {
    return ChatDetailDataModel(
      conversation: conversation ?? this.conversation,
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      messages: messages ?? this.messages,
    );
  }
}