import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../bloc/onboarding/onboarding_cubit.dart';
import '../../bloc/onboarding/onboarding_state.dart';
import '../../routes/app_routes.dart';

/// Onboarding screen with introduction slides
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (context) => OnboardingCubit(), child: const _OnboardingView());
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView> {
  final PageController _pageController = PageController();

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(icon: Icons.security_rounded, title: 'Security First', description: 'Your authenticator codes, protected with zero-knowledge encryption. Only you can access your secrets.', gradientColors: [AppColors.primary, AppColors.primaryDark]),
    _OnboardingPageData(icon: Icons.cloud_sync_rounded, title: 'Never Lose Access', description: 'Cloud backup with recovery codes - never get locked out of your accounts again.', gradientColors: [AppColors.accent, Color(0xFF2563EB)]),
    _OnboardingPageData(icon: Icons.devices_rounded, title: 'Multi-Device Sync', description: 'Use VaultKey across all your devices securely. Your codes are always with you.', gradientColors: [AppColors.success, Color(0xFF059669)]),
    _OnboardingPageData(icon: Icons.rocket_launch_rounded, title: 'Get Started', description: 'Create a free account or sign in to start securing your digital identity.', gradientColors: [AppColors.primary, AppColors.accent]),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    context.read<OnboardingCubit>().setCurrentPage(page);
  }

  void _nextPage() {
    final state = context.read<OnboardingCubit>().state;
    if (!state.isLastPage) {
      _pageController.nextPage(duration: AppConstants.mediumAnimation, curve: Curves.easeInOutCubic);
    } else {
      _navigateToLogin();
    }
  }

  void _navigateToLogin() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: state.isLastPage ? 0 : 1,
                  duration: AppConstants.shortAnimation,
                  child: TextButton(
                    onPressed: state.isLastPage ? null : _navigateToLogin,
                    child: Text('Skip', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: AppColors.white.withValues(alpha: 0.8))),
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: MediaQuery.of(context).padding.bottom + 32,
                child: Column(
                  children: [
                    _PageIndicators(currentPage: state.currentPage, totalPages: _pages.length),
                    const SizedBox(height: 32),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: FilledButton(
                              onPressed: _nextPage,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.white,
                                foregroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                              ),
                              child: Text(state.isLastPage ? l10n.signIn : l10n.next, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          if (state.isLastPage) ...[
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              height: 56,
                              child: OutlinedButton(
                                onPressed: () => context.go(AppRoutes.register),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.white,
                                  side: const BorderSide(color: AppColors.white, width: 2),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                ),
                                child: Text(l10n.createAccount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _PageIndicators extends StatelessWidget {
  final int currentPage;
  final int totalPages;

  const _PageIndicators({required this.currentPage, required this.totalPages});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: AppConstants.shortAnimation,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(color: isActive ? AppColors.white : AppColors.white.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(4)),
        );
      }),
    );
  }
}

/// Single onboarding page widget
class _OnboardingPage extends StatelessWidget {
  final _OnboardingPageData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: data.gradientColors),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Icon
              Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(color: AppColors.white.withValues(alpha: 0.15), shape: BoxShape.circle),
                child: Icon(data.icon, size: 80, color: AppColors.white),
              ),
              const SizedBox(height: 48),

              // Title
              Text(
                data.title,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Description
              Text(
                data.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white.withValues(alpha: 0.9), height: 1.5),
                textAlign: TextAlign.center,
              ),

              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

/// Data class for onboarding page content
class _OnboardingPageData {
  final IconData icon;
  final String title;
  final String description;
  final List<Color> gradientColors;

  const _OnboardingPageData({required this.icon, required this.title, required this.description, required this.gradientColors});
}
