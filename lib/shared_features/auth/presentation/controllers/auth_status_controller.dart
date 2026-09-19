import 'dart:async';
import 'package:edu_guardian_app/shared_features/messaging/presentation/controllers/chat_detail_providers.dart';
import 'package:edu_guardian_app/teachers_features/dashboard/presentation/controllers/teacher_dashboard_providers.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/controllers/my_classes_providers.dart';
import 'package:edu_guardian_app/teachers_features/edu/presentation/controllers/teacher_attendance_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/enums/enums.dart';
import '../../../../parents_features/dashboard/presentation/controllers/behavior_providers.dart';
import '../../../../parents_features/dashboard/presentation/controllers/dashboard_providers.dart';
import '../../../../parents_features/edu/presentation/controllers/academic_providers.dart';
import '../../../../parents_features/edu/presentation/controllers/attendance_providers.dart';
import '../../../messaging/presentation/controllers/chat_list_providers.dart';
import '../../../messaging/services/pusher_service.dart';
import '../../data/data_sources/auth_local_data_source.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/secure_storage.dart';
import 'role_provider.dart';


class AuthStatusNotifier extends AsyncNotifier<UserModel?> {
  @override
  FutureOr<UserModel?> build() async {
    final authLocalRepo = ref.watch(authLocalDataSourceProvider);
    final cachedUser = authLocalRepo.getCachedUser();
    // Background Refresh if a user is cached
    if (cachedUser != null) {
      Future.microtask(() => ref.read(pusherServiceProvider).initGlobalChannel(cachedUser.id));
      Future.microtask(() => _validateSessionInBackground());
    }

    return cachedUser;
  }

  Future<void> _validateSessionInBackground() async {
    try {
      final secureStorage = ref.read(secureStorageProvider);
      final token = await secureStorage.getAccessToken();
      
      if (token == null) {
        await logout();
        return;
      }
      await refreshUserData();
    } catch (e) {
      // Handle silent errors gracefully
    }
  }

  void updateState(UserModel? user, {bool cacheUser = false}) async {
    state = AsyncData(user);
    ref.read(roleProvider.notifier).setRole(user?.roles.first??UserRole.parent, cacheRole: true, userRoles: user?.roles);
    if (user != null && cacheUser) {
      await ref.read(authLocalDataSourceProvider).cacheUser(user);
      
    }
  }

  void updateAuthStatusWithCache() async {
    final cachedUser = ref.read(authLocalDataSourceProvider).getCachedUser();
    if (cachedUser != null) {
      state = AsyncData(cachedUser);
      Future.microtask(() {
        ref.read(roleProvider.notifier).setRole(cachedUser.roles.first, cacheRole: true, userRoles: cachedUser.roles);
      });
    }}

  Future<void> refreshUserData() async {
    if (state.value == null) return;
    try {
      final user = await ref.read(authRepositoryProvider).fetchProfile();
      if (user != null) {
        state = AsyncData(user);
        await ref.read(authLocalDataSourceProvider).cacheUser(user);
        ref.read(roleProvider.notifier).setRole(user.roles.first, cacheRole: true, userRoles: user.roles);
      }
    } catch (e) {
      rethrow;
    }
  }

  void updateAndCacheUser({bool? pushEnabled, bool? emailEnabled}) async {
    await ref.read(authRepositoryProvider).updateProfile(
      pushEnabled: pushEnabled,
      emailEnabled: emailEnabled,
    );
    state = AsyncData(
      state.value?.copyWith(
      pushNotificationsEnabled: pushEnabled,
      emailNotificationsEnabled: emailEnabled
      ));
    // ref.read(roleProvider.notifier).setRole(user?.roles.first??UserRole.parent, cacheRole: true, userRoles: user?.roles);
    if (state.value != null ) {
      await ref.read(authLocalDataSourceProvider).cacheUser(state.value!);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();
    try {
      // Add your API logout call here if needed
      await ref.read(authRepositoryProvider).logout();
    } catch (e) {
      // Ignore API errors, force local clear
    } finally {
      ref.read(pusherServiceProvider).disconnect();
      await ref.read(authLocalDataSourceProvider).clearSession();
      state = const AsyncData(null);
      
      if(ref.read(roleProvider)==UserRole.teacher){
        //Dashboard
        ref.invalidate(teacherDashboardStatsProvider);
        ref.invalidate(teacherScheduleProvider);
        //Attendance
        ref.invalidate(teacherAttendanceMetricsProvider);
        ref.invalidate(teacherAttendanceRecordsProvider);
        ref.invalidate(teacherAttendanceMetricsProvider);
        //classes
        ref.invalidate(teacherClassesProvider);
        ref.invalidate(filteredFlattenedClassesProvider);
        
      }else{
        //Dashboard
        ref.invalidate(parentDashboardStatsProvider);
        ref.invalidate(parentTimelineProvider);
        //Academic Performance
        ref.invalidate(academicPerformanceProvider);
        //Attendance
        ref.invalidate(parentAttendanceProvider);
        //Behaviours
        ref.invalidate(wardBehaviorProvider);
      }
      
      // Invalidate other shared feature providers here!
      //Messaging reset
      ref.invalidate(chatDetailProvider);
      ref.invalidate(unifiedChatListProvider);
      ref.invalidate(conversationsProvider);
      
      
    }
  }
}

final authStatusNotifierProvider = AsyncNotifierProvider<AuthStatusNotifier, UserModel?>(() {
  return AuthStatusNotifier();
});