import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:zawjati_mobile/core/usecase/usecase.dart';
import 'package:zawjati_mobile/features/settings/domain/usecases/get_settings_usecase.dart';
import 'package:zawjati_mobile/features/settings/domain/usecases/update_setting_usecase.dart';
import 'package:zawjati_mobile/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:zawjati_mobile/features/settings/domain/entities/app_settings.dart';

class MockGetSettingsUseCase extends Mock implements GetSettingsUseCase {}
class MockUpdateSettingUseCase extends Mock implements UpdateSettingUseCase {}

void main() {
  late MockGetSettingsUseCase mockGetSettings;
  late MockUpdateSettingUseCase mockUpdateSetting;
  late SettingsBloc settingsBloc;

  setUpAll(() {
    registerFallbackValue(NoParams());
    registerFallbackValue(UpdateSettingParams(key: '', value: ''));
  });

  final testSettings = AppSettings(
    themeMode: 'dark',
    language: 'en',
    notificationsEnabled: true,
  );

  setUp(() {
    mockGetSettings = MockGetSettingsUseCase();
    mockUpdateSetting = MockUpdateSettingUseCase();
    settingsBloc = SettingsBloc(
      getSettingsUseCase: mockGetSettings,
      updateSettingUseCase: mockUpdateSetting,
    );
  });

  tearDown(() {
    settingsBloc.close();
  });

  group('SettingsBloc', () {
    blocTest<SettingsBloc, SettingsState>(
      'emits Loaded when settings load',
      build: () {
        when(() => mockGetSettings(any()))
            .thenAnswer((_) async => Right(testSettings));
        return settingsBloc;
      },
      act: (bloc) => bloc.add(const LoadSettings()),
      expect: () => [
        SettingsLoaded(testSettings),
      ],
    );

    blocTest<SettingsBloc, SettingsState>(
      'updates setting value',
      build: () {
        when(() => mockUpdateSetting(any()))
            .thenAnswer((_) async => const Right(true));
        return settingsBloc;
      },
      seed: () => SettingsLoaded(testSettings),
      act: (bloc) => bloc.add(const UpdateSetting(key: 'themeMode', value: 'light')),
      expect: () => [
        isA<SettingsLoaded>().having(
          (s) => s.settings.themeMode,
          'themeMode',
          'light',
        ),
      ],
    );
  });
}
