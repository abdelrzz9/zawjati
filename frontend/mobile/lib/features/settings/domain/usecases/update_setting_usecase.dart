import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../repositories/settings_repository.dart';

class UpdateSettingUseCase implements UseCase<void, UpdateSettingParams> {
  final SettingsRepository repository;

  UpdateSettingUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateSettingParams params) {
    return repository.updateSetting(params.key, params.value);
  }
}

class UpdateSettingParams extends Equatable {
  final String key;
  final dynamic value;

  const UpdateSettingParams({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}
