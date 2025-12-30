import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';

import '../../../core/services/otp_service.dart';
import '../../../domain/entities/authenticator_entity.dart' as entity;
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/add_authenticator/add_authenticator_cubit.dart';
import '../../bloc/add_authenticator/add_authenticator_state.dart';
import '../../bloc/authenticator/authenticator_bloc.dart';
import '../../bloc/authenticator/authenticator_event.dart';
import '../../widgets/inputs/custom_text_field.dart';

/// Screen for manually adding an authenticator
class AddAuthenticatorScreen extends StatelessWidget {
  const AddAuthenticatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => AddAuthenticatorCubit(), child: const _AddAuthenticatorView());
  }
}

class _AddAuthenticatorView extends StatefulWidget {
  const _AddAuthenticatorView();

  @override
  State<_AddAuthenticatorView> createState() => _AddAuthenticatorViewState();
}

class _AddAuthenticatorViewState extends State<_AddAuthenticatorView> {
  final _formKey = GlobalKey<FormState>();
  final _issuerController = TextEditingController();
  final _accountController = TextEditingController();
  final _secretController = TextEditingController();

  @override
  void dispose() {
    _issuerController.dispose();
    _accountController.dispose();
    _secretController.dispose();
    super.dispose();
  }

  void _onSecretChanged(String value) {
    context.read<AddAuthenticatorCubit>().generatePreview(value);
  }

  void _onSubmit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final cubit = context.read<AddAuthenticatorCubit>();
    final state = cubit.state;
    final secret = _secretController.text.trim().toUpperCase();

    if (!cubit.validateSecret(secret)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invalid secret key. Please check and try again.'), backgroundColor: Colors.red));
      return;
    }

    cubit.setLoading(true);

    final authenticator = entity.AuthenticatorEntity(
      id: const Uuid().v4(),
      issuer: _issuerController.text.trim(),
      accountName: _accountController.text.trim(),
      secret: secret,
      type: state.selectedType,
      algorithm: state.selectedAlgorithm,
      digits: state.selectedDigits,
      period: state.selectedPeriod,
      createdAt: DateTime.now(),
    );

    context.read<AuthenticatorBloc>().add(AuthenticatorAddRequested(authenticator));
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<AddAuthenticatorCubit, AddAuthenticatorState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text(l10n.addAuthenticator),
            actions: [
              TextButton(
                onPressed: state.isLoading ? null : _onSubmit,
                child: state.isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(l10n.save),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BlocSelector<AddAuthenticatorCubit, AddAuthenticatorState, String?>(
                    selector: (state) => state.previewCode,
                    builder: (context, previewCode) {
                      if (previewCode == null) return const SizedBox.shrink();
                      return _PreviewCard(code: previewCode, period: state.selectedPeriod);
                    },
                  ),
                  CustomTextField(
                    controller: _issuerController,
                    labelText: l10n.issuer,
                    hintText: 'Google, Microsoft, GitHub...',
                    prefixIcon: Icons.business_outlined,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Issuer is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _accountController,
                    labelText: l10n.accountName,
                    hintText: 'email@example.com',
                    prefixIcon: Icons.account_circle_outlined,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Account name is required';
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    controller: _secretController,
                    labelText: l10n.secretKey,
                    hintText: 'JBSWY3DPEHPK3PXP',
                    prefixIcon: Icons.key_outlined,
                    textInputAction: TextInputAction.done,
                    textCapitalization: TextCapitalization.characters,
                    onChanged: _onSecretChanged,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) return 'Secret key is required';
                      if (!OTPService.instance.isValidSecret(value.trim())) return 'Invalid Base32 secret key';
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _AdvancedOptionsSection(secretController: _secretController),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  final String code;
  final int period;

  const _PreviewCard({required this.code, required this.period});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formattedCode = code.length > 3 ? '${code.substring(0, code.length ~/ 2)} ${code.substring(code.length ~/ 2)}' : code;

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text('Preview', style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 8),
            Text(
              formattedCode,
              style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: 4, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 4),
            Text('This code will change every $period seconds', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}

class _AdvancedOptionsSection extends StatelessWidget {
  final TextEditingController secretController;

  const _AdvancedOptionsSection({required this.secretController});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AddAuthenticatorCubit>();

    return ExpansionTile(
      title: const Text('Advanced Options'),
      initiallyExpanded: false,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              BlocSelector<AddAuthenticatorCubit, AddAuthenticatorState, entity.OTPType>(
                selector: (state) => state.selectedType,
                builder: (context, selectedType) {
                  return _DropdownRow<entity.OTPType>(
                    label: 'Type',
                    value: selectedType,
                    items: entity.OTPType.values,
                    onChanged: (value) {
                      if (value != null) cubit.setType(value);
                    },
                    itemLabel: (e) => e.name.toUpperCase(),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<AddAuthenticatorCubit, AddAuthenticatorState, entity.Algorithm>(
                selector: (state) => state.selectedAlgorithm,
                builder: (context, selectedAlgorithm) {
                  return _DropdownRow<entity.Algorithm>(
                    label: 'Algorithm',
                    value: selectedAlgorithm,
                    items: entity.Algorithm.values,
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setAlgorithm(value);
                        cubit.generatePreview(secretController.text);
                      }
                    },
                    itemLabel: (e) => e.name.toUpperCase(),
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<AddAuthenticatorCubit, AddAuthenticatorState, int>(
                selector: (state) => state.selectedDigits,
                builder: (context, selectedDigits) {
                  return _DropdownRow<int>(
                    label: 'Digits',
                    value: selectedDigits,
                    items: const [6, 8],
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setDigits(value);
                        cubit.generatePreview(secretController.text);
                      }
                    },
                    itemLabel: (e) => '$e digits',
                  );
                },
              ),
              const SizedBox(height: 16),
              BlocSelector<AddAuthenticatorCubit, AddAuthenticatorState, int>(
                selector: (state) => state.selectedPeriod,
                builder: (context, selectedPeriod) {
                  return _DropdownRow<int>(
                    label: 'Period',
                    value: selectedPeriod,
                    items: const [30, 60],
                    onChanged: (value) {
                      if (value != null) {
                        cubit.setPeriod(value);
                        cubit.generatePreview(secretController.text);
                      }
                    },
                    itemLabel: (e) => '$e seconds',
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DropdownRow<T> extends StatelessWidget {
  final String label;
  final T value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemLabel;

  const _DropdownRow({required this.label, required this.value, required this.items, required this.onChanged, required this.itemLabel});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: Text(label, style: Theme.of(context).textTheme.bodyMedium)),
        Expanded(
          flex: 3,
          child: DropdownButtonFormField<T>(
            initialValue: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: items.map((item) => DropdownMenuItem<T>(value: item, child: Text(itemLabel(item)))).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
