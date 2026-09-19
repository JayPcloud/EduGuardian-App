class WardModel {
  final String id;
  final String firstName;
  final String lastName;
  final String schoolClassId;
  final String classArmId;
  final String term;
  final String classCategory; // e.g., 'Primary'
  // 🚨 New Nested Objects
  final SchoolClassModel? schoolClass;
  final ClassArmModel? classArm;
  final List<PreviousClassModel> previousClasses;

  WardModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.schoolClassId,
    required this.classArmId,
    required this.term,
    required this.classCategory,
    this.schoolClass,
    this.classArm,
    this.previousClasses = const [],
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
      schoolClass: json['school_class'] != null ? SchoolClassModel.fromJson(json['school_class']) : null,
      classArm: json['class_arm'] != null ? ClassArmModel.fromJson(json['class_arm']) : null,
      previousClasses: json['previous_classes'] != null 
          ? (json['previous_classes'] as List).map((x) => PreviousClassModel.fromJson(x)).toList()
          : [],
    );
  }
}


// ==========================================
// SUB-MODELS FOR NESTED DATA
// ==========================================
class SchoolClassModel {
  final String id;
  final String name;
  final String? category;

  SchoolClassModel({required this.id, required this.name, this.category});

  factory SchoolClassModel.fromJson(Map<String, dynamic> json) {
    return SchoolClassModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      category: json['category'],
    );
  }
}

class ClassArmModel {
  final String id;
  final String name;

  ClassArmModel({required this.id, required this.name});

  factory ClassArmModel.fromJson(Map<String, dynamic> json) {
    return ClassArmModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}

class PreviousClassModel {
  final SchoolClassModel? schoolClass;
  final ClassArmModel? classArm;
  final TermSessionModel? term;
  final TermSessionModel? session;

  PreviousClassModel({this.schoolClass, this.classArm, this.term, this.session});

  factory PreviousClassModel.fromJson(Map<String, dynamic> json) {
    return PreviousClassModel(
      // Note: JSON key is 'class', not 'school_class' inside previous_classes array
      schoolClass: json['class'] != null ? SchoolClassModel.fromJson(json['class']) : null,
      classArm: json['class_arm'] != null ? ClassArmModel.fromJson(json['class_arm']) : null,
      term: json['term'] != null ? TermSessionModel.fromJson(json['term']) : null,
      session: json['session'] != null ? TermSessionModel.fromJson(json['session']) : null,
    );
  }
}

// Reusable model for Term and Session since they share the identical {id, name} structure
class TermSessionModel {
  final String id;
  final String name;

  TermSessionModel({required this.id, required this.name});

  factory TermSessionModel.fromJson(Map<String, dynamic> json) {
    return TermSessionModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
    );
  }
}