import 'package:equatable/equatable.dart';

import '../../../domain/entities/authenticator_entity.dart';

/// Authenticator loading status
enum AuthenticatorStatus { initial, loading, loaded, error }

/// Authenticator state
class AuthenticatorState extends Equatable {
  final AuthenticatorStatus status;
  final List<AuthenticatorEntity> authenticators;
  final List<AuthenticatorEntity> filteredAuthenticators;
  final Map<String, String> otpCodes;
  final String? searchQuery;
  final String? errorMessage;
  final String? successMessage;
  final int remainingSeconds;
  final double progress;

  const AuthenticatorState({this.status = AuthenticatorStatus.initial, this.authenticators = const [], this.filteredAuthenticators = const [], this.otpCodes = const {}, this.searchQuery, this.errorMessage, this.successMessage, this.remainingSeconds = 30, this.progress = 0.0});

  /// Check if loading
  bool get isLoading => status == AuthenticatorStatus.loading;

  /// Check if loaded
  bool get isLoaded => status == AuthenticatorStatus.loaded;

  /// Check if empty
  bool get isEmpty => authenticators.isEmpty;

  /// Check if searching
  bool get isSearching => searchQuery != null && searchQuery!.isNotEmpty;

  /// Get displayed authenticators (filtered or all)
  List<AuthenticatorEntity> get displayedAuthenticators => isSearching ? filteredAuthenticators : authenticators;

  /// Copy with updated fields
  AuthenticatorState copyWith({
    AuthenticatorStatus? status,
    List<AuthenticatorEntity>? authenticators,
    List<AuthenticatorEntity>? filteredAuthenticators,
    Map<String, String>? otpCodes,
    String? searchQuery,
    String? errorMessage,
    String? successMessage,
    int? remainingSeconds,
    double? progress,
    bool clearError = false,
    bool clearSuccess = false,
    bool clearSearch = false,
  }) {
    return AuthenticatorState(
      status: status ?? this.status,
      authenticators: authenticators ?? this.authenticators,
      filteredAuthenticators: filteredAuthenticators ?? this.filteredAuthenticators,
      otpCodes: otpCodes ?? this.otpCodes,
      searchQuery: clearSearch ? null : (searchQuery ?? this.searchQuery),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [status, authenticators, filteredAuthenticators, otpCodes, searchQuery, errorMessage, successMessage, remainingSeconds, progress];
}
