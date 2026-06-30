import 'package:zawjati_mobile/core/storage/app_local_storage.dart';
import 'package:zawjati_mobile/core/constants/storage_keys.dart';
import '../../domain/entities/app_settings.dart';

class SettingsLocalDataSource {
  final LocalStorage storage;

  SettingsLocalDataSource({required this.storage});

  AppSettings getSettings() {
    return AppSettings(
      themeMode: _getString(StorageKeys.themeMode, 'system'),
      language: _getString(StorageKeys.language, 'en'),
      streamingEnabled: _getBool(StorageKeys.streamingEnabled, true),
      animationsEnabled: _getBool(StorageKeys.animationsEnabled, true),
      notificationsEnabled: _getBool(StorageKeys.notificationsEnabled, true),
      pushNotificationsEnabled: _getBool('push_notifications_enabled', true),
      soundEnabled: _getBool('sound_enabled', true),
      reducedMotion: _getBool('reduced_motion', false),
      highContrast: _getBool('high_contrast', false),
      largeText: _getBool('large_text', false),
      userBiometricEnabled: _getBool('user_biometric_enabled', false),
      developerMode: _getBool('developer_mode', false),
      debugLogging: _getBool('debug_logging', false),
      cacheSize: storage.getInt('cache_size') ?? 0,
    );
  }

  Future<void> updateSetting(String key, dynamic value) async {
    if (value is String) {
      await storage.setString(key, value);
    } else if (value is bool) {
      await storage.setBool(key, value);
    } else if (value is int) {
      await storage.setInt(key, value);
    }
  }

  Future<void> clearCache() async {
    final keys = [
      StorageKeys.conversationCache,
      StorageKeys.memoryCache,
      StorageKeys.profileCache,
      StorageKeys.personalitiesCache,
      StorageKeys.settingsCache,
      StorageKeys.dashboardCache,
      StorageKeys.documentsCache,
      StorageKeys.notificationsCache,
    ];
    for (final key in keys) {
      await storage.remove(key);
    }
    await storage.setInt('cache_size', 0);
  }

  Future<int> getStorageUsage() async {
    return storage.getInt('cache_size') ?? 0;
  }

  String _getString(String key, String defaultValue) {
    return storage.getString(key) ?? defaultValue;
  }

  bool _getBool(String key, bool defaultValue) {
    return storage.getBool(key) ?? defaultValue;
  }
}
