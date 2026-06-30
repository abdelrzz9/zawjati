import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/personality.dart';
import '../repositories/personalities_repository.dart';

class GetPersonalitiesUseCase
    implements UseCase<List<Personality>, NoParams> {
  final PersonalitiesRepository repository;

  GetPersonalitiesUseCase(this.repository);

  @override
  Future<Either<Failure, List<Personality>>> call(NoParams params) {
    return repository.getPersonalities();
  }
}
