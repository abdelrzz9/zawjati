import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'developer_event.dart';
part 'developer_state.dart';

class DeveloperBloc extends Bloc<DeveloperEvent, DeveloperState> {
  DeveloperBloc() : super(const DeveloperState()) {
    on<LoadLogs>(_onLoadLogs);
    on<ClearLogs>(_onClearLogs);
    on<TestApiEndpoint>(_onTestApiEndpoint);
  }

  void _onLoadLogs(
    LoadLogs event,
    Emitter<DeveloperState> emit,
  ) {
    final newLogs = List<String>.from(state.logs)
      ..add('${DateTime.now()} [${event.level}] ${event.message}');
    emit(state.copyWith(logs: newLogs));
  }

  void _onClearLogs(
    ClearLogs event,
    Emitter<DeveloperState> emit,
  ) {
    emit(state.copyWith(logs: const []));
  }

  void _onTestApiEndpoint(
    TestApiEndpoint event,
    Emitter<DeveloperState> emit,
  ) {
    emit(
      state.copyWith(
        apiTestResult: 'Testing ${event.method} ${event.endpoint}...',
      ),
    );
  }
}
