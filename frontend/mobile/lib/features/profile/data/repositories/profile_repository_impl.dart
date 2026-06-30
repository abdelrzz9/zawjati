import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import '../../domain/entities/profile.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';
import '../models/profile_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  ProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, UserProfile>> getProfile(String userId) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final result = await remoteDataSource.getProfile(userId);
      final profile = ProfileModel.fromJson(result);
      return Right(profile);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, UserProfile>> updateProfile(
    String userId,
    UserProfile profile,
  ) async {
    if (!await networkInfo.isConnected) {
      return const Left(NetworkFailure());
    }
    try {
      final model = ProfileModel.fromEntity(profile);
      final result = await remoteDataSource.updateProfile(
        userId,
        model.toJson(),
      );
      final updated = ProfileModel.fromJson(result);
      return Right(updated);
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return const Left(UnknownFailure());
    }
  }
}
