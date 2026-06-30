import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/memory.dart';
import '../repositories/memory_repository.dart';

class SearchMemoriesUseCase
    implements UseCase<List<Memory>, SearchMemoriesParams> {
  final MemoryRepository repository;

  SearchMemoriesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Memory>>> call(SearchMemoriesParams params) {
    return repository.searchMemories(params.userId, params.query);
  }
}

class SearchMemoriesParams extends Equatable {
  final String userId;
  final String query;

  const SearchMemoriesParams({
    required this.userId,
    required this.query,
  });

  @override
  List<Object> get props => [userId, query];
}
