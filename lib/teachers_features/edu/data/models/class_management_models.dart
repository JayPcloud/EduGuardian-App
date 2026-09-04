class TeacherStudentRankingModel {
  final String id;
  final String name;
  final num percentage;

  TeacherStudentRankingModel({
    required this.id,
    required this.name,
    required this.percentage,
  });

  factory TeacherStudentRankingModel.fromJson(Map<String, dynamic> json) {
    return TeacherStudentRankingModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Student',
      percentage: json['percentage'] ?? 0,
    );
  }
}

class TeacherClassStudentModel {
  final String id;
  final String name;
  final String regNumber;

  TeacherClassStudentModel({required this.id, required this.name, required this.regNumber});

  factory TeacherClassStudentModel.fromJson(Map<String, dynamic> json) {
    return TeacherClassStudentModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? 'Unknown Student',
      regNumber: json['reg_number'] ?? '',
    );
  }
}