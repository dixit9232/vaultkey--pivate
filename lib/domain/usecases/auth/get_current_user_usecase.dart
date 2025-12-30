import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for getting current authenticated user
class GetCurrentUserUseCase {
  final AuthRepository _repository;

  GetCurrentUserUseCase(this._repository);

  /// Execute get current user
  Future<Either<Failure, UserEntity?>> call() {
    return _repository.getCurrentUser();
  }
}
