import 'package:fpdart/fpdart.dart';

import '../../core/failures/failures.dart';
import '../../domain/entities/authenticator_entity.dart';
import '../../domain/repositories/authenticator_repository.dart';
import '../datasources/local/authenticator_local_datasource.dart';
import '../models/authenticator_model.dart';

/// Implementation of authenticator repository
class AuthenticatorRepositoryImpl implements AuthenticatorRepository {
  final AuthenticatorLocalDataSource _localDataSource;

  AuthenticatorRepositoryImpl({required AuthenticatorLocalDataSource localDataSource}) : _localDataSource = localDataSource;

  @override
  Future<Either<Failure, List<AuthenticatorEntity>>> getAllAuthenticators() async {
    try {
      final models = await _localDataSource.getAllAuthenticators();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get authenticators: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthenticatorEntity?>> getAuthenticatorById(String id) async {
    try {
      final model = await _localDataSource.getAuthenticator(id);
      return Right(model?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to get authenticator: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthenticatorEntity>> addAuthenticator(AuthenticatorEntity authenticator) async {
    try {
      final model = AuthenticatorModel.fromEntity(authenticator);
      await _localDataSource.addAuthenticator(model);
      return Right(authenticator);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to add authenticator: $e'));
    }
  }

  @override
  Future<Either<Failure, AuthenticatorEntity>> updateAuthenticator(AuthenticatorEntity authenticator) async {
    try {
      final model = AuthenticatorModel.fromEntity(authenticator);
      await _localDataSource.updateAuthenticator(model);
      return Right(authenticator);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to update authenticator: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAuthenticator(String id) async {
    try {
      await _localDataSource.deleteAuthenticator(id);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to delete authenticator: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> reorderAuthenticators(List<AuthenticatorEntity> authenticators) async {
    try {
      final orderedIds = authenticators.map((a) => a.id).toList();
      await _localDataSource.reorderAuthenticators(orderedIds);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to reorder authenticators: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AuthenticatorEntity>>> searchAuthenticators(String query) async {
    try {
      final models = await _localDataSource.searchAuthenticators(query);
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to search authenticators: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> exportAuthenticators() async {
    try {
      final models = await _localDataSource.getAllAuthenticators();
      final jsonList = models.map((m) => m.toJson()).toList();
      // TODO: Encrypt the export data
      return Right(jsonList.toString());
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to export authenticators: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AuthenticatorEntity>>> importAuthenticators(String data) async {
    try {
      // TODO: Decrypt and parse the import data
      return const Right([]);
    } catch (e) {
      return Left(CacheFailure(message: 'Failed to import authenticators: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> syncToCloud() async {
    try {
      // TODO: Implement cloud sync
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to sync to cloud: $e'));
    }
  }

  @override
  Future<Either<Failure, List<AuthenticatorEntity>>> syncFromCloud() async {
    try {
      // TODO: Implement cloud sync
      return const Right([]);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to sync from cloud: $e'));
    }
  }
}
