import 'package:fpdart/fpdart.dart';

import '../../core/failures/exceptions.dart';
import '../../core/failures/failures.dart';
import '../../core/services/google_auth_service.dart';
import '../../core/services/microsoft_auth_service.dart';
import '../../core/services/network_info.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/firebase_datasource.dart';
import '../models/user_model.dart';

/// Implementation of authentication repository
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseDataSource _remoteDataSource;
  final LocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;
  final GoogleAuthService _googleAuthService;
  final MicrosoftAuthService _microsoftAuthService;

  static const String _userDataKey = 'user_data';

  AuthRepositoryImpl({required FirebaseDataSource remoteDataSource, required LocalDataSource localDataSource, required NetworkInfo networkInfo, required GoogleAuthService googleAuthService, required MicrosoftAuthService microsoftAuthService})
    : _remoteDataSource = remoteDataSource,
      _localDataSource = localDataSource,
      _networkInfo = networkInfo,
      _googleAuthService = googleAuthService,
      _microsoftAuthService = microsoftAuthService;

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword({required String email, required String password}) async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }

    try {
      final credential = await _remoteDataSource.signInWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        return Left(AuthFailure.invalidCredentials());
      }

      final userModel = UserModel(id: user.uid, email: user.email ?? email, displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified, lastLoginAt: DateTime.now());

      // Cache user data
      await _localDataSource.setSecureValue(_userDataKey, userModel.toJson().toString());

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Sign in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword({required String email, required String password}) async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }

    try {
      final credential = await _remoteDataSource.createUserWithEmailAndPassword(email: email, password: password);

      final user = credential.user;
      if (user == null) {
        return Left(const AuthFailure(message: 'Failed to create user'));
      }

      final userModel = UserModel(id: user.uid, email: user.email ?? email, displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified, createdAt: DateTime.now());

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Sign up failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      await _localDataSource.deleteSecureValue(_userDataKey);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(message: 'Sign out failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }

    try {
      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send reset email: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      final user = _remoteDataSource.currentUser;
      if (user == null) {
        return const Right(null);
      }

      return Right(UserModel(id: user.uid, email: user.email ?? '', displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified).toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to get current user: $e'));
    }
  }

  @override
  bool get isAuthenticated => _remoteDataSource.isAuthenticated;

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }

    try {
      final credential = await _googleAuthService.signIn();
      final userCredential = await _remoteDataSource.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        return Left(const AuthFailure(message: 'Google sign-in failed'));
      }

      final userModel = UserModel(id: user.uid, email: user.email ?? '', displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified, lastLoginAt: DateTime.now());

      await _localDataSource.setSecureValue(_userDataKey, userModel.toJson().toString());

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Google sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithMicrosoft() async {
    if (!await _networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }

    try {
      final credential = await _microsoftAuthService.signIn();
      final userCredential = await _remoteDataSource.signInWithCredential(credential);

      final user = userCredential.user;
      if (user == null) {
        return Left(const AuthFailure(message: 'Microsoft sign-in failed'));
      }

      final userModel = UserModel(id: user.uid, email: user.email ?? '', displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified, lastLoginAt: DateTime.now());

      await _localDataSource.setSecureValue(_userDataKey, userModel.toJson().toString());

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Microsoft sign-in failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendEmailVerification() async {
    try {
      await _remoteDataSource.sendEmailVerification();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to send verification email: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> reloadUser() async {
    try {
      await _remoteDataSource.reloadUser();
      final user = _remoteDataSource.currentUser;
      return Right(user?.emailVerified ?? false);
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to reload user: $e'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((user) {
      if (user == null) return null;
      return UserModel(id: user.uid, email: user.email ?? '', displayName: user.displayName, photoUrl: user.photoURL, emailVerified: user.emailVerified).toEntity();
    });
  }
}
