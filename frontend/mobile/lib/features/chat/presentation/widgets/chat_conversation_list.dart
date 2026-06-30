import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zawjati_mobile/core/theme/index.dart';
import '../../domain/entities/chat_conversation.dart';

class ChatConversationList extends StatelessWidget {
  final List<ChatConversation> conversations;
  final String? activeConversationId;
  final ValueChanged<String>? onConversationTap;
  final VoidCallback? onNewChat;

  const ChatConversationList({
    super.key,
    required this.conversations,
    this.activeConversationId,
    this.onConversationTap,
    this.onNewChat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (onNewChat != null)
          Padding(
            padding: const EdgeInsets.all(12),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onNewChat,
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text('New Chat'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppThemeColors.primaryAccent,
                  foregroundColor: AppThemeColors.neutral0,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      AppThemeMetrics.radiusMd,
                    ),
                  ),
                ),
              ),
            ),
          ),
        Expanded(
          child: conversations.isEmpty
              ? Center(
                  child: Text(
                    'No conversations',
                    style: AppThemeTextStyles.textTheme.bodySmall?.copyWith(
                      color: AppThemeColors.neutral400,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: conversations.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 2),
                  itemBuilder: (context, index) {
                    final conversation = conversations[index];
                    final isActive =
                        conversation.id == activeConversationId;
                    return _ConversationTile(
                      conversation: conversation,
                      isActive: isActive,
                      onTap: () =>
                          onConversationTap?.call(conversation.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ChatConversation conversation;
  final bool isActive;
  final VoidCallback? onTap;

  const _ConversationTile({
    required this.conversation,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lastMessage = conversation.messages.isNotEmpty
        ? conversation.messages.last.content
        : '';
    final preview = lastMessage.length > 60
        ? '${lastMessage.substring(0, 60)}...'
        : lastMessage;
    final timeStr = _formatTime(conversation.updatedAt);

    return Material(
      color: isActive
          ? AppThemeColors.primaryAccent.withValues(alpha: 0.1)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppThemeMetrics.radiusSm),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isActive
                      ? AppThemeColors.primaryAccent
                      : AppThemeColors.neutral700,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.chat_rounded,
                  size: 18,
                  color: AppThemeColors.neutral0,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.title,
                            style: TextStyle(
                              color: isActive
                                  ? AppThemeColors.primaryAccent
                                  : AppThemeColors.neutral0,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          timeStr,
                          style: const TextStyle(
                            color: AppThemeColors.neutral400,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      preview.isNotEmpty ? preview : 'No messages yet',
                      style: const TextStyle(
                        color: AppThemeColors.neutral400,
                        fontSize: 12,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inHours < 1) return '${diff.inMinutes}m';
    if (diff.inDays < 1) return '${diff.inHours}h';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return DateFormat('M/d').format(dateTime);
  }
}
