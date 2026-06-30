import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/app_theme_colors.dart';
import 'package:zawjati_mobile/core/theme/app_theme_metrics.dart';

class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? iconColor;
  final String? subtitle;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppThemeMetrics.spacingMd),
      decoration: BoxDecoration(
        color: AppThemeColors.surface,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusLg),
        border: Border.all(
          color: AppThemeColors.border,
          width: AppThemeMetrics.borderHairline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: (iconColor ?? AppThemeColors.primaryAccent).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
                ),
                child: Icon(
                  icon,
                  color: iconColor ?? AppThemeColors.primaryAccent,
                  size: AppThemeMetrics.iconMd,
                ),
              ),
              const Spacer(),
              Text(
                value,
                style: TextStyle(
                  color: AppThemeColors.primaryText,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppThemeMetrics.spacingSm),
          Text(
            label,
            style: TextStyle(
              color: AppThemeColors.hintText,
              fontSize: 13,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppThemeMetrics.spacing2xs),
            Text(
              subtitle!,
              style: TextStyle(
                color: AppThemeColors.subtitleText,
                fontSize: 11,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
