class TeacherAttendanceStudentModel {
  final String id;
  final String firstName;
  final String lastName;
  final String regNumber;
  final String? photo;

  TeacherAttendanceStudentModel({
    required this.id, required this.firstName, required this.lastName, required this.regNumber, this.photo,
  });

  String get fullName => '$firstName $lastName';

  factory TeacherAttendanceStudentModel.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceStudentModel(
      id: json['id']?.toString() ?? '',
      firstName: json['first_name'] ?? 'Unknown',
      lastName: json['last_name'] ?? '',
      regNumber: json['admission_number'] ?? '',
      photo: json['photo'],
    );
  }
}

class TeacherAttendanceRecordModel {
  final String id;
  final String studentId;
  final String status; // 'present', 'absent', 'late', 'excused'
  final TeacherAttendanceStudentModel student;

  TeacherAttendanceRecordModel({
    required this.id, required this.studentId, required this.status, required this.student,
  });

  factory TeacherAttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    return TeacherAttendanceRecordModel(
      id: json['id']?.toString() ?? '',
      studentId: json['student_id']?.toString() ?? '',
      status: json['status'] ?? 'absent',
      student: TeacherAttendanceStudentModel.fromJson(json['student'] ?? {}),
    );
  }
}

class PaginatedTeacherAttendanceModel {
  final int currentPage;
  final int lastPage;
  final List<TeacherAttendanceRecordModel> records;

  PaginatedTeacherAttendanceModel({required this.currentPage, required this.lastPage, required this.records});

  factory PaginatedTeacherAttendanceModel.fromJson(Map<String, dynamic> json) {
    final dataList = json['data'] as List? ?? [];
    return PaginatedTeacherAttendanceModel(
      currentPage: json['current_page'] ?? 1,
      lastPage: json['last_page'] ?? 1,
      records: dataList.map((x) => TeacherAttendanceRecordModel.fromJson(x)).toList(),
    );
  }

  PaginatedTeacherAttendanceModel copyWith({int? currentPage, int? lastPage, List<TeacherAttendanceRecordModel>? records}) {
    return PaginatedTeacherAttendanceModel(
      currentPage: currentPage ?? this.currentPage,
      lastPage: lastPage ?? this.lastPage,
      records: records ?? this.records,
    );
  }
}

class TeacherAttendanceMetricsModel {
  final int totalStudents;
  final int presentCount;
  final int absentCount;
  final int lateCount;
  final int excusedCount;

  TeacherAttendanceMetricsModel({
    required this.totalStudents, required this.presentCount, required this.absentCount, required this.lateCount, required this.excusedCount,
  });

  factory TeacherAttendanceMetricsModel.fromJson(Map<String, dynamic> json) {
    final metrics = json['metrics'] ?? {};
    return TeacherAttendanceMetricsModel(
      totalStudents: json['total_students_in_class'] ?? 0,
      presentCount: metrics['present']?['count'] ?? 0,
      absentCount: metrics['absent']?['count'] ?? 0,
      lateCount: metrics['late']?['count'] ?? 0,
      excusedCount: metrics['excused']?['count'] ?? 0,
    );
  }
}