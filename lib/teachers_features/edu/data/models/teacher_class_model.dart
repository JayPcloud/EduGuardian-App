
import 'class_management_models.dart';

class TeacherSubjectModel {
  final String id;
  final String name;
  final String code;

  TeacherSubjectModel({required this.id, required this.name, required this.code});

  factory TeacherSubjectModel.fromJson(Map<String, dynamic> json) {
    return TeacherSubjectModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Subject',
      code: json['code'] ?? '',
    );
  }
}

// 🚨 NEW MODEL: To handle the "arms" array
class TeacherClassArmModel {
  final String id;
  final String name;
  final int totalStudents;
  final int noOfStudents;

  TeacherClassArmModel({
    required this.id,
    required this.name,
    required this.totalStudents,
    required this.noOfStudents,
  });

  factory TeacherClassArmModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassArmModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Arm',
      totalStudents: json['total_students'] ?? 0,
      noOfStudents: json['no_of_students'] ?? 0,
    );
  }
}

class TeacherClassModel {
  final String id;
  final String name;
  final String category;
  
  // 🚨 NEW FIELDS added to match the updated JSON
  final int totalStudents;
  final int noOfStudents;
  final num attendancePercentage;
  final num totalAttendancePercentage;
  final List<TeacherClassArmModel> arms;
  final List<TeacherSubjectModel> subjects;
  final List<TeacherStudentRankingModel> topOfTheClass;
  final List<TeacherStudentRankingModel> needsAttention;
  
  TeacherClassModel({
    required this.id,
    required this.name,
    required this.category,
    required this.totalStudents,
    required this.noOfStudents,
    required this.attendancePercentage,
    required this.totalAttendancePercentage,
    required this.arms,
    required this.subjects,
    this.topOfTheClass = const [],
    this.needsAttention = const [],
  });

  factory TeacherClassModel.fromJson(Map<String, dynamic> json) {
    final armsJson = json['arms'] as List? ?? [];
    final subjectsJson = json['subjects'] as List? ?? [];
    final topClassJson = json['top_of_the_class'] as List? ?? [];
    final attentionJson = json['needs_attention'] as List? ?? [];
    
    return TeacherClassModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Class',
      category: json['category'] ?? '',
      
      // Parse stats
      totalStudents: json['total_students'] ?? 0,
      noOfStudents: json['no_of_students'] ?? 0,
      attendancePercentage: json['attendance_percentage'] ?? 0,
      totalAttendancePercentage: json['total_attendance_percentage'] ?? 0,
      
      // Map the nested arrays
      arms: armsJson.map((a) => TeacherClassArmModel.fromJson(a)).toList(),
      subjects: subjectsJson.map((s) => TeacherSubjectModel.fromJson(s)).toList(),
      topOfTheClass: topClassJson.map((s) => TeacherStudentRankingModel.fromJson(s)).toList(),
      needsAttention: attentionJson.map((s) => TeacherStudentRankingModel.fromJson(s)).toList()
    );
  }

  // Helper to extract a 2-letter initial (e.g., "JSS 1" -> "JS")
  String get initials {
    if (name.isEmpty) return 'CL';
    final parts = name.split(' ');
    if (parts.length > 1 && parts[0].length >= 2) {
      return parts[0].substring(0, 2).toUpperCase();
    }
    return name.substring(0, name.length >= 2 ? 2 : 1).toUpperCase();
  }

  String get classname => '$name ${arms[0].name}';

}

class TeacherClassesCountsModel {
  final int totalClasses;
  final int totalStudents;

  TeacherClassesCountsModel({required this.totalClasses, required this.totalStudents});

  factory TeacherClassesCountsModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassesCountsModel(
      totalClasses: json['total_classes'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
    );
  }
}

class TeacherClassesDataModel {
  final List<TeacherClassModel> classes;
  final TeacherClassesCountsModel counts;

  TeacherClassesDataModel({required this.classes, required this.counts});

  factory TeacherClassesDataModel.fromJson(Map<String, dynamic> json) {
    final classesJson = json['classes'] as List? ?? [];
    return TeacherClassesDataModel(
      classes: classesJson.map((c) => TeacherClassModel.fromJson(c)).toList(),
      counts: TeacherClassesCountsModel.fromJson(json['counts'] ?? {}),
    );
  }
}