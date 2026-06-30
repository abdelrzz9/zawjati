import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/user_document.dart';
import '../repositories/documents_repository.dart';

class UploadDocumentUseCase implements UseCase<UserDocument, UploadDocumentParams> {
  final DocumentsRepository repository;

  UploadDocumentUseCase(this.repository);

  @override
  Future<Either<Failure, UserDocument>> call(UploadDocumentParams params) {
    return repository.uploadDocument(params.filePath, params.filename);
  }
}

class UploadDocumentParams extends Equatable {
  final String filePath;
  final String filename;

  const UploadDocumentParams({
    required this.filePath,
    required this.filename,
  });

  @override
  List<Object> get props => [filePath, filename];
}
