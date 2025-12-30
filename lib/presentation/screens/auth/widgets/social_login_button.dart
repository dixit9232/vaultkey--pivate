import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Social login provider enum
enum SocialProvider { google, microsoft }

/// Social login button widget
class SocialLoginButton extends StatelessWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SocialLoginButton({super.key, required this.provider, this.onPressed, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: colorScheme.outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        child: isLoading
            ? SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2.5, valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary)))
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIcon(),
                  const SizedBox(width: 12),
                  Text(_getLabel(), style: Theme.of(context).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500)),
                ],
              ),
      ),
    );
  }

  Widget _buildIcon() {
    switch (provider) {
      case SocialProvider.google:
        return SvgPicture.asset('assets/icons/google-svg.svg', width: 24, height: 24);
      case SocialProvider.microsoft:
        return SvgPicture.asset('assets/icons/microsoft-svg.svg', width: 24, height: 24);
    }
  }

  String _getLabel() {
    switch (provider) {
      case SocialProvider.google:
        return 'Continue with Google';
      case SocialProvider.microsoft:
        return 'Continue with Microsoft';
    }
  }
}
