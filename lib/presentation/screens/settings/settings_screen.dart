import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/generated/app_localizations.dart';
import '../../routes/app_routes.dart';

/// Settings screen for app configuration
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        children: [
          // Appearance Section
          _buildSectionHeader(context, l10n.appearance),
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.appearance),
            subtitle: const Text('Theme, colors, display options'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to appearance settings
            },
          ),

          const Divider(),

          // Security Section
          _buildSectionHeader(context, l10n.security),
          ListTile(
            leading: const Icon(Icons.fingerprint),
            title: Text(l10n.enableBiometric),
            subtitle: const Text('Use fingerprint or face to unlock'),
            trailing: Switch(
              value: false, // TODO: Get from state
              onChanged: (value) {
                // TODO: Toggle biometric
              },
            ),
          ),
          ListTile(
            leading: const Icon(Icons.timer_outlined),
            title: Text(l10n.autoLock),
            subtitle: const Text('Lock app when in background'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to auto lock settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.content_paste_off),
            title: Text(l10n.clearClipboard),
            subtitle: Text(l10n.clearClipboardDescription),
            trailing: Switch(
              value: true, // TODO: Get from state
              onChanged: (value) {
                // TODO: Toggle clipboard clearing
              },
            ),
          ),

          const Divider(),

          // Backup Section
          _buildSectionHeader(context, l10n.backup),
          ListTile(
            leading: const Icon(Icons.cloud_outlined),
            title: Text(l10n.backup),
            subtitle: const Text('Cloud backup & sync settings'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to backup settings
            },
          ),

          const Divider(),

          // About Section
          _buildSectionHeader(context, l10n.about),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: Text(l10n.about),
            subtitle: const Text('Version, licenses, support'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // TODO: Navigate to about screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.signOut),
            textColor: theme.colorScheme.error,
            iconColor: theme.colorScheme.error,
            onTap: () {
              _showSignOutDialog(context, l10n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.w600, letterSpacing: 1.2),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.signOut),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Sign out and navigate to login
              context.go(AppRoutes.login);
            },
            child: Text(l10n.signOut),
          ),
        ],
      ),
    );
  }
}
