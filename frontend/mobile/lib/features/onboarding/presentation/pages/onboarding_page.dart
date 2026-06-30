import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/onboarding_content.dart';
import '../../../../core/constants/storage_keys.dart';
import '../../../../core/storage/app_local_storage.dart';
import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/onboarding_bloc.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OnboardingBloc(),
      child: const _OnboardingBody(),
    );
  }
}

class _OnboardingBody extends StatelessWidget {
  const _OnboardingBody();

  @override
  Widget build(BuildContext context) {
    final pageController = PageController();

    return BlocConsumer<OnboardingBloc, OnboardingState>(
      listener: (context, state) {
        if (state.isComplete) {
          context.read<LocalStorage>().setBool(
            StorageKeys.seenOnboarding,
            true,
          );
          context.go('/login');
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppThemeColors.onboardingBackground,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: pageController,
                    onPageChanged: (index) {
                      if (index > state.pageIndex) {
                        context
                            .read<OnboardingBloc>()
                            .add(const OnboardingNextPage());
                      } else {
                        context
                            .read<OnboardingBloc>()
                            .add(const OnboardingPreviousPage());
                      }
                    },
                    itemCount: onboardingSlides.length,
                    itemBuilder: (context, index) {
                      final slide = onboardingSlides[index];
                      return _SlideContent(slide: slide);
                    },
                  ),
                ),
                _BottomBar(
                  pageController: pageController,
                  pageCount: onboardingSlides.length,
                  currentIndex: state.pageIndex,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SlideContent extends StatelessWidget {
  final OnboardingSlide slide;

  const _SlideContent({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingXl,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Center(
              child: Image.asset(
                slide.image,
                height: 280,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.auto_awesome,
                  size: 120,
                  color: AppThemeColors.primaryAccent.withValues(alpha: 0.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingXl),
          Text(
            slide.title,
            style: AppThemeTextStyles.onboardingLargeText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppThemeMetrics.spacingMd),
          Text(
            slide.description,
            style: AppThemeTextStyles.onboardingMediumText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppThemeMetrics.spacingXxl),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final PageController pageController;
  final int pageCount;
  final int currentIndex;

  const _BottomBar({
    required this.pageController,
    required this.pageCount,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pageCount,
              (index) => _DotIndicator(
                isActive: index == currentIndex,
              ),
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingXl),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                if (currentIndex < pageCount - 1) {
                  pageController.nextPage(
                    duration: AppThemeMetrics.durationMedium,
                    curve: AppThemeMetrics.curveStandard,
                  );
                } else {
                  context
                      .read<OnboardingBloc>()
                      .add(const OnboardingComplete());
                }
              },
              child: Text(
                currentIndex < pageCount - 1 ? 'Next' : 'Get Started',
              ),
            ),
          ),
          const SizedBox(height: AppThemeMetrics.spacingSm),
          if (currentIndex < pageCount - 1)
            TextButton(
              onPressed: () {
                context.read<OnboardingBloc>().add(const OnboardingComplete());
              },
              child: const Text('Skip'),
            ),
        ],
      ),
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;

  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppThemeMetrics.durationFast,
      margin: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingXs,
      ),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppThemeColors.primaryAccent
            : AppThemeColors.neutral600,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
      ),
    );
  }
}
