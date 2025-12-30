import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/local/authenticator_local_datasource.dart';
import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/firebase_datasource.dart';
import '../../data/datasources/remote/supabase_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/authenticator_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/authenticator_repository.dart';
import '../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../domain/usecases/auth/google_sign_in_usecase.dart';
import '../../domain/usecases/auth/microsoft_sign_in_usecase.dart';
import '../../domain/usecases/auth/reload_user_usecase.dart';
import '../../domain/usecases/auth/send_email_verification_usecase.dart';
import '../../domain/usecases/auth/send_password_reset_usecase.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
import '../../presentation/bloc/auth/auth_bloc.dart';
import '../../presentation/bloc/authenticator/authenticator_bloc.dart';
import 'biometric_service.dart';
import 'google_auth_service.dart';
import 'microsoft_auth_service.dart';
import 'network_info.dart';

/// Global service locator instance
final GetIt sl = GetIt.instance;

/// Initialize all dependencies
Future<void> initDependencies() async {
  // External dependencies
  await _initExternalDependencies();

  // Core services
  await _initCoreServices();

  // Data sources
  await _initDataSources();

  // Repositories
  await _initRepositories();

  // Use cases
  await _initUseCases();

  // BLoCs
  await _initBlocs();
}

/// Initialize external dependencies (Firebase, etc.)
Future<void> _initExternalDependencies() async {
  // Firebase instances
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<FirebaseFirestore>(() => FirebaseFirestore.instance);
  sl.registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance);

  // Connectivity
  sl.registerLazySingleton<Connectivity>(() => Connectivity());

  // Secure storage (encryptedSharedPreferences deprecated, using default secure ciphers)
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
}

/// Initialize core services
Future<void> _initCoreServices() async {
  // Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));

  // Biometric service
  sl.registerLazySingleton<BiometricService>(() => BiometricServiceImpl());

  // Google auth service
  sl.registerLazySingleton<GoogleAuthService>(() => GoogleAuthServiceImpl());

  // Microsoft auth service
  sl.registerLazySingleton<MicrosoftAuthService>(() => MicrosoftAuthServiceImpl());
}

/// Initialize data sources
Future<void> _initDataSources() async {
  // Local data source
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(secureStorage: sl()));

  // Authenticator local data source
  sl.registerLazySingleton<AuthenticatorLocalDataSource>(() => AuthenticatorLocalDataSourceImpl());

  // Firebase data source (Primary Backend)
  sl.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSourceImpl(auth: sl(), firestore: sl(), storage: sl()));

  // Supabase data source (Secondary Backend)
  sl.registerLazySingleton<SupabaseDataSource>(() => SupabaseDataSourceImpl());
}

/// Initialize repositories
Future<void> _initRepositories() async {
  // Auth repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl(), googleAuthService: sl(), microsoftAuthService: sl()));

  // Authenticator repository
  sl.registerLazySingleton<AuthenticatorRepository>(() => AuthenticatorRepositoryImpl(localDataSource: sl<AuthenticatorLocalDataSource>()));
}

/// Initialize use cases
Future<void> _initUseCases() async {
  // Auth use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
  sl.registerLazySingleton(() => SendPasswordResetUseCase(sl()));
  sl.registerLazySingleton(() => SendEmailVerificationUseCase(sl()));
  sl.registerLazySingleton(() => ReloadUserUseCase(sl()));
  sl.registerLazySingleton(() => GetCurrentUserUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));
  sl.registerLazySingleton(() => MicrosoftSignInUseCase(sl()));
}

/// Initialize BLoCs
Future<void> _initBlocs() async {
  // Auth BLoC
  sl.registerFactory(
    () => AuthBloc(
      signInUseCase: sl(),
      signUpUseCase: sl(),
      signOutUseCase: sl(),
      sendPasswordResetUseCase: sl(),
      sendEmailVerificationUseCase: sl(),
      reloadUserUseCase: sl(),
      getCurrentUserUseCase: sl(),
      googleSignInUseCase: sl(),
      microsoftSignInUseCase: sl(),
      biometricService: sl(),
      localDataSource: sl(),
      authRepository: sl(),
    ),
  );

  // Authenticator BLoC
  sl.registerFactory(() => AuthenticatorBloc(repository: sl<AuthenticatorRepository>()));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
