abstract class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';

  // Auth
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String oauthCallback = '/oauth-callback';

  // Main shell
  static const String home = '/home';
  static const String chat = '/home/chat';
  static const String chatConversation = '/home/chat/:conversationId';
  static const String memories = '/home/memories';
  static const String profile = '/home/profile';
  static const String settings = '/home/settings';

  // Chat
  static const String chatSettings = '/chat-settings';
  static const String chatSearch = '/chat-search';
  static const String chatExport = '/chat-export';

  // Memory
  static const String memoryDetail = '/home/memories/:memoryId';
  static const String memorySearch = '/memory-search';
  static const String memoryTimeline = '/memory-timeline';

  // Personalities
  static const String personalities = '/personalities';
  static const String personalityDetail = '/personalities/:personalityId';
  static const String personalityCreate = '/personalities/create';

  // Profile
  static const String profileEdit = '/profile/edit';
  static const String profilePersonality = '/profile/personality';
  static const String profileVoice = '/profile/voice';

  // Settings
  static const String settingsTheme = '/settings/theme';
  static const String settingsLanguage = '/settings/language';
  static const String settingsNotifications = '/settings/notifications';
  static const String settingsVoice = '/settings/voice';
  static const String settingsStorage = '/settings/storage';
  static const String settingsPrivacy = '/settings/privacy';
  static const String settingsDeveloper = '/settings/developer';
  static const String settingsAccessibility = '/settings/accessibility';

  // Voice
  static const String voice = '/voice';

  // Documents (RAG)
  static const String documents = '/documents';
  static const String documentDetail = '/documents/:documentId';

  // Dashboard
  static const String dashboard = '/dashboard';

  // Notifications
  static const String notifications = '/notifications';

  // Developer
  static const String developer = '/developer';
  static const String developerLogs = '/developer/logs';
  static const String developerApi = '/developer/api';

  // Search
  static const String search = '/search';
}
