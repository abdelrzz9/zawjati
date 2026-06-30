part of 'onboarding_bloc.dart';

abstract class OnboardingEvent extends Equatable {
  const OnboardingEvent();

  @override
  List<Object?> get props => [];
}

class OnboardingNextPage extends OnboardingEvent {
  const OnboardingNextPage();
}

class OnboardingPreviousPage extends OnboardingEvent {
  const OnboardingPreviousPage();
}

class OnboardingComplete extends OnboardingEvent {
  const OnboardingComplete();
}
