import 'package:equatable/equatable.dart';

import '../../../domain/entities/user_entity.dart';

/// Authentication status enum
enum AuthStatus {
  /// Initial state, checking auth
  initial,

  /// User is authenticated
  authenticated,

  /// User is not authenticated
  unauthenticated,

  /// Authentication in progress
  loading,

  /// Email verification pending
  emailVerificationPending,

  /// Biometric authentication required
  biometricRequired,
}

/// Authentication state
class AuthState extends Equatable {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;
  final String? successMessage;
  final bool biometricEnabled;
  final bool biometricAvailable;
  final int failedAttempts;
  final DateTime? lockoutUntil;

  const AuthState({this.status = AuthStatus.initial, this.user, this.errorMessage, this.successMessage, this.biometricEnabled = false, this.biometricAvailable = false, this.failedAttempts = 0, this.lockoutUntil});

  /// Initial state
  factory AuthState.initial() => const AuthState(status: AuthStatus.initial);

  /// Check if user is authenticated
  bool get isAuthenticated => status == AuthStatus.authenticated;

  /// Check if user is loading
  bool get isLoading => status == AuthStatus.loading;

  /// Check if account is locked out
  bool get isLockedOut => lockoutUntil != null && DateTime.now().isBefore(lockoutUntil!);

  /// Get remaining lockout time in seconds
  int get lockoutRemainingSeconds {
    if (lockoutUntil == null) return 0;
    final remaining = lockoutUntil!.difference(DateTime.now()).inSeconds;
    return remaining > 0 ? remaining : 0;
  }

  @override
  List<Object?> get props => [status, user, errorMessage, successMessage, biometricEnabled, biometricAvailable, failedAttempts, lockoutUntil];

  /// Copy with method
  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
    String? successMessage,
    bool? biometricEnabled,
    bool? biometricAvailable,
    int? failedAttempts,
    DateTime? lockoutUntil,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearUser = false,
    bool clearLockout = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: clearUser ? null : (user ?? this.user),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      biometricAvailable: biometricAvailable ?? this.biometricAvailable,
      failedAttempts: failedAttempts ?? this.failedAttempts,
      lockoutUntil: clearLockout ? null : (lockoutUntil ?? this.lockoutUntil),
    );
  }
}
