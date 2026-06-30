import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import '../../domain/entities/personality.dart';
import '../../domain/repositories/personalities_repository.dart';
import '../datasources/personalities_remote_datasource.dart';
import '../models/personality_model.dart';

class PersonalitiesRepositoryImpl implements PersonalitiesRepository {
  final PersonalitiesRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  PersonalitiesRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Personality>>> getPersonalities() async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.getPersonalities();
      final personalities = result.map((e) {
        if (e is String) {
          return PersonalityModel(
            id: e,
            name: e,
            description: '',
            category: '',
          );
        }
        return PersonalityModel.fromJson(e as Map<String, dynamic>);
      }).toList();
      return Right(personalities);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
