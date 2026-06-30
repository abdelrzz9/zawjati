import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import '../../domain/usecases/stream_message_usecase.dart';
import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase _sendMessageUseCase;
  final StreamMessageUseCase _streamMessageUseCase;
  final GetConversationsUseCase _getConversationsUseCase;
  final Uuid _uuid;

  StreamSubscription<Either<Failure, String>>? _streamSubscription;
  String _currentAssistantMessageId = '';

  ChatBloc({
    required SendMessageUseCase sendMessageUseCase,
    required StreamMessageUseCase streamMessageUseCase,
    required GetConversationsUseCase getConversationsUseCase,
    Uuid? uuid,
  })  : _sendMessageUseCase = sendMessageUseCase,
        _streamMessageUseCase = streamMessageUseCase,
        _getConversationsUseCase = getConversationsUseCase,
        _uuid = uuid ?? const Uuid(),
        super(const ChatInitial()) {
    on<SendMessage>(_onSendMessage);
    on<StreamMessageEvent>(_onStreamMessage);
    on<LoadConversations>(_onLoadConversations);
    on<SelectConversation>(_onSelectConversation);
    on<ClearChat>(_onClearChat);
    on<RegenerateMessage>(_onRegenerateMessage);
    on<DeleteMessage>(_onDeleteMessage);
    on<EditMessage>(_onEditMessage);
    on<StopGeneration>(_onStopGeneration);
  }

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  void _onLoadConversations(
    LoadConversations event,
    Emitter<ChatState> emit,
  ) async {
    emit(const ChatLoading());
    final result = await _getConversationsUseCase(NoParams());
    result.fold(
      (failure) => emit(ChatError(message: failure.userFriendlyMessage)),
      (conversations) => emit(
        ChatLoaded(
          conversations: conversations,
          activeConversationId: conversations.isNotEmpty
              ? conversations.first.id
              : null,
          messages: conversations.isNotEmpty
              ? conversations.first.messages
              : [],
        ),
      ),
    );
  }

  void _onSelectConversation(
    SelectConversation event,
    Emitter<ChatState> emit,
  ) {
    if (state is ChatLoaded) {
      final loaded = state as ChatLoaded;
      final conversation = loaded.conversations
          .where((c) => c.id == event.conversationId)
          .firstOrNull;
      if (conversation != null) {
        emit(
          loaded.copyWith(
            activeConversationId: conversation.id,
            messages: conversation.messages,
            error: null,
          ),
        );
      }
    }
  }

  void _onSendMessage(
    SendMessage event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: 'user',
      content: event.message,
      timestamp: DateTime.now(),
      status: ChatMessageStatus.sending,
    );

    final updatedMessages = [...loaded.messages, userMessage];
    emit(loaded.copyWith(messages: updatedMessages, error: null));

    final result = await _sendMessageUseCase(
      SendMessageParams(
        message: event.message,
        personality: event.personality,
      ),
    );

    result.fold(
      (failure) {
        final failedMessages = loaded.messages
            .map((m) => m.id == userMessage.id
                ? m.copyWith(status: ChatMessageStatus.error)
                : m)
            .toList();
        emit(
          loaded.copyWith(
            messages: [...failedMessages],
            error: failure.userFriendlyMessage,
          ),
        );
      },
      (assistantMessage) {
        final sentMessages = updatedMessages
            .map((m) => m.id == userMessage.id
                ? m.copyWith(status: ChatMessageStatus.sent)
                : m)
            .toList();
        emit(
          loaded.copyWith(
            messages: [...sentMessages, assistantMessage],
            error: null,
          ),
        );
      },
    );
  }

  void _onStreamMessage(
    StreamMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;

    _currentAssistantMessageId = _uuid.v4();

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      role: 'user',
      content: event.message,
      timestamp: DateTime.now(),
      status: ChatMessageStatus.sent,
    );

    final assistantMessage = ChatMessage(
      id: _currentAssistantMessageId,
      role: 'assistant',
      content: '',
      timestamp: DateTime.now(),
      status: ChatMessageStatus.streaming,
    );

    final updatedMessages = [...loaded.messages, userMessage, assistantMessage];
    emit(
      loaded.copyWith(
        messages: updatedMessages,
        isStreaming: true,
        currentStreamContent: '',
        error: null,
      ),
    );

    _streamSubscription = _streamMessageUseCase(
      StreamMessageParams(
        message: event.message,
        personality: event.personality,
      ),
    ).listen(
      (either) {
        if (isClosed) return;
        either.fold(
          (failure) {
            if (isClosed) return;
            emit(
              (state as ChatLoaded).copyWith(
                error: failure.userFriendlyMessage,
                isStreaming: false,
                currentStreamContent: null,
              ),
            );
          },
          (token) {
            if (isClosed) return;
            final currentState = state;
            if (currentState is! ChatLoaded) return;
            final newContent =
                (currentState.currentStreamContent ?? '') + token;
            final updatedMessagesList = currentState.messages.map((m) {
              return m.id == _currentAssistantMessageId
                  ? m.copyWith(content: newContent)
                  : m;
            }).toList();
            emit(
              currentState.copyWith(
                messages: updatedMessagesList,
                currentStreamContent: newContent,
                isStreaming: true,
              ),
            );
          },
        );
      },
      onDone: () {
        if (isClosed) return;
        final currentState = state;
        if (currentState is! ChatLoaded) return;
        final finalMessages = currentState.messages.map((m) {
          return m.id == _currentAssistantMessageId
              ? m.copyWith(status: ChatMessageStatus.delivered)
              : m;
        }).toList();
        emit(
          currentState.copyWith(
            messages: finalMessages,
            isStreaming: false,
            currentStreamContent: null,
          ),
        );
      },
      onError: (error) {
        if (isClosed) return;
        emit(
          (state as ChatLoaded).copyWith(
            error: error.toString(),
            isStreaming: false,
            currentStreamContent: null,
          ),
        );
      },
    );
  }

  void _onStopGeneration(
    StopGeneration event,
    Emitter<ChatState> emit,
  ) {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    if (state is ChatLoaded) {
      final loaded = state as ChatLoaded;
      final finalMessages = loaded.messages.map((m) {
        return m.id == _currentAssistantMessageId
            ? m.copyWith(status: ChatMessageStatus.delivered)
            : m;
      }).toList();
      emit(
        loaded.copyWith(
          messages: finalMessages,
          isStreaming: false,
          currentStreamContent: null,
        ),
      );
    }
  }

  void _onClearChat(
    ClearChat event,
    Emitter<ChatState> emit,
  ) {
    _streamSubscription?.cancel();
    _streamSubscription = null;
    if (state is ChatLoaded) {
      emit(
        (state as ChatLoaded).copyWith(
          messages: [],
          activeConversationId: null,
          currentStreamContent: null,
          isStreaming: false,
          error: null,
        ),
      );
    }
  }

  void _onRegenerateMessage(
    RegenerateMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;
    final msgIndex = loaded.messages.indexWhere((m) => m.id == event.messageId);
    if (msgIndex < 0 || msgIndex == 0) return;

    final userMsg = msgIndex > 0 ? loaded.messages[msgIndex - 1] : null;
    if (userMsg == null || !userMsg.isUser) return;

    final messagesBefore = loaded.messages.sublist(0, msgIndex);
    add(
      StreamMessageEvent(
        message: userMsg.content,
        personality: loaded.activeConversationId,
      ),
    );
    emit(
      loaded.copyWith(
        messages: messagesBefore,
        isStreaming: true,
      ),
    );
  }

  void _onDeleteMessage(
    DeleteMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;
    emit(
      loaded.copyWith(
        messages: loaded.messages.where((m) => m.id != event.messageId).toList(),
      ),
    );
  }

  void _onEditMessage(
    EditMessage event,
    Emitter<ChatState> emit,
  ) {
    if (state is! ChatLoaded) return;
    final loaded = state as ChatLoaded;
    final updated = loaded.messages.map((m) {
      return m.id == event.messageId
          ? m.copyWith(content: event.newContent, status: ChatMessageStatus.sent)
          : m;
    }).toList();
    emit(loaded.copyWith(messages: updated));
  }
}
