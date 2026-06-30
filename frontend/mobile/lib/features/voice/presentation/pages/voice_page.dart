import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme_colors.dart';
import '../../../../core/theme/app_theme_metrics.dart';
import '../../../../core/theme/app_theme_text_styles.dart';
import '../bloc/voice_bloc.dart';

class VoicePage extends StatelessWidget {
  const VoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VoiceBloc(),
      child: const _VoiceBody(),
    );
  }
}

class _VoiceBody extends StatelessWidget {
  const _VoiceBody();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VoiceBloc, VoiceState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppThemeColors.background,
          appBar: AppBar(
            title: const Text('Voice'),
            actions: [
              Row(
                children: [
                  const Text('Hands-free'),
                  Switch(
                    value: state.isHandsFree,
                    onChanged: (_) {
                      context
                          .read<VoiceBloc>()
                          .add(const ToggleHandsFree());
                    },
                  ),
                ],
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _WaveformAnimation(isActive: state.isListening),
                      const SizedBox(
                        height: AppThemeMetrics.spacingXl,
                      ),
                      if (state.transcript != null &&
                          state.transcript!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppThemeMetrics.spacingLg,
                          ),
                          child: Text(
                            state.transcript!,
                            style: AppThemeTextStyles.textTheme.bodyLarge,
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Text(
                          state.isListening
                              ? 'Listening...'
                              : 'Tap to speak',
                          style: AppThemeTextStyles.textTheme.bodyMedium
                              ?.copyWith(
                            color: AppThemeColors.subtitleText,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(AppThemeMetrics.spacingXl),
                child: Column(
                  children: [
                    _VoiceSelector(),
                    const SizedBox(height: AppThemeMetrics.spacingMd),
                    _PlaybackSpeedControl(),
                    const SizedBox(height: AppThemeMetrics.spacingXl),
                    GestureDetector(
                      onLongPress: state.isHandsFree
                          ? null
                          : () {
                              context
                                  .read<VoiceBloc>()
                                  .add(const StartListening());
                            },
                      onLongPressUp: state.isHandsFree
                          ? null
                          : () {
                              context.read<VoiceBloc>().add(
                                    const StopListening(),
                                  );
                            },
                      onTap: state.isHandsFree
                          ? () {
                              if (state.isListening) {
                                context
                                    .read<VoiceBloc>()
                                    .add(const StopListening());
                              } else {
                                context
                                    .read<VoiceBloc>()
                                    .add(const StartListening());
                              }
                            }
                          : null,
                      child: AnimatedContainer(
                        duration: AppThemeMetrics.durationFast,
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: state.isListening
                              ? AppThemeColors.error
                              : AppThemeColors.primaryAccent,
                          shape: BoxShape.circle,
                          boxShadow: state.isListening
                              ? [
                                  BoxShadow(
                                    color: AppThemeColors.error
                                        .withValues(alpha: 0.4),
                                    blurRadius: 20,
                                    spreadRadius: 4,
                                  ),
                                ]
                              : null,
                        ),
                        child: Icon(
                          state.isListening ? Icons.mic : Icons.mic_none,
                          color: AppThemeColors.neutral0,
                          size: AppThemeMetrics.iconLg,
                        ),
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

class _WaveformAnimation extends StatefulWidget {
  final bool isActive;

  const _WaveformAnimation({required this.isActive});

  @override
  State<_WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<_WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppThemeMetrics.durationSlow,
    );
    _animations = List.generate(
      5,
      (i) => Tween<double>(begin: 0.3, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(i * 0.15, 0.6 + i * 0.08,
              curve: Curves.easeInOutCubic),
        ),
      ),
    );
    if (widget.isActive) _controller.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(_WaveformAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _controller.repeat(reverse: true);
    } else if (!widget.isActive && oldWidget.isActive) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _animations.map((anim) {
              return AnimatedBuilder(
                animation: anim,
                builder: (context, child) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    width: 4,
                    height: 40 * anim.value,
                    decoration: BoxDecoration(
                      color: widget.isActive
                          ? AppThemeColors.primaryAccent.withValues(
                              alpha: 0.6 + anim.value * 0.4,
                            )
                          : AppThemeColors.neutral600,
                      borderRadius: BorderRadius.circular(
                        AppThemeMetrics.radiusPill,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}

class _VoiceSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.record_voice_over,
          size: AppThemeMetrics.iconSm,
          color: AppThemeColors.subtitleText,
        ),
        const SizedBox(width: AppThemeMetrics.spacingSm),
        const Text(
          'Voice: Default',
          style: TextStyle(color: AppThemeColors.subtitleText),
        ),
        const SizedBox(width: AppThemeMetrics.spacingXs),
        const Icon(
          Icons.arrow_drop_down,
          color: AppThemeColors.subtitleText,
        ),
      ],
    );
  }
}

class _PlaybackSpeedControl extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.speed,
          size: AppThemeMetrics.iconSm,
          color: AppThemeColors.subtitleText,
        ),
        const SizedBox(width: AppThemeMetrics.spacingSm),
        const Text(
          'Speed: 1.0x',
          style: TextStyle(color: AppThemeColors.subtitleText),
        ),
      ],
    );
  }
}
