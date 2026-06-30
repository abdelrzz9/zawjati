import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

enum ZawjatiBadgeVariant { primary, success, error, warning, neutral }

class ZawjatiBadge extends StatelessWidget {
  final String label;
  final ZawjatiBadgeVariant variant;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;

  const ZawjatiBadge({
    super.key,
    required this.label,
    this.variant = ZawjatiBadgeVariant.primary,
    this.fontSize,
    this.padding,
  });

  Color get _color => switch (variant) {
        ZawjatiBadgeVariant.primary => AppThemeColors.primaryAccent,
        ZawjatiBadgeVariant.success => AppThemeColors.success,
        ZawjatiBadgeVariant.error => AppThemeColors.error,
        ZawjatiBadgeVariant.warning => AppThemeColors.warning,
        ZawjatiBadgeVariant.neutral => AppThemeColors.neutral400,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ??
          const EdgeInsets.symmetric(
            horizontal: AppThemeMetrics.spacingSm,
            vertical: AppThemeMetrics.spacing2xs,
          ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
        border: Border.all(
          color: _color.withValues(alpha: 0.3),
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontSize: fontSize ?? 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
