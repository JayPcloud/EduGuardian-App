import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/alert_model.dart';
import '../../data/repositories/alerts_repository.dart';


class AlertsNotifier extends AutoDisposeAsyncNotifier<PaginatedAnnouncementModel> {
  bool _isFetchingMore = false;

  @override
  FutureOr<PaginatedAnnouncementModel> build() async {
    return ref.read(alertsRepositoryProvider).getAnnouncements(page: 1);
  }

  Future<void> loadMore() async {
    if (_isFetchingMore) return;
    
    final currentData = state.valueOrNull;
    if (currentData == null) return;
    if (currentData.currentPage >= currentData.lastPage) return;

    _isFetchingMore = true;

    try {
      final nextPageData = await ref.read(alertsRepositoryProvider)
          .getAnnouncements(page: currentData.currentPage + 1);

      state = AsyncData(currentData.copyWith(
        currentPage: nextPageData.currentPage,
        announcements: [...currentData.announcements, ...nextPageData.announcements],
      ));
    } catch (e) {
      print("Failed to load more alerts: $e");
    } finally {
      _isFetchingMore = false;
    }
  }

  Future<void> markAllAsRead() async {
    final currentData = state.valueOrNull;
    if (currentData == null) return;

    try {
      // API Call
      await ref.read(alertsRepositoryProvider).markAllAsRead();

      // Optimistic UI Update: Instantly flip all isRead flags to true!
      final updatedList = currentData.announcements.map((a) => a.copyWith(isRead: true)).toList();
      state = AsyncData(currentData.copyWith(announcements: updatedList));
    } catch (e) {
      // Let the UI handle the error (e.g. via Snackbar)
      rethrow;
    }
  }
  
  bool get isFetchingMore => _isFetchingMore;
}

final alertsProvider = AsyncNotifierProvider.autoDispose<AlertsNotifier, PaginatedAnnouncementModel>(() {
  return AlertsNotifier();
});