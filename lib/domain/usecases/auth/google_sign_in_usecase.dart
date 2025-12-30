import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for Google Sign-In
class GoogleSignInUseCase {
  final AuthRepository _repository;

  GoogleSignInUseCase(this._repository);

  /// Execute Google Sign-In
  Future<Either<Failure, UserEntity>> call() {
    return _repository.signInWithGoogle();
  }
}
