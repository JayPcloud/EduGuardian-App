import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/texts.dart';

class SecureStorage {
  final FlutterSecureStorage _storage;

  SecureStorage(this._storage);
  
  // --- Token Management ---
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: AppTexts.accessTokenKey, value: token);
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: AppTexts.accessTokenKey);
  }

  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: AppTexts.refrehTokenKey, value: token);
  }

  Future<void> saveAllTokens({required String accessToken, required String refreshToken}) async {
    await _storage.write(key: AppTexts.refrehTokenKey, value: refreshToken);
    await _storage.write(key: AppTexts.accessTokenKey, value: accessToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: AppTexts.refrehTokenKey);
  }

  Future<void> deleteAllTokens() async {
    // await _storage.delete(key: AppTexts.refrehTokenKey);
    await _storage.delete(key: AppTexts.accessTokenKey);
  }

  FlutterSecureStorage get flutterSecureStorage => _storage;
}

// 🚨 Standard Provider
final secureStorageProvider = Provider<SecureStorage>((ref) {
  const flutterSecureStorage = FlutterSecureStorage();
  return SecureStorage(flutterSecureStorage);
});