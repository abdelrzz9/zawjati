import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

enum ZawjatiSnackbarType { success, error, info, warning }

class ZawjatiSnackbar {
  ZawjatiSnackbar._();

  static void show(
    BuildContext context, {
    required String message,
    ZawjatiSnackbarType type = ZawjatiSnackbarType.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 4),
  }) {
    final color = switch (type) {
      ZawjatiSnackbarType.success => AppThemeColors.success,
      ZawjatiSnackbarType.error => AppThemeColors.error,
      ZawjatiSnackbarType.info => AppThemeColors.info,
      ZawjatiSnackbarType.warning => AppThemeColors.warning,
    };

    final icon = switch (type) {
      ZawjatiSnackbarType.success => Icons.check_circle_rounded,
      ZawjatiSnackbarType.error => Icons.error_rounded,
      ZawjatiSnackbarType.info => Icons.info_rounded,
      ZawjatiSnackbarType.warning => Icons.warning_rounded,
    };

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppThemeMetrics.spacingSm),
            Expanded(
              child: Text(
                message,
                style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
                  color: AppThemeColors.primaryText,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppThemeColors.surfaceHigh,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          side: BorderSide(color: color.withValues(alpha: 0.3)),
        ),
        action: actionLabel != null && onAction != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: color,
                onPressed: onAction,
              )
            : null,
        duration: duration,
        margin: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      ),
    );
  }
}
