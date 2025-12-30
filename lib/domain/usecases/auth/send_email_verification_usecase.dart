import 'package:fpdart/fpdart.dart';

import '../../../core/failures/failures.dart';
import '../../repositories/auth_repository.dart';

/// Use case for sending email verification
class SendEmailVerificationUseCase {
  final AuthRepository _repository;

  SendEmailVerificationUseCase(this._repository);

  /// Execute email verification sending
  Future<Either<Failure, void>> call() {
    return _repository.sendEmailVerification();
  }
}
