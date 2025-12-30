import 'package:equatable/equatable.dart';

import '../../../domain/entities/subscription_entity.dart';

/// Subscription state
class SubscriptionState extends Equatable {
  final bool isYearly;
  final SubscriptionTier? selectedTier;
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;

  const SubscriptionState({this.isYearly = true, this.selectedTier, this.isLoading = false, this.errorMessage, this.successMessage});

  SubscriptionState copyWith({bool? isYearly, SubscriptionTier? selectedTier, bool? isLoading, String? errorMessage, String? successMessage, bool clearError = false, bool clearSuccess = false, bool clearTier = false}) {
    return SubscriptionState(
      isYearly: isYearly ?? this.isYearly,
      selectedTier: clearTier ? null : (selectedTier ?? this.selectedTier),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      successMessage: clearSuccess ? null : (successMessage ?? this.successMessage),
    );
  }

  @override
  List<Object?> get props => [isYearly, selectedTier, isLoading, errorMessage, successMessage];
}
