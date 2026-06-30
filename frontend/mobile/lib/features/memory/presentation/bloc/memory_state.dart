part of 'memory_bloc.dart';

abstract class MemoryState extends Equatable {
  const MemoryState();

  @override
  List<Object?> get props => [];
}

class MemoryInitial extends MemoryState {
  const MemoryInitial();
}

class MemoryLoading extends MemoryState {
  const MemoryLoading();
}

class MemoryLoaded extends MemoryState {
  final List<Memory> memories;
  final MemoryCategory? selectedCategory;
  final String? searchQuery;

  const MemoryLoaded({
    required this.memories,
    this.selectedCategory,
    this.searchQuery,
  });

  List<Memory> get filtered {
    if (selectedCategory == null) return memories;
    return memories.where((m) => m.category == selectedCategory).toList();
  }

  MemoryLoaded copyWith({
    List<Memory>? memories,
    MemoryCategory? selectedCategory,
    String? searchQuery,
  }) {
    return MemoryLoaded(
      memories: memories ?? this.memories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props =>
      [memories, selectedCategory, searchQuery];
}

class MemoryError extends MemoryState {
  final String message;

  const MemoryError(this.message);

  @override
  List<Object?> get props => [message];
}
