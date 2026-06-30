import 'package:equatable/equatable.dart';
import 'chat_message.dart';

class ChatConversation extends Equatable {
  final String id;
  final String title;
  final List<ChatMessage> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? personality;
  final int messageCount;

  const ChatConversation({
    required this.id,
    required this.title,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.personality,
    this.messageCount = 0,
  });

  ChatConversation copyWith({
    String? id,
    String? title,
    List<ChatMessage>? messages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? personality,
    int? messageCount,
  }) {
    return ChatConversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      personality: personality ?? this.personality,
      messageCount: messageCount ?? this.messageCount,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, messages, createdAt, updatedAt, personality, messageCount];
}
