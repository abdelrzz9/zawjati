import 'package:flutter/material.dart';
import 'package:zawjati_mobile/core/theme/index.dart';

class ChatInputBar extends StatefulWidget {
  final bool isStreaming;
  final ValueChanged<String> onSend;
  final VoidCallback? onVoice;
  final VoidCallback? onAttach;
  final VoidCallback? onStopGeneration;

  const ChatInputBar({
    super.key,
    this.isStreaming = false,
    required this.onSend,
    this.onVoice,
    this.onAttach,
    this.onStopGeneration,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    setState(() {
      _hasText = _controller.text.trim().isNotEmpty;
    });
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
    _hasText = false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppThemeColors.neutral850,
        border: Border(
          top: BorderSide(color: AppThemeColors.neutral700),
        ),
      ),
      padding: EdgeInsets.only(
        left: 8,
        right: 8,
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (widget.onAttach != null)
            IconButton(
              onPressed: widget.onAttach,
              icon: const Icon(
                Icons.attach_file_rounded,
                color: AppThemeColors.neutral300,
              ),
            ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxHeight: 120),
              decoration: BoxDecoration(
                color: AppThemeColors.neutral800,
                borderRadius: BorderRadius.circular(
                  AppThemeMetrics.radiusPill,
                ),
                border: Border.all(color: AppThemeColors.neutral600),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      focusNode: _focusNode,
                      textInputAction: TextInputAction.send,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      style: const TextStyle(
                        color: AppThemeColors.neutral0,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: AppThemeColors.neutral400,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      onSubmitted: (_) => _handleSend(),
                    ),
                  ),
                  if (widget.onVoice != null && !_hasText)
                    IconButton(
                      onPressed: widget.onVoice,
                      icon: const Icon(
                        Icons.mic_rounded,
                        color: AppThemeColors.neutral300,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 4),
          if (widget.isStreaming && widget.onStopGeneration != null)
            Container(
              decoration: const BoxDecoration(
                color: AppThemeColors.error,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: widget.onStopGeneration,
                icon: const Icon(
                  Icons.stop_rounded,
                  color: AppThemeColors.neutral0,
                ),
              ),
            )
          else
            Container(
              decoration: BoxDecoration(
                color: _hasText
                    ? AppThemeColors.primaryAccent
                    : AppThemeColors.neutral700,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _hasText ? _handleSend : null,
                icon: Icon(
                  Icons.send_rounded,
                  color: _hasText
                      ? AppThemeColors.neutral0
                      : AppThemeColors.neutral400,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
