import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for user sign out
class SignOutUseCase {
  final AuthRepository _repository;

  SignOutUseCase(this._repository);

  /// Execute sign out
  Future<Either<Failure, void>> call() {
    return _repository.signOut();
  }
}
