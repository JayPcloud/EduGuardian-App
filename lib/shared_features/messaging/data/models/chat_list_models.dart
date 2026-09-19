class MessageContactModel {
  final String id;
  final String name;
  final String role;

  MessageContactModel({required this.id, required this.name, required this.role});

  factory MessageContactModel.fromJson(Map<String, dynamic> json) {
    return MessageContactModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown',
      role: json['role']?.toString().toLowerCase() ?? 'user',
    );
  }
}

class MessageSnippetModel {
  final String body;
  final DateTime? sentAt;

  MessageSnippetModel({required this.body, this.sentAt});

  factory MessageSnippetModel.fromJson(Map<String, dynamic> json) {
    return MessageSnippetModel(
      body: json['body'] ?? '',
      sentAt: json['sent_at'] != null ? DateTime.tryParse(json['sent_at']) : null,
    );
  }
}

class ConversationModel {
  final String id;
  final MessageContactModel otherUser;
  final MessageSnippetModel? lastMessage;
  final int unreadCount;

  ConversationModel({
    required this.id, required this.otherUser, this.lastMessage, required this.unreadCount,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? '',
      otherUser: MessageContactModel.fromJson(json['other_user'] ?? {}),
      lastMessage: json['last_message'] != null ? MessageSnippetModel.fromJson(json['last_message']) : null,
      unreadCount: json['unread_count'] ?? 0,
    );
  }

  ConversationModel copyWith({
    String? id,
    MessageContactModel? otherUser,
    MessageSnippetModel? lastMessage,
    int? unreadCount,
  }) {
    return ConversationModel(
      id: id ?? this.id,
      otherUser: otherUser ?? this.otherUser,
      lastMessage: lastMessage ?? this.lastMessage,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class PaginatedConversationsModel {
  final int currentPage;
  final int lastPage;
  final List<ConversationModel> conversations;

  PaginatedConversationsModel({required this.currentPage, required this.lastPage, required this.conversations});

  factory PaginatedConversationsModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return PaginatedConversationsModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      conversations: dataList.map((x) => ConversationModel.fromJson(x)).toList(),
    );
  }

  PaginatedConversationsModel copyWith({int? currentPage, int? lastPage, List<ConversationModel>? conversations}) {
    return PaginatedConversationsModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      conversations: conversations ?? this.conversations,
    );
  }
}

// 🚨 UNIFIED UI MODEL: This makes the UI completely dumb and logic-free
class ChatListItemData {
  final String id; // Conversation ID or Contact ID
  final String name;
  final String preview;
  final String time;
  final int unreadCount;
  final bool isConversation;
  final String role;

  ChatListItemData({
    required this.id, required this.name, required this.preview, required this.time, required this.unreadCount, required this.isConversation, required this.role
  });
}