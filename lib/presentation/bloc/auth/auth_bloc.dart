import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/services/biometric_service.dart';
import '../../../data/datasources/local/local_datasource.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/auth/get_current_user_usecase.dart';
import '../../../domain/usecases/auth/google_sign_in_usecase.dart';
import '../../../domain/usecases/auth/microsoft_sign_in_usecase.dart';
import '../../../domain/usecases/auth/reload_user_usecase.dart';
import '../../../domain/usecases/auth/send_email_verification_usecase.dart';
import '../../../domain/usecases/auth/send_password_reset_usecase.dart';
import '../../../domain/usecases/auth/sign_in_usecase.dart';
import '../../../domain/usecases/auth/sign_out_usecase.dart';
import '../../../domain/usecases/auth/sign_up_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Authentication BLoC for managing auth state
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;
  final SignOutUseCase _signOutUseCase;
  final SendPasswordResetUseCase _sendPasswordResetUseCase;
  final SendEmailVerificationUseCase _sendEmailVerificationUseCase;
  final ReloadUserUseCase _reloadUserUseCase;
  final GetCurrentUserUseCase _getCurrentUserUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;
  final MicrosoftSignInUseCase _microsoftSignInUseCase;
  final BiometricService _biometricService;
  final LocalDataSource _localDataSource;
  final AuthRepository _authRepository;

  StreamSubscription? _authStateSubscription;
  Timer? _sessionTimer;
  Timer? _lockoutTimer;
  DateTime? _lastActivityTime;

  // Rate limiting constants
  static const int _lockoutDuration30Sec = 30;
  static const int _lockoutDuration5Min = 300;

  AuthBloc({
    required SignInUseCase signInUseCase,
    required SignUpUseCase signUpUseCase,
    required SignOutUseCase signOutUseCase,
    required SendPasswordResetUseCase sendPasswordResetUseCase,
    required SendEmailVerificationUseCase sendEmailVerificationUseCase,
    required ReloadUserUseCase reloadUserUseCase,
    required GetCurrentUserUseCase getCurrentUserUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
    required MicrosoftSignInUseCase microsoftSignInUseCase,
    required BiometricService biometricService,
    required LocalDataSource localDataSource,
    required AuthRepository authRepository,
  }) : _signInUseCase = signInUseCase,
       _signUpUseCase = signUpUseCase,
       _signOutUseCase = signOutUseCase,
       _sendPasswordResetUseCase = sendPasswordResetUseCase,
       _sendEmailVerificationUseCase = sendEmailVerificationUseCase,
       _reloadUserUseCase = reloadUserUseCase,
       _getCurrentUserUseCase = getCurrentUserUseCase,
       _googleSignInUseCase = googleSignInUseCase,
       _microsoftSignInUseCase = microsoftSignInUseCase,
       _biometricService = biometricService,
       _localDataSource = localDataSource,
       _authRepository = authRepository,
       super(AuthState.initial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthMicrosoftSignInRequested>(_onMicrosoftSignInRequested);
    on<AuthBiometricSignInRequested>(_onBiometricSignInRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);
    on<AuthPasswordResetRequested>(_onPasswordResetRequested);
    on<AuthResendVerificationRequested>(_onResendVerificationRequested);
    on<AuthCheckEmailVerificationRequested>(_onCheckEmailVerificationRequested);
    on<AuthBiometricPreferenceChanged>(_onBiometricPreferenceChanged);
    on<AuthSessionTimeoutOccurred>(_onSessionTimeoutOccurred);
    on<AuthAppResumed>(_onAppResumed);

    // Listen to auth state changes
    _listenToAuthStateChanges();
  }

  /// Listen to Firebase auth state changes
  void _listenToAuthStateChanges() {
    _authStateSubscription = _authRepository.authStateChanges.listen((user) {
      if (user == null && state.isAuthenticated) {
        // User signed out externally
        add(const AuthSignOutRequested());
      }
    });
  }

  /// Check current authentication state
  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    // Check biometric availability
    final biometricAvailable = await _biometricService.isAvailable();
    final biometricEnabled = await _getBiometricPreference();

    // Check if user is authenticated via Firebase
    final result = await _getCurrentUserUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, biometricAvailable: biometricAvailable, biometricEnabled: biometricEnabled));
      },
      (user) {
        if (user == null) {
          emit(state.copyWith(status: AuthStatus.unauthenticated, biometricAvailable: biometricAvailable, biometricEnabled: biometricEnabled));
        } else if (!user.emailVerified) {
          emit(state.copyWith(status: AuthStatus.emailVerificationPending, user: user, biometricAvailable: biometricAvailable, biometricEnabled: biometricEnabled));
        } else {
          _startSessionTimer();
          emit(state.copyWith(status: AuthStatus.authenticated, user: user, biometricAvailable: biometricAvailable, biometricEnabled: biometricEnabled));
        }
      },
    );
  }

  /// Handle sign in with email/password
  Future<void> _onSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    // Check lockout
    if (state.isLockedOut) {
      emit(state.copyWith(errorMessage: 'Account locked. Try again in ${state.lockoutRemainingSeconds} seconds.'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _signInUseCase(email: event.email, password: event.password);

    result.fold(
      (failure) {
        final newFailedAttempts = state.failedAttempts + 1;
        DateTime? lockoutUntil;

        // Progressive lockout
        if (newFailedAttempts >= 15) {
          // Account suspended - handled by Firebase
          emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: 'Account temporarily suspended. Contact support.', failedAttempts: newFailedAttempts));
          return;
        } else if (newFailedAttempts >= 10) {
          lockoutUntil = DateTime.now().add(const Duration(seconds: _lockoutDuration5Min));
          _startLockoutTimer(_lockoutDuration5Min);
        } else if (newFailedAttempts >= 5) {
          lockoutUntil = DateTime.now().add(const Duration(seconds: _lockoutDuration30Sec));
          _startLockoutTimer(_lockoutDuration30Sec);
        }

        emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: failure.message, failedAttempts: newFailedAttempts, lockoutUntil: lockoutUntil));
      },
      (user) {
        // Check if email is verified
        if (!user.emailVerified) {
          emit(state.copyWith(status: AuthStatus.emailVerificationPending, user: user, failedAttempts: 0, clearLockout: true));
        } else {
          _startSessionTimer();
          emit(state.copyWith(status: AuthStatus.authenticated, user: user, failedAttempts: 0, clearLockout: true));
        }
      },
    );
  }

  /// Handle sign up with email/password
  Future<void> _onSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _signUpUseCase(email: event.email, password: event.password);

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: failure.message));
      },
      (user) {
        emit(state.copyWith(status: AuthStatus.emailVerificationPending, user: user, successMessage: 'Account created! Please verify your email.'));
      },
    );
  }

  /// Handle Google sign in
  Future<void> _onGoogleSignInRequested(AuthGoogleSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _googleSignInUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: failure.message));
      },
      (user) {
        _startSessionTimer();
        emit(state.copyWith(status: AuthStatus.authenticated, user: user, failedAttempts: 0, clearLockout: true));
      },
    );
  }

  /// Handle Microsoft sign in
  Future<void> _onMicrosoftSignInRequested(AuthMicrosoftSignInRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _microsoftSignInUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: failure.message));
      },
      (user) {
        _startSessionTimer();
        emit(state.copyWith(status: AuthStatus.authenticated, user: user, failedAttempts: 0, clearLockout: true));
      },
    );
  }

  /// Handle biometric sign in
  Future<void> _onBiometricSignInRequested(AuthBiometricSignInRequested event, Emitter<AuthState> emit) async {
    if (!state.biometricAvailable || !state.biometricEnabled) {
      emit(state.copyWith(errorMessage: 'Biometric authentication not available'));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final authenticated = await _biometricService.authenticate(reason: 'Authenticate to access VaultKey');

    if (authenticated) {
      // TODO: Get cached user credentials and sign in
      emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: 'Biometric sign in not fully implemented'));
    } else {
      final newFailedAttempts = state.failedAttempts + 1;
      if (newFailedAttempts >= 3) {
        // Fall back to password after 3 failed biometric attempts
        emit(
          state.copyWith(
            status: AuthStatus.unauthenticated,
            errorMessage: 'Biometric failed. Please use your password.',
            failedAttempts: newFailedAttempts,
            biometricEnabled: false, // Temporarily disable
          ),
        );
      } else {
        emit(state.copyWith(status: AuthStatus.biometricRequired, errorMessage: 'Biometric authentication failed', failedAttempts: newFailedAttempts));
      }
    }
  }

  /// Handle sign out
  Future<void> _onSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    _sessionTimer?.cancel();
    final result = await _signOutUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(errorMessage: failure.message));
      },
      (_) {
        emit(AuthState.initial().copyWith(status: AuthStatus.unauthenticated, biometricAvailable: state.biometricAvailable));
      },
    );
  }

  /// Handle password reset request
  Future<void> _onPasswordResetRequested(AuthPasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final result = await _sendPasswordResetUseCase(email: event.email);

    result.fold(
      (failure) {
        // For security, show the same success message even on failure
        emit(state.copyWith(status: AuthStatus.unauthenticated, successMessage: 'If an account exists for ${event.email}, you will receive a password reset email.'));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.unauthenticated, successMessage: 'If an account exists for ${event.email}, you will receive a password reset email.'));
      },
    );
  }

  /// Handle resend verification email
  Future<void> _onResendVerificationRequested(AuthResendVerificationRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading, clearSuccess: true));

    final result = await _sendEmailVerificationUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.emailVerificationPending, errorMessage: failure.message));
      },
      (_) {
        emit(state.copyWith(status: AuthStatus.emailVerificationPending, successMessage: 'Verification email sent!'));
      },
    );
  }

  /// Handle check email verification
  Future<void> _onCheckEmailVerificationRequested(AuthCheckEmailVerificationRequested event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loading));

    final result = await _reloadUserUseCase();

    result.fold(
      (failure) {
        emit(state.copyWith(status: AuthStatus.emailVerificationPending, errorMessage: failure.message));
      },
      (isVerified) {
        if (isVerified) {
          _startSessionTimer();
          // Reload user to get updated state
          add(const AuthCheckRequested());
        } else {
          emit(state.copyWith(status: AuthStatus.emailVerificationPending, errorMessage: 'Email not yet verified. Please check your inbox.'));
        }
      },
    );
  }

  /// Handle biometric preference change
  Future<void> _onBiometricPreferenceChanged(AuthBiometricPreferenceChanged event, Emitter<AuthState> emit) async {
    if (event.enabled && !state.biometricAvailable) {
      emit(state.copyWith(errorMessage: 'Biometric authentication not available on this device'));
      return;
    }

    await _setBiometricPreference(event.enabled);

    emit(state.copyWith(biometricEnabled: event.enabled, successMessage: event.enabled ? 'Biometric authentication enabled' : 'Biometric authentication disabled'));
  }

  /// Handle session timeout
  Future<void> _onSessionTimeoutOccurred(AuthSessionTimeoutOccurred event, Emitter<AuthState> emit) async {
    _sessionTimer?.cancel();

    if (state.biometricEnabled && state.biometricAvailable) {
      emit(state.copyWith(status: AuthStatus.biometricRequired, errorMessage: 'Session expired. Please authenticate.'));
    } else {
      emit(state.copyWith(status: AuthStatus.unauthenticated, errorMessage: 'Session expired. Please sign in again.', clearUser: true));
    }
  }

  /// Handle app resumed from background
  Future<void> _onAppResumed(AuthAppResumed event, Emitter<AuthState> emit) async {
    if (!state.isAuthenticated) return;

    final now = DateTime.now();
    if (_lastActivityTime != null) {
      final inactiveDuration = now.difference(_lastActivityTime!);
      if (inactiveDuration > AppConstants.sessionTimeout) {
        add(const AuthSessionTimeoutOccurred());
        return;
      }
    }

    // If biometric is enabled, require re-auth after background
    if (state.biometricEnabled && state.biometricAvailable) {
      emit(state.copyWith(status: AuthStatus.biometricRequired));
    }

    _lastActivityTime = now;
  }

  // Helper methods

  void _startSessionTimer() {
    _sessionTimer?.cancel();
    _sessionTimer = Timer(AppConstants.sessionTimeout, () {
      add(const AuthSessionTimeoutOccurred());
    });
  }

  void _resetSessionTimer() {
    _lastActivityTime = DateTime.now();
    _startSessionTimer();
  }

  void _startLockoutTimer(int seconds) {
    _lockoutTimer?.cancel();
    _lockoutTimer = Timer(Duration(seconds: seconds), () {
      // Lockout expired, clear it
    });
  }

  Future<bool> _getBiometricPreference() async {
    final value = await _localDataSource.getSecureValue(AppConstants.biometricEnabledKey);
    return value == 'true';
  }

  Future<void> _setBiometricPreference(bool enabled) async {
    await _localDataSource.setSecureValue(AppConstants.biometricEnabledKey, enabled.toString());
  }

  /// Call this when user interacts with the app
  void recordActivity() {
    _resetSessionTimer();
  }

  @override
  Future<void> close() {
    _authStateSubscription?.cancel();
    _sessionTimer?.cancel();
    _lockoutTimer?.cancel();
    return super.close();
  }
}
