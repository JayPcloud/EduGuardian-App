import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dashboard/presentation/controllers/student_providers.dart';
import '../../data/models/badge_model.dart';
import '../../data/repositories/activities_repository.dart';
// Import your activeWardProvider and BadgeModel/ActivitiesRepository

final badgesProvider = FutureProvider.autoDispose<List<BadgeModel>>((ref) async {
  await ref.watch(myWardsProvider.future);
  final activeWard = ref.watch(activeWardProvider);
  
  if (activeWard == null) throw 'No student selected';

  return ref.read(activitiesRepositoryProvider).getBadges(activeWard.id);
});