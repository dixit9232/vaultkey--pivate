import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../domain/entities/authenticator_entity.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/scanner/qr_scanner_cubit.dart';
import '../../bloc/scanner/qr_scanner_state.dart';

/// QR Code scanner screen for adding authenticators
class QRScannerScreen extends StatelessWidget {
  const QRScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => QRScannerCubit(), child: const _QRScannerView());
  }
}

class _QRScannerView extends StatefulWidget {
  const _QRScannerView();

  @override
  State<_QRScannerView> createState() => _QRScannerViewState();
}

class _QRScannerViewState extends State<_QRScannerView> {
  final MobileScannerController _controller = MobileScannerController(detectionSpeed: DetectionSpeed.normal, facing: CameraFacing.back, torchEnabled: false);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final cubit = context.read<QRScannerCubit>();
    final state = cubit.state;

    if (state.isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null || !code.startsWith('otpauth://')) return;

    cubit.processQRCode(code);
  }

  void _showConfirmationDialog(BuildContext context, AuthenticatorEntity authenticator) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<QRScannerCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Authenticator'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(context, 'Service', authenticator.issuer),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Account', authenticator.accountName),
            const SizedBox(height: 8),
            _buildInfoRow(context, 'Type', authenticator.type.name.toUpperCase()),
            const SizedBox(height: 16),
            Text('Add this authenticator to VaultKey?', style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              cubit.resetScanner();
            },
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop(authenticator);
            },
            child: Text(l10n.add),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text('$label:', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
        ),
        Expanded(child: Text(value, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<QRScannerCubit, QRScannerState>(
      listener: (context, state) {
        if (state.scannedAuthenticator != null) {
          _showConfirmationDialog(context, state.scannedAuthenticator!);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.scanQRCode),
          actions: [
            IconButton(
              icon: ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, state, child) {
                  return Icon(state.torchState == TorchState.on ? Icons.flash_on : Icons.flash_off);
                },
              ),
              onPressed: () => _controller.toggleTorch(),
              tooltip: 'Toggle flashlight',
            ),
            IconButton(icon: const Icon(Icons.cameraswitch), onPressed: () => _controller.switchCamera(), tooltip: 'Switch camera'),
          ],
        ),
        body: Stack(
          children: [
            MobileScanner(
              controller: _controller,
              onDetect: _onDetect,
              errorBuilder: (context, error, child) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 64, color: Colors.red),
                      const SizedBox(height: 16),
                      Text('Camera Error', style: theme.textTheme.titleLarge),
                      const SizedBox(height: 8),
                      Text(error.errorDetails?.message ?? 'Unknown error', style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
                    ],
                  ),
                );
              },
            ),
            _buildScanOverlay(context),
            BlocBuilder<QRScannerCubit, QRScannerState>(
              buildWhen: (prev, curr) => prev.errorMessage != curr.errorMessage,
              builder: (context, state) {
                if (state.errorMessage == null) return const SizedBox.shrink();
                return Positioned(
                  bottom: 100,
                  left: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: theme.colorScheme.errorContainer, borderRadius: BorderRadius.circular(12)),
                    child: Text(
                      state.errorMessage!,
                      style: TextStyle(color: theme.colorScheme.onErrorContainer),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 32,
              left: 16,
              right: 16,
              child: OutlinedButton.icon(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.edit_note),
                label: Text(l10n.enterManually),
                style: OutlinedButton.styleFrom(backgroundColor: theme.colorScheme.surface.withValues(alpha: 0.9), padding: const EdgeInsets.symmetric(vertical: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScanOverlay(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.5), BlendMode.srcOut),
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.transparent, backgroundBlendMode: BlendMode.dstOut),
          ),
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
            ),
          ),
        ],
      ),
    );
  }
}
