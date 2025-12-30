import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/services/otp_service.dart';
import '../../../domain/entities/authenticator_entity.dart' as entity;
import 'add_authenticator_state.dart';

/// Cubit for managing add authenticator form state
class AddAuthenticatorCubit extends Cubit<AddAuthenticatorState> {
  final OTPService _otpService;

  AddAuthenticatorCubit({OTPService? otpService}) : _otpService = otpService ?? OTPService.instance, super(const AddAuthenticatorState());

  /// Update OTP type
  void setType(entity.OTPType type) {
    emit(state.copyWith(selectedType: type));
  }

  /// Update algorithm
  void setAlgorithm(entity.Algorithm algorithm) {
    emit(state.copyWith(selectedAlgorithm: algorithm));
    // Regenerate preview with new algorithm
  }

  /// Update digits
  void setDigits(int digits) {
    emit(state.copyWith(selectedDigits: digits));
  }

  /// Update period
  void setPeriod(int period) {
    emit(state.copyWith(selectedPeriod: period));
  }

  /// Generate preview code
  void generatePreview(String secret) {
    final secretUpper = secret.trim().toUpperCase();
    if (secretUpper.isEmpty) {
      emit(state.copyWith(clearPreview: true));
      return;
    }

    if (_otpService.isValidSecret(secretUpper)) {
      final code = _otpService.generateTOTP(secret: secretUpper, algorithm: state.selectedAlgorithm.name, digits: state.selectedDigits, period: state.selectedPeriod);
      emit(state.copyWith(previewCode: code));
    } else {
      emit(state.copyWith(clearPreview: true));
    }
  }

  /// Set loading state
  void setLoading(bool loading) {
    emit(state.copyWith(isLoading: loading));
  }

  /// Set error message
  void setError(String? error) {
    if (error == null) {
      emit(state.copyWith(clearError: true));
    } else {
      emit(state.copyWith(errorMessage: error));
    }
  }

  /// Validate secret
  bool validateSecret(String secret) {
    return _otpService.isValidSecret(secret.trim().toUpperCase());
  }
}
