import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/user_document.dart';
import '../repositories/documents_repository.dart';

class GetDocumentsUseCase implements UseCase<List<UserDocument>, NoParams> {
  final DocumentsRepository repository;

  GetDocumentsUseCase(this.repository);

  @override
  Future<Either<Failure, List<UserDocument>>> call(NoParams params) {
    return repository.getDocuments();
  }
}
