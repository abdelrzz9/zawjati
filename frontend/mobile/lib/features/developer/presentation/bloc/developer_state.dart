part of 'developer_bloc.dart';

class DeveloperState extends Equatable {
  final List<String> logs;
  final String? apiTestResult;

  const DeveloperState({
    this.logs = const [],
    this.apiTestResult,
  });

  DeveloperState copyWith({
    List<String>? logs,
    String? apiTestResult,
  }) {
    return DeveloperState(
      logs: logs ?? this.logs,
      apiTestResult: apiTestResult ?? this.apiTestResult,
    );
  }

  @override
  List<Object?> get props => [logs, apiTestResult];
}
