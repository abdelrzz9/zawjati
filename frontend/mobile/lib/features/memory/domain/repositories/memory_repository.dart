import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/memory.dart';

abstract class MemoryRepository {
  Future<Either<Failure, List<Memory>>> getMemories(
    String userId, {
    MemoryCategory? category,
    int? minImportance,
  });

  Future<Either<Failure, List<Memory>>> searchMemories(
    String userId,
    String query,
  );

  Future<Either<Failure, void>> deleteMemory(String id);

  Future<Either<Failure, void>> updateMemory(
    String id,
    Map<String, dynamic> data,
  );
}
