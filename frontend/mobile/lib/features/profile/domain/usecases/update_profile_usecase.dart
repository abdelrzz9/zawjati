import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/profile.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase
    implements UseCase<UserProfile, UpdateProfileParams> {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  @override
  Future<Either<Failure, UserProfile>> call(UpdateProfileParams params) {
    return repository.updateProfile(params.userId, params.profile);
  }
}

class UpdateProfileParams extends Equatable {
  final String userId;
  final UserProfile profile;

  const UpdateProfileParams({
    required this.userId,
    required this.profile,
  });

  @override
  List<Object?> get props => [userId, profile];
}
