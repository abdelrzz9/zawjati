import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../../domain/repositories/chat_repository.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/chat_message.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_request_model.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource _remoteDataSource;

  ChatRepositoryImpl({required ChatRemoteDataSource remoteDataSource})
      : _remoteDataSource = remoteDataSource;

  @override
  Future<Either<Failure, ChatMessage>> sendMessage({
    required String message,
    String userId = 'default',
    String? personality,
  }) async {
    try {
      final request = ChatRequestModel(
        message: message,
        userId: userId,
        personality: personality,
        stream: false,
      );
      final response = await _remoteDataSource.sendMessage(request);
      final chatMessage = ChatMessageModel(
        id: response.requestId.isNotEmpty ? response.requestId : '',
        role: 'assistant',
        content: response.reply,
        timestamp: DateTime.now(),
        status: MessageStatusModel.delivered,
        metadata: {
          if (response.latencyMs != null) 'latency_ms': response.latencyMs,
          if (response.promptTokens != null)
            'prompt_tokens': response.promptTokens,
          if (response.completionTokens != null)
            'completion_tokens': response.completionTokens,
          if (response.totalTokens != null)
            'total_tokens': response.totalTokens,
          if (response.cost != null) 'cost': response.cost,
          'request_id': response.requestId,
        },
      ).toEntity();
      return Right(chatMessage);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<Either<Failure, String>> streamMessage({
    required String message,
    String userId = 'default',
    String? personality,
  }) async* {
    try {
      final request = ChatRequestModel(
        message: message,
        userId: userId,
        personality: personality,
        stream: true,
      );
      final tokenStream = _remoteDataSource.streamMessage(request);
      await for (final token in tokenStream) {
        yield Right(token);
      }
    } on Failure catch (f) {
      yield Left(f);
    } catch (e) {
      yield Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChatConversation>>> getConversations() async {
    try {
      final models = await _remoteDataSource.getConversations();
      final conversations = models.map((m) => m.toEntity()).toList();
      return Right(conversations);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
