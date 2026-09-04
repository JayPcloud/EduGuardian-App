class TeacherDashboardStatsModel {
  final int totalClassAssigned;
  final int totalStudents;
  final int totalSubjectsAssigned;

  TeacherDashboardStatsModel({
    required this.totalClassAssigned,
    required this.totalStudents,
    required this.totalSubjectsAssigned,
  });

  factory TeacherDashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return TeacherDashboardStatsModel(
      totalClassAssigned: json['total_class_assigned'] ?? 0,
      totalStudents: json['total_students'] ?? 0,
      totalSubjectsAssigned: json['total_subjects_assigned'] ?? 0,
    );
  }
}

class TeacherScheduleModel {
  final String timeH;
  final String timeM;
  final String subject;
  final String className;
  final String details;
  final String status;

  TeacherScheduleModel({
    required this.timeH,
    required this.timeM,
    required this.subject,
    required this.className,
    required this.details,
    required this.status,
  });
}