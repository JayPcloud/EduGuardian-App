import 'package:flutter/material.dart';


class GradeInfo {
  final String letter;
  final String remark;
  final Color color;
  GradeInfo(this.letter, this.remark, this.color);
}

class ResultConfigModel {
  final String id;
  final String classCategory;
  final String assessmentType;
  final int percentage;
  final bool isExam;

  ResultConfigModel({
    required this.id, required this.classCategory, required this.assessmentType, required this.percentage, required this.isExam,
  });

  factory ResultConfigModel.fromJson(Map<String, dynamic> json) {
    return ResultConfigModel(
      id: json['id']?.toString() ?? '',
      classCategory: json['class_category'] ?? '',
      assessmentType: json['assessment_type'] ?? 'Unknown',
      percentage: json['percentage'] ?? 0,
      isExam: json['is_exam'] ?? false,
    );
  }
}

// Model to handle the existing scores fetched from the backend
class StudentExistingResultModel {
  final String studentId;
  final List<num?> scores; // Matches the order of configs

  StudentExistingResultModel({required this.studentId, required this.scores});

  factory StudentExistingResultModel.fromJson(Map<String, dynamic> json) {
    final scoresJson = json['scores'] as List? ?? [];
    return StudentExistingResultModel(
      studentId: json['student_id']?.toString() ?? '',
      scores: scoresJson.map((e) => e != null ? num.tryParse(e.toString()) : null).toList(),
    );
  }
}