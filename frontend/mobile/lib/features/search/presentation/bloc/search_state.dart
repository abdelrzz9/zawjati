part of 'search_bloc.dart';

class SearchState extends Equatable {
  final String query;
  final List<Map<String, dynamic>> messages;
  final List<Map<String, dynamic>> memories;
  final bool isSearching;

  const SearchState({
    this.query = '',
    this.messages = const [],
    this.memories = const [],
    this.isSearching = false,
  });

  SearchState copyWith({
    String? query,
    List<Map<String, dynamic>>? messages,
    List<Map<String, dynamic>>? memories,
    bool? isSearching,
  }) {
    return SearchState(
      query: query ?? this.query,
      messages: messages ?? this.messages,
      memories: memories ?? this.memories,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [query, messages, memories, isSearching];
}
