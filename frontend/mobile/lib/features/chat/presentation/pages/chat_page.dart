import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/theme/index.dart';
import '../bloc/chat_bloc.dart';
import '../bloc/chat_event.dart';
import '../bloc/chat_state.dart';
import '../widgets/chat_conversation_list.dart';
import '../widgets/chat_empty_state.dart';
import 'chat_conversation_page.dart';

class ChatPage extends StatefulWidget {
  final ChatBloc bloc;

  const ChatPage({super.key, required this.bloc});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    super.initState();
    widget.bloc.add(const LoadConversations());
  }

  void _handleNewChat() {
    widget.bloc.add(const ClearChat());
  }

  void _handleConversationTap(String id) {
    widget.bloc.add(SelectConversation(conversationId: id));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(
      bloc: widget.bloc,
      builder: (context, state) {
        if (state is ChatInitial || state is ChatLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: AppThemeColors.primaryAccent,
              ),
            ),
          );
        }

        if (state is ChatError) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    size: 48,
                    color: AppThemeColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppThemeColors.neutral200,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        widget.bloc.add(const LoadConversations()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppThemeColors.primaryAccent,
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! ChatLoaded) {
          return const Scaffold(
            body: SizedBox.shrink(),
          );
        }

        final isWideScreen =
            MediaQuery.of(context).size.width >=
                AppThemeMetrics.largeScreenMinWidth;

        if (isWideScreen) {
          return _buildWideLayout(context, state);
        }

        return _buildNarrowLayout(context, state);
      },
    );
  }

  Widget _buildNarrowLayout(BuildContext context, ChatLoaded state) {
    final hasConversations = state.conversations.isNotEmpty;
    final hasActiveConversation =
        state.activeConversationId != null || state.messages.isNotEmpty;

    if (!hasConversations && !hasActiveConversation) {
      return Scaffold(
        appBar: _buildAppBar(context),
        body: ChatEmptyState(onStartChat: _handleNewChat),
        floatingActionButton: FloatingActionButton(
          onPressed: _handleNewChat,
          backgroundColor: AppThemeColors.primaryAccent,
          child: const Icon(
            Icons.add_rounded,
            color: AppThemeColors.neutral0,
          ),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(context),
      body: ChatConversationPage(bloc: widget.bloc),
      floatingActionButton: !hasActiveConversation
          ? FloatingActionButton(
              onPressed: _handleNewChat,
              backgroundColor: AppThemeColors.primaryAccent,
              child: const Icon(
                Icons.add_rounded,
                color: AppThemeColors.neutral0,
              ),
            )
          : null,
    );
  }

  Widget _buildWideLayout(BuildContext context, ChatLoaded state) {
    final hasConversations = state.conversations.isNotEmpty;
    final hasActiveConversation =
        state.activeConversationId != null || state.messages.isNotEmpty;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Row(
        children: [
          SizedBox(
            width: 320,
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(
                    color: AppThemeColors.neutral700,
                  ),
                ),
              ),
              child: ChatConversationList(
                conversations: state.conversations,
                activeConversationId: state.activeConversationId,
                onConversationTap: _handleConversationTap,
                onNewChat: _handleNewChat,
              ),
            ),
          ),
          Expanded(
            child: hasActiveConversation
                ? ChatConversationPage(bloc: widget.bloc)
                : ChatEmptyState(onStartChat: _handleNewChat),
          ),
        ],
      ),
      floatingActionButton: !hasConversations
          ? FloatingActionButton(
              onPressed: _handleNewChat,
              backgroundColor: AppThemeColors.primaryAccent,
              child: const Icon(
                Icons.add_rounded,
                color: AppThemeColors.neutral0,
              ),
            )
          : null,
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final state = widget.bloc.state;
    String title = 'Chat';
    if (state is ChatLoaded && state.activeConversationId != null) {
      final conversation = state.conversations
          .where((c) => c.id == state.activeConversationId)
          .firstOrNull;
      if (conversation != null) {
        title = conversation.title;
      }
    }

    return AppBar(
      title: Text(
        title,
        style: AppThemeTextStyles.appBarTitleStyle,
      ),
      backgroundColor: AppThemeColors.neutral900,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      actions: [
        if (state is ChatLoaded && state.messages.isNotEmpty)
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  backgroundColor: AppThemeColors.surface,
                  title: const Text(
                    'Clear Chat?',
                    style: TextStyle(color: AppThemeColors.neutral0),
                  ),
                  content: const Text(
                    'This will clear all messages in the current conversation.',
                    style: TextStyle(color: AppThemeColors.neutral200),
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
                        widget.bloc.add(const ClearChat());
                        Navigator.pop(ctx);
                      },
                      child: const Text(
                        'Clear',
                        style: TextStyle(color: AppThemeColors.error),
                      ),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: AppThemeColors.neutral300,
            ),
          ),
      ],
    );
  }
}
