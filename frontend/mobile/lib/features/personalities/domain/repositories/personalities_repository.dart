import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/personality.dart';

abstract class PersonalitiesRepository {
  Future<Either<Failure, List<Personality>>> getPersonalities();
}
