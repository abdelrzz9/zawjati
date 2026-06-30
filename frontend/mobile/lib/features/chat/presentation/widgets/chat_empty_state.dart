import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/index.dart';

class ChatEmptyState extends StatelessWidget {
  final VoidCallback? onStartChat;

  const ChatEmptyState({super.key, this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppThemeMetrics.spacingXxl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppThemeColors.primaryAccent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: const Icon(
                Icons.chat_bubble_outline_rounded,
                size: 40,
                color: AppThemeColors.primaryAccent,
              ),
            ),
            const SizedBox(height: AppThemeMetrics.spacingLg),
            Text(
              'No conversations yet',
              style: AppThemeTextStyles.textTheme.headlineSmall?.copyWith(
                color: AppThemeColors.primaryText,
              ),
            ),
            const SizedBox(height: AppThemeMetrics.spacingSm),
            Text(
              'Start a chat to begin your conversation\nwith your AI companion',
              textAlign: TextAlign.center,
              style: AppThemeTextStyles.textTheme.bodySmall?.copyWith(
                color: AppThemeColors.neutral300,
              ),
            ),
            const SizedBox(height: AppThemeMetrics.spacingLg),
            if (onStartChat != null)
              ElevatedButton.icon(
                onPressed: onStartChat,
                icon: const Icon(Icons.add_rounded),
                label: const Text('New Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColors.primaryAccent,
                  foregroundColor: AppThemeColors.neutral0,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppThemeMetrics.spacingLg,
                    vertical: AppThemeMetrics.spacingMd,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppThemeMetrics.radiusMd,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
