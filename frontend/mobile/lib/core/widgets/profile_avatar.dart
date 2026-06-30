import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import 'loading_indicator.dart';

enum AvatarSize { xs, sm, md, lg, xl }

class ZawjatiProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final bool showOnlineIndicator;
  final AvatarSize size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ZawjatiProfileAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.showOnlineIndicator = false,
    this.size = AvatarSize.md,
    this.backgroundColor,
    this.foregroundColor,
  });

  double get _dimension => switch (size) {
        AvatarSize.xs => 24,
        AvatarSize.sm => 32,
        AvatarSize.md => 44,
        AvatarSize.lg => 64,
        AvatarSize.xl => 96,
      };

  double get _indicatorSize => switch (size) {
        AvatarSize.xs => 6,
        AvatarSize.sm => 8,
        AvatarSize.md => 10,
        AvatarSize.lg => 14,
        AvatarSize.xl => 18,
      };

  double get _fontSize => _dimension * 0.4;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: _dimension / 2,
          backgroundColor: backgroundColor ?? AppThemeColors.surfaceHigh,
          foregroundColor: foregroundColor ?? AppThemeColors.primaryText,
          child: hasImage
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: imageUrl!,
                    width: _dimension,
                    height: _dimension,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => ZawjatiLoading(
                      size: _dimension * 0.4,
                      strokeWidth: 2,
                    ),
                    errorWidget: (_, _, _) => Text(
                      _initialsText,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : Text(
                  _initialsText,
                  style: TextStyle(
                    fontSize: _fontSize,
                    fontWeight: FontWeight.w600,
                    color: foregroundColor ?? AppThemeColors.primaryAccent,
                  ),
                ),
        ),
        if (showOnlineIndicator)
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: _indicatorSize,
              height: _indicatorSize,
              decoration: BoxDecoration(
                color: AppThemeColors.success,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppThemeColors.background,
                  width: AppThemeMetrics.borderThin + 0.5,
                ),
              ),
            ),
          ),
      ],
    );
  }

  String get _initialsText {
    if (initials != null && initials!.isNotEmpty) return initials!;
    return '?';
  }
}
