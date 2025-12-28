import 'package:equatable/equatable.dart';

/// Base status enum for BLoC states
enum BaseStatus { initial, loading, success, failure }

/// Base class for all BLoC states
abstract class BaseState extends Equatable {
  final BaseStatus status;
  final String? errorMessage;

  const BaseState({this.status = BaseStatus.initial, this.errorMessage});

  /// Check if state is initial
  bool get isInitial => status == BaseStatus.initial;

  /// Check if state is loading
  bool get isLoading => status == BaseStatus.loading;

  /// Check if state is success
  bool get isSuccess => status == BaseStatus.success;

  /// Check if state is failure
  bool get isFailure => status == BaseStatus.failure;

  @override
  List<Object?> get props => [status, errorMessage];
}
