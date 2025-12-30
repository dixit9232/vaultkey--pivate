import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/injection_container.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/authenticator/authenticator_bloc.dart';
import '../../bloc/authenticator/authenticator_event.dart';
import '../../bloc/authenticator/authenticator_state.dart';
import '../../routes/app_routes.dart';
import '../../widgets/authenticator/otp_card.dart';

/// Home screen - main authenticator list
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (context) => sl<AuthenticatorBloc>()..add(const AuthenticatorLoadRequested()),
      child: BlocConsumer<AuthenticatorBloc, AuthenticatorState>(
        listener: (context, state) {
          // Show success message
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.success));
          }

          // Show error message
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), behavior: SnackBarBehavior.floating, backgroundColor: AppColors.error));
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(l10n.appName),
              actions: [
                IconButton(icon: const Icon(Icons.add), onPressed: () => context.push(AppRoutes.addAuthenticator), tooltip: l10n.addAuthenticator),
                IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () => context.push(AppRoutes.settings), tooltip: l10n.settings),
              ],
            ),
            body: _buildBody(context, state, l10n),
            floatingActionButton: FloatingActionButton.extended(onPressed: () => context.push(AppRoutes.scanQR), icon: const Icon(Icons.qr_code_scanner), label: Text(l10n.scanQRCode)),
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, AuthenticatorState state, AppLocalizations l10n) {
    if (state.isLoading && state.authenticators.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.isEmpty) {
      return _EmptyState(l10n: l10n);
    }

    return RefreshIndicator(
      onRefresh: () async {
        context.read<AuthenticatorBloc>().add(const AuthenticatorLoadRequested());
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 100),
        itemCount: state.displayedAuthenticators.length,
        itemBuilder: (context, index) {
          final authenticator = state.displayedAuthenticators[index];
          final otpCode = state.otpCodes[authenticator.id] ?? '------';

          return OTPCard(
            authenticator: authenticator,
            otpCode: otpCode,
            remainingSeconds: state.remainingSeconds,
            progress: state.progress,
            onCopy: () {
              context.read<AuthenticatorBloc>().add(AuthenticatorCopyCode(id: authenticator.id, code: otpCode));
            },
            onEdit: () {
              // TODO: Navigate to edit screen
            },
            onDelete: () {
              _showDeleteDialog(context, authenticator.id, authenticator.issuer, l10n);
            },
          );
        },
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, String id, String issuer, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('Are you sure you want to delete $issuer?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(dialogContext).pop(), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthenticatorBloc>().add(AuthenticatorDeleteRequested(id));
            },
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no authenticators are added
class _EmptyState extends StatelessWidget {
  final AppLocalizations l10n;

  const _EmptyState({required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), shape: BoxShape.circle),
              child: const Icon(Icons.security_rounded, size: 64, color: AppColors.primary),
            ),
            const SizedBox(height: 32),
            Text(
              l10n.noAuthenticators,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.noAuthenticatorsMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodySmall?.color),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(onPressed: () => context.push(AppRoutes.scanQR), icon: const Icon(Icons.qr_code_scanner), label: Text(l10n.scanQRCode)),
                const SizedBox(width: 16),
                OutlinedButton.icon(onPressed: () => context.push(AppRoutes.addAuthenticator), icon: const Icon(Icons.edit_note), label: Text(l10n.enterManually)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
