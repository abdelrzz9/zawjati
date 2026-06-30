import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/index.dart';

class ChatTypingIndicator extends StatefulWidget {
  const ChatTypingIndicator({super.key});

  @override
  State<ChatTypingIndicator> createState() => _ChatTypingIndicatorState();
}

class _ChatTypingIndicatorState extends State<ChatTypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _dot(0.0),
          const SizedBox(width: 4),
          _dot(0.15),
          const SizedBox(width: 4),
          _dot(0.3),
        ],
      ),
    );
  }

  Widget _dot(double delay) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = (_controller.value - delay).clamp(0.0, 1.0);
        final bounce = math.sin(value * 3.14159).clamp(0.0, 1.0);
        final scale = 0.5 + (bounce * 0.5);
        final opacity = 0.4 + (bounce * 0.6);
        return Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppThemeColors.neutral300,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      },
    );
  }
}
