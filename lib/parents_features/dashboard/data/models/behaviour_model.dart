class BehaviorTeacherModel {
  final String id;
  final String name;

  BehaviorTeacherModel({required this.id, required this.name});

  factory BehaviorTeacherModel.fromJson(Map<String, dynamic> json) {
    return BehaviorTeacherModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Teacher',
    );
  }
}

class BehaviorModel {
  final String id;
  final String studentId;
  final String type; // e.g., 'discipline', 'merit'
  final String category;
  final DateTime date;
  final String details;
  final BehaviorTeacherModel teacher;

  BehaviorModel({
    required this.id,
    required this.studentId,
    required this.type,
    required this.category,
    required this.date,
    required this.details,
    required this.teacher,
  });

  factory BehaviorModel.fromJson(Map<String, dynamic> json) {
    return BehaviorModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      type: json['type']?.toString().toLowerCase() ?? 'neutral',
      category: json['category'] ?? 'General',
      date: DateTime.tryParse(json['created_at'] ?? json['date'] ?? '') ?? DateTime.now(),
      details: json['details'] ?? 'No details provided.',
      teacher: BehaviorTeacherModel.fromJson(json['teacher'] ?? {}),
    );
  }
}

class PaginatedBehaviorModel {
  final int currentPage;
  final int lastPage;
  final List<BehaviorModel> behaviors;

  PaginatedBehaviorModel({
    required this.currentPage,
    required this.lastPage,
    required this.behaviors,
  });

  factory PaginatedBehaviorModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return PaginatedBehaviorModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      behaviors: dataList.map((b) => BehaviorModel.fromJson(b)).toList(),
    );
  }

  // Helper to easily append new pages in our Notifier
  PaginatedBehaviorModel copyWith({
    int? currentPage,
    int? lastPage,
    List<BehaviorModel>? behaviors,
  }) {
    return PaginatedBehaviorModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      behaviors: behaviors ?? this.behaviors,
    );
  }
}