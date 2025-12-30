import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_form_state.dart';

/// Cubit for managing register form UI state
class RegisterFormCubit extends Cubit<RegisterFormState> {
  RegisterFormCubit() : super(const RegisterFormState());

  /// Set accepted terms
  void setAcceptedTerms(bool value) {
    emit(state.copyWith(acceptedTerms: value));
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    emit(state.copyWith(isConfirmPasswordObscured: !state.isConfirmPasswordObscured));
  }

  /// Update password strength
  void updatePasswordStrength(String password) {
    emit(state.copyWith(passwordStrength: _calculateStrength(password)));
  }

  /// Set email error
  void setEmailError(String? error) {
    if (error == null) {
      emit(state.copyWith(clearEmailError: true));
    } else {
      emit(state.copyWith(emailError: error));
    }
  }

  /// Set password error
  void setPasswordError(String? error) {
    if (error == null) {
      emit(state.copyWith(clearPasswordError: true));
    } else {
      emit(state.copyWith(passwordError: error));
    }
  }

  /// Set confirm password error
  void setConfirmPasswordError(String? error) {
    if (error == null) {
      emit(state.copyWith(clearConfirmPasswordError: true));
    } else {
      emit(state.copyWith(confirmPasswordError: error));
    }
  }

  /// Clear all errors
  void clearErrors() {
    emit(state.copyWith(clearEmailError: true, clearPasswordError: true, clearConfirmPasswordError: true));
  }

  /// Reset form
  void resetForm() {
    emit(const RegisterFormState());
  }

  /// Calculate password strength
  PasswordStrengthLevel _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrengthLevel.weak;

    int score = 0;

    // Length checks
    if (password.length >= 8) score++;
    if (password.length >= 12) score++;

    // Character type checks
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrengthLevel.weak;
    if (score <= 4) return PasswordStrengthLevel.fair;
    if (score <= 5) return PasswordStrengthLevel.good;
    return PasswordStrengthLevel.strong;
  }
}
