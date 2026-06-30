import 'package:flutter/material.dart';

import '../extensions/context_extensions.dart';
import '../extensions/responsive_extensions.dart';
import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class AppErrorView extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onRetry;
  final IconData icon;

  const AppErrorView({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onRetry,
    this.icon = Icons.wifi_off_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(
          context.widthCalculated(AppThemeMetrics.spacingXl),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: context.iconSize() * 3,
              color: AppThemeColors.secondaryText,
            ),
            SizedBox(
              height: context.heightCalculated(AppThemeMetrics.spacingLg),
            ),
            Text(
              title,
              style: context.textTheme.headlineSmall?.copyWith(
                color: AppThemeColors.primaryText,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: context.heightCalculated(AppThemeMetrics.spacingSm),
            ),
            Text(
              subtitle,
              style: context.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: context.heightCalculated(AppThemeMetrics.spacingXl),
            ),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                foregroundColor: AppThemeColors.primaryText,
                backgroundColor: AppThemeColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
