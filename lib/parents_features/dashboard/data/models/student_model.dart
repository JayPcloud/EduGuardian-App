class WardModel {
  final String id;
  final String firstName;
  final String lastName;
  final String schoolClassId;
  final String classArmId;
  final String term;
  final String classCategory; // e.g., 'Primary'

  WardModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.schoolClassId,
    required this.classArmId,
    required this.term,
    required this.classCategory,
  });

  String get fullName => '$firstName $lastName';
  String get initials => '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}';

  factory WardModel.fromJson(Map<String, dynamic> json) {
    return WardModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      schoolClassId: json['school_class_id']?.toString() ?? '',
      classArmId: json['class_arm_id']?.toString() ?? '',
      term: json['term']?.toString() ?? '1',
      classCategory: json['class_category'] ?? 'Student',
    );
  }
}