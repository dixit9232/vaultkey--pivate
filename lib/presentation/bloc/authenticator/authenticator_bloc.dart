import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/otp_service.dart';
import '../../../domain/repositories/authenticator_repository.dart';
import 'authenticator_event.dart';
import 'authenticator_state.dart';

/// BLoC for managing authenticator state
class AuthenticatorBloc extends Bloc<AuthenticatorEvent, AuthenticatorState> {
  final AuthenticatorRepository _repository;
  final OTPService _otpService;
  Timer? _otpTimer;

  AuthenticatorBloc({required AuthenticatorRepository repository, OTPService? otpService}) : _repository = repository, _otpService = otpService ?? OTPService.instance, super(const AuthenticatorState()) {
    on<AuthenticatorLoadRequested>(_onLoadRequested);
    on<AuthenticatorAddRequested>(_onAddRequested);
    on<AuthenticatorUpdateRequested>(_onUpdateRequested);
    on<AuthenticatorDeleteRequested>(_onDeleteRequested);
    on<AuthenticatorReorderRequested>(_onReorderRequested);
    on<AuthenticatorSearchRequested>(_onSearchRequested);
    on<AuthenticatorSearchCleared>(_onSearchCleared);
    on<AuthenticatorCopyCode>(_onCopyCode);
    on<AuthenticatorRefreshCodes>(_onRefreshCodes);

    // Start OTP timer
    _startOTPTimer();
  }

  void _startOTPTimer() {
    _otpTimer?.cancel();
    _otpTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      add(const AuthenticatorRefreshCodes());
    });
  }

  Future<void> _onLoadRequested(AuthenticatorLoadRequested event, Emitter<AuthenticatorState> emit) async {
    emit(state.copyWith(status: AuthenticatorStatus.loading));

    final result = await _repository.getAllAuthenticators();

    result.fold((failure) => emit(state.copyWith(status: AuthenticatorStatus.error, errorMessage: failure.message)), (authenticators) {
      final otpCodes = _generateAllOTPCodes(authenticators);
      final remaining = _otpService.getRemainingSeconds();
      final progress = _otpService.getProgress();

      emit(state.copyWith(status: AuthenticatorStatus.loaded, authenticators: authenticators, otpCodes: otpCodes, remainingSeconds: remaining, progress: progress, clearError: true));
    });
  }

  Future<void> _onAddRequested(AuthenticatorAddRequested event, Emitter<AuthenticatorState> emit) async {
    emit(state.copyWith(status: AuthenticatorStatus.loading));

    final result = await _repository.addAuthenticator(event.authenticator);

    result.fold((failure) => emit(state.copyWith(status: AuthenticatorStatus.loaded, errorMessage: failure.message)), (authenticator) {
      final updatedList = [...state.authenticators, authenticator];
      final otpCodes = _generateAllOTPCodes(updatedList);

      emit(state.copyWith(status: AuthenticatorStatus.loaded, authenticators: updatedList, otpCodes: otpCodes, successMessage: 'Authenticator added successfully', clearError: true));
    });
  }

  Future<void> _onUpdateRequested(AuthenticatorUpdateRequested event, Emitter<AuthenticatorState> emit) async {
    final result = await _repository.updateAuthenticator(event.authenticator);

    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (authenticator) {
      final updatedList = state.authenticators.map((a) => a.id == authenticator.id ? authenticator : a).toList();

      emit(state.copyWith(authenticators: updatedList, successMessage: 'Authenticator updated', clearError: true));
    });
  }

  Future<void> _onDeleteRequested(AuthenticatorDeleteRequested event, Emitter<AuthenticatorState> emit) async {
    final result = await _repository.deleteAuthenticator(event.id);

    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (_) {
      final updatedList = state.authenticators.where((a) => a.id != event.id).toList();
      final otpCodes = Map<String, String>.from(state.otpCodes)..remove(event.id);

      emit(state.copyWith(authenticators: updatedList, otpCodes: otpCodes, successMessage: 'Authenticator deleted', clearError: true));
    });
  }

  Future<void> _onReorderRequested(AuthenticatorReorderRequested event, Emitter<AuthenticatorState> emit) async {
    // Optimistically update UI
    emit(state.copyWith(authenticators: event.authenticators));

    final result = await _repository.reorderAuthenticators(event.authenticators);

    result.fold((failure) {
      // Revert on failure
      add(const AuthenticatorLoadRequested());
      emit(state.copyWith(errorMessage: failure.message));
    }, (_) {});
  }

  Future<void> _onSearchRequested(AuthenticatorSearchRequested event, Emitter<AuthenticatorState> emit) async {
    final result = await _repository.searchAuthenticators(event.query);

    result.fold((failure) => emit(state.copyWith(errorMessage: failure.message)), (filtered) => emit(state.copyWith(searchQuery: event.query, filteredAuthenticators: filtered)));
  }

  void _onSearchCleared(AuthenticatorSearchCleared event, Emitter<AuthenticatorState> emit) {
    emit(state.copyWith(clearSearch: true, filteredAuthenticators: []));
  }

  Future<void> _onCopyCode(AuthenticatorCopyCode event, Emitter<AuthenticatorState> emit) async {
    await Clipboard.setData(ClipboardData(text: event.code));

    emit(state.copyWith(successMessage: 'Code copied to clipboard', clearError: true));

    // Update last used time
    final authenticator = state.authenticators.firstWhere((a) => a.id == event.id, orElse: () => state.authenticators.first);

    final updated = authenticator.copyWith(lastUsedAt: DateTime.now());
    await _repository.updateAuthenticator(updated);
  }

  void _onRefreshCodes(AuthenticatorRefreshCodes event, Emitter<AuthenticatorState> emit) {
    final remaining = _otpService.getRemainingSeconds();
    final progress = _otpService.getProgress();

    // Only regenerate codes when the period resets
    if (remaining == 30 || state.otpCodes.isEmpty) {
      final otpCodes = _generateAllOTPCodes(state.authenticators);
      emit(state.copyWith(otpCodes: otpCodes, remainingSeconds: remaining, progress: progress, clearSuccess: true));
    } else {
      emit(state.copyWith(remainingSeconds: remaining, progress: progress, clearSuccess: true));
    }
  }

  Map<String, String> _generateAllOTPCodes(List authenticators) {
    final codes = <String, String>{};
    for (final auth in authenticators) {
      codes[auth.id] = _otpService.generateTOTP(secret: auth.secret, algorithm: auth.algorithm.name, digits: auth.digits, period: auth.period);
    }
    return codes;
  }

  @override
  Future<void> close() {
    _otpTimer?.cancel();
    return super.close();
  }
}
