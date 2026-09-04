class AttendanceSummaryModel {
  final int percentage;
  final int totalPresent;
  final int totalLate;
  final int totalAbsent;
  final int totalExcused;

  AttendanceSummaryModel({
    required this.percentage,
    required this.totalPresent,
    required this.totalLate,
    required this.totalAbsent,
    required this.totalExcused,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      percentage: json['percentage'] ?? 0,
      totalPresent: json['total_present'] ?? 0,
      totalLate: json['total_late'] ?? 0,
      totalAbsent: json['total_absent'] ?? 0,
      totalExcused: json['total_excused'] ?? 0,
    );
  }
}

class AttendanceRecordModel {
  final DateTime date;
  final String status;
  final String remark;

  AttendanceRecordModel({
    required this.date,
    required this.status,
    required this.remark,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return AttendanceRecordModel(
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      status: json['status'] ?? 'absent',
      remark: json['remark'] ?? '',
    );
  }
}

// 🚨 Master model that holds both summary and records
class AttendanceDataModel {
  final AttendanceSummaryModel summary;
  final List<AttendanceRecordModel> records;

  AttendanceDataModel({required this.summary, required this.records});

  factory AttendanceDataModel.fromJson(Map<String, dynamic> json) {
    final summaryJson = json['summary'] ?? {};
    final recordsJson = json['records'] as List? ?? [];

    return AttendanceDataModel(
      summary: AttendanceSummaryModel.fromJson(summaryJson),
      records: recordsJson.map((r) => AttendanceRecordModel.fromJson(r)).toList(),
    );
  }

  // 🚨 HELPER FOR YOUR CALENDAR
  // Converts the list of records into a fast-lookup Map for your calendar grid
  Map<DateTime, String> get statusMap {
    final map = <DateTime, String>{};
    for (var record in records) {
      // Normalize to just the year/month/day so time doesn't mess up the matching
      final cleanDate = DateTime(record.date.year, record.date.month, record.date.day);
      map[cleanDate] = record.status.toLowerCase();
    }
    return map;
  }
}