import 'package:flutter/material.dart';

import 'app_exception.dart';
import 'error_mapper.dart';
import 'logger.dart';

class ErrorHandler {
  final ErrorMapper _errorMapper;
  final Logger _logger;

  ErrorHandler({ErrorMapper? errorMapper, Logger? logger})
    : _errorMapper = errorMapper ?? const ErrorMapper(),
      _logger = logger ?? Logger.create();

  void handleException(
    String tag,
    AppException exception, {
    bool Function()? onUnauthorized,
  }) {
    _logger.logException(tag, exception);

    if (exception is AuthenticationException) {
      onUnauthorized?.call();
    }
  }

  String getUserMessage(AppException exception) {
    return _errorMapper.getUserFriendlyMessage(exception);
  }

  void showError(
    BuildContext context,
    String tag,
    AppException exception, {
    bool Function()? onUnauthorized,
  }) {
    handleException(tag, exception, onUnauthorized: onUnauthorized);
    final message = getUserMessage(exception);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void showSuccess(BuildContext context, String message) {
    _logger.info('UI', 'Success: $message');
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  AppException wrapException(
    Object error, {
    StackTrace? stackTrace,
    int? statusCode,
    String? requestId,
    String? provider,
  }) {
    if (error is AppException) return error;

    if (error is TimeoutException) {
      return TimeoutException(
        stackTrace: stackTrace,
        requestId: requestId,
        provider: provider,
      );
    }

    return UnknownException(
      message: error.toString(),
      stackTrace: stackTrace,
      requestId: requestId,
      provider: provider,
    );
  }
}
