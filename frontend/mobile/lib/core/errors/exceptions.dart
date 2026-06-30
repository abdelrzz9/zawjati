import 'app_exception.dart' as app;

// Retained for backward compatibility - delegates to AppException
class ServerException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  const ServerException({
    this.message = 'Server Error',
    this.statusCode,
    this.error,
  });

  app.AppException toAppException({String? requestId, String? provider}) {
    final status = statusCode;
    if (status == 401) {
      return app.AuthenticationException(
        message: message,
        statusCode: statusCode,
        requestId: requestId,
        provider: provider,
      );
    }
    if (status == 429) {
      return app.RateLimitException(
        message: message,
        statusCode: statusCode,
        requestId: requestId,
        provider: provider,
      );
    }
    if (status != null && status >= 500) {
      return app.ServerException(
        message: message,
        statusCode: statusCode,
        requestId: requestId,
        provider: provider,
      );
    }
    return app.UnknownException(
      message: message,
      statusCode: statusCode,
      requestId: requestId,
      provider: provider,
    );
  }

  @override
  String toString() {
    return 'ServerException(message: $message, statusCode: $statusCode, error: $error)';
  }
}

class CacheException implements Exception {
  final String message;

  const CacheException({this.message = 'Cache Error'});

  app.AppException toAppException({String? requestId, String? provider}) {
    return app.CacheException(message: message);
  }

  @override
  String toString() => 'CacheException(message: $message)';
}
