import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/otp_service.dart';
import '../../../domain/entities/authenticator_entity.dart';
import 'qr_scanner_state.dart';

/// Cubit for managing QR scanner state
class QRScannerCubit extends Cubit<QRScannerState> {
  final OTPService _otpService;

  QRScannerCubit({OTPService? otpService}) : _otpService = otpService ?? OTPService.instance, super(const QRScannerState());

  /// Start processing a QR code
  void startProcessing() {
    emit(state.copyWith(isProcessing: true, clearError: true));
  }

  /// Process a QR code
  void processQRCode(String uri) {
    if (state.isProcessing) return;

    emit(state.copyWith(isProcessing: true, clearError: true));

    final otpAuth = _otpService.parseOTPAuthUri(uri);

    if (otpAuth == null) {
      emit(state.copyWith(isProcessing: false, errorMessage: 'Invalid QR code format'));
      return;
    }

    // Validate the secret
    if (!_otpService.isValidSecret(otpAuth.secret)) {
      emit(state.copyWith(isProcessing: false, errorMessage: 'Invalid secret key in QR code'));
      return;
    }

    // Create authenticator entity
    final authenticator = AuthenticatorEntity(
      id: const Uuid().v4(),
      issuer: otpAuth.issuer.isNotEmpty ? otpAuth.issuer : 'Unknown',
      accountName: otpAuth.accountName,
      secret: otpAuth.secret,
      type: otpAuth.isTotp ? OTPType.totp : OTPType.hotp,
      algorithm: _mapAlgorithm(otpAuth.algorithm),
      digits: otpAuth.digits,
      period: otpAuth.period,
      createdAt: DateTime.now(),
    );

    emit(state.copyWith(isProcessing: true, scannedAuthenticator: authenticator));
  }

  /// Reset the scanner state after confirmation dialog is dismissed
  void resetScanner() {
    emit(state.copyWith(isProcessing: false, clearError: true, clearAuthenticator: true));
  }

  /// Clear error message
  void clearError() {
    emit(state.copyWith(clearError: true));
  }

  Algorithm _mapAlgorithm(String algorithm) {
    switch (algorithm.toLowerCase()) {
      case 'sha256':
        return Algorithm.sha256;
      case 'sha512':
        return Algorithm.sha512;
      default:
        return Algorithm.sha1;
    }
  }
}
