import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../theme/app_theme_colors.dart';
import '../theme/app_theme_metrics.dart';
import '../theme/app_theme_text_styles.dart';

class ZawjatiMessageBubble extends StatelessWidget {
  final String content;
  final bool isUser;
  final DateTime? timestamp;
  final MessageStatus status;
  final String? senderName;

  const ZawjatiMessageBubble({
    super.key,
    required this.content,
    required this.isUser,
    this.timestamp,
    this.status = MessageStatus.sent,
    this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isUser ? AppThemeColors.primaryAccent : AppThemeColors.surfaceHigh;
    final textColor = isUser ? Colors.white : AppThemeColors.primaryText;
    final alignment = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 64 : 0,
        right: isUser ? 0 : 64,
        bottom: AppThemeMetrics.spacingSm,
      ),
      child: Column(
        crossAxisAlignment: alignment,
        children: [
          if (senderName != null && !isUser)
            Padding(
              padding: const EdgeInsets.only(
                left: AppThemeMetrics.spacingMd,
                bottom: AppThemeMetrics.spacing2xs,
              ),
              child: Text(
                senderName!,
                style: AppThemeTextStyles.textTheme.labelSmall?.copyWith(
                  color: AppThemeColors.hintText,
                ),
              ),
            ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppThemeMetrics.spacingMd,
              vertical: AppThemeMetrics.spacingSm + 2,
            ),
            decoration: BoxDecoration(
              color: bubbleColor,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppThemeMetrics.radiusLg),
                topRight: const Radius.circular(AppThemeMetrics.radiusLg),
                bottomLeft: Radius.circular(
                  isUser ? AppThemeMetrics.radiusLg : AppThemeMetrics.radiusXs,
                ),
                bottomRight: Radius.circular(
                  isUser ? AppThemeMetrics.radiusXs : AppThemeMetrics.radiusLg,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: alignment == CrossAxisAlignment.end
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Text(
                  content,
                  style: AppThemeTextStyles.textTheme.bodyMedium?.copyWith(
                    color: textColor,
                  ),
                ),
                if (timestamp != null) ...[
                  const SizedBox(height: AppThemeMetrics.spacing2xs),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('HH:mm').format(timestamp!),
                        style: TextStyle(
                          fontSize: 11,
                          color: isUser
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppThemeColors.hintText,
                        ),
                      ),
                      if (isUser) ...[
                        const SizedBox(width: 4),
                        _StatusIcon(status: status),
                      ],
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

enum MessageStatus { sending, sent, delivered, read, failed }

class _StatusIcon extends StatelessWidget {
  final MessageStatus status;

  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      MessageStatus.sending => Icons.access_time_rounded,
      MessageStatus.sent => Icons.check_rounded,
      MessageStatus.delivered => Icons.done_all_rounded,
      MessageStatus.read => Icons.done_all_rounded,
      MessageStatus.failed => Icons.error_rounded,
    };

    final color = switch (status) {
      MessageStatus.sending => Colors.white.withValues(alpha: 0.5),
      MessageStatus.sent => Colors.white.withValues(alpha: 0.7),
      MessageStatus.delivered => Colors.white.withValues(alpha: 0.7),
      MessageStatus.read => AppThemeColors.info,
      MessageStatus.failed => AppThemeColors.error,
    };

    return Icon(icon, size: 14, color: color);
  }
}
