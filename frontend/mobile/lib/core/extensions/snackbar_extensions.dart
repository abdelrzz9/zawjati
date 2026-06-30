import 'package:flutter/material.dart';
import 'package:multai_mobile/core/errors/app_exception.dart';
import 'package:multai_mobile/core/errors/error_handler.dart';
import 'package:multai_mobile/core/theme/app_theme_metrics.dart';

extension SnackBarX on BuildContext {
  void showErrorSnackBar(String message) {
    _showError(message);
  }

  void showExceptionError(
    AppException exception, {
    String tag = 'UI',
    bool Function()? onUnauthorized,
  }) {
    final handler = ErrorHandler();
    handler.showError(this, tag, exception, onUnauthorized: onUnauthorized);
  }

  void showSuccessSnackBar(String message) {
    _showSuccess(message);
  }

  void _showError(String message) {
    final tt = Theme.of(this).textTheme;
    final cs = Theme.of(this).colorScheme;

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: tt.bodySmall?.copyWith(color: cs.onError),
          ),
          backgroundColor: cs.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          ),
          margin: const EdgeInsets.all(AppThemeMetrics.spacingMd),
        ),
      );
  }

  void _showSuccess(String message) {
    final tt = Theme.of(this).textTheme;
    final cs = Theme.of(this).colorScheme;

    ScaffoldMessenger.of(this)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
            style: tt.bodySmall?.copyWith(color: cs.onPrimary),
          ),
          backgroundColor: cs.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppThemeMetrics.radiusMd),
          ),
          margin: const EdgeInsets.all(AppThemeMetrics.spacingMd),
        ),
      );
  }
}
