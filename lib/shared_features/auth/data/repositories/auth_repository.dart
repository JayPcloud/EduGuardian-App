import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/exceptions/error_handler.dart';
import '../../../../parents_features/dashboard/data/models/student_model.dart';
import '../data_sources/auth_local_data_source.dart';
import '../data_sources/auth_remote_data_source.dart';
import '../models/user_model.dart';
// Import your remotes here

// ── HELPER: The Universal Parser ──
// Extracts the payload from the "data" object as requested
Future<UserModel> _saveAndReturnUser(Map<String, dynamic> responseData, AuthLocalDataSource local) async {
  final payload = responseData['data']; // 🚨 Digging into the nested data object
  final user = UserModel.fromJson(payload['user']);
  final token = payload['token']; 
  
  await local.saveSession(token, user);
  return user;
}


// ── 1. PARENT REPOSITORY ──
class ParentAuthRepository {
  final ParentRemoteDataSource remote;
  final AuthLocalDataSource local;

  ParentAuthRepository({required this.remote, required this.local});

  Future<String> sendActivationCode({required String email}) async {
    try {
      final resp = await remote.sendActivationCode(email: email);
      return resp['message'] ?? 'Code sent';
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  // Returns the user because this logs them in!
  Future<UserModel> verifyActivationCode({required String email, required String code}) async {
    try {
      final resp = await remote.verifyActivationCode(email: email, code: code);
      return await _saveAndReturnUser(resp, local);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> setPassword({required String password, required String confirmPassword}) async {
    try {
      await remote.setPassword(password: password, confirmPassword: confirmPassword);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<List<WardModel>> fetchMyWards() async {
    try {
      final response = await remote.fetchMyWards();
      // The API returns the parent object which contains a 'students' array
      return response.map((s) => WardModel.fromJson(s)).toList();
    } catch (e) {
      debugPrint(e.toString());
      throw ErrorHandler.parse(e).message;
    }
  }


  Future<void> setNotificationPreferences({
    required bool gradesReport, 
    required bool behaviorAlerts, 
    required bool attendance, 
    required bool schoolAnnouncements
  }) async {
    try {
      await remote.setNotificationPreferences(
        attendance: attendance,
        behaviorAlerts: behaviorAlerts,
        gradesReport: gradesReport,
        schoolAnnouncements: schoolAnnouncements
      );
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
  
}


// ── 2. TEACHER REPOSITORY ──
class TeacherAuthRepository {
  final TeacherRemoteDataSource remote;
  final AuthLocalDataSource local;

  TeacherAuthRepository({required this.remote, required this.local});

  Future<UserModel> activateTeacherAccount({
    required String code, required String email, required String password, required String confirmPassword
  }) async {
    try {
      final resp = await remote.activateTeacherAccount(
        code: code, email: email, password: password, confirmPassword: confirmPassword
      );
      return await _saveAndReturnUser(resp, local);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }
}


// ── 3. THE UNITED AUTH REPOSITORY ──
class AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;
  
  // 🚨 Composition: Exposing the specific flows!
  final ParentAuthRepository parents;
  final TeacherAuthRepository teachers;

  AuthRepository({
    required this.remote, 
    required this.local,
    required this.parents,
    required this.teachers,
  });

  Future<UserModel> login({required String email, required String password}) async {
    try {
      final resp = await remote.login(email, password);
      return await _saveAndReturnUser(resp, local);
    } catch (e) {
      // debugPrint(e.toString());
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<UserModel> fetchProfile() async {
    try {
      final resp = await remote.getProfile();
      return await _saveAndReturnUser(resp, local);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> updateProfile({String? name, String? phone,bool? bioEnabled, bool? pushEnabled, bool? emailEnabled}) async {
    try {
      await remote.updateProfile(
        name: name,
        phone: phone,
        bioEnabled: bioEnabled,
        pushEnabled: pushEnabled,
        emailEnabled: emailEnabled,
      );
      // return await _saveAndReturnUser(resp, local);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> sendforgotPasswordCode({required String email}) async {
    try {
      await remote.sendforgotPasswordCode(email: email);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> verifyOtp({required String email, required String code}) async {
    try {
      await remote.verifyEmailOtp(email: email, code:code);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> resetPassword({required String email, required String otpCode, required String newPassword}) async {
    try {
      await remote.resetPassword(email: email, otpCode: otpCode, newPassword: newPassword);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> changePassword({required String currentPassword, required String newPassword}) async {
    try {
      await remote.changePassword(currentPassword: currentPassword, newPassword: newPassword);
    } catch (e) {
      throw ErrorHandler.parse(e).message;
    }
  }

  Future<void> logout() async {
    await local.clearSession();
  }
}

// ── PROVIDERS ──
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final local = ref.watch(authLocalDataSourceProvider);
  
  // Construct the sub-repositories
  final parentsRepo = ParentAuthRepository(
    remote: ref.watch(parentRemoteDataSourceProvider), 
    local: local,
  );
  
  final teachersRepo = TeacherAuthRepository(
    remote: ref.watch(teacherRemoteDataSourceProvider), 
    local: local,
  );

  // Return the united master repository
  return AuthRepository(
    remote: ref.watch(authRemoteDataSourceProvider),
    local: local,
    parents: parentsRepo,
    teachers: teachersRepo,
  );
});