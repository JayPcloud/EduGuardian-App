class DashboardStatsModel {
  final String studentId;
  final String studentName;
  final String gpaScore;
  final String gpaRemark;
  final String average;
  final int attendancePercentage;

  DashboardStatsModel({
    required this.studentId,
    required this.studentName,
    required this.gpaScore,
    required this.gpaRemark,
    required this.average,
    required this.attendancePercentage,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      studentId: json['student_id']?.toString() ?? '',
      studentName: json['student_name'] ?? 'Unknown',
      gpaScore: json['gpa_score']?.toString() ?? '0.0',
      gpaRemark: json['gpa_remark'] ?? 'N/A',
      average: json['average']?.toString() ?? '0.0',
      attendancePercentage: json['attendance_percentage'] ?? 0,
    );
  }
}

class TimelineItemModel {
  final String time;
  final String title;
  final String subtitle;
  final bool isDone;
  final bool isActive;
  final bool isFaded;

  TimelineItemModel({
    required this.time,
    required this.title,
    required this.subtitle,
    this.isDone = false,
    this.isActive = false,
    this.isFaded = false,
  });
}