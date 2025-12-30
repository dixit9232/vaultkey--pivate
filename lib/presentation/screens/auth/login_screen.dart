import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/injection_container.dart';
import '../../../core/utils/validators.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/auth/auth.dart';
import '../../routes/app_routes.dart';
import '../../widgets/inputs/custom_text_field.dart';
import 'widgets/password_field.dart';
import 'widgets/social_login_button.dart';

/// Login screen
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()..add(const AuthCheckRequested())),
        BlocProvider(create: (context) => LoginFormCubit()),
      ],
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      final rememberMe = context.read<LoginFormCubit>().state.rememberMe;
      context.read<AuthBloc>().add(AuthSignInRequested(email: _emailController.text.trim(), password: _passwordController.text, rememberMe: rememberMe));
    }
  }

  void _onGoogleSignIn(BuildContext context) {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  void _onMicrosoftSignIn(BuildContext context) {
    context.read<AuthBloc>().add(const AuthMicrosoftSignInRequested());
  }

  void _onBiometricSignIn(BuildContext context) {
    context.read<AuthBloc>().add(const AuthBiometricSignInRequested());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          context.go(AppRoutes.home);
        } else if (state.status == AuthStatus.emailVerificationPending) {
          context.go(AppRoutes.emailVerification);
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(label: l10n.ok, textColor: AppColors.white, onPressed: () {}),
            ),
          );
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    _buildHeader(context, l10n),
                    const SizedBox(height: 48),
                    CustomTextField(
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      labelText: l10n.email,
                      hintText: 'email@example.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      enabled: !state.isLoading,
                      validator: Validators.validateEmail,
                      onSubmitted: (_) => FocusScope.of(context).requestFocus(_passwordFocusNode),
                    ),
                    const SizedBox(height: 16),
                    PasswordField(controller: _passwordController, focusNode: _passwordFocusNode, labelText: l10n.password, enabled: !state.isLoading, validator: Validators.validatePassword, onSubmitted: (_) => _onSubmit(context)),
                    const SizedBox(height: 8),
                    _OptionsRow(isLoading: state.isLoading),
                    const SizedBox(height: 24),
                    _buildSignInButton(context, l10n, state),
                    const SizedBox(height: 24),
                    if (state.biometricAvailable && state.biometricEnabled) _buildBiometricButton(context, l10n, state),
                    _buildDivider(context),
                    const SizedBox(height: 24),
                    _buildSocialButtons(context, l10n, state),
                    const SizedBox(height: 32),
                    _buildSignUpLink(context, l10n),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.signIn, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Welcome back! Please sign in to continue.', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildSignInButton(BuildContext context, AppLocalizations l10n, AuthState state) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: state.isLoading || state.isLockedOut ? null : () => _onSubmit(context),
        child: state.isLoading
            ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white)))
            : Text(state.isLockedOut ? 'Locked (${state.lockoutRemainingSeconds}s)' : l10n.signIn, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildBiometricButton(BuildContext context, AppLocalizations l10n, AuthState state) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: SizedBox(
        height: 56,
        child: FilledButton.tonal(
          onPressed: state.isLoading ? null : () => _onBiometricSignIn(context),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.fingerprint, size: 28),
              const SizedBox(width: 12),
              Text(l10n.biometricPromptTitle, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text('OR', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
        ),
        Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
      ],
    );
  }

  Widget _buildSocialButtons(BuildContext context, AppLocalizations l10n, AuthState state) {
    return Column(
      children: [
        SocialLoginButton(provider: SocialProvider.google, onPressed: state.isLoading ? null : () => _onGoogleSignIn(context)),
        const SizedBox(height: 12),
        SocialLoginButton(provider: SocialProvider.microsoft, onPressed: state.isLoading ? null : () => _onMicrosoftSignIn(context)),
      ],
    );
  }

  Widget _buildSignUpLink(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.dontHaveAccount, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: () => context.push(AppRoutes.register), child: Text(l10n.signUp)),
      ],
    );
  }
}

class _OptionsRow extends StatelessWidget {
  final bool isLoading;

  const _OptionsRow({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formCubit = context.read<LoginFormCubit>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: BlocBuilder<LoginFormCubit, LoginFormState>(
                buildWhen: (prev, curr) => prev.rememberMe != curr.rememberMe,
                builder: (context, formState) {
                  return Checkbox(value: formState.rememberMe, onChanged: isLoading ? null : (value) => formCubit.setRememberMe(value ?? false));
                },
              ),
            ),
            const SizedBox(width: 8),
            Text('Remember me', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        TextButton(onPressed: isLoading ? null : () => context.push(AppRoutes.forgotPassword), child: Text(l10n.forgotPassword)),
      ],
    );
  }
}
