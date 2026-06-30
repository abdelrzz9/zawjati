import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfile>> getProfile(String userId);

  Future<Either<Failure, UserProfile>> updateProfile(
    String userId,
    UserProfile profile,
  );
}
