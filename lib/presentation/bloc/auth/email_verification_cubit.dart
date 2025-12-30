import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing email verification UI state
class EmailVerificationCubit extends Cubit<EmailVerificationState> {
  Timer? _cooldownTimer;

  EmailVerificationCubit() : super(const EmailVerificationState());

  void startResendCooldown() {
    emit(state.copyWith(canResend: false, resendCooldown: 60));

    _cooldownTimer?.cancel();
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final newCooldown = state.resendCooldown - 1;
      if (newCooldown <= 0) {
        timer.cancel();
        emit(state.copyWith(canResend: true, resendCooldown: 0));
      } else {
        emit(state.copyWith(resendCooldown: newCooldown));
      }
    });
  }

  @override
  Future<void> close() {
    _cooldownTimer?.cancel();
    return super.close();
  }
}

class EmailVerificationState extends Equatable {
  final bool canResend;
  final int resendCooldown;

  const EmailVerificationState({this.canResend = true, this.resendCooldown = 0});

  EmailVerificationState copyWith({bool? canResend, int? resendCooldown}) {
    return EmailVerificationState(canResend: canResend ?? this.canResend, resendCooldown: resendCooldown ?? this.resendCooldown);
  }

  @override
  List<Object?> get props => [canResend, resendCooldown];
}
