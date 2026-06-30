import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class ZawjatiAnimatedToggle extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final Color? activeColor;
  final Color? inactiveColor;
  final double width;
  final double height;
  final Duration duration;

  const ZawjatiAnimatedToggle({
    super.key,
    required this.value,
    this.onChanged,
    this.activeColor,
    this.inactiveColor,
    this.width = 48,
    this.height = 28,
    this.duration = AppThemeMetrics.durationMedium,
  });

  @override
  State<ZawjatiAnimatedToggle> createState() => _ZawjatiAnimatedToggleState();
}

class _ZawjatiAnimatedToggleState extends State<ZawjatiAnimatedToggle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnim;
  late Animation<Color?> _colorAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );

    _positionAnim = Tween<double>(
      begin: 0,
      end: widget.width - widget.height,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    _colorAnim = ColorTween(
      begin: widget.inactiveColor ?? AppThemeColors.neutral600,
      end: widget.activeColor ?? AppThemeColors.primaryAccent,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    ));

    if (widget.value) _controller.value = 1.0;
  }

  @override
  void didUpdateWidget(ZawjatiAnimatedToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      if (widget.value) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChanged?.call(!widget.value),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Container(
            width: widget.width,
            height: widget.height,
            decoration: BoxDecoration(
              color: _colorAnim.value,
              borderRadius: BorderRadius.circular(widget.height / 2),
            ),
            padding: const EdgeInsets.all(3),
            child: AnimatedBuilder(
              animation: _positionAnim,
              builder: (context, _) {
                return Container(
                  width: widget.height - 6,
                  height: widget.height - 6,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
