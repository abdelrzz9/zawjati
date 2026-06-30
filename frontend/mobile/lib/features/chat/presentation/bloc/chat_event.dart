import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class SendMessage extends ChatEvent {
  final String message;
  final String? personality;

  const SendMessage({required this.message, this.personality});

  @override
  List<Object?> get props => [message, personality];
}

class StreamMessageEvent extends ChatEvent {
  final String message;
  final String? personality;

  const StreamMessageEvent({required this.message, this.personality});

  @override
  List<Object?> get props => [message, personality];
}

class LoadConversations extends ChatEvent {
  const LoadConversations();
}

class SelectConversation extends ChatEvent {
  final String conversationId;

  const SelectConversation({required this.conversationId});

  @override
  List<Object?> get props => [conversationId];
}

class ClearChat extends ChatEvent {
  const ClearChat();
}

class RegenerateMessage extends ChatEvent {
  final String messageId;

  const RegenerateMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class DeleteMessage extends ChatEvent {
  final String messageId;

  const DeleteMessage({required this.messageId});

  @override
  List<Object?> get props => [messageId];
}

class EditMessage extends ChatEvent {
  final String messageId;
  final String newContent;

  const EditMessage({required this.messageId, required this.newContent});

  @override
  List<Object?> get props => [messageId, newContent];
}

class StopGeneration extends ChatEvent {
  const StopGeneration();
}
