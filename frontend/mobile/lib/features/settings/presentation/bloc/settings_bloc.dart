import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/usecases/get_settings_usecase.dart';
import '../../domain/usecases/update_setting_usecase.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSettings extends SettingsEvent {
  const LoadSettings();
}

final class UpdateSetting extends SettingsEvent {
  final String key;
  final dynamic value;

  const UpdateSetting({required this.key, required this.value});

  @override
  List<Object?> get props => [key, value];
}

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

final class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

final class SettingsLoaded extends SettingsState {
  final AppSettings settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

final class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUseCase getSettingsUseCase;
  final UpdateSettingUseCase updateSettingUseCase;

  SettingsBloc({
    required this.getSettingsUseCase,
    required this.updateSettingUseCase,
  }) : super(const SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSetting>(_onUpdateSetting);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    final result = await getSettingsUseCase(NoParams());
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateSetting(
    UpdateSetting event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final current = (state as SettingsLoaded).settings;
      final result = await updateSettingUseCase(
        UpdateSettingParams(key: event.key, value: event.value),
      );

      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (_) {
          final updated = _applyUpdate(current, event.key, event.value);
          emit(SettingsLoaded(updated));
        },
      );
    }
  }

  AppSettings _applyUpdate(AppSettings settings, String key, dynamic value) {
    final map = <String, dynamic>{
      'themeMode': settings.themeMode,
      'language': settings.language,
      'streamingEnabled': settings.streamingEnabled,
      'animationsEnabled': settings.animationsEnabled,
      'notificationsEnabled': settings.notificationsEnabled,
      'pushNotificationsEnabled': settings.pushNotificationsEnabled,
      'soundEnabled': settings.soundEnabled,
      'reducedMotion': settings.reducedMotion,
      'highContrast': settings.highContrast,
      'largeText': settings.largeText,
      'userBiometricEnabled': settings.userBiometricEnabled,
      'developerMode': settings.developerMode,
      'debugLogging': settings.debugLogging,
      'cacheSize': settings.cacheSize,
    };
    map[key] = value;
    return AppSettings(
      themeMode: map['themeMode'] as String,
      language: map['language'] as String,
      streamingEnabled: map['streamingEnabled'] as bool,
      animationsEnabled: map['animationsEnabled'] as bool,
      notificationsEnabled: map['notificationsEnabled'] as bool,
      pushNotificationsEnabled: map['pushNotificationsEnabled'] as bool,
      soundEnabled: map['soundEnabled'] as bool,
      reducedMotion: map['reducedMotion'] as bool,
      highContrast: map['highContrast'] as bool,
      largeText: map['largeText'] as bool,
      userBiometricEnabled: map['userBiometricEnabled'] as bool,
      developerMode: map['developerMode'] as bool,
      debugLogging: map['debugLogging'] as bool,
      cacheSize: map['cacheSize'] as int,
    );
  }
}
