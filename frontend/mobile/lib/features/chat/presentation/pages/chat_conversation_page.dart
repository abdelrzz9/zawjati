import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:zawjati_mobile/core/theme/index.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/chat_message_bubble.dart';

class ChatConversationPage extends StatefulWidget {
  final ChatBloc bloc;

  const ChatConversationPage({super.key, required this.bloc});

  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollToBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final show = _scrollController.hasClients &&
        _scrollController.offset <
            _scrollController.position.maxScrollExtent - 200;
    if (show != _showScrollToBottom) {
      setState(() => _showScrollToBottom = show);
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handleSend(String message) {
    widget.bloc.add(StreamMessageEvent(message: message));
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _handleStopGeneration() {
    widget.bloc.add(const StopGeneration());
  }

  void _handleRegenerate(String messageId) {
    widget.bloc.add(RegenerateMessage(messageId: messageId));
  }

  void _handleDelete(String messageId) {
    widget.bloc.add(DeleteMessage(messageId: messageId));
  }

  void _handleEdit(String messageId) {
    final state = widget.bloc.state;
    if (state is! ChatLoaded) return;
    final message = state.messages.where((m) => m.id == messageId).firstOrNull;
    if (message == null) return;

    final controller = TextEditingController(text: message.content);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppThemeColors.surface,
        title: const Text(
          'Edit Message',
          style: TextStyle(color: AppThemeColors.neutral0),
        ),
        content: TextField(
          controller: controller,
          maxLines: 5,
          style: const TextStyle(color: AppThemeColors.neutral0),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Edit your message...',
            hintStyle: TextStyle(color: AppThemeColors.neutral400),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppThemeColors.neutral300),
            ),
          ),
          TextButton(
            onPressed: () {
              widget.bloc.add(
                EditMessage(
                  messageId: messageId,
                  newContent: controller.text.trim(),
                ),
              );
              Navigator.pop(ctx);
            },
            child: const Text(
              'Save',
              style: TextStyle(color: AppThemeColors.primaryAccent),
            ),
          ),
        ],
      ),
    );
  }

  void _handleCopy(String content) {
    Clipboard.setData(ClipboardData(text: content));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Message copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is! ChatLoaded) {
          return const SizedBox.shrink();
        }
        final messages = state.messages;
        final isStreaming = state.isStreaming;

        return Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? _buildEmptyChat()
                  : Stack(
                      children: [
                        ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                          ),
                          itemCount:
                              messages.length + 1, // +1 for date headers
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return _buildDateHeader(messages.first.timestamp);
                            }
                            final msgIndex = index - 1;
                            if (msgIndex >= messages.length) {
                              return const SizedBox.shrink();
                            }
                            final message = messages[msgIndex];
                            final showDateHeader = msgIndex > 0 &&
                                !_isSameDay(
                                  messages[msgIndex - 1].timestamp,
                                  message.timestamp,
                                );
                            return Column(
                              children: [
                                if (showDateHeader)
                                  _buildDateHeader(message.timestamp),
                                ChatMessageBubble(
                                  key: ValueKey(message.id),
                                  message: message,
                                  isLast: msgIndex == messages.length - 1,
                                  isStreaming:
                                      isStreaming && message.isAssistant,
                                  onCopy: () => _handleCopy(message.content),
                                  onEdit: message.isUser
                                      ? () => _handleEdit(message.id)
                                      : null,
                                  onDelete: () =>
                                      _handleDelete(message.id),
                                  onRegenerate: !message.isUser
                                      ? () =>
                                          _handleRegenerate(message.id)
                                      : null,
                                ),
                              ],
                            );
                          },
                        ),
                        if (_showScrollToBottom)
                          Positioned(
                            bottom: 16,
                            right: 16,
                            child: FloatingActionButton.small(
                              onPressed: _scrollToBottom,
                              backgroundColor: AppThemeColors.surfaceHigh,
                              child: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: AppThemeColors.neutral0,
                              ),
                            ),
                          ),
                      ],
                    ),
            ),
            ChatInputBar(
              isStreaming: isStreaming,
              onSend: _handleSend,
              onVoice: () {},
              onAttach: () {},
              onStopGeneration: _handleStopGeneration,
            ),
          ],
        );
      },
    );
  }

  Widget _buildDateHeader(DateTime date) {
    final now = DateTime.now();
    String label;
    if (_isSameDay(date, now)) {
      label = 'Today';
    } else if (_isSameDay(
        date, now.subtract(const Duration(days: 1)))) {
      label = 'Yesterday';
    } else {
      label = DateFormat('MMMM d, yyyy').format(date);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppThemeColors.neutral700.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: AppThemeColors.neutral300,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Widget _buildEmptyChat() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppThemeColors.primaryAccent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(32),
            ),
            child: const Icon(
              Icons.chat_bubble_outline_rounded,
              size: 32,
              color: AppThemeColors.primaryAccent,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Start a conversation',
            style: TextStyle(
              color: AppThemeColors.neutral200,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Send a message to begin chatting\nwith your AI companion',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppThemeColors.neutral400,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
