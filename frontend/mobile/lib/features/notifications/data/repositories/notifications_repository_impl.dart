import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notifications_repository.dart';
import '../datasources/notifications_remote_datasource.dart';
import '../models/notification_model.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  final NotificationsRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  NotificationsRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications() async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      final result = await remoteDataSource.getNotifications();
      final notifications = result.map((json) => NotificationModel.fromJson(json)).toList();
      return Right(notifications);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markRead(String notificationId) async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      await remoteDataSource.markRead(notificationId);
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> markAllRead() async {
    if (!await networkInfo.isConnected) {
      return Left(const NetworkFailure());
    }
    try {
      await remoteDataSource.markAllRead();
      return const Right(null);
    } on Failure catch (f) {
      return Left(f);
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}
