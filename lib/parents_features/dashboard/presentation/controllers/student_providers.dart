import 'package:edu_guardian_app/shared_features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/student_model.dart';

// 1. Holds the currently selected student details
class ActiveWardNotifier extends Notifier<WardModel?> {
  @override
  WardModel? build() => null;

  void setWard(WardModel ward) {
    state = ward;
  }
}

final activeWardProvider = NotifierProvider<ActiveWardNotifier, WardModel?>(() {
  return ActiveWardNotifier();
});

// 2. Fetches the list of students and auto-selects the first one if none is selected
final myWardsProvider = FutureProvider<List<WardModel>>((ref) async {
  final wards = await ref.read(authRepositoryProvider).parents.fetchMyWards();
  
  if (wards.isNotEmpty && ref.read(activeWardProvider) == null) {
    // Silently set the first child as active on initial load
    Future.microtask(() {
      ref.read(activeWardProvider.notifier).setWard(wards.first);
    });
  }
  return wards;
});
