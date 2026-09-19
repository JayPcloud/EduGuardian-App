class BadgeModel {
  final int id;
  final String name;
  final String type;
  final String category;
  final String description;
  final String? logo;
  final String level;
  final DateTime? awardedAt;

  BadgeModel({
    required this.id,
    required this.name,
    required this.type,
    required this.category,
    required this.description,
    this.logo,
    required this.level,
    this.awardedAt,
  });

  factory BadgeModel.fromJson(Map<String, dynamic> json) {
    // Extract the date from the nested pivot object
    final pivot = json['pivot'] as Map<String, dynamic>?;
    final awardedAtStr = pivot?['awarded_at'] as String?;

    return BadgeModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 'Standard',
      category: json['category'] ?? '',
      description: json['description'] ?? '',
      logo: json['logo'],
      level: json['level']?.toString() ?? '1',
      awardedAt: awardedAtStr != null ? DateTime.tryParse(awardedAtStr) : null,
    );
  }
}