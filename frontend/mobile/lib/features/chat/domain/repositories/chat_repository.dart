import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/chat_conversation.dart';
import '../entities/chat_message.dart';

abstract class ChatRepository {
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String message,
    String userId = 'default',
    String? personality,
  });

  Stream<Either<Failure, String>> streamMessage({
    required String message,
    String userId = 'default',
    String? personality,
  });

  Future<Either<Failure, List<ChatConversation>>> getConversations();
}
