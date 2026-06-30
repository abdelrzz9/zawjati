import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class GetMemoriesUseCase
    implements UseCase<List<Memory>, GetMemoriesParams> {
  final MemoryRepository repository;

  GetMemoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Memory>>> call(GetMemoriesParams params) {
    return repository.getMemories(
      params.userId,
      category: params.category,
      minImportance: params.minImportance,
    );
  }
}

class GetMemoriesParams extends Equatable {
  final String userId;
  final MemoryCategory? category;
  final int? minImportance;

  const GetMemoriesParams({
    required this.userId,
    this.category,
    this.minImportance,
  });

  @override
  List<Object?> get props => [userId, category, minImportance];
}
