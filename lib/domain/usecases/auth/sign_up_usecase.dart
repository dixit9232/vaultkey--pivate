import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for user sign up
class SignUpUseCase {
  final AuthRepository _repository;

  SignUpUseCase(this._repository);

  /// Execute sign up with email and password
  Future<Either<Failure, UserEntity>> call({required String email, required String password}) {
    return _repository.signUpWithEmailAndPassword(email: email, password: password);
  }
}
