import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String get baseUrl => dotenv.env['BASE_URL']?.trim() ?? 'http://localhost:8000';

  static const String apiPrefix = '/api';

  // Auth
  static const String register = '$apiPrefix/auth/register';
  static const String login = '$apiPrefix/auth/login';
  static const String refresh = '$apiPrefix/auth/refresh';
  static const String logout = '$apiPrefix/auth/logout';
  static const String me = '$apiPrefix/auth/me';
  static const String deleteAccount = '$apiPrefix/auth/delete';

  // OAuth
  static const String googleLogin = '$apiPrefix/auth/google';
  static const String appleLogin = '$apiPrefix/auth/apple';
  static const String githubLogin = '$apiPrefix/auth/github';

  // Chat
  static const String chat = '$apiPrefix/chat';
  static const String chatStream = '$apiPrefix/chat/stream';
  static const String chatWs = '$apiPrefix/chat/ws';

  // Profile
  static const String profile = '$apiPrefix/profile';
  static String profileById(String userId) => '$apiPrefix/profile/$userId';

  // Personalities
  static const String personalities = '$apiPrefix/personalities';

  // Memory
  static const String memories = '$apiPrefix/memories';
  static String memoryById(String id) => '$apiPrefix/memories/$id';
  static const String memoriesSearch = '$apiPrefix/memories/search';

  // Documents (RAG)
  static const String documents = '$apiPrefix/documents';
  static String documentById(String id) => '$apiPrefix/documents/$id';
  static const String documentsUpload = '$apiPrefix/documents/upload';

  // Notifications
  static const String notifications = '$apiPrefix/notifications';
  static const String notificationsRead = '$apiPrefix/notifications/read';

  // Settings
  static const String settings = '$apiPrefix/settings';
  static const String settingsTheme = '$apiPrefix/settings/theme';

  // Dashboard / Metrics
  static const String metrics = '$apiPrefix/metrics';
  static const String metricsSummary = '$apiPrefix/metrics/summary';

  // Health
  static const String health = '/health';
  static const String ready = '/ready';
}
