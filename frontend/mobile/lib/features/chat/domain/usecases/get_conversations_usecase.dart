import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/chat_conversation.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase
    implements UseCase<List<ChatConversation>, NoParams> {
  final ChatRepository repository;

  GetConversationsUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ChatConversation>>> call(NoParams params) {
    return repository.getConversations();
  }
}
