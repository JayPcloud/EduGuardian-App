class SubjectPerformanceModel {
  final String subjectId;
  final String subjectName;
  final int percentage;
  final String term;
  final String grade;

  SubjectPerformanceModel({
    required this.subjectId,
    required this.subjectName,
    required this.percentage,
    required this.term,
    required this.grade,
  });

  factory SubjectPerformanceModel.fromJson(Map<String, dynamic> json) {
    return SubjectPerformanceModel(
      subjectId: json['subject_id']?.toString() ?? '',
      subjectName: json['subject_name'] ?? 'Unknown',
      percentage: json['percentage'] ?? 0,
      term: json['term'] ?? '',
      grade: json['grade'] ?? 'N/A',
    );
  }
}