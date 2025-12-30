import 'package:flutter/gestures.dart';
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

/// Registration/Sign-up screen
class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => sl<AuthBloc>()),
        BlocProvider(create: (context) => RegisterFormCubit()),
      ],
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    super.dispose();
  }

  void _onSubmit(BuildContext context) {
    final acceptedTerms = context.read<RegisterFormCubit>().state.acceptedTerms;

    if (!acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Terms & Conditions'), backgroundColor: AppColors.warning, behavior: SnackBarBehavior.floating));
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthSignUpRequested(email: _emailController.text.trim(), password: _passwordController.text));
    }
  }

  void _onGoogleSignIn(BuildContext context) {
    context.read<AuthBloc>().add(const AuthGoogleSignInRequested());
  }

  void _onMicrosoftSignIn(BuildContext context) {
    context.read<AuthBloc>().add(const AuthMicrosoftSignInRequested());
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), backgroundColor: AppColors.error, behavior: SnackBarBehavior.floating));
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: AppColors.success, behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.pop()),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildHeader(context, l10n),
                    const SizedBox(height: 32),
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
                    PasswordField(
                      controller: _passwordController,
                      focusNode: _passwordFocusNode,
                      labelText: l10n.password,
                      enabled: !state.isLoading,
                      showStrengthIndicator: true,
                      validator: Validators.validateStrongPassword,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmPasswordFocusNode),
                    ),
                    const SizedBox(height: 16),
                    PasswordField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmPasswordFocusNode,
                      labelText: l10n.confirmPassword,
                      enabled: !state.isLoading,
                      validator: (value) => Validators.validateConfirmPassword(value, _passwordController.text),
                      onSubmitted: (_) => _onSubmit(context),
                    ),
                    const SizedBox(height: 16),
                    _TermsCheckbox(isLoading: state.isLoading),
                    const SizedBox(height: 24),
                    _buildSignUpButton(context, l10n, state),
                    const SizedBox(height: 24),
                    _buildDivider(context),
                    const SizedBox(height: 24),
                    _buildSocialButtons(context, state),
                    const SizedBox(height: 32),
                    _buildSignInLink(context, l10n),
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
        Text(l10n.createAccount, style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text('Create a free account to secure your authenticators', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildSignUpButton(BuildContext context, AppLocalizations l10n, AuthState state) {
    return SizedBox(
      height: 56,
      child: FilledButton(
        onPressed: state.isLoading ? null : () => _onSubmit(context),
        child: state.isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(AppColors.white))) : Text(l10n.createAccount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
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

  Widget _buildSocialButtons(BuildContext context, AuthState state) {
    return Column(
      children: [
        SocialLoginButton(provider: SocialProvider.google, onPressed: state.isLoading ? null : () => _onGoogleSignIn(context)),
        const SizedBox(height: 12),
        SocialLoginButton(provider: SocialProvider.microsoft, onPressed: state.isLoading ? null : () => _onMicrosoftSignIn(context)),
      ],
    );
  }

  Widget _buildSignInLink(BuildContext context, AppLocalizations l10n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(l10n.alreadyHaveAccount, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(onPressed: () => context.pop(), child: Text(l10n.signIn)),
      ],
    );
  }
}

class _TermsCheckbox extends StatelessWidget {
  final bool isLoading;

  const _TermsCheckbox({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final formCubit = context.read<RegisterFormCubit>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: BlocBuilder<RegisterFormCubit, RegisterFormState>(
            buildWhen: (prev, curr) => prev.acceptedTerms != curr.acceptedTerms,
            builder: (context, formState) {
              return Checkbox(value: formState.acceptedTerms, onChanged: isLoading ? null : (value) => formCubit.setAcceptedTerms(value ?? false));
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium,
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
