import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final String? retryLabel;

  const ZawjatiErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
    this.retryLabel = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppThemeMetrics.spacingXl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(AppThemeMetrics.spacingLg),
              decoration: BoxDecoration(
                color: AppThemeColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 48,
                color: AppThemeColors.error,
              ),
            ),
            const SizedBox(height: AppThemeMetrics.spacingLg),
            Text(
              message,
              style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppThemeColors.secondaryText,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppThemeMetrics.spacingLg),
              OutlinedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(retryLabel!),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppThemeColors.primaryAccent,
                  side: BorderSide(color: AppThemeColors.inputBorder),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppThemeMetrics.radiusPill),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
