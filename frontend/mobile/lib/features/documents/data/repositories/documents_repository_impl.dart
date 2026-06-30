import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import '../../domain/entities/user_document.dart';
import '../../domain/repositories/documents_repository.dart';
import '../datasources/documents_remote_datasource.dart';
import '../models/document_model.dart';

class DocumentsRepositoryImpl implements DocumentsRepository {
  final DocumentsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  DocumentsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<UserDocument>>> getDocuments() async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      final result = await remoteDataSource.getDocuments();
      final documents = result.map((json) => DocumentModel.fromJson(json)).toList();
      return Right(documents);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserDocument>> uploadDocument(
    String filePath,
    String filename,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      final result = await remoteDataSource.uploadDocument(filePath, filename);
      return Right(DocumentModel.fromJson(result));
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      await remoteDataSource.deleteDocument(id);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
