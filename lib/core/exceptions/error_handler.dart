import 'package:dio/dio.dart';
import 'app_exceptions.dart';

class ErrorHandler {
  /// Takes any raw error, figures out what happened, and returns a clean AppException
  static AppException parse(dynamic error) {
    if (error is DioException) {
      return _handleDioError(error);
    }
    // If it's a generic Dart error (e.g., a typo in your own code throwing a TypeError)
    return AppException('An unexpected error occurred. Please try again.');
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      // --- NETWORK ERRORS ---
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return AppException('Connection timed out. Please check your internet.');
      case DioExceptionType.connectionError:
        return AppException('No internet connection. Please try again.');
        
      // --- BACKEND RESPONSE ERRORS ---
      case DioExceptionType.badResponse:
        return _parseBadResponse(error.response);
          
      default:
        return AppException('Network error. Please try again.');
    }
  }

  static AppException _parseBadResponse(Response? response) {
    if (response == null) return AppException('Invalid response from server.');

    final statusCode = response.statusCode;
    final data = response.data;

    // 🚨 500 SERVER ERROR (Your exact requirement)
    if (statusCode == 500 || statusCode == 502 || statusCode == 504) {
      return AppException('Something went wrong, please try again.');
    }

    // 🚨 401 UNAUTHORIZED (Auth Exception)
    if (statusCode == 401) {
      final msg = _extractDjangoMessage(data) ?? 'Session expired or invalid credentials.';
      return AuthException(msg);
    }

    // 🚨 400 BAD REQUEST & OTHER 4xx ERRORS
    final msg = _extractDjangoMessage(data) ?? 'An error occurred (Code: $statusCode).';
    return AppException(msg);
  }

  /// The ultimate Django Rest Framework error parser!
  /// The ultimate Django Rest Framework error parser!
  /// The ultimate Django Rest Framework error parser!
  static String? _extractDjangoMessage(dynamic data) {
    String? rawMessage;

    if (data is Map<String, dynamic>) {
      // 🚨 THE FIX: A helper to strip brackets if Django sends the error inside a List ["..."]
      String? extractCleanString(dynamic value) {
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value != null) return value.toString();
        return null;
      }

      if (data.containsKey('message')) {
        rawMessage = extractCleanString(data['message']);
      } else if (data.containsKey('detail')) {
        rawMessage = extractCleanString(data['detail']);
      } else if (data.containsKey('error')) {
        rawMessage = extractCleanString(data['error']);
      } else if (data.isNotEmpty) {
        rawMessage = extractCleanString(data.values.first);
      }
    }else if(data is List) {
      if(data.first is String) {
        rawMessage = data.first;
      }
    } else if (data is String) {
      rawMessage = data;
    }

    // 🚨 If we didn't find anything, return null so the fallback kicks in
    if (rawMessage == null || rawMessage.trim().isEmpty) return null;

    // 🚨 THE SMART TRIM LOGIC 🚨
    
    // 1. If Django dumped an HTML error page, hide it completely.
    if (rawMessage.contains('<html') || rawMessage.contains('<!DOCTYPE')) {
      return 'An error occurred. Please try again.';
    }

    // 2. If it's just a really long text string, trim it to 200 characters
    if (rawMessage.length > 200) {
      // Substring grabs the first 150 chars, and we add '...' at the end
      return '${rawMessage.substring(0, 150)}...';
    }

    // Just a final safety sweep to remove any stray literal quotation marks
    return rawMessage.replaceAll('"', '').trim();
  }
}