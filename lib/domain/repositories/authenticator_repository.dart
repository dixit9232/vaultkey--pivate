import 'package:fpdart/fpdart.dart';

import '../../core/failures/failures.dart';
import '../entities/authenticator_entity.dart';

/// Abstract authenticator repository contract
abstract class AuthenticatorRepository {
  /// Get all authenticators
  Future<Either<Failure, List<AuthenticatorEntity>>> getAllAuthenticators();

  /// Get authenticator by ID
  Future<Either<Failure, AuthenticatorEntity?>> getAuthenticatorById(String id);

  /// Add new authenticator
  Future<Either<Failure, AuthenticatorEntity>> addAuthenticator(AuthenticatorEntity authenticator);

  /// Update authenticator
  Future<Either<Failure, AuthenticatorEntity>> updateAuthenticator(AuthenticatorEntity authenticator);

  /// Delete authenticator
  Future<Either<Failure, void>> deleteAuthenticator(String id);

  /// Reorder authenticators
  Future<Either<Failure, void>> reorderAuthenticators(List<AuthenticatorEntity> authenticators);

  /// Search authenticators
  Future<Either<Failure, List<AuthenticatorEntity>>> searchAuthenticators(String query);

  /// Export authenticators (encrypted)
  Future<Either<Failure, String>> exportAuthenticators();

  /// Import authenticators
  Future<Either<Failure, List<AuthenticatorEntity>>> importAuthenticators(String data);

  /// Sync authenticators to cloud
  Future<Either<Failure, void>> syncToCloud();

  /// Sync authenticators from cloud
  Future<Either<Failure, List<AuthenticatorEntity>>> syncFromCloud();
}
