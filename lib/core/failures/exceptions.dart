/// Custom exception classes
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  const AppException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() => 'AppException: $message (code: $code)';
}

/// Server exception for API errors
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.code,
    super.originalException,
  });
}

/// Network exception for connectivity issues
class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection',
    super.code = 'NETWORK_ERROR',
  });
}

/// Cache exception for local storage errors
class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache operation failed',
    super.code = 'CACHE_ERROR',
  });
}

/// Authentication exception
class AuthException extends AppException {
  const AuthException({required super.message, super.code});
}

/// Encryption exception
class EncryptionException extends AppException {
  const EncryptionException({
    super.message = 'Encryption/decryption failed',
    super.code = 'ENCRYPTION_ERROR',
  });
}

/// Validation exception
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code = 'VALIDATION_ERROR',
  });
}
