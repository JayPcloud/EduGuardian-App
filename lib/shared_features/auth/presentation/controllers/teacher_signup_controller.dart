import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository.dart';
import 'auth_status_controller.dart';

class TeacherSignupController extends AutoDisposeNotifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> activateAccount({
    required String email,
    required String code,
    required String password,
    required String confirmPassword,
  }) async {
    state = const AsyncLoading();
    try {
      final user = await ref.read(authRepositoryProvider).teachers.activateTeacherAccount(
        email: email, 
        code: code,
        password: password, 
        confirmPassword: confirmPassword,
      );
      ref.read(authStatusNotifierProvider.notifier).updateState(user);
      state = const AsyncData(null);
      
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final teacherSignupControllerProvider = NotifierProvider.autoDispose<TeacherSignupController, AsyncValue<void>>(() {
  return TeacherSignupController();
});