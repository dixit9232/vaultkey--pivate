import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/subscription_entity.dart';
import '../../bloc/subscription/subscription_cubit.dart';
import '../../bloc/subscription/subscription_state.dart';

/// Subscription screen for viewing and managing subscription plans
class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => SubscriptionCubit(), child: const _SubscriptionView());
  }
}

class _SubscriptionView extends StatelessWidget {
  const _SubscriptionView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<SubscriptionCubit, SubscriptionState>(
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
          appBar: AppBar(title: const Text('Choose Your Plan')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Billing Toggle
                _BillingToggle(isYearly: state.isYearly),
                const SizedBox(height: 24),

                // Pricing Cards
                _PricingCard(
                  tier: SubscriptionTier.essential,
                  name: 'Essential',
                  monthlyPrice: 0,
                  yearlyPrice: 0,
                  features: const ['Unlimited TOTP/HOTP', 'QR Code Scanning', 'Biometric Authentication', 'Local Encrypted Storage', 'Recovery Codes'],
                  isPopular: false,
                  isYearly: state.isYearly,
                  selectedTier: state.selectedTier,
                ),
                const SizedBox(height: 16),

                _PricingCard(
                  tier: SubscriptionTier.securePlus,
                  name: 'Secure+',
                  monthlyPrice: 2.99,
                  yearlyPrice: 24.99,
                  features: const ['Everything in Essential', 'Encrypted Cloud Backup', 'Multi-Device Sync', 'Backup History (5 versions)', 'Priority Support'],
                  isPopular: true,
                  isYearly: state.isYearly,
                  selectedTier: state.selectedTier,
                ),
                const SizedBox(height: 16),

                _PricingCard(
                  tier: SubscriptionTier.pro,
                  name: 'Pro',
                  monthlyPrice: 4.99,
                  yearlyPrice: 39.99,
                  features: const ['Everything in Secure+', 'Advanced Organization', 'Bulk Import/Export', 'Custom Icons', 'Extended Backup (20 versions)', 'Beta Features Access'],
                  isPopular: false,
                  isYearly: state.isYearly,
                  selectedTier: state.selectedTier,
                ),

                const SizedBox(height: 32),

                // Restore Purchases
                BlocBuilder<SubscriptionCubit, SubscriptionState>(
                  buildWhen: (prev, curr) => prev.isLoading != curr.isLoading,
                  builder: (context, state) {
                    return TextButton(onPressed: state.isLoading ? null : () => context.read<SubscriptionCubit>().restorePurchases(), child: const Text('Restore Purchases'));
                  },
                ),

                const SizedBox(height: 16),

                // Terms and Privacy
                Text(
                  'By subscribing, you agree to our Terms of Service and Privacy Policy. '
                  'Subscriptions auto-renew unless cancelled at least 24 hours before the end of the current period.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _BillingToggle extends StatelessWidget {
  final bool isYearly;

  const _BillingToggle({required this.isYearly});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SubscriptionCubit>();

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          Expanded(
            child: _ToggleOption(label: 'Monthly', isSelected: !isYearly, onTap: () => cubit.setBillingPeriod(isYearly: false)),
          ),
          Expanded(
            child: _ToggleOption(label: 'Yearly', subtitle: 'Save up to 33%', isSelected: isYearly, onTap: () => cubit.setBillingPeriod(isYearly: true)),
          ),
        ],
      ),
    );
  }
}

class _ToggleOption extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleOption({required this.label, this.subtitle, required this.isSelected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: isSelected ? theme.colorScheme.primary : Colors.transparent, borderRadius: BorderRadius.circular(8)),
        child: Column(
          children: [
            Text(
              label,
              style: theme.textTheme.titleMedium?.copyWith(color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface, fontWeight: FontWeight.w600),
            ),
            if (subtitle != null) Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: isSelected ? theme.colorScheme.onPrimary.withValues(alpha: 0.8) : theme.colorScheme.primary)),
          ],
        ),
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  final SubscriptionTier tier;
  final String name;
  final double monthlyPrice;
  final double yearlyPrice;
  final List<String> features;
  final bool isPopular;
  final bool isYearly;
  final SubscriptionTier? selectedTier;

  const _PricingCard({required this.tier, required this.name, required this.monthlyPrice, required this.yearlyPrice, required this.features, required this.isPopular, required this.isYearly, required this.selectedTier});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<SubscriptionCubit>();
    final isSelected = selectedTier == tier;
    final price = isYearly ? yearlyPrice : monthlyPrice;
    final period = isYearly ? '/year' : '/month';

    return GestureDetector(
      onTap: () => cubit.selectTier(tier),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : isPopular
                ? theme.colorScheme.primary.withValues(alpha: 0.5)
                : theme.colorScheme.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isPopular ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.2), blurRadius: 12, offset: const Offset(0, 4))] : null,
        ),
        child: Column(
          children: [
            if (isPopular)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                ),
                child: Text(
                  '★ MOST POPULAR',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelMedium?.copyWith(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        price == 0 ? 'Free' : '\$${price.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineMedium?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold),
                      ),
                      if (price > 0)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 4),
                          child: Text(period, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        ),
                    ],
                  ),
                  if (isYearly && yearlyPrice > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        'Save \$${((monthlyPrice * 12) - yearlyPrice).toStringAsFixed(2)}/year',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.tertiary, fontWeight: FontWeight.w500),
                      ),
                    ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  ...features.map(
                    (feature) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.check_circle, size: 20, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(child: Text(feature, style: theme.textTheme.bodyMedium)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: tier == SubscriptionTier.essential ? OutlinedButton(onPressed: null, child: const Text('Current Plan')) : FilledButton(onPressed: () => cubit.purchaseSubscription(), child: const Text('Upgrade')),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
