import 'package:equatable/equatable.dart';

class AppSettings extends Equatable {
  final String themeMode;
  final String language;
  final bool streamingEnabled;
  final bool animationsEnabled;
  final bool notificationsEnabled;
  final bool pushNotificationsEnabled;
  final bool soundEnabled;
  final bool reducedMotion;
  final bool highContrast;
  final bool largeText;
  final bool userBiometricEnabled;
  final bool developerMode;
  final bool debugLogging;
  final int cacheSize;

  const AppSettings({
    this.themeMode = 'system',
    this.language = 'en',
    this.streamingEnabled = true,
    this.animationsEnabled = true,
    this.notificationsEnabled = true,
    this.pushNotificationsEnabled = true,
    this.soundEnabled = true,
    this.reducedMotion = false,
    this.highContrast = false,
    this.largeText = false,
    this.userBiometricEnabled = false,
    this.developerMode = false,
    this.debugLogging = false,
    this.cacheSize = 0,
  });

  AppSettings copyWith({
    String? themeMode,
    String? language,
    bool? streamingEnabled,
    bool? animationsEnabled,
    bool? notificationsEnabled,
    bool? pushNotificationsEnabled,
    bool? soundEnabled,
    bool? reducedMotion,
    bool? highContrast,
    bool? largeText,
    bool? userBiometricEnabled,
    bool? developerMode,
    bool? debugLogging,
    int? cacheSize,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      language: language ?? this.language,
      streamingEnabled: streamingEnabled ?? this.streamingEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      pushNotificationsEnabled: pushNotificationsEnabled ?? this.pushNotificationsEnabled,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      reducedMotion: reducedMotion ?? this.reducedMotion,
      highContrast: highContrast ?? this.highContrast,
      largeText: largeText ?? this.largeText,
      userBiometricEnabled: userBiometricEnabled ?? this.userBiometricEnabled,
      developerMode: developerMode ?? this.developerMode,
      debugLogging: debugLogging ?? this.debugLogging,
      cacheSize: cacheSize ?? this.cacheSize,
    );
  }

  @override
  List<Object?> get props => [
    themeMode,
    language,
    streamingEnabled,
    animationsEnabled,
    notificationsEnabled,
    pushNotificationsEnabled,
    soundEnabled,
    reducedMotion,
    highContrast,
    largeText,
    userBiometricEnabled,
    developerMode,
    debugLogging,
    cacheSize,
  ];
}
