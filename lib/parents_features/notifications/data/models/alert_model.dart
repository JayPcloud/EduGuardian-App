class AnnouncementModel {
  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool isRead;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.isRead,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'New Alert',
      body: json['body'] ?? json['message'] ?? json['content'] ?? '', // Guessing common keys
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? json['read'] ?? false, // Boolean flag for "Acknowledged"
    );
  }

  // Helper for optimistic UI updates
  AnnouncementModel copyWith({bool? isRead}) {
    return AnnouncementModel(
      id: id,
      title: title,
      body: body,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class PaginatedAnnouncementModel {
  final int currentPage;
  final int lastPage;
  final List<AnnouncementModel> announcements;

  PaginatedAnnouncementModel({
    required this.currentPage,
    required this.lastPage,
    required this.announcements,
  });

  factory PaginatedAnnouncementModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return PaginatedAnnouncementModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      announcements: dataList.map((a) => AnnouncementModel.fromJson(a)).toList(),
    );
  }

  PaginatedAnnouncementModel copyWith({
    int? currentPage,
    int? lastPage,
    List<AnnouncementModel>? announcements,
  }) {
    return PaginatedAnnouncementModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      announcements: announcements ?? this.announcements,
    );
  }
}