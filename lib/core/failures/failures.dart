import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Server failure for API/network errors
class ServerFailure extends Failure {
  const ServerFailure({required super.message, super.code});
}

/// Network failure for connectivity issues
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'No internet connection. Please check your network.',
    super.code = 'NETWORK_ERROR',
  });
}

/// Cache failure for local storage errors
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'Failed to access local storage.',
    super.code = 'CACHE_ERROR',
  });
}

/// Authentication failure
class AuthFailure extends Failure {
  const AuthFailure({required super.message, super.code});

  factory AuthFailure.invalidCredentials() => const AuthFailure(
    message: 'Invalid email or password.',
    code: 'INVALID_CREDENTIALS',
  );

  factory AuthFailure.userNotFound() =>
      const AuthFailure(message: 'User not found.', code: 'USER_NOT_FOUND');

  factory AuthFailure.emailAlreadyInUse() => const AuthFailure(
    message: 'Email is already in use.',
    code: 'EMAIL_ALREADY_IN_USE',
  );

  factory AuthFailure.weakPassword() => const AuthFailure(
    message: 'Password is too weak.',
    code: 'WEAK_PASSWORD',
  );

  factory AuthFailure.sessionExpired() => const AuthFailure(
    message: 'Session expired. Please sign in again.',
    code: 'SESSION_EXPIRED',
  );

  factory AuthFailure.unauthorized() =>
      const AuthFailure(message: 'Unauthorized access.', code: 'UNAUTHORIZED');
}

/// Validation failure for input errors
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code = 'VALIDATION_ERROR',
  });
}

/// Encryption failure for security operations
class EncryptionFailure extends Failure {
  const EncryptionFailure({
    super.message = 'Encryption/decryption failed.',
    super.code = 'ENCRYPTION_ERROR',
  });
}

/// Biometric failure
class BiometricFailure extends Failure {
  const BiometricFailure({required super.message, super.code});

  factory BiometricFailure.notAvailable() => const BiometricFailure(
    message: 'Biometric authentication is not available on this device.',
    code: 'BIOMETRIC_NOT_AVAILABLE',
  );

  factory BiometricFailure.notEnrolled() => const BiometricFailure(
    message:
        'No biometrics enrolled. Please set up biometrics in device settings.',
    code: 'BIOMETRIC_NOT_ENROLLED',
  );

  factory BiometricFailure.failed() => const BiometricFailure(
    message: 'Biometric authentication failed.',
    code: 'BIOMETRIC_FAILED',
  );

  factory BiometricFailure.cancelled() => const BiometricFailure(
    message: 'Biometric authentication was cancelled.',
    code: 'BIOMETRIC_CANCELLED',
  );
}

/// Permission failure
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code = 'PERMISSION_DENIED',
  });

  factory PermissionFailure.camera() => const PermissionFailure(
    message: 'Camera permission is required to scan QR codes.',
    code: 'CAMERA_PERMISSION_DENIED',
  );
}

/// Unknown failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'Something went wrong. Please try again.',
    super.code = 'UNKNOWN_ERROR',
  });
}
