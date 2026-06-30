import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/chat/domain/entities/chat_message.dart';
import 'package:zawjati_mobile/features/chat/domain/entities/chat_conversation.dart';
import 'package:zawjati_mobile/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:zawjati_mobile/features/chat/domain/usecases/stream_message_usecase.dart';
import 'package:zawjati_mobile/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:zawjati_mobile/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:zawjati_mobile/features/chat/presentation/bloc/chat_event.dart';
import 'package:zawjati_mobile/features/chat/presentation/bloc/chat_state.dart';

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {}
class MockStreamMessageUseCase extends Mock implements StreamMessageUseCase {}
class MockGetConversationsUseCase extends Mock
    implements GetConversationsUseCase {}

void main() {
  late MockSendMessageUseCase mockSendMessage;
  late MockStreamMessageUseCase mockStreamMessage;
  late MockGetConversationsUseCase mockGetConversations;
  late ChatBloc chatBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(SendMessageParams(message: ''));
    registerFallbackValue(StreamMessageParams(message: ''));
  });

  final testConversation = ChatConversation(
    id: 'conv-1',
    title: 'Test Chat',
    messages: [],
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  final testAssistantMessage = ChatMessage(
    id: 'msg-2',
    role: 'assistant',
    content: 'Hello! How can I help?',
    timestamp: DateTime.now(),
    status: ChatMessageStatus.delivered,
  );

  setUp(() {
    mockSendMessage = MockSendMessageUseCase();
    mockStreamMessage = MockStreamMessageUseCase();
    mockGetConversations = MockGetConversationsUseCase();
    chatBloc = ChatBloc(
      sendMessageUseCase: mockSendMessage,
      streamMessageUseCase: mockStreamMessage,
      getConversationsUseCase: mockGetConversations,
    );
  });

  tearDown(() {
    chatBloc.close();
  });

  group('ChatBloc', () {
    blocTest<ChatBloc, ChatState>(
      'emits [Loading, Loaded] when conversations load successfully',
      build: () {
        when(() => mockGetConversations(any()))
            .thenAnswer((_) async => Right([testConversation]));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const LoadConversations()),
      expect: () => [
        const ChatLoading(),
        isA<ChatLoaded>(),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'emits [Loading, Error] when conversations fail to load',
      build: () {
        when(() => mockGetConversations(any()))
            .thenAnswer((_) async => Left(ServerFailure('Connection error', 503)));
        return chatBloc;
      },
      act: (bloc) => bloc.add(const LoadConversations()),
      expect: () => [
        const ChatLoading(),
        isA<ChatError>(),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'sends message and receives response',
      build: () {
        when(() => mockGetConversations(any()))
            .thenAnswer((_) async => Right([testConversation]));
        when(() => mockSendMessage(any()))
            .thenAnswer((_) async => Right(testAssistantMessage));
        return chatBloc;
      },
      seed: () => ChatLoaded(
        conversations: [testConversation],
        messages: [],
        activeConversationId: 'conv-1',
      ),
      act: (bloc) => bloc.add(const SendMessage(message: 'Hello')),
      expect: () => [
        isA<ChatLoaded>().having(
          (s) => s.messages.length,
          'has user message',
          1,
        ),
        isA<ChatLoaded>().having(
          (s) => s.messages.length,
          'has both messages',
          2,
        ),
      ],
    );

    late StreamController<Either<Failure, String>> streamController;
    blocTest<ChatBloc, ChatState>(
      'sets up streaming state on StreamMessageEvent',
      build: () {
        streamController = StreamController<Either<Failure, String>>();
        when(() => mockGetConversations(any()))
            .thenAnswer((_) async => Right([testConversation]));
        when(() => mockStreamMessage(any())).thenAnswer((_) => streamController.stream);
        return chatBloc;
      },
      tearDown: () => streamController.close(),
      seed: () => ChatLoaded(
        conversations: [testConversation],
        messages: [],
        activeConversationId: 'conv-1',
      ),
      act: (bloc) => bloc.add(const StreamMessageEvent(message: 'Hi')),
      expect: () => [
        isA<ChatLoaded>().having(
          (s) => s.isStreaming,
          'isStreaming',
          true,
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'stops generation and resets streaming state',
      build: () => chatBloc,
      seed: () => ChatLoaded(
        conversations: [testConversation],
        messages: [ChatMessage(
          id: 'stream-1',
          role: 'assistant',
          content: 'In progress...',
          timestamp: DateTime.now(),
          status: ChatMessageStatus.streaming,
        )],
        isStreaming: true,
        currentStreamContent: 'In progress...',
        activeConversationId: 'conv-1',
      ),
      act: (bloc) => bloc.add(const StopGeneration()),
      expect: () => [
        isA<ChatLoaded>().having(
          (s) => s.isStreaming,
          'isStreaming',
          false,
        ),
      ],
    );

    blocTest<ChatBloc, ChatState>(
      'clears chat state',
      build: () => chatBloc,
      seed: () => ChatLoaded(
        conversations: [testConversation],
        messages: [testAssistantMessage],
        activeConversationId: 'conv-1',
      ),
      act: (bloc) => bloc.add(const ClearChat()),
      expect: () => [
        isA<ChatLoaded>()
            .having((s) => s.messages.length, 'messages empty', 0)
            .having((s) => s.activeConversationId, 'no active conv', isNull),
      ],
    );

    test('initial state is ChatInitial', () {
      expect(chatBloc.state, const ChatInitial());
    });
  });
}
