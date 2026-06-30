part of 'developer_bloc.dart';

abstract class DeveloperEvent extends Equatable {
  const DeveloperEvent();

  @override
  List<Object?> get props => [];
}

class LoadLogs extends DeveloperEvent {
  final String level;
  final String message;

  const LoadLogs({this.level = 'info', required this.message});

  @override
  List<Object?> get props => [level, message];
}

class ClearLogs extends DeveloperEvent {
  const ClearLogs();
}

class TestApiEndpoint extends DeveloperEvent {
  final String method;
  final String endpoint;
  final Map<String, String>? headers;
  final String? body;

  const TestApiEndpoint({
    required this.method,
    required this.endpoint,
    this.headers,
    this.body,
  });

  @override
  List<Object?> get props => [method, endpoint, headers, body];
}
