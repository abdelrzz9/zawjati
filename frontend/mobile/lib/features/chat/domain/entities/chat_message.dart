import 'package:equatable/equatable.dart';

enum ChatMessageStatus { sending, sent, delivered, error, streaming }

class ChatMessage extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final ChatMessageStatus status;
  final Map<String, dynamic>? metadata;

  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.status = ChatMessageStatus.sent,
    this.metadata,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant' || role == 'model';
  bool get isSystem => role == 'system';

  ChatMessage copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    ChatMessageStatus? status,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  List<Object?> get props => [id, role, content, timestamp, status, metadata];
}
