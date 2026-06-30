import 'package:equatable/equatable.dart';

class AppNotification extends Equatable {
  final String id;
  final String type;
  final String title;
  final String body;
  final Map<String, dynamic>? data;
  final bool read;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.read,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, title, body, data, read, createdAt];
}
