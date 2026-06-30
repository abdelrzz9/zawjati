import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class ZawjatiCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final double? elevation;

  const ZawjatiCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      decoration: BoxDecoration(
        color: AppThemeColors.card,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
        boxShadow: (elevation ?? AppThemeMetrics.elevationNone) > 0
            ? [
                BoxShadow(
                  color: AppThemeColors.shadowSoft,
                  blurRadius: (elevation ?? AppThemeMetrics.elevationNone) * 4,
                  offset: Offset(0, elevation ?? AppThemeMetrics.elevationNone),
                ),
              ]
            : null,
      ),
      padding: padding ?? const EdgeInsets.all(AppThemeMetrics.spacingMd),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
          splashColor: AppThemeColors.primaryAccent.withValues(alpha: AppThemeMetrics.opacityHover),
          highlightColor: AppThemeColors.primaryAccent.withValues(alpha: AppThemeMetrics.opacityPressed),
          child: card,
        ),
      );
    }

    return card;
  }
}
