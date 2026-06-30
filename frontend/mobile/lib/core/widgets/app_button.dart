import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

enum ZawjatiButtonVariant { primary, secondary, outlined, text, destructive }

class ZawjatiButton extends StatefulWidget {
  final String label;
  final ZawjatiButtonVariant variant;
  final VoidCallback? onPressed;
  final bool loading;
  final bool fullWidth;
  final IconData? icon;
  final double? height;
  final EdgeInsets? padding;
  final Color? customColor;

  const ZawjatiButton({
    super.key,
    required this.label,
    this.variant = ZawjatiButtonVariant.primary,
    this.onPressed,
    this.loading = false,
    this.fullWidth = false,
    this.icon,
    this.height,
    this.padding,
    this.customColor,
  });

  @override
  State<ZawjatiButton> createState() => _ZawjatiButtonState();
}

class _ZawjatiButtonState extends State<ZawjatiButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppThemeMetrics.durationFast,
      vsync: this,
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _disabled => widget.onPressed == null || widget.loading;

  @override
  Widget build(BuildContext context) {
    final isPrimary = widget.variant == ZawjatiButtonVariant.primary;
    final isSecondary = widget.variant == ZawjatiButtonVariant.secondary;
    final isOutlined = widget.variant == ZawjatiButtonVariant.outlined;
    final isText = widget.variant == ZawjatiButtonVariant.text;

    final Color bgColor;
    final Color fgColor;
    final Color? borderColor;
    final Color disabledBg;
    final Color disabledFg;

    if (isPrimary) {
      bgColor = widget.customColor ?? AppThemeColors.button;
      fgColor = Colors.white;
      borderColor = null;
      disabledBg = (widget.customColor ?? AppThemeColors.button)
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
      disabledFg = Colors.white.withValues(alpha: AppThemeMetrics.opacityDisabled);
    } else if (isSecondary) {
      bgColor = widget.customColor ?? AppThemeColors.surfaceHigh;
      fgColor = AppThemeColors.primaryText;
      borderColor = null;
      disabledBg = AppThemeColors.surfaceHigh
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
      disabledFg = AppThemeColors.primaryText
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
    } else if (isOutlined) {
      bgColor = Colors.transparent;
      fgColor = widget.customColor ?? AppThemeColors.primaryAccent;
      borderColor = widget.customColor ?? AppThemeColors.inputBorder;
      disabledBg = Colors.transparent;
      disabledFg = AppThemeColors.primaryAccent
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
    } else if (isText) {
      bgColor = Colors.transparent;
      fgColor = widget.customColor ?? AppThemeColors.primaryAccent;
      borderColor = null;
      disabledBg = Colors.transparent;
      disabledFg = AppThemeColors.primaryAccent
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
    } else {
      bgColor = widget.customColor ?? AppThemeColors.error;
      fgColor = Colors.white;
      borderColor = null;
      disabledBg = AppThemeColors.error
          .withValues(alpha: AppThemeMetrics.opacityDisabled);
      disabledFg = Colors.white.withValues(alpha: AppThemeMetrics.opacityDisabled);
    }

    return GestureDetector(
      onTap: _disabled ? null : widget.onPressed,
      onTapDown: _disabled ? null : (_) => _controller.forward(),
      onTapUp: _disabled ? null : (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnim.value,
          child: child,
        ),
        child: SizedBox(
          width: widget.fullWidth ? double.infinity : null,
          height: widget.height ?? 52,
          child: AnimatedContainer(
            duration: AppThemeMetrics.durationFast,
            decoration: BoxDecoration(
              color: _disabled ? disabledBg : bgColor,
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
              border: borderColor != null
                  ? Border.all(
                      color: _disabled
                          ? borderColor
                              .withValues(alpha: AppThemeMetrics.opacityDisabled)
                          : borderColor,
                      width: AppThemeMetrics.borderThick,
                    )
                  : null,
            ),
            padding: widget.padding ??
                EdgeInsets.symmetric(
                  horizontal: isText ? AppThemeMetrics.spacingSm : AppThemeMetrics.spacingLg,
                ),
            child: Row(
              mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading)
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _disabled ? disabledFg : fgColor,
                      ),
                    ),
                  )
                else ...[
                  if (widget.icon != null) ...[
                    Icon(widget.icon, size: 20, color: _disabled ? disabledFg : fgColor),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    widget.label,
                    style: (isText
                            ? AppThemeTextStyles.buttonTextStyle
                            : AppThemeTextStyles.buttonTextStyle)
                        .copyWith(
                      color: _disabled ? disabledFg : fgColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
