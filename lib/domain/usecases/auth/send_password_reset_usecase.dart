import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for sending password reset email
class SendPasswordResetUseCase {
  final AuthRepository _repository;

  SendPasswordResetUseCase(this._repository);

  /// Execute password reset email sending
  Future<Either<Failure, void>> call({required String email}) {
    return _repository.sendPasswordResetEmail(email);
  }
}
