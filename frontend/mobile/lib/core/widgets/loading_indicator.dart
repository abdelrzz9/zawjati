import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class ZawjatiLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  const ZawjatiLoading({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppThemeColors.primaryAccent,
        ),
      ),
    );
  }
}

class ZawjatiLoadingOverlay extends StatelessWidget {
  final String? message;
  final Color? backgroundColor;
  final Color? indicatorColor;

  const ZawjatiLoadingOverlay({
    super.key,
    this.message,
    this.backgroundColor,
    this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        color: backgroundColor ?? AppThemeColors.overlay,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppThemeMetrics.spacingXl,
              vertical: AppThemeMetrics.spacingLg,
            ),
            decoration: BoxDecoration(
              color: AppThemeColors.surface,
              borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ZawjatiLoading(
                  size: 32,
                  color: indicatorColor,
                ),
                if (message != null) ...[
                  const SizedBox(height: AppThemeMetrics.spacingMd),
                  Text(
                    message!,
                    style: const TextStyle(
                      color: AppThemeColors.primaryText,
                      fontSize: 14,
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
