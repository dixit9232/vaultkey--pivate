import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_form_state.dart';

/// Cubit for managing login form UI state
class LoginFormCubit extends Cubit<LoginFormState> {
  LoginFormCubit() : super(const LoginFormState());

  /// Toggle remember me
  void setRememberMe(bool value) {
    emit(state.copyWith(rememberMe: value));
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    emit(state.copyWith(isPasswordObscured: !state.isPasswordObscured));
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

  /// Clear all errors
  void clearErrors() {
    emit(state.copyWith(clearEmailError: true, clearPasswordError: true));
  }

  /// Reset form
  void resetForm() {
    emit(const LoginFormState());
  }
}
