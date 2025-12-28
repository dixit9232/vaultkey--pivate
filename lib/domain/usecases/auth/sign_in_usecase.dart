import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../entities/user_entity.dart';
import '../../repositories/auth_repository.dart';

/// Use case for user sign in
class SignInUseCase {
  final AuthRepository _repository;

  SignInUseCase(this._repository);

  /// Execute sign in with email and password
  Future<Either<Failure, UserEntity>> call({required String email, required String password}) {
    return _repository.signInWithEmailAndPassword(email: email, password: password);
  }
}
