import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? trailing;

  const ZawjatiSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppThemeMetrics.spacingMd,
        vertical: AppThemeMetrics.spacingSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppThemeTextStyles.textTheme.titleLarge,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppThemeMetrics.spacing2xs),
                  Text(
                    subtitle!,
                    style: AppThemeTextStyles.textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppThemeMetrics.spacingMd,
                  vertical: AppThemeMetrics.spacingSm,
                ),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: AppThemeTextStyles.buttonTextStyle.copyWith(
                  fontSize: 13,
                  color: AppThemeColors.primaryAccent,
                ),
              ),
            ),
          ?trailing,
        ],
      ),
    );
  }
}
