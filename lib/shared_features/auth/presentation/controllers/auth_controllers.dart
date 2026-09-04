import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository.dart';
import 'auth_status_controller.dart';

class AuthController extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() {
    return const AsyncData(null);
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();
    try {
      final repo = ref.read(authRepositoryProvider);
      final user = await repo.login(email: email, password: password);
      // Update global auth status here if needed
      state = const AsyncData(null);
      ref.read(authStatusNotifierProvider.notifier).updateState(user, cacheUser: false);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final authControllerProvider = NotifierProvider<AuthController, AsyncValue<void>>(() {
  return AuthController();
});



class PasswordResetState {
  final String email;
  final String otpCode;
  PasswordResetState({this.email = '', this.otpCode = ''});
  
  PasswordResetState copyWith({String? email, String? otpCode}) {
    return PasswordResetState(
      email: email ?? this.email, 
      otpCode: otpCode ?? this.otpCode,
    );
  }
}

class PasswordResetController extends AutoDisposeNotifier<AsyncValue<PasswordResetState>> {
  @override
  AsyncValue<PasswordResetState> build() => AsyncData(PasswordResetState());

  Future<void> sendCode(String email) async {
    state = const AsyncLoading();
    try {
      await ref.read(authRepositoryProvider).sendforgotPasswordCode(email: email);
      state = AsyncData(PasswordResetState(email: email));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> verifyCode(String code) async {
    state = const AsyncLoading();
    try {
      final email = state.value!.email;
      await ref.read(authRepositoryProvider).verifyOtp(email: email, code: code);
      state = AsyncData(state.value!.copyWith(otpCode: code));
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> resetPassword(String newPassword) async {
    state = const AsyncLoading();
    try {
      final email = state.value!.email;
      final otp = state.value!.otpCode;
      await ref.read(authRepositoryProvider).resetPassword(
        email: email, otpCode: otp, newPassword: newPassword
      );
      state = AsyncData(state.value!);
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }
}

final passwordResetControllerProvider = NotifierProvider.autoDispose<PasswordResetController, AsyncValue<PasswordResetState>>(() {
  return PasswordResetController();
});