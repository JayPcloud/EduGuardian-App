import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/teachers_timetable_model.dart';
import '../../data/repositories/teachers_timetable_repository.dart';


// Provides the fetched timetable data
final teacherTimetableProvider = FutureProvider.autoDispose<TeacherTimetableDataModel>((ref) async {
  return ref.read(teacherTimetableRepositoryProvider).getTimetable();
});

// Holds the currently selected day (e.g., 'monday', 'tuesday')
// Defaults to the current active weekday, or Monday if it's the weekend.
final selectedTimetableDayProvider = StateProvider.autoDispose<String>((ref) {
  final weekday = DateTime.now().weekday;
  switch (weekday) {
    case 1: return 'monday';
    case 2: return 'tuesday';
    case 3: return 'wednesday';
    case 4: return 'thursday';
    case 5: return 'friday';
    default: return 'monday'; // Default to Monday on weekends
  }
});