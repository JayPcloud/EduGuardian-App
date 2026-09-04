import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/data/repositories/auth_repository.dart';

class ChangePasswordController extends AutoDisposeAsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const AsyncData(null);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final changePasswordControllerProvider = AsyncNotifierProvider.autoDispose<ChangePasswordController, void>(() {
  return ChangePasswordController();
});