import 'package:equatable/equatable.dart';
import '../../domain/entities/chat_message.dart';

enum MessageStatusModel { sending, sent, delivered, error, streaming }

class ChatMessageModel extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final MessageStatusModel status;
  final Map<String, dynamic>? metadata;

  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.status = MessageStatusModel.sent,
    this.metadata,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      content: json['content'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      status: _parseStatus(json['status'] as String?),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  static MessageStatusModel _parseStatus(String? status) {
    switch (status) {
      case 'sending':
        return MessageStatusModel.sending;
      case 'sent':
        return MessageStatusModel.sent;
      case 'delivered':
        return MessageStatusModel.delivered;
      case 'error':
        return MessageStatusModel.error;
      case 'streaming':
        return MessageStatusModel.streaming;
      default:
        return MessageStatusModel.sent;
    }
  }

  static String _statusToString(MessageStatusModel status) {
    switch (status) {
      case MessageStatusModel.sending:
        return 'sending';
      case MessageStatusModel.sent:
        return 'sent';
      case MessageStatusModel.delivered:
        return 'delivered';
      case MessageStatusModel.error:
        return 'error';
      case MessageStatusModel.streaming:
        return 'streaming';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'status': _statusToString(status),
      if (metadata != null) 'metadata': metadata,
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      id: id,
      role: role,
      content: content,
      timestamp: timestamp,
      status: ChatMessageStatus.values.firstWhere(
        (e) => e.name == status.name,
        orElse: () => ChatMessageStatus.sent,
      ),
      metadata: metadata,
    );
  }

  static ChatMessageModel fromEntity(ChatMessage entity) {
    return ChatMessageModel(
      id: entity.id,
      role: entity.role,
      content: entity.content,
      timestamp: entity.timestamp,
      status: MessageStatusModel.values.firstWhere(
        (e) => e.name == entity.status.name,
        orElse: () => MessageStatusModel.sent,
      ),
      metadata: entity.metadata,
    );
  }

  ChatMessageModel copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    MessageStatusModel? status,
    Map<String, dynamic>? metadata,
  }) {
    return ChatMessageModel(
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
