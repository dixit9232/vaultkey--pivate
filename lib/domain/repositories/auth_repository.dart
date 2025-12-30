import 'package:fpdart/fpdart.dart';

import '../../core/failures/failures.dart';
import '../entities/user_entity.dart';

/// Abstract authentication repository contract
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password});

  /// Sign up with email and password
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({required String email, required String password});

  /// Sign in with Google
  Future<Either<Failure, UserEntity>> signInWithGoogle();

  /// Sign in with Microsoft
  Future<Either<Failure, UserEntity>> signInWithMicrosoft();

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Send email verification to current user
  Future<Either<Failure, void>> sendEmailVerification();

  /// Reload user to check verification status
  /// Returns true if email is now verified
  Future<Either<Failure, bool>> reloadUser();

  /// Get currently authenticated user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user is authenticated
  bool get isAuthenticated;

  /// Stream of auth state changes
  Stream<UserEntity?> get authStateChanges;
}
