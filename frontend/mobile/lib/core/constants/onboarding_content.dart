import 'images.dart';

class OnboardingSlide {
  final String image;
  final String? secondImage;
  final String title;
  final String description;

  const OnboardingSlide({
    required this.image,
    this.secondImage,
    required this.title,
    required this.description,
  });
}

const List<OnboardingSlide> onboardingSlides = [
  OnboardingSlide(
    image: AppImages.onboarding1,
    title: 'Your events,\ncaptured.',
    description:
        'Join Micro Club events — our team captures every moment for you.',
  ),
  OnboardingSlide(
    image: AppImages.onboarding2,
    secondImage: AppImages.onboarding3,
    title: 'Found\nautomatically.',
    description: 'Our AI finds your face across every photo from every event.',
  ),
  OnboardingSlide(
    image: AppImages.onboarding3,
    title: 'Keep your\nmoments.',
    description: 'View, approve and download your photos whenever you want.',
  ),
];
