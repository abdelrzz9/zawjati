import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_conversation.dart';
import 'chat_message_model.dart';

class ChatConversationModel extends Equatable {
  final String id;
  final String title;
  final List<ChatMessageModel> messages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? personality;
  final int messageCount;

  const ChatConversationModel({
    required this.id,
    required this.title,
    this.messages = const [],
    required this.createdAt,
    required this.updatedAt,
    this.personality,
    this.messageCount = 0,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    return ChatConversationModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      title: json['title'] as String? ?? 'New Chat',
      messages: (json['messages'] as List<dynamic>?)
              ?.map((m) =>
                  ChatMessageModel.fromJson(m as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      personality: json['personality'] as String?,
      messageCount: json['message_count'] as int? ??
          json['messages']?.length as int? ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      if (personality != null) 'personality': personality,
      'message_count': messageCount,
    };
  }

  ChatConversation toEntity() {
    return ChatConversation(
      id: id,
      title: title,
      messages: messages.map((m) => m.toEntity()).toList(),
      createdAt: createdAt,
      updatedAt: updatedAt,
      personality: personality,
      messageCount: messageCount,
    );
  }

  static ChatConversationModel fromEntity(ChatConversation entity) {
    return ChatConversationModel(
      id: entity.id,
      title: entity.title,
      messages:
          entity.messages.map((m) => ChatMessageModel.fromEntity(m)).toList(),
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      personality: entity.personality,
      messageCount: entity.messageCount,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, messages, createdAt, updatedAt, personality, messageCount];
}
