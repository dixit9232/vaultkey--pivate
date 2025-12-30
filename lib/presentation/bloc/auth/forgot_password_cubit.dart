import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Cubit for managing forgot password form state
class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit() : super(const ForgotPasswordState());

  void setEmailSent(bool sent) {
    emit(state.copyWith(emailSent: sent));
  }

  void resetForm() {
    emit(const ForgotPasswordState());
  }
}

class ForgotPasswordState extends Equatable {
  final bool emailSent;

  const ForgotPasswordState({this.emailSent = false});

  ForgotPasswordState copyWith({bool? emailSent}) {
    return ForgotPasswordState(emailSent: emailSent ?? this.emailSent);
  }

  @override
  List<Object?> get props => [emailSent];
}
