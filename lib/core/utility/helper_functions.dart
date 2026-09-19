import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  static String getGroupDateHeader(DateTime? date) {
    if (date == null) return 'Unknown Date';
    
    // 🚨 CRITICAL: Convert UTC to Local time first
    final localDate = date.toLocal();
    final now = DateTime.now();
    
    // Strip hours/minutes to get raw days
    final today = DateTime(now.year, now.month, now.day);
    final msgDate = DateTime(localDate.year, localDate.month, localDate.day);
    final diff = today.difference(msgDate).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Yesterday';
    if (diff < 7) return DateFormat('EEEE').format(localDate); // "Monday"
    
    return DateFormat('dd/MM/yyyy').format(localDate); // "12/02/2026"
  }

  static bool isSameDay(DateTime? date1, DateTime? date2) {
    if (date1 == null || date2 == null) return false;
    final d1 = date1.toLocal();
    final d2 = date2.toLocal();
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

}
