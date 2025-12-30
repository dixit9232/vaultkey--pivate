import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../failures/exceptions.dart';

/// Service for handling Microsoft Sign-In authentication
abstract class MicrosoftAuthService {
  /// Sign in with Microsoft and return Firebase credential
  Future<OAuthCredential> signIn();

  /// Sign out from Microsoft
  Future<void> signOut();

  /// Check if user is signed in with Microsoft
  bool get isSignedIn;
}

/// Implementation of Microsoft auth service using Firebase's OAuthProvider
class MicrosoftAuthServiceImpl implements MicrosoftAuthService {
  final FirebaseAuth _firebaseAuth;
  bool _isSignedIn = false;

  // Microsoft OAuth provider for Firebase
  static final OAuthProvider _microsoftProvider = OAuthProvider('microsoft.com')
    ..addScope('email')
    ..addScope('profile')
    ..setCustomParameters({
      'prompt': 'select_account',
      'tenant': 'common', // Allows personal and work accounts
    });

  MicrosoftAuthServiceImpl({FirebaseAuth? firebaseAuth}) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<OAuthCredential> signIn() async {
    try {
      UserCredential userCredential;

      if (kIsWeb) {
        // Web: Use popup sign-in
        userCredential = await _firebaseAuth.signInWithPopup(_microsoftProvider);
      } else {
        // Mobile: Use redirect-based sign-in
        userCredential = await _firebaseAuth.signInWithProvider(_microsoftProvider);
      }

      // Get the credential from the result
      final credential = userCredential.credential;
      if (credential == null) {
        throw AuthException(message: 'Failed to get Microsoft credentials', code: 'MICROSOFT_CREDENTIAL_ERROR');
      }

      _isSignedIn = true;

      // Return the OAuthCredential
      return credential as OAuthCredential;
    } on FirebaseAuthException catch (e) {
      _isSignedIn = false;
      throw AuthException(message: _mapFirebaseError(e), code: e.code);
    } catch (e) {
      _isSignedIn = false;
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Microsoft sign-in failed: $e', code: 'MICROSOFT_SIGN_IN_ERROR');
    }
  }

  @override
  Future<void> signOut() async {
    _isSignedIn = false;
    // Microsoft sign-out is handled by Firebase signOut
    // No additional cleanup needed for OAuth providers
  }

  @override
  bool get isSignedIn => _isSignedIn;

  /// Map Firebase auth errors to user-friendly messages
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'account-exists-with-different-credential':
        return 'An account already exists with a different sign-in method. Please sign in using that method.';
      case 'invalid-credential':
        return 'The Microsoft credential is invalid. Please try again.';
      case 'operation-not-allowed':
        return 'Microsoft sign-in is not enabled. Please contact support.';
      case 'user-disabled':
        return 'This account has been disabled. Please contact support.';
      case 'user-not-found':
        return 'No account found with this Microsoft account.';
      case 'popup-closed-by-user':
      case 'cancelled':
        return 'Sign-in was cancelled.';
      case 'popup-blocked':
        return 'Sign-in popup was blocked. Please allow popups and try again.';
      case 'network-request-failed':
        return 'Network error. Please check your connection and try again.';
      default:
        return e.message ?? 'Microsoft sign-in failed. Please try again.';
    }
  }
}
