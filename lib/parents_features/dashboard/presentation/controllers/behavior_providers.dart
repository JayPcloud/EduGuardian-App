import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/behaviour_model.dart';
import '../../data/repositories/ward_behavior_repository.dart';
import 'student_providers.dart';

class WardBehaviorNotifier extends AutoDisposeAsyncNotifier<PaginatedBehaviorModel> {
  bool _isFetchingMore = false;

  @override
  FutureOr<PaginatedBehaviorModel> build() async {
    // 1. Wait for wards to load
    await ref.watch(myWardsProvider.future);
    final activeWard = ref.watch(activeWardProvider);
    if (activeWard == null) throw 'No student records found.';

    // 2. Fetch Initial Page (Page 1)
    return ref.read(wardBehaviorRepositoryProvider).getBehaviors(activeWard.id, page: 1);
  }

  Future<void> loadMore() async {
    // Prevent spamming the API while a request is already in flight
    if (_isFetchingMore) return; 

    final currentData = state.valueOrNull;
    if (currentData == null) return;
    
    // If we've reached the last page, stop trying to fetch
    if (currentData.currentPage >= currentData.lastPage) return;

    _isFetchingMore = true;

    try {
      final activeWard = ref.read(activeWardProvider);
      if (activeWard == null) return;

      // Fetch the next page
      final nextPageData = await ref.read(wardBehaviorRepositoryProvider)
          .getBehaviors(activeWard.id, page: currentData.currentPage + 1);

      // Append new behaviors to the existing list and update state
      state = AsyncData(currentData.copyWith(
        currentPage: nextPageData.currentPage,
        behaviors: [...currentData.behaviors, ...nextPageData.behaviors],
      ));
    } catch (e) {
      // We don't want to blow up the whole screen if page 2 fails, 
      // just ignore or show a toast via the UI
      print("Failed to load more behaviors: $e");
    } finally {
      _isFetchingMore = false;
    }
  }
  
  bool get isFetchingMore => _isFetchingMore;
}

final wardBehaviorProvider = AsyncNotifierProvider.autoDispose<WardBehaviorNotifier, PaginatedBehaviorModel>(() {
  return WardBehaviorNotifier();
});