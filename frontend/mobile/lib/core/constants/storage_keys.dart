abstract class StorageKeys {
  StorageKeys._();

  // Auth
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // Session
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';
  static const String seenOnboarding = 'seen_onboarding';

  // Settings
  static const String themeMode = 'theme_mode';
  static const String language = 'language';
  static const String streamingEnabled = 'streaming_enabled';
  static const String animationsEnabled = 'animations_enabled';

  // Chat
  static const String activePersonality = 'active_personality';
  static const String conversationCache = 'conversation_cache';
  static const String memoryCache = 'memory_cache';

  // Device
  static const String deviceId = 'device_id';
  static const String pushToken = 'push_token';

  // Notifications
  static const String notificationsEnabled = 'notifications_enabled';
  static const String lastNotificationCheck = 'last_notification_check';

  // Cache
  static const String profileCache = 'profile_cache';
  static const String personalitiesCache = 'personalities_cache';
  static const String settingsCache = 'settings_cache';
  static const String dashboardCache = 'dashboard_cache';
  static const String documentsCache = 'documents_cache';
  static const String notificationsCache = 'notifications_cache';
}
