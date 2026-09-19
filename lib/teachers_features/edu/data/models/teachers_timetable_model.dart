class TimetableSessionInfoModel {
  final String academicSessionId;
  final int term;

  TimetableSessionInfoModel({required this.academicSessionId, required this.term});

  factory TimetableSessionInfoModel.fromJson(Map<String, dynamic> json) {
    return TimetableSessionInfoModel(
      academicSessionId: json['academic_session_id']?.toString() ?? '',
      term: json['term'] ?? 1,
    );
  }
}

class TimetableSessionModel {
  final String id;
  final String className;
  final String subjectName;
  final String room;
  final String sessionType;

  TimetableSessionModel({
    required this.id, required this.className, required this.subjectName, required this.room, required this.sessionType,
  });

  factory TimetableSessionModel.fromJson(Map<String, dynamic> json) {
    return TimetableSessionModel(
      id: json['id']?.toString() ?? '',
      className: json['class_name'] ?? '',
      subjectName: json['subject_name'] ?? '',
      room: json['room'] ?? '',
      sessionType: json['session_type'] ?? '',
    );
  }
}

class TimetableDaysModel {
  final TimetableSessionModel? monday;
  final TimetableSessionModel? tuesday;
  final TimetableSessionModel? wednesday;
  final TimetableSessionModel? thursday;
  final TimetableSessionModel? friday;

  TimetableDaysModel({this.monday, this.tuesday, this.wednesday, this.thursday, this.friday});

  factory TimetableDaysModel.fromJson(Map<String, dynamic> json) {
    return TimetableDaysModel(
      monday: json['monday'] != null ? TimetableSessionModel.fromJson(json['monday']) : null,
      tuesday: json['tuesday'] != null ? TimetableSessionModel.fromJson(json['tuesday']) : null,
      wednesday: json['wednesday'] != null ? TimetableSessionModel.fromJson(json['wednesday']) : null,
      thursday: json['thursday'] != null ? TimetableSessionModel.fromJson(json['thursday']) : null,
      friday: json['friday'] != null ? TimetableSessionModel.fromJson(json['friday']) : null,
    );
  }

  // Helper to dynamically fetch the session for a specific day key
  TimetableSessionModel? getSessionForDay(String dayKey) {
    switch (dayKey.toLowerCase()) {
      case 'monday': return monday;
      case 'tuesday': return tuesday;
      case 'wednesday': return wednesday;
      case 'thursday': return thursday;
      case 'friday': return friday;
      default: return null;
    }
  }
}

class TimetableGridItemModel {
  final String periodId;
  final String periodName;
  final String time;
  final bool isBreak;
  final TimetableDaysModel days;

  TimetableGridItemModel({
    required this.periodId, required this.periodName, required this.time, required this.isBreak, required this.days,
  });

  factory TimetableGridItemModel.fromJson(Map<String, dynamic> json) {
    return TimetableGridItemModel(
      periodId: json['period_id']?.toString() ?? '',
      periodName: json['period_name'] ?? '',
      time: json['time'] ?? '',
      isBreak: json['is_break'] ?? false,
      days: TimetableDaysModel.fromJson(json['days'] ?? {}),
    );
  }
}

class TeacherTimetableDataModel {
  final List<TimetableGridItemModel> grid;
  final TimetableSessionInfoModel session;

  TeacherTimetableDataModel({required this.grid, required this.session});

  factory TeacherTimetableDataModel.fromJson(Map<String, dynamic> json) {
    final gridJson = json['grid'] as List? ?? [];
    return TeacherTimetableDataModel(
      session: TimetableSessionInfoModel.fromJson(json['session'] ?? {}),
      grid: gridJson.map((e) => TimetableGridItemModel.fromJson(e)).toList(),
    );
  }
}