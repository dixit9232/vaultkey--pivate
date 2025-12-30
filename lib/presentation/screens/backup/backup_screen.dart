import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/backup/backup_cubit.dart';
import '../../bloc/backup/backup_state.dart';

/// Backup & Sync settings screen
class BackupScreen extends StatelessWidget {
  const BackupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => BackupCubit()..loadBackupData(), child: const _BackupView());
  }
}

class _BackupView extends StatelessWidget {
  const _BackupView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocConsumer<BackupCubit, BackupState>(
      listener: (context, state) {
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!), behavior: SnackBarBehavior.floating));
        }
        if (state.successMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), behavior: SnackBarBehavior.floating));
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(title: Text(l10n.backup)),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _BackupStatusCard(state: state),
              const SizedBox(height: 24),
              _AutoBackupSection(state: state),
              const SizedBox(height: 24),
              _SyncSection(theme: theme, l10n: l10n),
              const SizedBox(height: 24),
              _BackupHistorySection(state: state),
              const SizedBox(height: 24),
              _RecoverySection(theme: theme, l10n: l10n),
            ],
          ),
        );
      },
    );
  }
}

class _BackupStatusCard extends StatelessWidget {
  final BackupState state;

  const _BackupStatusCard({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<BackupCubit>();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: theme.colorScheme.primaryContainer, borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.cloud_done, color: theme.colorScheme.onPrimaryContainer),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cloud Backup', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(state.lastSyncAt != null ? 'Last backup: ${_formatTime(state.lastSyncAt!)}' : 'Never backed up', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: state.isSyncing ? null : () => cubit.performBackup(),
                  child: state.isSyncing ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Backup Now'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Storage Used', style: theme.textTheme.bodySmall),
                    Text('${state.storageUsed.toStringAsFixed(1)} MB of ${state.storageTotal.toStringAsFixed(0)} MB', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: state.storageProgress, backgroundColor: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(4)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    return '${diff.inDays} days ago';
  }
}

class _AutoBackupSection extends StatelessWidget {
  final BackupState state;

  const _AutoBackupSection({required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<BackupCubit>();

    return Card(
      child: Column(
        children: [
          BlocSelector<BackupCubit, BackupState, bool>(
            selector: (state) => state.autoBackupEnabled,
            builder: (context, autoBackupEnabled) {
              return SwitchListTile(title: const Text('Automatic Backup'), subtitle: const Text('Backup when authenticators change'), value: autoBackupEnabled, onChanged: (value) => cubit.toggleAutoBackup(value));
            },
          ),
          const Divider(height: 1),
          ListTile(title: const Text('Backup Frequency'), subtitle: const Text('Daily'), trailing: const Icon(Icons.chevron_right), enabled: state.autoBackupEnabled, onTap: () {}),
          const Divider(height: 1),
          BlocSelector<BackupCubit, BackupState, ({bool autoEnabled, bool wifiOnly})>(
            selector: (state) => (autoEnabled: state.autoBackupEnabled, wifiOnly: state.wifiOnlyEnabled),
            builder: (context, data) {
              return ListTile(
                title: const Text('Backup on Wi-Fi Only'),
                subtitle: const Text('Save mobile data'),
                trailing: Switch(value: data.wifiOnly, onChanged: data.autoEnabled ? (value) => cubit.toggleWifiOnly(value) : null),
                enabled: data.autoEnabled,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SyncSection extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _SyncSection({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Multi-Device Sync', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.phone_android)),
            title: const Text('This device'),
            subtitle: const Text('Last synced: Just now'),
            trailing: Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ),
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.tablet_android)),
            title: const Text('Tablet'),
            subtitle: const Text('Last synced: 2 hours ago'),
            trailing: Icon(Icons.check_circle, color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

class _BackupHistorySection extends StatelessWidget {
  final BackupState state;

  const _BackupHistorySection({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<BackupCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Backup History', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
              TextButton(onPressed: () {}, child: const Text('View All')),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: state.backupHistory.map((backup) {
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(backup.isAutomatic ? Icons.cloud_sync : Icons.cloud_upload, size: 20, color: theme.colorScheme.primary),
                    ),
                    title: Text(backup.relativeTime),
                    subtitle: Text('${backup.authenticatorCount} authenticators • ${backup.formattedSize}'),
                    trailing: PopupMenuButton<String>(
                      itemBuilder: (context) => [const PopupMenuItem(value: 'restore', child: Text('Restore')), const PopupMenuItem(value: 'download', child: Text('Download')), const PopupMenuItem(value: 'delete', child: Text('Delete'))],
                      onSelected: (value) {
                        if (value == 'restore') {
                          cubit.restoreBackup(backup.id);
                        } else if (value == 'delete') {
                          cubit.deleteBackup(backup.id);
                        }
                      },
                    ),
                  ),
                  if (backup != state.backupHistory.last) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _RecoverySection extends StatelessWidget {
  final ThemeData theme;
  final AppLocalizations l10n;

  const _RecoverySection({required this.theme, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.tertiaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.vpn_key, color: theme.colorScheme.onTertiaryContainer),
            ),
            title: const Text('Recovery Codes'),
            subtitle: const Text('View or regenerate codes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: theme.colorScheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.picture_as_pdf, color: theme.colorScheme.onSecondaryContainer),
            ),
            title: const Text('Recovery Kit'),
            subtitle: const Text('Download PDF backup'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
