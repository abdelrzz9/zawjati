import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiDialog {
  ZawjatiDialog._();

  static Future<bool?> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    String cancelLabel = 'Cancel',
    VoidCallback? onConfirm,
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppThemeColors.surface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppThemeMetrics.radiusXl),
        ),
        title: Text(
          title,
          style: AppThemeTextStyles.textTheme.headlineSmall,
        ),
        content: Text(
          message,
          style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppThemeColors.secondaryText,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              cancelLabel,
              style: AppThemeTextStyles.buttonTextStyle.copyWith(
                color: AppThemeColors.hintText,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(ctx).pop(true);
            },
            child: Text(
              confirmLabel,
              style: AppThemeTextStyles.buttonTextStyle.copyWith(
                color: isDestructive
                    ? AppThemeColors.error
                    : AppThemeColors.primaryAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ZawjatiLoadingDialog {
  ZawjatiLoadingDialog._();

  static void show(BuildContext context, {String message = 'Loading...'}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => PopScope(
        canPop: false,
        child: AlertDialog(
          backgroundColor: AppThemeColors.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusXl),
          ),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                ),
              ),
              const SizedBox(width: AppThemeMetrics.spacingMd),
              Text(
                message,
                style: AppThemeTextStyles.textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void hide(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
