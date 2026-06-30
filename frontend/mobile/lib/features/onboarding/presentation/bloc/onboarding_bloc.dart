import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'onboarding_event.dart';
part 'onboarding_state.dart';

class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingNextPage>(_onNextPage);
    on<OnboardingPreviousPage>(_onPreviousPage);
    on<OnboardingComplete>(_onComplete);
  }

  void _onNextPage(
    OnboardingNextPage event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.pageIndex < 2) {
      emit(state.copyWith(pageIndex: state.pageIndex + 1));
    }
  }

  void _onPreviousPage(
    OnboardingPreviousPage event,
    Emitter<OnboardingState> emit,
  ) {
    if (state.pageIndex > 0) {
      emit(state.copyWith(pageIndex: state.pageIndex - 1));
    }
  }

  void _onComplete(
    OnboardingComplete event,
    Emitter<OnboardingState> emit,
  ) {
    emit(state.copyWith(isComplete: true));
  }
}
