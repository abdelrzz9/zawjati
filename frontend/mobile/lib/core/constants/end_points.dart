import 'package:flutter_dotenv/flutter_dotenv.dart';

class EndPoints {
  static String get baseUrl => dotenv.env['BASE_URL']?.trim() ?? '';

  // ── Auth ───────────────────────────────────────────────────────────────────
  static const String register = '/user/auth/register';
  static const String registerVerify = '/user/auth/register/verify';
  static const String resendOtp = '/user/auth/register/resend-otp';
  static const String login = '/user/auth/login';
  static const String refresh = '/user/auth/refresh';
  static const String refreshToken = '/user/auth/refresh';
  static const String logout = '/user/auth/logout';
  static const String me = '/user/auth/me';
  static const String revokeDevice = '/user/auth/revoke-device';
  static const String updateDeviceToken = '/user/auth/devices/token';
  static const String inactivateDevice = '/user/auth/devices/inactivate';

  // ── Face Enrollment ────────────────────────────────────────────────────────
  static const String faceEnrollment = '/user/enroll';

  // ── Events ─────────────────────────────────────────────────────────────────
  static const String userEvents = '/user/event/me';
  static const String joinEvent = '/user/event/join';

  // ── Notifications ──────────────────────────────────────────────────────────
  static const String notifications = '/user/notifications';
  static const String notificationsRead = '/user/notifications/read';

  // ── Photo Approval ─────────────────────────────────────────────────────────
  static const String photoApprovals = '/user/photos/approvals';
  static const String photoDecision = '/user/photos';

  // ── Gallery ────────────────────────────────────────────────────────────────
  static const String photos = '/user/photos';
}
