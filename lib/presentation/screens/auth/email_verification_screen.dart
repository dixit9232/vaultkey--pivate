import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/injection_container.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../bloc/auth/email_verification_cubit.dart';
import '../../routes/app_routes.dart';

/// Email verification pending screen
class EmailVerificationScreen extends StatelessWidget {
  const EmailVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => EmailVerificationCubit()),
      ],
      child: const _EmailVerificationView(),
    );
  }
}

class _EmailVerificationView extends StatelessWidget {
  const _EmailVerificationView();

  void _onResendEmail(BuildContext context) {
    context.read<AuthBloc>().add(const AuthResendVerificationRequested());
    context.read<EmailVerificationCubit>().startResendCooldown();
  }

  void _onCheckVerification(BuildContext context) {
    context.read<AuthBloc>().add(const AuthCheckEmailVerificationRequested());
  }

  void _onSignOut(BuildContext context) {
    context.read<AuthBloc>().add(const AuthSignOutRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(AppRoutes.home);
        }
        if (state.status == AuthStatus.unauthenticated && state.user == null) {
          context.go(AppRoutes.login);
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, authState) {
        return Scaffold(
          appBar: AppBar(
            actions: [TextButton(onPressed: () => _onSignOut(context), child: Text(l10n.signOut))],
          ),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const Spacer(),
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
                    child: const Icon(Icons.mark_email_unread_outlined, size: 60, color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    'Verify Your Email',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'We\'ve sent a verification link to:',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    authState.user?.email ?? 'your email',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
                    child: Column(children: [_buildStep(context, '1', 'Check your inbox (and spam folder)'), const SizedBox(height: 12), _buildStep(context, '2', 'Click the verification link'), const SizedBox(height: 12), _buildStep(context, '3', 'Come back and tap "I\'ve Verified"')]),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: FilledButton(
                      onPressed: authState.isLoading ? null : () => _onCheckVerification(context),
                      child: authState.isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
                          : const Text('I\'ve Verified My Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  BlocBuilder<EmailVerificationCubit, EmailVerificationState>(
                    builder: (context, evState) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: OutlinedButton(
                          onPressed: evState.canResend ? () => _onResendEmail(context) : null,
                          child: Text(evState.canResend ? 'Resend Verification Email' : 'Resend in ${evState.resendCooldown}s', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  TextButton(onPressed: () => _onSignOut(context), child: const Text('Use a different email')),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStep(BuildContext context, String number, String text) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle),
          child: Center(
            child: Text(
              number,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).colorScheme.onPrimary, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}
