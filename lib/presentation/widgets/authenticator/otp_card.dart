import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/authenticator_entity.dart';

/// OTP Card widget for displaying authenticator with countdown
class OTPCard extends StatelessWidget {
  final AuthenticatorEntity authenticator;
  final String otpCode;
  final int remainingSeconds;
  final double progress;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final VoidCallback? onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const OTPCard({super.key, required this.authenticator, required this.otpCode, this.remainingSeconds = 30, this.progress = 0.0, this.onTap, this.onLongPress, this.onCopy, this.onEdit, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isExpiring = remainingSeconds <= 5;

    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isExpiring ? BorderSide(color: theme.colorScheme.error.withValues(alpha: 0.5), width: 1.5) : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap ?? onCopy,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Service Icon
              _buildServiceIcon(context),
              const SizedBox(width: 16),

              // Account Info & OTP Code
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Issuer
                    Text(
                      authenticator.issuer,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),

                    // Account Name
                    Text(
                      authenticator.accountName,
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // OTP Code
                    _buildOTPCode(context, isExpiring),
                  ],
                ),
              ),

              // Timer & Actions
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // More Options Menu
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: theme.colorScheme.onSurfaceVariant),
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'copy',
                        child: ListTile(leading: Icon(Icons.copy), title: Text('Copy'), dense: true, contentPadding: EdgeInsets.zero),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: ListTile(leading: Icon(Icons.edit_outlined), title: Text('Edit'), dense: true, contentPadding: EdgeInsets.zero),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline, color: AppColors.error),
                          title: Text('Delete', style: TextStyle(color: AppColors.error)),
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      switch (value) {
                        case 'copy':
                          onCopy?.call();
                          break;
                        case 'edit':
                          onEdit?.call();
                          break;
                        case 'delete':
                          onDelete?.call();
                          break;
                      }
                    },
                  ),

                  const SizedBox(height: 8),

                  // Countdown Timer
                  _buildCountdown(context, isExpiring),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor = _getServiceColor(authenticator.issuer);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
      child: authenticator.iconUrl != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(authenticator.iconUrl!, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => _buildDefaultIcon(theme, iconColor)),
            )
          : _buildDefaultIcon(theme, iconColor),
    );
  }

  Widget _buildDefaultIcon(ThemeData theme, Color color) {
    final initial = authenticator.issuer.isNotEmpty ? authenticator.issuer[0].toUpperCase() : '?';

    return Center(
      child: Text(
        initial,
        style: theme.textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOTPCode(BuildContext context, bool isExpiring) {
    final theme = Theme.of(context);
    final formattedCode = _formatOTPCode(otpCode);

    return AnimatedDefaultTextStyle(
      duration: const Duration(milliseconds: 200),
      style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 28, fontWeight: FontWeight.w600, letterSpacing: 4, color: isExpiring ? theme.colorScheme.error : theme.colorScheme.onSurface),
      child: Text(formattedCode),
    );
  }

  Widget _buildCountdown(BuildContext context, bool isExpiring) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Progress Ring
          CircularProgressIndicator(value: 1 - progress, strokeWidth: 3, backgroundColor: theme.colorScheme.surfaceContainerHighest, valueColor: AlwaysStoppedAnimation<Color>(isExpiring ? theme.colorScheme.error : theme.colorScheme.primary)),
          // Seconds Text
          Text(
            '$remainingSeconds',
            style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold, color: isExpiring ? theme.colorScheme.error : theme.colorScheme.onSurface),
          ),
        ],
      ),
    );
  }

  String _formatOTPCode(String code) {
    if (code.length <= 3) return code;
    final mid = code.length ~/ 2;
    return '${code.substring(0, mid)} ${code.substring(mid)}';
  }

  Color _getServiceColor(String issuer) {
    // Common service colors
    final lowerIssuer = issuer.toLowerCase();
    if (lowerIssuer.contains('google')) return const Color(0xFF4285F4);
    if (lowerIssuer.contains('microsoft')) return const Color(0xFF00A4EF);
    if (lowerIssuer.contains('github')) return const Color(0xFF333333);
    if (lowerIssuer.contains('amazon')) return const Color(0xFFFF9900);
    if (lowerIssuer.contains('facebook')) return const Color(0xFF1877F2);
    if (lowerIssuer.contains('twitter') || lowerIssuer.contains('x')) return const Color(0xFF1DA1F2);
    if (lowerIssuer.contains('discord')) return const Color(0xFF5865F2);
    if (lowerIssuer.contains('slack')) return const Color(0xFF4A154B);
    if (lowerIssuer.contains('dropbox')) return const Color(0xFF0061FF);
    if (lowerIssuer.contains('apple')) return const Color(0xFF555555);
    if (lowerIssuer.contains('steam')) return const Color(0xFF1B2838);
    if (lowerIssuer.contains('binance')) return const Color(0xFFF0B90B);
    if (lowerIssuer.contains('coinbase')) return const Color(0xFF0052FF);

    // Generate color from issuer name
    final hash = issuer.hashCode;
    return Color.fromARGB(255, (hash & 0xFF0000) >> 16, (hash & 0x00FF00) >> 8, hash & 0x0000FF).withValues(alpha: 0.8);
  }
}
