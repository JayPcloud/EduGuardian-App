import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/texts.dart';
import '../../shared_features/auth/data/data_sources/auth_local_data_source.dart';
import '../../shared_features/auth/services/secure_storage.dart';
import 'interceptors/auth_interceptors.dart';

class ApiClient {
  final Dio dio;

  ApiClient({
    required SecureStorage storage,
    required VoidCallback onLogout,
  }) : dio = Dio() {
    dio.options.baseUrl = AppTexts.defaultApiBaseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (kDebugMode) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final client = HttpClient();
          // This tells Flutter to trust ANY certificate
          client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
          return client;
        },
      );
    }

    dio.interceptors.add(
      AuthInterceptor(
        storage: storage, 
        dio: dio, 
        logout: onLogout
      )
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: true, 
          responseBody: true,
          logPrint: (obj) => print("📡 API: $obj") 
        )
      );
    }
  }
  
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters}) {
    return dio.get(path, queryParameters: queryParameters);
  }
  
  Future<Response> post(String path, {dynamic data}) {
    return dio.post(path, data: data);
  }
}

// 🚨 Standard Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  final storage = ref.watch(secureStorageProvider);

  return ApiClient(
    storage: storage,
    onLogout: () {
      ref.read(authLocalDataSourceProvider).clearSession();
      // Make sure authStatusNotifierProvider is also migrated if needed!
      // ref.read(authStatusNotifierProvider.notifier).updateState(null);
    },
  );
});