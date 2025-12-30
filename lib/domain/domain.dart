/// Domain layer barrel file
/// Export all entities, repositories, and use cases
library;

// Entities
export 'entities/user_entity.dart';
export 'entities/authenticator_entity.dart';
export 'entities/backup_entity.dart';
export 'entities/subscription_entity.dart';

// Repository contracts
export 'repositories/auth_repository.dart';
export 'repositories/authenticator_repository.dart';

// Use cases - Auth
export 'usecases/auth/get_current_user_usecase.dart';
export 'usecases/auth/google_sign_in_usecase.dart';
export 'usecases/auth/microsoft_sign_in_usecase.dart';
export 'usecases/auth/reload_user_usecase.dart';
export 'usecases/auth/send_email_verification_usecase.dart';
export 'usecases/auth/send_password_reset_usecase.dart';
export 'usecases/auth/sign_in_usecase.dart';
export 'usecases/auth/sign_out_usecase.dart';
export 'usecases/auth/sign_up_usecase.dart';
