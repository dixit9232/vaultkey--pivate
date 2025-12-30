import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/auth/auth.dart';

/// Password field with visibility toggle
class PasswordField extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final bool showStrengthIndicator;

  const PasswordField({super.key, this.controller, this.focusNode, this.labelText, this.hintText, this.enabled = true, this.validator, this.onSubmitted, this.onChanged, this.textInputAction = TextInputAction.done, this.showStrengthIndicator = false});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => PasswordVisibilityCubit()),
        if (showStrengthIndicator) BlocProvider(create: (_) => PasswordStrengthCubit()),
      ],
      child: _PasswordFieldContent(controller: controller, focusNode: focusNode, labelText: labelText, hintText: hintText, enabled: enabled, validator: validator, onSubmitted: onSubmitted, onChanged: onChanged, textInputAction: textInputAction, showStrengthIndicator: showStrengthIndicator),
    );
  }
}

class _PasswordFieldContent extends StatelessWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? labelText;
  final String? hintText;
  final bool enabled;
  final String? Function(String?)? validator;
  final void Function(String)? onSubmitted;
  final void Function(String)? onChanged;
  final TextInputAction textInputAction;
  final bool showStrengthIndicator;

  const _PasswordFieldContent({this.controller, this.focusNode, this.labelText, this.hintText, this.enabled = true, this.validator, this.onSubmitted, this.onChanged, this.textInputAction = TextInputAction.done, this.showStrengthIndicator = false});

  void _handleChange(BuildContext context, String value) {
    if (showStrengthIndicator) {
      context.read<PasswordStrengthCubit>().updateStrength(value);
    }
    onChanged?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocBuilder<PasswordVisibilityCubit, bool>(
          builder: (context, obscureText) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              obscureText: obscureText,
              enabled: enabled,
              textInputAction: textInputAction,
              keyboardType: TextInputType.visiblePassword,
              autocorrect: false,
              enableSuggestions: false,
              decoration: InputDecoration(
                labelText: labelText,
                hintText: hintText,
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(icon: Icon(obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined), onPressed: () => context.read<PasswordVisibilityCubit>().toggle(), tooltip: obscureText ? 'Show password' : 'Hide password'),
              ),
              validator: validator,
              onFieldSubmitted: onSubmitted,
              onChanged: (value) => _handleChange(context, value),
            );
          },
        ),
        if (showStrengthIndicator)
          BlocBuilder<PasswordStrengthCubit, PasswordStrengthLevel>(
            builder: (context, strength) {
              final hasText = controller?.text.isNotEmpty ?? false;
              if (!hasText) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _PasswordStrengthIndicator(strength: strength),
                  const SizedBox(height: 4),
                  Text('Use 8+ characters with uppercase, numbers, symbols', style: Theme.of(context).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant)),
                ],
              );
            },
          ),
      ],
    );
  }
}

class _PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrengthLevel strength;

  const _PasswordStrengthIndicator({required this.strength});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(value: strength.progress, backgroundColor: colorScheme.surfaceContainerHighest, valueColor: AlwaysStoppedAnimation<Color>(_getColor(colorScheme)), minHeight: 4),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          strength.label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(color: _getColor(colorScheme), fontWeight: FontWeight.w600),
        ),
      ],
    );
  }

  Color _getColor(ColorScheme colorScheme) {
    switch (strength) {
      case PasswordStrengthLevel.weak:
        return colorScheme.error;
      case PasswordStrengthLevel.fair:
        return colorScheme.tertiary;
      case PasswordStrengthLevel.good:
        return colorScheme.primary;
      case PasswordStrengthLevel.strong:
        return const Color(0xFF22C55E);
    }
  }
}
