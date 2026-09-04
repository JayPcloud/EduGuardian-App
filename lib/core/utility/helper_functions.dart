import 'package:flutter/material.dart';

import '../../teachers_features/edu/data/models/result_models.dart';

class HelperFunctions {

  static String getGradeRemark(num percentage) {
    if (percentage >= 75) return 'Excellent';
    if (percentage >= 60) return 'Very Good';
    if (percentage >= 50) return 'Good';
    if (percentage >= 40) return 'Fair';
    return 'Poor';
  }

  static GradeInfo calculateGrade(num totalScore) {
    if (totalScore >= 75) return GradeInfo('A', 'Excellent', const Color(0xFF1E88E5)); // Blue
    if (totalScore >= 60) return GradeInfo('B', 'Very Good', const Color(0xFF00BFA5)); // Teal
    if (totalScore >= 50) return GradeInfo('C', 'Good', const Color(0xFF43A047)); // Green
    if (totalScore >= 40) return GradeInfo('D', 'Fair', const Color(0xFFFFB300)); // Yellow/Amber
    return GradeInfo('F', 'Poor', const Color(0xFFE53935)); // Red
  }


}