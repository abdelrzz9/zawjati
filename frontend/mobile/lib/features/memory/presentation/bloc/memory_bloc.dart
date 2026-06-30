import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/features/memory/domain/entities/memory.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/get_memories_usecase.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/delete_memory_usecase.dart';
import 'package:zawjati_mobile/features/memory/domain/usecases/search_memories_usecase.dart';

part 'memory_event.dart';
part 'memory_state.dart';

class MemoryBloc extends Bloc<MemoryEvent, MemoryState> {
  final GetMemoriesUseCase getMemoriesUseCase;
  final DeleteMemoryUseCase deleteMemoryUseCase;
  final SearchMemoriesUseCase searchMemoriesUseCase;

  String? _currentUserId;

  MemoryBloc({
    required this.getMemoriesUseCase,
    required this.deleteMemoryUseCase,
    required this.searchMemoriesUseCase,
  }) : super(const MemoryInitial()) {
    on<LoadMemories>(_onLoadMemories);
    on<SearchMemories>(_onSearchMemories);
    on<DeleteMemory>(_onDeleteMemory);
    on<PinMemory>(_onPinMemory);
    on<FilterByCategory>(_onFilterByCategory);
  }

  FutureOr<void> _onLoadMemories(
    LoadMemories event,
    Emitter<MemoryState> emit,
  ) async {
    _currentUserId = event.userId;
    emit(const MemoryLoading());
    final result = await getMemoriesUseCase(
      GetMemoriesParams(
        userId: event.userId,
        category: event.category,
        minImportance: event.minImportance,
      ),
    );
    result.fold(
      (failure) => emit(MemoryError(failure.userFriendlyMessage)),
      (memories) => emit(MemoryLoaded(
        memories: memories,
        selectedCategory: event.category,
      )),
    );
  }

  FutureOr<void> _onSearchMemories(
    SearchMemories event,
    Emitter<MemoryState> emit,
  ) async {
    if (_currentUserId == null) {
      emit(MemoryError('User not authenticated'));
      return;
    }
    if (event.query.isEmpty) {
      add(LoadMemories(userId: _currentUserId!));
      return;
    }
    emit(const MemoryLoading());
    final result = await searchMemoriesUseCase(
      SearchMemoriesParams(userId: _currentUserId!, query: event.query),
    );
    result.fold(
      (failure) => emit(MemoryError(failure.userFriendlyMessage)),
      (memories) => emit(MemoryLoaded(
        memories: memories,
        searchQuery: event.query,
      )),
    );
  }

  FutureOr<void> _onDeleteMemory(
    DeleteMemory event,
    Emitter<MemoryState> emit,
  ) async {
    final result = await deleteMemoryUseCase(DeleteMemoryParams(id: event.id));
    result.fold(
      (failure) => emit(MemoryError(failure.userFriendlyMessage)),
      (_) {
        final current = state;
        if (current is MemoryLoaded) {
          final updated = current.memories.where((m) => m.id != event.id).toList();
          emit(current.copyWith(memories: updated));
        }
      },
    );
  }

  FutureOr<void> _onPinMemory(
    PinMemory event,
    Emitter<MemoryState> emit,
  ) async {
    final current = state;
    if (current is MemoryLoaded) {
      final updated = current.memories.map((m) {
        if (m.id == event.id) {
          return m.copyWith(pinned: !m.pinned);
        }
        return m;
      }).toList();
      emit(current.copyWith(memories: updated));
    }
  }

  FutureOr<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<MemoryState> emit,
  ) async {
    final current = state;
    if (current is MemoryLoaded) {
      if (event.category == null || event.category == current.selectedCategory) {
        emit(current.copyWith(selectedCategory: null));
      } else {
        emit(current.copyWith(selectedCategory: event.category));
      }
    } else if (state is MemoryInitial || state is MemoryError) {
      if (_currentUserId != null) {
        add(LoadMemories(
          userId: _currentUserId!,
          category: event.category,
        ));
      }
    }
  }
}
