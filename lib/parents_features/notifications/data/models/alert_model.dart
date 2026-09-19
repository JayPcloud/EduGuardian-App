class AnnouncementModel {
  final String id;
  final String title;
  final String category;
  final String urgencyLevel;
  final String body;
  final DateTime scheduledDate;
  final bool isRead;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.category,
    required this.urgencyLevel,
    required this.body,
    required this.scheduledDate,
    required this.isRead,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? 'New Announcement',
      category: json['category'] ?? '',
      urgencyLevel: json['urgency_level'] ?? 'normal',
      // 🚨 Mapped message_content to your existing body variable
      body: json['message_content'] ?? '', 
      // 🚨 Replaced createdAt with scheduled_date as requested
      scheduledDate: DateTime.tryParse(json['scheduled_date'] ?? '') ?? DateTime.now(),
      isRead: json['is_read'] ?? false, 
    );
  }

  // Helper for optimistic UI updates
  AnnouncementModel copyWith({bool? isRead}) {
    return AnnouncementModel(
      id: id,
      title: title,
      category: category,
      urgencyLevel: urgencyLevel,
      body: body,
      scheduledDate: scheduledDate,
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