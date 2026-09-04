import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/api/api_client.dart';

// ── 1. SHARED AUTH REMOTE ──
class AuthRemoteDataSource {
  final ApiClient _client;
  AuthRemoteDataSource(this._client);

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post('auth/login', data: {
      'email': email,
      'password': password,
    });
    return response.data;
  }

  Future<void> sendforgotPasswordCode({required String email}) async {
    await _client.dio.post('auth/forgot-password', data: {'email': email});
  }

  Future<void> verifyEmailOtp({required String email, required String code}) async {
    await _client.dio.post('auth/forgot-password', data: {'email': email, 'otp': code});
  }

  Future<void> resetPassword({required String email, required String otpCode, required String newPassword}) async {
    await _client.dio.post('auth/reset-password', data: {
      'email': email, 
      'otp': otpCode, 
      'password': newPassword, 
      'password_confirmation': newPassword
    });
  }

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _client.dio.get('auth/profile');
    return response.data;
  }

  Future<Map<String, dynamic>> updateProfile({String? name, String? phone, bool? bioEnabled, bool? pushEnabled, bool? emailEnabled}) async {
    final response = await _client.dio.put('auth/profile', data: { // Assuming this was a typo in your snippet
      if(name!=null)"name": name,
      if(phone!=null)"phone": phone,
      if(bioEnabled!=null)"biometric_enabled": bioEnabled,
      if(pushEnabled!=null)"push_notifications_enabled": pushEnabled,
      if(emailEnabled!=null)"email_notifications_enabled": emailEnabled,
    });
    return response.data;
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.dio.put('auth/profile/password', data: {
      "current_password": currentPassword,
      "password": newPassword,
      "password_confirmation": newPassword, // Backend expects this too
    });
  }
}

// ── 2. PARENT SPECIFIC REMOTE ──
class ParentRemoteDataSource {
  final ApiClient _client;
  ParentRemoteDataSource(this._client);

  Future<Map<String, dynamic>> sendActivationCode({required String email}) async {
    final response = await _client.dio.post('guardian/activation/send-code', data: {
      'email': email,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> verifyActivationCode({required String email, required String code}) async {
    final response = await _client.dio.post('guardian/activation/verify', data: {
      'email': email,
      'code': code,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> setPassword({required String password, required String confirmPassword}) async {
    final response = await _client.dio.post('guardian/activation/reset-password', data: {
      'password': password,
      'password_confirmation': confirmPassword,
    });
    return response.data;
  }

  Future<Map<String, dynamic>> setNotificationPreferences({
    required bool gradesReport,
    required bool behaviorAlerts,
    required bool attendance,
    required bool schoolAnnouncements
  }) async {
    final response = await _client.dio.post('guardian/preferences', data: {
      "grades_reports": gradesReport,
      "behavior_alerts": behaviorAlerts,
      "attendance": attendance,
      "school_announcements": schoolAnnouncements
    });
    return response.data;
  }

  Future<List<Map<String, dynamic>>> fetchMyWards() async {
    final response = await _client.dio.get('guardian/my-students');
    final students = response.data['data'] as List<dynamic>;
    return students.map((e) => e as Map<String, dynamic>).toList();
  }  

}

// ── 3. TEACHER SPECIFIC REMOTE ──
class TeacherRemoteDataSource {
  final ApiClient _client;
  TeacherRemoteDataSource(this._client);

  Future<Map<String, dynamic>> activateTeacherAccount({
    required String code,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await _client.dio.post('auth/staff/activation', data: {
      "email": email,
      "code": code,
      "password": password,
      "password_confirmation": confirmPassword
    });
    return response.data;
  }
}

// ── PROVIDERS ──
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(ref.watch(apiClientProvider));
});

final parentRemoteDataSourceProvider = Provider<ParentRemoteDataSource>((ref) {
  return ParentRemoteDataSource(ref.watch(apiClientProvider));
});

final teacherRemoteDataSourceProvider = Provider<TeacherRemoteDataSource>((ref) {
  return TeacherRemoteDataSource(ref.watch(apiClientProvider));
});