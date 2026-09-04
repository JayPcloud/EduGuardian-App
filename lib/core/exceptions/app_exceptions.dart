// Base exception for normal errors
class AppException implements Exception {
  final String message;
  AppException(this.message);

  @override
  String toString() => message; // Clean print without the "Exception:" prefix
}

// Specific exception for Auth flows (401 Unauthorized, etc.)
class AuthException extends AppException {
  AuthException(super.message);
}