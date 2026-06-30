import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../injection.dart' as di;
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/auth/presentation/bloc/auth_state.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/chat/presentation/bloc/chat_bloc.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/memory/presentation/pages/memory_page.dart';
import '../../features/memory/presentation/pages/memory_detail_page.dart';
import '../../features/personalities/presentation/pages/personalities_page.dart';
import '../../features/personalities/presentation/pages/personality_detail_page.dart';
import '../../features/personalities/presentation/pages/personality_create_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/profile_edit_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/settings_theme_page.dart';
import '../../features/settings/presentation/pages/settings_language_page.dart';
import '../../features/settings/presentation/pages/settings_notifications_page.dart';
import '../../features/settings/presentation/pages/settings_voice_page.dart';
import '../../features/settings/presentation/pages/settings_storage_page.dart';
import '../../features/settings/presentation/pages/settings_privacy_page.dart';
import '../../features/settings/presentation/pages/settings_developer_page.dart';
import '../../features/settings/presentation/pages/settings_accessibility_page.dart';
import '../../features/voice/presentation/pages/voice_page.dart';
import '../../features/documents/presentation/pages/documents_page.dart';
import '../../features/documents/presentation/pages/document_detail_page.dart';
import '../../features/dashboard/presentation/pages/dashboard_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/developer/presentation/pages/developer_page.dart';
import '../../features/developer/presentation/pages/developer_logs_page.dart';
import '../../features/developer/presentation/pages/developer_api_page.dart';
import '../../features/search/presentation/pages/search_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../widgets/home_shell.dart';
import 'app_routes.dart';

GoRouter appRouter(AuthBloc authBloc) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    refreshListenable: authBloc,
    redirect: (context, state) {
      final isAuthenticated = authBloc.state is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register') ||
          state.matchedLocation == AppRoutes.splash ||
          state.matchedLocation == AppRoutes.onboarding ||
          state.matchedLocation.startsWith('/forgot-password');
      final isLoggingInRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/register');

      if (!isAuthenticated && !isAuthRoute) {
        return AppRoutes.login;
      }
      if (isAuthenticated && isLoggingInRoute) {
        return AppRoutes.chat;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => BlocProvider.value(
          value: authBloc,
          child: const SplashPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const OnboardingPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: BlocProvider.value(
            value: authBloc,
            child: const LoginPage(),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
        ),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => BlocProvider.value(
          value: authBloc,
          child: const RegisterPage(),
        ),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => HomeShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.chat,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: ChatPage(bloc: di.sl<ChatBloc>()),
            ),
          ),
          GoRoute(
            path: AppRoutes.memories,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const MemoryPage(),
            ),
          ),
          GoRoute(
            path: AppRoutes.profile,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const ProfilePage(),
            ),
            routes: [
              GoRoute(
                path: 'edit',
                builder: (context, state) => const ProfileEditPage(),
              ),
            ],
          ),
          GoRoute(
            path: AppRoutes.settings,
            pageBuilder: (context, state) => NoTransitionPage(
              key: state.pageKey,
              child: const SettingsPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.personalities,
        builder: (context, state) => const PersonalitiesPage(),
      ),
      GoRoute(
        path: AppRoutes.personalityCreate,
        builder: (context, state) => const PersonalityCreatePage(),
      ),
      GoRoute(
        path: AppRoutes.settingsTheme,
        builder: (context, state) => const SettingsThemePage(),
      ),
      GoRoute(
        path: AppRoutes.settingsLanguage,
        builder: (context, state) => const SettingsLanguagePage(),
      ),
      GoRoute(
        path: AppRoutes.settingsNotifications,
        builder: (context, state) => const SettingsNotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.settingsVoice,
        builder: (context, state) => const SettingsVoicePage(),
      ),
      GoRoute(
        path: AppRoutes.settingsStorage,
        builder: (context, state) => const SettingsStoragePage(),
      ),
      GoRoute(
        path: AppRoutes.settingsPrivacy,
        builder: (context, state) => const SettingsPrivacyPage(),
      ),
      GoRoute(
        path: AppRoutes.settingsDeveloper,
        builder: (context, state) => const SettingsDeveloperPage(),
      ),
      GoRoute(
        path: AppRoutes.settingsAccessibility,
        builder: (context, state) => const SettingsAccessibilityPage(),
      ),
      GoRoute(
        path: AppRoutes.voice,
        builder: (context, state) => const VoicePage(),
      ),
      GoRoute(
        path: AppRoutes.documents,
        builder: (context, state) => const DocumentsPage(),
      ),
      GoRoute(
        path: AppRoutes.dashboard,
        builder: (context, state) => const DashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.developer,
        builder: (context, state) => const DeveloperPage(),
        routes: [
          GoRoute(
            path: 'logs',
            builder: (context, state) => const DeveloperLogsPage(),
          ),
          GoRoute(
            path: 'api',
            builder: (context, state) => const DeveloperApiPage(),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.search,
        builder: (context, state) => const SearchPage(),
      ),
      // Profile edit is a sub-route of /profile
    ],
  );
}
