import 'package:flutter/material.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class ZawjatiBottomSheet {
  ZawjatiBottomSheet._();

  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool showDragHandle = true,
    double? maxHeight,
    bool useSafeArea = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      backgroundColor: AppThemeColors.surface,
      showDragHandle: showDragHandle,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppThemeMetrics.radiusXxl),
        ),
      ),
      isScrollControlled: maxHeight != null,
      builder: (ctx) => Container(
        constraints: maxHeight != null
            ? BoxConstraints(maxHeight: maxHeight)
            : null,
        padding: EdgeInsets.only(
          bottom: useSafeArea ? MediaQuery.of(ctx).padding.bottom : 0,
        ),
        child: child,
      ),
    );
  }
}
