import 'package:equatable/equatable.dart';

import '../../../domain/entities/authenticator_entity.dart' as entity;

/// Add Authenticator state
class AddAuthenticatorState extends Equatable {
  final entity.OTPType selectedType;
  final entity.Algorithm selectedAlgorithm;
  final int selectedDigits;
  final int selectedPeriod;
  final bool isLoading;
  final String? previewCode;
  final String? errorMessage;

  const AddAuthenticatorState({this.selectedType = entity.OTPType.totp, this.selectedAlgorithm = entity.Algorithm.sha1, this.selectedDigits = 6, this.selectedPeriod = 30, this.isLoading = false, this.previewCode, this.errorMessage});

  AddAuthenticatorState copyWith({entity.OTPType? selectedType, entity.Algorithm? selectedAlgorithm, int? selectedDigits, int? selectedPeriod, bool? isLoading, String? previewCode, String? errorMessage, bool clearPreview = false, bool clearError = false}) {
    return AddAuthenticatorState(
      selectedType: selectedType ?? this.selectedType,
      selectedAlgorithm: selectedAlgorithm ?? this.selectedAlgorithm,
      selectedDigits: selectedDigits ?? this.selectedDigits,
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      isLoading: isLoading ?? this.isLoading,
      previewCode: clearPreview ? null : (previewCode ?? this.previewCode),
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [selectedType, selectedAlgorithm, selectedDigits, selectedPeriod, isLoading, previewCode, errorMessage];
}
