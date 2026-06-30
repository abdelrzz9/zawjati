import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/user_document.dart';

abstract class DocumentsRepository {
  Future<Either<Failure, List<UserDocument>>> getDocuments();
  Future<Either<Failure, UserDocument>> uploadDocument(String filePath, String filename);
  Future<Either<Failure, void>> deleteDocument(String id);
}
