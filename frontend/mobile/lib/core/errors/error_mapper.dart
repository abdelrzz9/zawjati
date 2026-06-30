import 'app_exception.dart';

class ErrorMapper {
  const ErrorMapper();

  String getUserFriendlyMessage(AppException exception) {
    return _productionMessage(exception);
  }

  String getLogMessage(AppException exception) {
    return exception.debugInfo;
  }

  String _productionMessage(AppException exception) {
    return switch (exception) {
      NetworkException _ =>
        'Unable to connect. Check your internet connection.',
      TimeoutException _ =>
        'The request is taking longer than expected. Please try again.',
      RateLimitException _ =>
        'Too many requests. Please wait a moment and try again.',
      AuthenticationException _ =>
        'Authentication failed. Please sign in again.',
      AIProviderUnavailableException _ =>
        'The AI service is temporarily unavailable.',
      NotFoundException _ => 'The requested resource was not found.',
      ValidationException _ =>
        exception.message.isNotEmpty
            ? exception.message
            : 'Invalid input. Please check your data.',
      ServerException _ =>
        exception.message.isNotEmpty
            ? exception.message
            : 'A server error occurred. Please try again later.',
      CacheException _ => 'Something went wrong. Please try again.',
      UnknownException _ => 'Something went wrong. Please try again later.',
      _ => 'Something went wrong. Please try again later.',
    };
  }
}
