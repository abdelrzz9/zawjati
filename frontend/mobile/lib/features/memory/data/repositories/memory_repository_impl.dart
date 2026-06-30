import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import '../../domain/entities/memory.dart';
import '../../domain/repositories/memory_repository.dart';
import '../datasources/memory_remote_datasource.dart';

class MemoryRepositoryImpl implements MemoryRepository {
  final MemoryRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  MemoryRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Memory>>> getMemories(
    String userId, {
    MemoryCategory? category,
    int? minImportance,
  }) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      final models = await remoteDataSource.getMemories(
        userId,
        category: category,
        minImportance: minImportance,
      );
      return Right(models);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Memory>>> searchMemories(
    String userId,
    String query,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      final models = await remoteDataSource.searchMemories(userId, query);
      return Right(models);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMemory(String id) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.deleteMemory(id);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateMemory(
    String id,
    Map<String, dynamic> data,
  ) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure('No internet connection'));
    }
    try {
      await remoteDataSource.updateMemory(id, data);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
