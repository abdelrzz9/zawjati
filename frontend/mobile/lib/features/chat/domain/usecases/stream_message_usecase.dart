import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../repositories/chat_repository.dart';

class StreamMessageParams {
  final String message;
  final String userId;
  final String? personality;

  const StreamMessageParams({
    required this.message,
    this.userId = 'default',
    this.personality,
  });
}

class StreamMessageUseCase {
  final ChatRepository repository;

  StreamMessageUseCase({required this.repository});

  Stream<Either<Failure, String>> call(StreamMessageParams params) {
    return repository.streamMessage(
      message: params.message,
      userId: params.userId,
      personality: params.personality,
    );
  }
}
