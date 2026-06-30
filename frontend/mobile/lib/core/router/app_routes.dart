abstract class AppRoutes {
  // ───────────────────────────────────────────────────────────────────────────
  static const String onboarding = '/onboarding';
  static const String splash = '/';
  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String login = '/login';
  static const String register = '/register';

  // ── Home shell ─────────────────────────────────────────────────────────────
  static const String home = '/home';
  static const String events = '/home/events';
  static const String gallery = '/home/gallery';
  static const String account = '/home/account';

  // ── Face enrollment ────────────────────────────────────────────────────────
  static const String faceEnrollment = '/face-enrollment';
  static const String photoApproval = '/photo-approval';
  static const String notifications = '/home/notifications';
}
