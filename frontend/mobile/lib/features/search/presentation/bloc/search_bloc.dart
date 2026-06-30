import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<SearchQueryChanged>(_onQueryChanged);
    on<SearchClear>(_onClear);
  }

  void _onQueryChanged(
    SearchQueryChanged event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(query: event.query, isSearching: event.query.isNotEmpty));
  }

  void _onClear(
    SearchClear event,
    Emitter<SearchState> emit,
  ) {
    emit(const SearchState());
  }
}
