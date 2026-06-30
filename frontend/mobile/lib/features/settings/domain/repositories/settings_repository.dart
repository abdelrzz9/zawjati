import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import '../entities/app_settings.dart';

abstract class SettingsRepository {
  AppSettings getSettings();

  Future<Either<Failure, void>> updateSetting(String key, dynamic value);

  Future<Either<Failure, void>> clearCache();

  Future<Either<Failure, int>> getStorageUsage();
}
