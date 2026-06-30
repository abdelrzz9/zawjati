import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';

class _ShimmerContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const _ShimmerContainer({
    required this.width,
    required this.height,
    this.borderRadius = AppThemeMetrics.radiusSm,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppThemeColors.shimmer,
      highlightColor: AppThemeColors.surfaceHigh,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppThemeColors.shimmer,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ZawjatiSkeletonLine extends StatelessWidget {
  final double width;
  final double height;

  const ZawjatiSkeletonLine({
    super.key,
    this.width = double.infinity,
    this.height = 14,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      width: width,
      height: height,
      borderRadius: AppThemeMetrics.radiusXs,
    );
  }
}

class ZawjatiSkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ZawjatiSkeletonBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = AppThemeMetrics.radiusMd,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

class ZawjatiSkeletonCircle extends StatelessWidget {
  final double size;

  const ZawjatiSkeletonCircle({
    super.key,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return _ShimmerContainer(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

class ZawjatiSkeletonList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ZawjatiSkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: itemCount,
      separatorBuilder: (_, _) => const SizedBox(height: AppThemeMetrics.spacingSm),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppThemeMetrics.spacingMd),
          child: Row(
            children: [
              const ZawjatiSkeletonCircle(size: 44),
              const SizedBox(width: AppThemeMetrics.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ZawjatiSkeletonLine(width: 160, height: 14),
                    const SizedBox(height: AppThemeMetrics.spacingSm),
                    ZawjatiSkeletonLine(width: 220, height: 12),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
