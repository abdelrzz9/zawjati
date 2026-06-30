import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../repositories/notifications_repository.dart';

class MarkReadUseCase implements UseCase<void, MarkReadParams> {
  final NotificationsRepository repository;

  MarkReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(MarkReadParams params) {
    if (params.markAll) {
      return repository.markAllRead();
    }
    return repository.markRead(params.notificationId!);
  }
}

class MarkReadParams extends Equatable {
  final String? notificationId;
  final bool markAll;

  const MarkReadParams.markAll()
      : notificationId = null,
        markAll = true;

  const MarkReadParams.single(this.notificationId) : markAll = false;

  @override
  List<Object?> get props => [notificationId, markAll];
}
