import 'images.dart';

class OnboardingSlide {
  final String image;
  final String title;
  final String description;

  const OnboardingSlide({
    required this.image,
    required this.title,
    required this.description,
  });
}

const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    image: AppImages.onboarding1,
    title: 'Your AI Companion',
    description:
        'Meet your intelligent companion who learns from every conversation and adapts to your personality.',
  ),
  OnboardingSlide(
    image: AppImages.onboarding2,
    title: 'Remembers Everything',
    description:
        'Zawjati remembers your preferences, goals, and important life events to provide personalized conversations.',
  ),
  OnboardingSlide(
    image: AppImages.onboarding3,
    title: 'Privacy First',
    description:
        'Your data is encrypted and private. You control what is remembered and can delete anything anytime.',
  ),
];
