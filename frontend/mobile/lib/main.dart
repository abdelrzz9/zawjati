import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection.dart' as di;
import 'core/theme/app_theme_data.dart';
import 'core/router/app_router.dart';
import 'core/constants/storage_keys.dart';
import 'core/security/env_validator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/settings/presentation/bloc/settings_bloc.dart';
import 'core/network/dio_client.dart';
import 'core/storage/app_local_storage.dart';
import 'core/errors/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {}

  EnvValidator.validateProduction();

  await Hive.initFlutter();

  try {
    await Firebase.initializeApp();
  } catch (_) {}

  await di.initDependencies();

  final localStorage = di.sl<LocalStorage>();

  final themeMode = _loadThemeMode(localStorage);
  final locale = _loadLocale(localStorage);

  runApp(ZawjatiApp(
    themeMode: themeMode,
    locale: locale,
  ));
}

ThemeMode _loadThemeMode(LocalStorage storage) {
  final saved = storage.getString(StorageKeys.themeMode);
  switch (saved) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'amoled':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}

Locale _loadLocale(LocalStorage storage) {
  final saved = storage.getString(StorageKeys.language);
  return saved != null ? Locale(saved) : const Locale('en');
}

class ZawjatiApp extends StatefulWidget {
  final ThemeMode themeMode;
  final Locale locale;

  const ZawjatiApp({
    super.key,
    required this.themeMode,
    required this.locale,
  });

  @override
  State<ZawjatiApp> createState() => _ZawjatiAppState();

  static _ZawjatiAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_ZawjatiAppState>()!;
}

class _ZawjatiAppState extends State<ZawjatiApp> {
  late ThemeMode _themeMode;
  late Locale _locale;
  late AuthBloc _authBloc;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.themeMode;
    _locale = widget.locale;
    _authBloc = di.sl<AuthBloc>();
    _router = appRouter(_authBloc);
    _authBloc.add(const AuthCheckRequested());
  }

  @override
  void dispose() {
    _authBloc.close();
    super.dispose();
  }

  void setThemeMode(ThemeMode mode) {
    setState(() => _themeMode = mode);
    di.sl<LocalStorage>().setString(
      StorageKeys.themeMode,
      mode.name,
    );
  }

  void setLocale(Locale locale) {
    setState(() => _locale = locale);
    di.sl<LocalStorage>().setString(
      StorageKeys.language,
      locale.languageCode,
    );
  }

  ThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _authBloc),
        BlocProvider(create: (_) => di.sl<SettingsBloc>()),
      ],
      child: MaterialApp.router(
        title: 'Zawjati',
        debugShowCheckedModeBanner: false,
        theme: AppThemeData.lightTheme,
        darkTheme: AppThemeData.darkTheme,
        themeMode: _themeMode,
        locale: _locale,
        supportedLocales: const [
          Locale('en'),
          Locale('ar'),
          Locale('fr'),
        ],
        routerConfig: _router,
        builder: (context, child) {
          return MediaQuery.withClampedTextScaling(
            maxScaleFactor: 1.3,
            child: child!,
          );
        },
      ),
    );
  }
}
