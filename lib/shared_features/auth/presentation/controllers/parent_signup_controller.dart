import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';

class ParentSignupState {
  final String email;
  final String otpCode;
  final bool isLoading;
  final UserModel? user;
  ParentSignupState({this.email = '', this.otpCode = '', this.isLoading=false, this.user});
  
  ParentSignupState copyWith({String? email, String? otpCode, bool? isLoading, UserModel? user}) {
    return ParentSignupState(email: email ?? this.email, otpCode: otpCode ?? this.otpCode, isLoading: isLoading??this.isLoading ,user: user ?? this.user);
  }
}

class ParentSignupController extends AutoDisposeNotifier<ParentSignupState> {
  @override
  ParentSignupState build() => ParentSignupState();

  Future<void> sendActivationCode(String email) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).parents.sendActivationCode(email: email);
      state = ParentSignupState(isLoading: false, email: email, otpCode: '');
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> verifyActivationCode(String code) async {
    state = state.copyWith(isLoading: true);
    try {
      final email = state.email;
      // This endpoint returns a user and logs them in!
      final user = await ref.read(authRepositoryProvider).parents.verifyActivationCode(email: email, code: code);
      state = state.copyWith(isLoading: false,otpCode: code, user: user);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> setPassword(String password, String confirmPassword) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).parents.setPassword(password: password, confirmPassword: confirmPassword);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  Future<void> setNotificationPreferences({
    required bool grades, required bool behavior, required bool attendance, required bool announcements
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      await ref.read(authRepositoryProvider).parents.setNotificationPreferences(
        gradesReport: grades, behaviorAlerts: behavior, attendance: attendance, schoolAnnouncements: announcements
      );
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }
}

final parentSignupControllerProvider = NotifierProvider.autoDispose<ParentSignupController, ParentSignupState>(() {
  return ParentSignupController();
});