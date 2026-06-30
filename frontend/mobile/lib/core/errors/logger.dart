import 'package:flutter/foundation.dart';
import 'app_exception.dart';

abstract class Logger {
  void debug(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);
  void info(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);
  void warning(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);
  void error(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]);

  void logException(String tag, AppException exception);

  factory Logger.create() => _ConsoleLogger();

  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  onDebug;
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  onInfo;
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  onWarning;
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  onError;

  // Integration points for external services
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  firebaseCrashlytics;
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  sentry;
  static void Function(
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  )?
  customAnalytics;
}

class _ConsoleLogger implements Logger {
  static const _sensitivePatterns = [
    r'access_token',
    r'refresh_token',
    r'password',
    r'secret',
    r'api_key',
    r'authorization',
    r'bearer\s+\S+',
    r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b',
  ];

  String _sanitize(String message) {
    var sanitized = message;
    for (final pattern in _sensitivePatterns) {
      try {
        sanitized = sanitized.replaceAllMapped(
          RegExp(pattern, caseSensitive: false),
          (match) => _obfuscateMatch(match.group(0) ?? ''),
        );
      } catch (_) {}
    }
    return sanitized;
  }

  static String _obfuscateMatch(String value) {
    if (value.length <= 4) return '****';
    return '${value.substring(0, 2)}****${value.substring(value.length - 2)}';
  }

  @override
  void debug(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (!kDebugMode) return;
    final sanitized = _sanitize(message);
    debugPrint('[Logger][$tag][DEBUG] $sanitized');
    if (error != null) {
      debugPrint('[Logger][$tag][DEBUG_DETAIL] $error');
    }
    _invokeCallbacks(Logger.onDebug, tag, message, error, stackTrace);
  }

  @override
  void info(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final sanitized = _sanitize(message);
    debugPrint('[Logger][$tag][INFO] $sanitized');
    _invokeCallbacks(Logger.onInfo, tag, message, error, stackTrace);
  }

  @override
  void warning(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final sanitized = _sanitize(message);
    debugPrint('[Logger][$tag][WARNING] $sanitized');
    _invokeCallbacks(Logger.onWarning, tag, message, error, stackTrace);
  }

  @override
  void error(
    String tag,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    final sanitized = _sanitize(message);
    debugPrint('[Logger][$tag][ERROR] $sanitized');
    if (error != null && kDebugMode) {
      debugPrint('[Logger][$tag][ERROR_DETAIL] ${error.runtimeType}: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('[Logger][$tag][ERROR_STACKTRACE] $stackTrace');
    }
    _invokeCallbacks(Logger.onError, tag, message, error, stackTrace);
  }

  @override
  void logException(String tag, AppException exception) {
    if (kDebugMode) {
      error(tag, exception.debugInfo, exception, exception.stackTrace);
    } else {
      error(tag, '${exception.runtimeType}: ${exception.message}', exception);
    }
  }

  void _invokeCallbacks(
    void Function(
      String tag,
      String message,
      Object? error,
      StackTrace? stackTrace,
    )?
    callback,
    String tag,
    String message,
    Object? error,
    StackTrace? stackTrace,
  ) {
    callback?.call(tag, message, error, stackTrace);
    Logger.firebaseCrashlytics?.call(tag, message, error, stackTrace);
    Logger.sentry?.call(tag, message, error, stackTrace);
    Logger.customAnalytics?.call(tag, message, error, stackTrace);
  }
}
