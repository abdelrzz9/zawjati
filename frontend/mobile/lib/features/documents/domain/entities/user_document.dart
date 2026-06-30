import 'package:equatable/equatable.dart';

enum DocumentStatus { indexing, ready, error }

class UserDocument extends Equatable {
  final String id;
  final String filename;
  final String type;
  final int size;
  final DocumentStatus status;
  final DateTime createdAt;
  final int chunkCount;

  const UserDocument({
    required this.id,
    required this.filename,
    required this.type,
    required this.size,
    required this.status,
    required this.createdAt,
    this.chunkCount = 0,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  List<Object?> get props => [id, filename, type, size, status, createdAt, chunkCount];
}
