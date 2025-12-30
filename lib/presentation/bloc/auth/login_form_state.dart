import 'package:equatable/equatable.dart';

/// Login form UI state
class LoginFormState extends Equatable {
  /// Whether "Remember Me" is checked
  final bool rememberMe;

  /// Whether password is obscured
  final bool isPasswordObscured;

  /// Email field error message
  final String? emailError;

  /// Password field error message
  final String? passwordError;

  const LoginFormState({this.rememberMe = false, this.isPasswordObscured = true, this.emailError, this.passwordError});

  /// Check if form is valid (no errors)
  bool get isValid => emailError == null && passwordError == null;

  LoginFormState copyWith({bool? rememberMe, bool? isPasswordObscured, String? emailError, String? passwordError, bool clearEmailError = false, bool clearPasswordError = false}) {
    return LoginFormState(rememberMe: rememberMe ?? this.rememberMe, isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured, emailError: clearEmailError ? null : (emailError ?? this.emailError), passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError));
  }

  @override
  List<Object?> get props => [rememberMe, isPasswordObscured, emailError, passwordError];
}
