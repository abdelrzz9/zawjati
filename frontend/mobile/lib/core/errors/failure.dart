import 'package:equatable/equatable.dart';
import 'app_exception.dart';

abstract class Failure extends Equatable {
  const Failure(this.message);

  final String message;

  String get userFriendlyMessage => message;

  AppException get appException;

  @override
  List<Object?> get props => [message];
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'Unable to connect']);

  @override
  AppException get appException => const NetworkException();
}

class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'Request timed out']);

  @override
  AppException get appException => const TimeoutException();
}

class RateLimitFailure extends Failure {
  const RateLimitFailure([super.message = 'Too many requests']);

  @override
  AppException get appException => const RateLimitException();
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'Session expired']);

  @override
  AppException get appException => const AuthenticationException();
}

class ServerFailure extends Failure {
  final int? statusCode;
  final String? requestId;

  const ServerFailure([
    super.message = 'Server error',
    this.statusCode,
    this.requestId,
  ]);

  @override
  AppException get appException =>
      ServerException(message: message, statusCode: statusCode);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache error']);

  @override
  AppException get appException => const CacheException();
}

class CancelledFailure extends Failure {
  const CancelledFailure([super.message = '']);

  @override
  AppException get appException => const UnknownException();
}

class ValidationFailure extends Failure {
  const ValidationFailure([super.message = 'Validation error']);

  @override
  AppException get appException => const ValidationException();
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found']);

  @override
  AppException get appException => const NotFoundException();
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Unknown error']);

  @override
  AppException get appException => const UnknownException();
}

// Face Enrollment specific failures
class FileNotFoundFailure extends Failure {
  const FileNotFoundFailure([super.message = 'File not found']);

  @override
  AppException get appException => const NotFoundException();
}

class FileTooLargeFailure extends Failure {
  const FileTooLargeFailure([super.message = 'File too large']);

  @override
  AppException get appException => const ValidationException();
}

class InvalidFileFormatFailure extends Failure {
  const InvalidFileFormatFailure([super.message = 'Invalid file format']);

  @override
  AppException get appException => const ValidationException();
}
