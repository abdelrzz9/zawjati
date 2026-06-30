import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/chat_message.dart';
import '../repositories/chat_repository.dart';

class SendMessageParams {
  final String message;
  final String userId;
  final String? personality;

  const SendMessageParams({
    required this.message,
    this.userId = 'default',
    this.personality,
  });
}

class SendMessageUseCase
    implements UseCase<ChatMessage, SendMessageParams> {
  final ChatRepository repository;

  SendMessageUseCase({required this.repository});

  @override
  Future<Either<Failure, ChatMessage>> call(SendMessageParams params) {
    return repository.sendMessage(
      message: params.message,
      userId: params.userId,
      personality: params.personality,
    );
  }
}
