import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../failures/exceptions.dart';

/// Service for handling Google Sign-In authentication
abstract class GoogleAuthService {
  /// Sign in with Google and return Firebase credential
  Future<OAuthCredential> signIn();

  /// Sign out from Google
  Future<void> signOut();

  /// Check if user is signed in with Google
  bool get isSignedIn;
}

/// Implementation of Google auth service
class GoogleAuthServiceImpl implements GoogleAuthService {
  final GoogleSignIn _googleSignIn;

  GoogleAuthServiceImpl({GoogleSignIn? googleSignIn}) : _googleSignIn = googleSignIn ?? GoogleSignIn(scopes: ['email', 'profile']);

  @override
  Future<OAuthCredential> signIn() async {
    try {
      // Trigger the authentication flow
      final googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw const AuthException(message: 'Google sign-in was cancelled', code: 'GOOGLE_SIGN_IN_CANCELLED');
      }

      // Obtain the auth details from the request
      final googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      return credential;
    } on PlatformException catch (e) {
      throw AuthException(message: 'Google sign-in failed: ${e.message}', code: e.code);
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException(message: 'Google sign-in failed: $e', code: 'GOOGLE_SIGN_IN_ERROR');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
    } catch (e) {
      // Ignore sign-out errors
    }
  }

  @override
  bool get isSignedIn => _googleSignIn.currentUser != null;
}
