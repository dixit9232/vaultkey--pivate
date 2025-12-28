import 'package:fpdart/fpdart.dart';

import '../../core/failures/failures.dart';
import '../entities/user_entity.dart';

/// Abstract authentication repository contract
abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password});

  /// Sign up with email and password
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({required String email, required String password});

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Get currently authenticated user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Check if user is authenticated
  bool get isAuthenticated;
}
