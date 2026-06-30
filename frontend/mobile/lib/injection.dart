import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:dio/dio.dart';

import 'core/network/dio_client.dart';
import 'core/network/network_info.dart';
import 'core/storage/app_local_storage.dart';
import 'core/errors/logger.dart';
import 'core/errors/error_handler.dart';
import 'core/errors/error_mapper.dart';
import 'core/errors/failure_handler.dart';

import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/login_usecase.dart';
import 'features/auth/domain/usecases/register_usecase.dart';
import 'features/auth/domain/usecases/logout_usecase.dart';
import 'features/auth/domain/usecases/check_auth_usecase.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/chat/data/datasources/chat_remote_datasource.dart';
import 'features/chat/data/repositories/chat_repository_impl.dart';
import 'features/chat/domain/repositories/chat_repository.dart';
import 'features/chat/domain/usecases/send_message_usecase.dart';
import 'features/chat/domain/usecases/stream_message_usecase.dart';
import 'features/chat/domain/usecases/get_conversations_usecase.dart';
import 'features/chat/presentation/bloc/chat_bloc.dart';

import 'features/memory/data/datasources/memory_remote_datasource.dart';
import 'features/memory/data/repositories/memory_repository_impl.dart';
import 'features/memory/domain/repositories/memory_repository.dart';
import 'features/memory/domain/usecases/get_memories_usecase.dart';
import 'features/memory/domain/usecases/delete_memory_usecase.dart';
import 'features/memory/domain/usecases/search_memories_usecase.dart';
import 'features/memory/presentation/bloc/memory_bloc.dart';

import 'features/profile/data/datasources/profile_remote_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';
import 'features/profile/domain/usecases/update_profile_usecase.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

import 'features/personalities/data/datasources/personalities_remote_datasource.dart';
import 'features/personalities/data/repositories/personalities_repository_impl.dart';
import 'features/personalities/domain/repositories/personalities_repository.dart';
import 'features/personalities/domain/usecases/get_personalities_usecase.dart';
import 'features/personalities/presentation/bloc/personalities_bloc.dart';

import 'features/settings/data/datasources/settings_local_datasource.dart';
import 'features/settings/data/repositories/settings_repository_impl.dart';
import 'features/settings/domain/repositories/settings_repository.dart';
import 'features/settings/domain/usecases/get_settings_usecase.dart';
import 'features/settings/domain/usecases/update_setting_usecase.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';

import 'features/notifications/data/datasources/notifications_remote_datasource.dart';
import 'features/notifications/data/repositories/notifications_repository_impl.dart';
import 'features/notifications/domain/repositories/notifications_repository.dart';
import 'features/notifications/domain/usecases/get_notifications_usecase.dart';
import 'features/notifications/domain/usecases/mark_read_usecase.dart';
import 'features/notifications/presentation/bloc/notifications_bloc.dart';

import 'features/documents/data/datasources/documents_remote_datasource.dart';
import 'features/documents/data/repositories/documents_repository_impl.dart';
import 'features/documents/domain/repositories/documents_repository.dart';
import 'features/documents/domain/usecases/get_documents_usecase.dart';
import 'features/documents/domain/usecases/upload_document_usecase.dart';
import 'features/documents/presentation/bloc/documents_bloc.dart';

import 'features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'features/dashboard/domain/repositories/dashboard_repository.dart';
import 'features/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'features/dashboard/presentation/bloc/dashboard_bloc.dart';

import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'features/voice/presentation/bloc/voice_bloc.dart';
import 'features/search/presentation/bloc/search_bloc.dart';
import 'features/developer/presentation/bloc/developer_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  final prefs = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => prefs);
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  sl.registerLazySingleton<InternetConnection>(
    () => InternetConnection.createInstance(),
  );

  // Storage
  sl.registerLazySingleton<LocalStorage>(
    () => AppLocalStorage(
      prefs: sl(),
      secureStorage: sl(),
    ),
  );

  // Network info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(
      connectivity: sl(),
      connectionChecker: sl(),
    ),
  );

  // Dio client
  sl.registerLazySingleton<Dio>(() => Dio());
  sl.registerLazySingleton<DioClient>(
    () => DioClient(
      getAccessToken: () => sl<LocalStorage>().getString('access_token'),
      onTokenRefresh: () async {
        final refreshToken = await sl<LocalStorage>().getSecureString('refresh_token');
        if (refreshToken == null) return null;
        try {
          final response = await Dio().post(
            'http://localhost:8000/api/auth/refresh',
            data: {'refresh_token': refreshToken},
          );
          final newToken = response.data['access_token'] as String?;
          if (newToken != null) {
            await sl<LocalStorage>().setString('access_token', newToken);
          }
          return newToken;
        } catch (_) {
          return null;
        }
      },
    ),
  );

  // Logging & errors
  sl.registerLazySingleton<Logger>(() => Logger.create());
  sl.registerLazySingleton<ErrorMapper>(() => const ErrorMapper());
  sl.registerLazySingleton<ErrorHandler>(
    () => ErrorHandler(errorMapper: sl(), logger: sl()),
  );
  _initFailureHandler();

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSource(dioClient: sl()),
  );
  sl.registerLazySingleton<MemoryRemoteDataSource>(
    () => MemoryRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<PersonalitiesRemoteDataSource>(
    () => PersonalitiesRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<SettingsLocalDataSource>(
    () => SettingsLocalDataSource(storage: sl()),
  );
  sl.registerLazySingleton<NotificationsRemoteDataSource>(
    () => NotificationsRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<DocumentsRemoteDataSource>(
    () => DocumentsRemoteDataSource(client: sl()),
  );
  sl.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSource(client: sl()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localStorage: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<MemoryRepository>(
    () => MemoryRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<PersonalitiesRepository>(
    () => PersonalitiesRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<SettingsRepository>(
    () => SettingsRepositoryImpl(
      localDataSource: sl(),
    ),
  );
  sl.registerLazySingleton<NotificationsRepository>(
    () => NotificationsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<DocumentsRepository>(
    () => DocumentsRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => CheckAuthUseCase(sl()));
  sl.registerLazySingleton(() => SendMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => StreamMessageUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetConversationsUseCase(repository: sl()));
  sl.registerLazySingleton(() => GetMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => DeleteMemoryUseCase(sl()));
  sl.registerLazySingleton(() => SearchMemoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetProfileUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUseCase(sl()));
  sl.registerLazySingleton(() => GetPersonalitiesUseCase(sl()));
  sl.registerLazySingleton(() => GetSettingsUseCase(sl()));
  sl.registerLazySingleton(() => UpdateSettingUseCase(sl()));
  sl.registerLazySingleton(() => GetNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkReadUseCase(sl()));
  sl.registerLazySingleton(() => GetDocumentsUseCase(sl()));
  sl.registerLazySingleton(() => UploadDocumentUseCase(sl()));
  sl.registerLazySingleton(() => GetDashboardUseCase(sl()));

  // BLoCs
  sl.registerFactory(() => AuthBloc(
    loginUseCase: sl(),
    registerUseCase: sl(),
    logoutUseCase: sl(),
    checkAuthUseCase: sl(),
  ));
  sl.registerFactory(() => ChatBloc(
    sendMessageUseCase: sl(),
    streamMessageUseCase: sl(),
    getConversationsUseCase: sl(),
  ));
  sl.registerFactory(() => MemoryBloc(
    getMemoriesUseCase: sl(),
    deleteMemoryUseCase: sl(),
    searchMemoriesUseCase: sl(),
  ));
  sl.registerFactory(() => ProfileBloc(
    getProfileUseCase: sl(),
    updateProfileUseCase: sl(),
  ));
  sl.registerFactory(() => PersonalitiesBloc(
    getPersonalitiesUseCase: sl(),
  ));
  sl.registerFactory(() => SettingsBloc(
    getSettingsUseCase: sl(),
    updateSettingUseCase: sl(),
  ));
  sl.registerFactory(() => NotificationsBloc(
    getNotificationsUseCase: sl(),
    markReadUseCase: sl(),
  ));
  sl.registerFactory(() => DocumentsBloc(
    getDocumentsUseCase: sl(),
    uploadDocumentUseCase: sl(),
  ));
  sl.registerFactory(() => DashboardBloc(
    getDashboardUseCase: sl(),
  ));
  sl.registerFactory(() => OnboardingBloc());
  sl.registerFactory(() => VoiceBloc());
  sl.registerFactory(() => SearchBloc());
  sl.registerFactory(() => DeveloperBloc());
}

void _initFailureHandler() {
  final handler = FailureHandler(
    errorHandler: sl(),
    errorMapper: sl(),
    logger: sl(),
  );
  FailureHandler.initialize(handler);
}
