import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthUseCase implements UseCase<User, NoParams> {
  final AuthRepository repository;

  CheckAuthUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.checkAuth();
  }
}
