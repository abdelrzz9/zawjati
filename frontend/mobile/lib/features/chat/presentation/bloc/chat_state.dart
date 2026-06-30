import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';

abstract class ChatState extends Equatable {
  const ChatState();
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {
  const ChatInitial();
}

class ChatLoading extends ChatState {
  const ChatLoading();
}

class ChatLoaded extends ChatState {
  final List<ChatConversation> conversations;
  final String? activeConversationId;
  final List<ChatMessage> messages;
  final bool isStreaming;
  final String? error;
  final String? currentStreamContent;

  const ChatLoaded({
    this.conversations = const [],
    this.activeConversationId,
    this.messages = const [],
    this.isStreaming = false,
    this.error,
    this.currentStreamContent,
  });

  ChatLoaded copyWith({
    List<ChatConversation>? conversations,
    Object? activeConversationId = _sentinel,
    List<ChatMessage>? messages,
    bool? isStreaming,
    Object? error = _sentinel,
    Object? currentStreamContent = _sentinel,
  }) {
    return ChatLoaded(
      conversations: conversations ?? this.conversations,
      activeConversationId: activeConversationId == _sentinel
          ? this.activeConversationId
          : activeConversationId as String?,
      messages: messages ?? this.messages,
      isStreaming: isStreaming ?? this.isStreaming,
      error: error == _sentinel ? this.error : error as String?,
      currentStreamContent: currentStreamContent == _sentinel
          ? this.currentStreamContent
          : currentStreamContent as String?,
    );
  }

  static const _sentinel = Object();

  @override
  List<Object?> get props => [
        conversations,
        activeConversationId,
        messages,
        isStreaming,
        error,
        currentStreamContent,
      ];
}

class ChatError extends ChatState {
  final String message;

  const ChatError({required this.message});

  @override
  List<Object?> get props => [message];
}
