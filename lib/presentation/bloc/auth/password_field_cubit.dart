import 'package:flutter_bloc/flutter_bloc.dart';

import 'register_form_state.dart';

/// Cubit for managing password field visibility state
class PasswordVisibilityCubit extends Cubit<bool> {
  PasswordVisibilityCubit() : super(true); // true = obscured

  /// Toggle visibility
  void toggle() => emit(!state);

  /// Show password
  void show() => emit(false);

  /// Hide password
  void hide() => emit(true);
}

/// Cubit for managing password strength state
class PasswordStrengthCubit extends Cubit<PasswordStrengthLevel> {
  PasswordStrengthCubit() : super(PasswordStrengthLevel.weak);

  /// Update strength based on password
  void updateStrength(String password) {
    emit(_calculateStrength(password));
  }

  /// Reset to weak
  void reset() => emit(PasswordStrengthLevel.weak);

  PasswordStrengthLevel _calculateStrength(String password) {
    if (password.isEmpty) return PasswordStrengthLevel.weak;

    int score = 0;

    // Length check
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
