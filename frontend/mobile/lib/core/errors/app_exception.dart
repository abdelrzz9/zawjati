abstract class AppException implements Exception {
  const AppException({
    this.message = '',
    this.statusCode,
    this.stackTrace,
    this.requestId,
    this.provider,
  });

  final String message;
  final int? statusCode;
  final StackTrace? stackTrace;
  final String? requestId;
  final String? provider;

  String get debugInfo {
    final buffer = StringBuffer()
      ..writeln('Type: $runtimeType')
      ..writeln('Message: $message');
    if (statusCode != null) buffer.writeln('StatusCode: $statusCode');
    if (requestId != null) buffer.writeln('RequestId: $requestId');
    if (provider != null) buffer.writeln('Provider: $provider');
    if (stackTrace != null) {
      buffer.writeln('StackTrace: ${stackTrace.toString()}');
    }
    return buffer.toString();
  }
}

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'Unable to connect',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class TimeoutException extends AppException {
  const TimeoutException({
    super.message = 'Request timed out',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class RateLimitException extends AppException {
  const RateLimitException({
    super.message = 'Too many requests',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    super.message = 'Authentication failed',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class ServerException extends AppException {
  const ServerException({
    super.message = 'Server error',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class CacheException extends AppException {
  const CacheException({
    super.message = 'Cache error',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class ValidationException extends AppException {
  const ValidationException({
    super.message = 'Validation error',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class NotFoundException extends AppException {
  const NotFoundException({
    super.message = 'Resource not found',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class AIProviderUnavailableException extends AppException {
  const AIProviderUnavailableException({
    super.message = 'AI provider unavailable',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}

class UnknownException extends AppException {
  const UnknownException({
    super.message = 'Unknown error',
    super.statusCode,
    super.stackTrace,
    super.requestId,
    super.provider,
  });
}
