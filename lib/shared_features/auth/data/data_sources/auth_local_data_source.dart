import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/enums/enums.dart';
import '../../services/secure_storage.dart';
import '../models/user_model.dart';
// import your UserModel here

final userBoxProvider = Provider<Box>((ref) {
  throw UnimplementedError('userBoxProvider not initialized in main.dart');
});

class AuthLocalDataSource {
  final SecureStorage _tokenStorage;
  final Box _userBox;

  AuthLocalDataSource(this._tokenStorage, this._userBox);

  // Future<void> saveSession(String access, String refresh, UserModel user) async {
  //   await _tokenStorage.saveAllTokens(accessToken: access, refreshToken: refresh);
  //   await _userBox.put('current_user', user.toJson());
  // }

  Future<void> saveSession(String token,UserModel user) async {
    await _tokenStorage.saveAccessToken(token,);
    await _userBox.put('current_user', user.toJson());
  }

  Future<void> cacheUser(UserModel user) async {
    await _userBox.put('current_user', user.toJson());
  } 

  UserModel? getCachedUser() {
    final userData = _userBox.get('current_user');
    if (userData != null) {
      return UserModel.fromJson(Map<String, dynamic>.from(userData));
    }
    return null;
  }

  Future<void> cacheActiveRole(UserRole role) async {
    await _userBox.put('active_role', role.name);
  }

  // 🚨 ADD THIS: Get the last active role
  UserRole? getCachedActiveRole() {
    final roleStr = _userBox.get('active_role');
    if (roleStr != null) {
      // Find the enum matching the saved string
      return UserRole.values.firstWhere(
        (e) => e.name == roleStr, 
        orElse: () => UserRole.parent // failsafe
      );
    }
    return null;
  }

  Future<void> clearSession() async {
    await _tokenStorage.deleteAllTokens();
    await _userBox.delete('current_user');
    await _userBox.delete('active_role');
  }
}

// 🚨 Standard Provider
final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final tokenStorage = ref.watch(secureStorageProvider);
  final userBox = ref.watch(userBoxProvider);
  return AuthLocalDataSource(tokenStorage, userBox);
});