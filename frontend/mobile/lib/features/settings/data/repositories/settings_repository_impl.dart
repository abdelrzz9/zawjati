import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource localDataSource;

  SettingsRepositoryImpl({required this.localDataSource});

  @override
  AppSettings getSettings() {
    return localDataSource.getSettings();
  }

  @override
  Future<Either<Failure, void>> updateSetting(String key, dynamic value) async {
    try {
      await localDataSource.updateSetting(key, value);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to update setting: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> clearCache() async {
    try {
      await localDataSource.clearCache();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to clear cache: $e'));
    }
  }

  @override
  Future<Either<Failure, int>> getStorageUsage() async {
    try {
      final size = await localDataSource.getStorageUsage();
      return Right(size);
    } catch (e) {
      return Left(CacheFailure('Failed to get storage usage: $e'));
    }
  }
}
