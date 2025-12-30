import 'package:flutter_bloc/flutter_bloc.dart';

import 'onboarding_state.dart';

/// Cubit for managing onboarding state
class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit() : super(const OnboardingState());

  /// Update current page
  void setCurrentPage(int page) {
    emit(state.copyWith(currentPage: page));
  }

  /// Go to next page
  void nextPage() {
    if (!state.isLastPage) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  /// Go to previous page
  void previousPage() {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }
}
