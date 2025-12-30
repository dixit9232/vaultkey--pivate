import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart' as local_auth;

/// Service for handling biometric authentication
abstract class BiometricService {
  /// Check if biometric authentication is available
  Future<bool> isAvailable();

  /// Check if device has enrolled biometrics
  Future<bool> hasEnrolledBiometrics();

  /// Get available biometric types
  Future<List<local_auth.BiometricType>> getAvailableBiometrics();

  /// Authenticate using biometrics
  Future<bool> authenticate({required String reason});

  /// Cancel ongoing authentication
  Future<void> cancelAuthentication();
}

/// Implementation of biometric service using local_auth package
class BiometricServiceImpl implements BiometricService {
  final local_auth.LocalAuthentication _localAuth;

  BiometricServiceImpl({local_auth.LocalAuthentication? localAuth}) : _localAuth = localAuth ?? local_auth.LocalAuthentication();

  @override
  Future<bool> isAvailable() async {
    try {
      // Check if device supports biometrics
      final canAuthenticateWithBiometrics = await _localAuth.canCheckBiometrics;
      final canAuthenticate = await _localAuth.isDeviceSupported();
      return canAuthenticateWithBiometrics && canAuthenticate;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<bool> hasEnrolledBiometrics() async {
    try {
      final biometrics = await _localAuth.getAvailableBiometrics();
      return biometrics.isNotEmpty;
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<List<local_auth.BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuth.authenticate(localizedReason: reason, options: const local_auth.AuthenticationOptions(stickyAuth: true, biometricOnly: true, useErrorDialogs: true, sensitiveTransaction: true));
    } on PlatformException {
      return false;
    }
  }

  @override
  Future<void> cancelAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } on PlatformException {
      // Ignore cancellation errors
    }
  }
}
