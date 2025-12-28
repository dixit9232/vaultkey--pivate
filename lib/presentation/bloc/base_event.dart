import 'package:equatable/equatable.dart';

/// Base class for all BLoC events
abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}
