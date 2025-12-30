import 'package:equatable/equatable.dart';

import '../../../domain/entities/authenticator_entity.dart';

/// Authenticator events
abstract class AuthenticatorEvent extends Equatable {
  const AuthenticatorEvent();

  @override
  List<Object?> get props => [];
}

/// Load all authenticators
class AuthenticatorLoadRequested extends AuthenticatorEvent {
  const AuthenticatorLoadRequested();
}

/// Add new authenticator
class AuthenticatorAddRequested extends AuthenticatorEvent {
  final AuthenticatorEntity authenticator;

  const AuthenticatorAddRequested(this.authenticator);

  @override
  List<Object?> get props => [authenticator];
}

/// Update authenticator
class AuthenticatorUpdateRequested extends AuthenticatorEvent {
  final AuthenticatorEntity authenticator;

  const AuthenticatorUpdateRequested(this.authenticator);

  @override
  List<Object?> get props => [authenticator];
}

/// Delete authenticator
class AuthenticatorDeleteRequested extends AuthenticatorEvent {
  final String id;

  const AuthenticatorDeleteRequested(this.id);

  @override
  List<Object?> get props => [id];
}

/// Reorder authenticators
class AuthenticatorReorderRequested extends AuthenticatorEvent {
  final List<AuthenticatorEntity> authenticators;

  const AuthenticatorReorderRequested(this.authenticators);

  @override
  List<Object?> get props => [authenticators];
}

/// Search authenticators
class AuthenticatorSearchRequested extends AuthenticatorEvent {
  final String query;

  const AuthenticatorSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

/// Clear search
class AuthenticatorSearchCleared extends AuthenticatorEvent {
  const AuthenticatorSearchCleared();
}

/// Copy OTP code to clipboard
class AuthenticatorCopyCode extends AuthenticatorEvent {
  final String id;
  final String code;

  const AuthenticatorCopyCode({required this.id, required this.code});

  @override
  List<Object?> get props => [id, code];
}

/// Refresh OTP codes
class AuthenticatorRefreshCodes extends AuthenticatorEvent {
  const AuthenticatorRefreshCodes();
}
