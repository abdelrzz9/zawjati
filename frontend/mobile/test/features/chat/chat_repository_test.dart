import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:zawjati_mobile/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:zawjati_mobile/features/chat/domain/entities/chat_message.dart';
import 'package:zawjati_mobile/features/chat/domain/entities/chat_conversation.dart';
import 'package:zawjati_mobile/features/chat/data/models/chat_request_model.dart';
import 'package:zawjati_mobile/features/chat/data/models/chat_response_model.dart';
import 'package:zawjati_mobile/features/chat/data/models/chat_conversation_model.dart';

class MockChatRemoteDataSource extends Mock implements ChatRemoteDataSource {}

void main() {
  late MockChatRemoteDataSource mockDataSource;
  late ChatRepositoryImpl repository;

  setUpAll(() {
    registerFallbackValue(ChatRequestModel(message: ''));
  });

  setUp(() {
    mockDataSource = MockChatRemoteDataSource();
    repository = ChatRepositoryImpl(remoteDataSource: mockDataSource);
  });

  group('ChatRepository', () {
    test('sendMessage returns ChatMessage on success', () async {
      final responseModel = ChatResponseModel(
        reply: 'Hello!',
        requestId: 'req-1',
      );
      when(() => mockDataSource.sendMessage(any()))
          .thenAnswer((_) async => responseModel);

      final result = await repository.sendMessage(
        message: 'Hi',
        userId: 'user-1',
      );

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right'),
        (r) {
          expect(r.role, 'assistant');
          expect(r.content, 'Hello!');
        },
      );
    });

    test('sendMessage returns Failure on exception', () async {
      when(() => mockDataSource.sendMessage(any()))
          .thenThrow(Exception('Network error'));

      final result = await repository.sendMessage(
        message: 'Hi',
        userId: 'user-1',
      );

      expect(result.isLeft(), true);
    });

    test('getConversations returns list on success', () async {
      final models = [
        ChatConversationModel(
          id: 'conv-1',
          title: 'Test',
          messages: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      ];
      when(() => mockDataSource.getConversations())
          .thenAnswer((_) async => models);

      final result = await repository.getConversations();

      expect(result.isRight(), true);
      result.fold(
        (l) => fail('Expected Right'),
        (r) => expect(r.length, 1),
      );
    });

    test('getConversations returns Failure on exception', () async {
      when(() => mockDataSource.getConversations())
          .thenThrow(Exception('Failed'));

      final result = await repository.getConversations();

      expect(result.isLeft(), true);
    });
  });
}
