import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import '../../data/datasources/local/local_datasource.dart';
import '../../data/datasources/remote/firebase_datasource.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/auth/sign_in_usecase.dart';
import '../../domain/usecases/auth/sign_out_usecase.dart';
import '../../domain/usecases/auth/sign_up_usecase.dart';
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

  // Secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    ),
  );
}

/// Initialize core services
Future<void> _initCoreServices() async {
  // Network info
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: sl()));
}

/// Initialize data sources
Future<void> _initDataSources() async {
  // Local data source
  sl.registerLazySingleton<LocalDataSource>(() => LocalDataSourceImpl(secureStorage: sl()));

  // Firebase data source
  sl.registerLazySingleton<FirebaseDataSource>(() => FirebaseDataSourceImpl(auth: sl(), firestore: sl(), storage: sl()));
}

/// Initialize repositories
Future<void> _initRepositories() async {
  // Auth repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));
}

/// Initialize use cases
Future<void> _initUseCases() async {
  // Auth use cases
  sl.registerLazySingleton(() => SignInUseCase(sl()));
  sl.registerLazySingleton(() => SignUpUseCase(sl()));
  sl.registerLazySingleton(() => SignOutUseCase(sl()));
}

/// Initialize BLoCs
Future<void> _initBlocs() async {
  // BLoCs will be registered here as they are created
  // Example:
  // sl.registerFactory(() => AuthBloc(
  //   signInUseCase: sl(),
  //   signUpUseCase: sl(),
  //   signOutUseCase: sl(),
  // ));
}

/// Reset all dependencies (useful for testing)
Future<void> resetDependencies() async {
  await sl.reset();
}
