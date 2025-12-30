import 'package:equatable/equatable.dart';

import '../../../domain/entities/authenticator_entity.dart';

/// QR Scanner state
class QRScannerState extends Equatable {
  final bool isProcessing;
  final String? errorMessage;
  final AuthenticatorEntity? scannedAuthenticator;

  const QRScannerState({this.isProcessing = false, this.errorMessage, this.scannedAuthenticator});

  QRScannerState copyWith({bool? isProcessing, String? errorMessage, AuthenticatorEntity? scannedAuthenticator, bool clearError = false, bool clearAuthenticator = false}) {
    return QRScannerState(isProcessing: isProcessing ?? this.isProcessing, errorMessage: clearError ? null : (errorMessage ?? this.errorMessage), scannedAuthenticator: clearAuthenticator ? null : (scannedAuthenticator ?? this.scannedAuthenticator));
  }

  @override
  List<Object?> get props => [isProcessing, errorMessage, scannedAuthenticator];
}
