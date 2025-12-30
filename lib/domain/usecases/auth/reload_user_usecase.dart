import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for reloading user to check email verification status
class ReloadUserUseCase {
  final AuthRepository _repository;

  ReloadUserUseCase(this._repository);

  /// Execute user reload
  Future<Either<Failure, bool>> call() {
    return _repository.reloadUser();
  }
}
