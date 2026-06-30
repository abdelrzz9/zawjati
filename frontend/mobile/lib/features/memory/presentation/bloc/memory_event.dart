part of 'memory_bloc.dart';

abstract class MemoryEvent extends Equatable {
  const MemoryEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemories extends MemoryEvent {
  final String userId;
  final MemoryCategory? category;
  final int? minImportance;

  const LoadMemories({
    required this.userId,
    this.category,
    this.minImportance,
  });

  @override
  List<Object?> get props => [userId, category, minImportance];
}

class SearchMemories extends MemoryEvent {
  final String query;

  const SearchMemories({required this.query});

  @override
  List<Object?> get props => [query];
}

class DeleteMemory extends MemoryEvent {
  final String id;

  const DeleteMemory({required this.id});

  @override
  List<Object?> get props => [id];
}

class PinMemory extends MemoryEvent {
  final String id;

  const PinMemory({required this.id});

  @override
  List<Object?> get props => [id];
}

class FilterByCategory extends MemoryEvent {
  final MemoryCategory? category;

  const FilterByCategory({this.category});

  @override
  List<Object?> get props => [category];
}
