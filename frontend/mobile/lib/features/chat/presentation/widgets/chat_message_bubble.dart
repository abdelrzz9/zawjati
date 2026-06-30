import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zawjati_mobile/core/theme/index.dart';
import '../../domain/entities/chat_message.dart';
import 'chat_markdown_view.dart';
import 'chat_typing_indicator.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isLast;
  final bool isStreaming;
  final VoidCallback? onCopy;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onRegenerate;

  const ChatMessageBubble({
    super.key,
    required this.message,
    this.isLast = false,
    this.isStreaming = false,
    this.onCopy,
    this.onEdit,
    this.onDelete,
    this.onRegenerate,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.isUser;
    final showStatus = isLast && isUser;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: GestureDetector(
        onLongPress: () => _showContextMenu(context),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            _buildTimestamp(context),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment:
                  isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                if (!isUser) _buildAvatar(context),
                const SizedBox(width: 8),
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isUser
                          ? AppThemeColors.primaryAccent.withValues(alpha: 0.85)
                          : AppThemeColors.surfaceHigh,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(
                          AppThemeMetrics.radiusLg,
                        ),
                        topRight: const Radius.circular(
                          AppThemeMetrics.radiusLg,
                        ),
                        bottomLeft: Radius.circular(
                          isUser ? AppThemeMetrics.radiusLg : 4,
                        ),
                        bottomRight: Radius.circular(
                          isUser ? 4 : AppThemeMetrics.radiusLg,
                        ),
                      ),
                    ),
                    child: _buildContent(isUser),
                  ),
                ),
                if (isUser) const SizedBox(width: 8),
                if (isUser) _buildAvatar(context),
              ],
            ),
            if (showStatus) _buildStatus(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTimestamp(BuildContext context) {
    final now = DateTime.now();
    final diff = now.difference(message.timestamp);
    String timeStr;
    if (diff.inMinutes < 1) {
      timeStr = 'Just now';
    } else if (diff.inHours < 1) {
      timeStr = '${diff.inMinutes}m ago';
    } else if (diff.inDays < 1) {
      timeStr = DateFormat('h:mm a').format(message.timestamp);
    } else {
      timeStr = DateFormat('MMM d, h:mm a').format(message.timestamp);
    }
    return Padding(
      padding: EdgeInsets.only(
        left: message.isUser ? 0 : 48,
        right: message.isUser ? 48 : 0,
      ),
      child: Text(
        timeStr,
        style: const TextStyle(
          color: AppThemeColors.neutral400,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildContent(bool isUser) {
    if (isUser) {
      return SelectableText(
        message.content,
        style: const TextStyle(
          color: AppThemeColors.neutral0,
          fontSize: 15,
          height: 1.4,
        ),
      );
    }

    if (isStreaming && message.content.isEmpty) {
      return const ChatTypingIndicator();
    }

    return ChatMarkdownView(
      content: message.content,
      isUser: false,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return CircleAvatar(
      radius: 16,
      backgroundColor: message.isUser
          ? AppThemeColors.primaryAccent
          : AppThemeColors.neutral600,
      child: Icon(
        message.isUser ? Icons.person_rounded : Icons.auto_awesome_rounded,
        size: 18,
        color: AppThemeColors.neutral0,
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    IconData icon;
    Color color;
    switch (message.status) {
      case ChatMessageStatus.sending:
        icon = Icons.access_time_rounded;
        color = AppThemeColors.neutral400;
      case ChatMessageStatus.sent:
        icon = Icons.check_rounded;
        color = AppThemeColors.neutral400;
      case ChatMessageStatus.delivered:
        icon = Icons.done_all_rounded;
        color = AppThemeColors.success;
      case ChatMessageStatus.error:
        icon = Icons.error_outline_rounded;
        color = AppThemeColors.error;
      case ChatMessageStatus.streaming:
        icon = Icons.more_horiz_rounded;
        color = AppThemeColors.neutral400;
    }
    return Padding(
      padding: const EdgeInsets.only(top: 2, right: 48),
      child: Icon(icon, size: 14, color: color),
    );
  }

  void _showContextMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppThemeColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: AppThemeColors.neutral500,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
            if (onCopy != null)
              ListTile(
                leading: const Icon(
                  Icons.copy_rounded,
                  color: AppThemeColors.neutral200,
                ),
                title: const Text(
                  'Copy',
                  style: TextStyle(color: AppThemeColors.neutral0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onCopy?.call();
                },
              ),
            if (onEdit != null && message.isUser)
              ListTile(
                leading: const Icon(
                  Icons.edit_rounded,
                  color: AppThemeColors.neutral200,
                ),
                title: const Text(
                  'Edit',
                  style: TextStyle(color: AppThemeColors.neutral0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onEdit?.call();
                },
              ),
            if (onRegenerate != null && !message.isUser)
              ListTile(
                leading: const Icon(
                  Icons.refresh_rounded,
                  color: AppThemeColors.neutral200,
                ),
                title: const Text(
                  'Regenerate',
                  style: TextStyle(color: AppThemeColors.neutral0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onRegenerate?.call();
                },
              ),
            if (onDelete != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline_rounded,
                  color: AppThemeColors.error,
                ),
                title: const Text(
                  'Delete',
                  style: TextStyle(color: AppThemeColors.error),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onDelete?.call();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
