import 'package:equatable/equatable.dart';

/// Onboarding state
class OnboardingState extends Equatable {
  final int currentPage;
  final int totalPages;

  const OnboardingState({this.currentPage = 0, this.totalPages = 4});

  bool get isLastPage => currentPage == totalPages - 1;

  OnboardingState copyWith({int? currentPage, int? totalPages}) {
    return OnboardingState(currentPage: currentPage ?? this.currentPage, totalPages: totalPages ?? this.totalPages);
  }

  @override
  List<Object?> get props => [currentPage, totalPages];
}
