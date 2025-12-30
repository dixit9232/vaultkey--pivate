import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for signing in with Microsoft
class MicrosoftSignInUseCase {
  final AuthRepository _repository;

  MicrosoftSignInUseCase(this._repository);

  /// Execute Microsoft sign in
  Future<Either<Failure, UserEntity>> call() async {
    return await _repository.signInWithMicrosoft();
  }
}
