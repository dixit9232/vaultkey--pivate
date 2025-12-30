import 'package:equatable/equatable.dart';

/// Register form UI state
class RegisterFormState extends Equatable {
  /// Whether terms are accepted
  final bool acceptedTerms;

  /// Whether password is obscured
  final bool isPasswordObscured;

  /// Whether confirm password is obscured
  final bool isConfirmPasswordObscured;

  /// Email field error message
  final String? emailError;

  /// Password field error message
  final String? passwordError;

  /// Confirm password error message
  final String? confirmPasswordError;

  /// Current password strength level
  final PasswordStrengthLevel passwordStrength;

  const RegisterFormState({this.acceptedTerms = false, this.isPasswordObscured = true, this.isConfirmPasswordObscured = true, this.emailError, this.passwordError, this.confirmPasswordError, this.passwordStrength = PasswordStrengthLevel.weak});

  /// Check if form is valid
  bool get isValid => acceptedTerms && emailError == null && passwordError == null && confirmPasswordError == null && passwordStrength.index >= PasswordStrengthLevel.fair.index;

  RegisterFormState copyWith({
    bool? acceptedTerms,
    bool? isPasswordObscured,
    bool? isConfirmPasswordObscured,
    String? emailError,
    String? passwordError,
    String? confirmPasswordError,
    PasswordStrengthLevel? passwordStrength,
    bool clearEmailError = false,
    bool clearPasswordError = false,
    bool clearConfirmPasswordError = false,
  }) {
    return RegisterFormState(
      acceptedTerms: acceptedTerms ?? this.acceptedTerms,
      isPasswordObscured: isPasswordObscured ?? this.isPasswordObscured,
      isConfirmPasswordObscured: isConfirmPasswordObscured ?? this.isConfirmPasswordObscured,
      emailError: clearEmailError ? null : (emailError ?? this.emailError),
      passwordError: clearPasswordError ? null : (passwordError ?? this.passwordError),
      confirmPasswordError: clearConfirmPasswordError ? null : (confirmPasswordError ?? this.confirmPasswordError),
      passwordStrength: passwordStrength ?? this.passwordStrength,
    );
  }

  @override
  List<Object?> get props => [acceptedTerms, isPasswordObscured, isConfirmPasswordObscured, emailError, passwordError, confirmPasswordError, passwordStrength];
}

/// Password strength levels
enum PasswordStrengthLevel {
  /// Weak password (score <= 2)
  weak(0.25, 'Weak'),

  /// Fair password (score <= 4)
  fair(0.5, 'Fair'),

  /// Good password (score <= 5)
  good(0.75, 'Good'),

  /// Strong password (score > 5)
  strong(1.0, 'Strong');

  /// Progress value for UI (0.0 to 1.0)
  final double progress;

  /// Display label
  final String label;

  const PasswordStrengthLevel(this.progress, this.label);
}
