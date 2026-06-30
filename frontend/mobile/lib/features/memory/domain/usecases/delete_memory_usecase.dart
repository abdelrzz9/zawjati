import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../repositories/memory_repository.dart';

class DeleteMemoryUseCase implements UseCase<void, DeleteMemoryParams> {
  final MemoryRepository repository;

  DeleteMemoryUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(DeleteMemoryParams params) {
    return repository.deleteMemory(params.id);
  }
}

class DeleteMemoryParams extends Equatable {
  final String id;

  const DeleteMemoryParams({required this.id});

  @override
  List<Object> get props => [id];
}
