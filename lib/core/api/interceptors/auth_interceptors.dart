import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../shared_features/auth/services/secure_storage.dart';
import '../../constants/texts.dart';


class AuthInterceptor extends Interceptor {
  final SecureStorage _storage;
  final Dio _dio;
  final VoidCallback logout; // <-- CHANGED: Simple callback instead of Notifier

  AuthInterceptor({
    required SecureStorage storage,
    required Dio dio,
    required this.logout,
  })  : _storage = storage,
        _dio = dio;

  // Mutex/Lock to prevent multiple refresh calls at once
  // Future<String?>? _refreshTokenFuture;

  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    // 1. Get Access Token
    final token = await _storage.getAccessToken(); // Ensure method is getAccessToken
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 🚨 ULTIMATE ANTI-LOOP SAFEGUARD
    // If we already retried this exact request and it STILL failed, don't loop again.
    if (err.requestOptions.extra['isRetry'] == true) {
      if (err.response?.statusCode == 401) logout();
      return handler.next(err);
    }

    // 1. Check for 401 Unauthorized
    if (err.response?.statusCode == 401) {
      logout();
      // final refreshToken = await _storage.getRefreshToken();

      // if (refreshToken != null) {
      //   String? newAccessToken;
        
      //   // 🚨 ISOLATED BLOCK 1: Refresh Logic with Smart Network Checking
      //   try {
      //     newAccessToken = await (_refreshTokenFuture ??= _refresh(refreshToken));
      //   } on DioException catch (e) {
      //     final isNetworkIssue = e.type == DioExceptionType.connectionError ||
      //                            e.type == DioExceptionType.connectionTimeout ||
      //                            e.type == DioExceptionType.receiveTimeout;
                                 
      //     final isServerCrash = e.response?.statusCode != null && e.response!.statusCode! >= 500;

      //     if (isNetworkIssue || isServerCrash) {
      //       return handler.reject(e);
      //     }

      //     logout();
      //     return handler.reject(err);
      //   } finally {
      //     _refreshTokenFuture = null; 
      //   }

      //   // 🚨 ISOLATED BLOCK 2: Retry Original Request
      //   if (newAccessToken != null) {
      //     try {
      //       final opts = err.requestOptions;
      //       opts.headers['Authorization'] = 'Bearer $newAccessToken';
            
      //       // Flag this request so it can NEVER trigger a refresh loop again
      //       opts.extra['isRetry'] = true; 
            
      //       // Fix for Form-Data data failing immediately after refresh
      //       if (opts.data is FormData) {
      //         opts.data = (opts.data as FormData).clone();
      //       }
      //       // Retry the original request
      //       final response = await _dio.fetch(opts);
      //       return handler.resolve(response);
            
      //     } on DioException catch (retryErr) {
      //       return handler.reject(retryErr);
      //     }
      //   }
      // } else {
      //   logout();
      //   return handler.reject(err);
      // }
    }
    
    return handler.next(err);
  }


  Future<String?> _refresh(String refreshToken) async {
    try {
      // Use a FRESH Dio instance to avoid interceptor loops
      final refreshDio = Dio(BaseOptions(baseUrl: _dio.options.baseUrl));

      // Django SimpleJWT standard endpoint
      final response = await refreshDio.post('/accounts/token/refresh/', data: {
        'refresh': refreshToken, 
      });

      // Django SimpleJWT returns 'access'
      final newAccessToken = response.data[AppTexts.accessTokenKey]; 
      // it rotates the refresh token too
      final newRefreshToken = response.data[AppTexts.refrehTokenKey]; 

      if (newAccessToken != null) {
        await _storage.saveAccessToken(newAccessToken);
      }
      
      if (newRefreshToken != null) {
        await _storage.saveRefreshToken(newRefreshToken);
      }

      return newAccessToken;
    } catch (e) {
      rethrow; // Let onError handle the logout
    }
  }



  //@override
  // void onError(DioException err, ErrorInterceptorHandler handler) async {
  //   // 1. Check for 401 Unauthorized
  //   if (err.response?.statusCode == 401) {
  //     final refreshToken = await _storage.getRefreshToken();

  //     if (refreshToken != null) {
  //       try {
  //         // 2. Refresh Token (Wait if another request is already refreshing)
  //         final newAccessToken =
  //             await (_refreshTokenFuture ??= _refresh(refreshToken));

  //         if (newAccessToken != null) {
  //           // 3. Retry original request
  //           final opts = err.requestOptions;
  //           opts.headers['Authorization'] = 'Bearer $newAccessToken';
            
  //           // Use _dio.fetch to retry
  //           final response = await _dio.fetch(opts);
  //           return handler.resolve(response);
  //         }
  //       } catch (e) {
  //         // 4. Refresh Failed? Logout.
  //         _refreshTokenFuture = null;
  //         onLogout(); // Trigger logout in UI
  //         return handler.reject(err);
  //       } finally {
  //         _refreshTokenFuture = null; // Release lock
  //       }
  //     } else {
  //       // No refresh token? Logout.
  //       onLogout();
  //     }
  //   }
  //   return handler.next(err);
  // }
}