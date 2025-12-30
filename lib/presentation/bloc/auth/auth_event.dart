import 'package:equatable/equatable.dart';

/// Base class for all auth events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Check current authentication status
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Sign in with email and password
class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  final bool rememberMe;

  const AuthSignInRequested({required this.email, required this.password, this.rememberMe = false});

  @override
  List<Object?> get props => [email, password, rememberMe];
}

/// Sign up with email and password
class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthSignUpRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Sign in with Google
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested();
}

/// Sign in with Microsoft
class AuthMicrosoftSignInRequested extends AuthEvent {
  const AuthMicrosoftSignInRequested();
}

/// Sign in with biometrics
class AuthBiometricSignInRequested extends AuthEvent {
  const AuthBiometricSignInRequested();
}

/// Sign out
class AuthSignOutRequested extends AuthEvent {
  const AuthSignOutRequested();
}

/// Send password reset email
class AuthPasswordResetRequested extends AuthEvent {
  final String email;

  const AuthPasswordResetRequested({required this.email});

  @override
  List<Object?> get props => [email];
}

/// Resend email verification
class AuthResendVerificationRequested extends AuthEvent {
  const AuthResendVerificationRequested();
}

/// Check if email is verified
class AuthCheckEmailVerificationRequested extends AuthEvent {
  const AuthCheckEmailVerificationRequested();
}

/// Update user's biometric preference
class AuthBiometricPreferenceChanged extends AuthEvent {
  final bool enabled;

  const AuthBiometricPreferenceChanged({required this.enabled});

  @override
  List<Object?> get props => [enabled];
}

/// Session timeout event
class AuthSessionTimeoutOccurred extends AuthEvent {
  const AuthSessionTimeoutOccurred();
}

/// App resumed from background - check if re-auth needed
class AuthAppResumed extends AuthEvent {
  const AuthAppResumed();
}
