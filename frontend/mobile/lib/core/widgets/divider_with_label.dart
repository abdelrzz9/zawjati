import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiDivider extends StatelessWidget {
  final String? label;
  final double thickness;
  final Color? color;

  const ZawjatiDivider({
    super.key,
    this.label,
    this.thickness = AppThemeMetrics.borderHairline,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final dividerColor = color ?? AppThemeColors.divider;

    if (label == null || label!.isEmpty) {
      return Divider(
        thickness: thickness,
        color: dividerColor,
        height: AppThemeMetrics.spacingLg,
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppThemeMetrics.spacingMd),
      child: Row(
        children: [
          Expanded(child: Divider(thickness: thickness, color: dividerColor)),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppThemeMetrics.spacingMd,
            ),
            child: Text(
              label!,
              style: AppThemeTextStyles.textTheme.labelSmall?.copyWith(
                color: AppThemeColors.hintText,
                letterSpacing: 0.5,
              ),
            ),
          ),
          Expanded(child: Divider(thickness: thickness, color: dividerColor)),
        ],
      ),
    );
  }
}
