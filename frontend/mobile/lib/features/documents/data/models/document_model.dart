import 'package:zawjati_mobile/features/documents/domain/entities/user_document.dart';

class DocumentModel extends UserDocument {
  const DocumentModel({
    required super.id,
    required super.filename,
    required super.type,
    required super.size,
    required super.status,
    required super.createdAt,
    super.chunkCount,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      filename: json['filename'] as String,
      type: json['type'] as String,
      size: json['size'] as int,
      status: _parseStatus(json['status'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      chunkCount: json['chunk_count'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'filename': filename,
    'type': type,
    'size': size,
    'status': status.name,
    'created_at': createdAt.toIso8601String(),
    'chunk_count': chunkCount,
  };

  static DocumentStatus _parseStatus(String status) {
    switch (status) {
      case 'indexing':
        return DocumentStatus.indexing;
      case 'ready':
        return DocumentStatus.ready;
      case 'error':
        return DocumentStatus.error;
      default:
        return DocumentStatus.error;
    }
  }
}
