part of 'onboarding_bloc.dart';

class OnboardingState extends Equatable {
  final int pageIndex;
  final bool isComplete;

  const OnboardingState({
    this.pageIndex = 0,
    this.isComplete = false,
  });

  OnboardingState copyWith({
    int? pageIndex,
    bool? isComplete,
  }) {
    return OnboardingState(
      pageIndex: pageIndex ?? this.pageIndex,
      isComplete: isComplete ?? this.isComplete,
    );
  }

  @override
  List<Object?> get props => [pageIndex, isComplete];
}
