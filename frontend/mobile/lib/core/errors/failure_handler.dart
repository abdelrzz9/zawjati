import 'failure.dart';
import 'error_handler.dart';
import 'error_mapper.dart';
import 'logger.dart';

class FailureHandler {
  final ErrorHandler errorHandler;
  final ErrorMapper errorMapper;
  final Logger logger;

  FailureHandler({
    ErrorHandler? errorHandler,
    ErrorMapper? errorMapper,
    Logger? logger,
  }) : errorHandler = errorHandler ?? ErrorHandler(),
       errorMapper = errorMapper ?? const ErrorMapper(),
       logger = logger ?? Logger.create();

  static FailureHandler? _instance;

  static FailureHandler get instance {
    _instance ??= FailureHandler();
    return _instance!;
  }

  static void initialize(FailureHandler handler) {
    _instance = handler;
  }

  String getUserFriendlyMessage(Failure failure) {
    return errorMapper.getUserFriendlyMessage(failure.appException);
  }

  void logFailure(Failure failure, String source) {
    logger.logException(source, failure.appException);
  }

  void handleFailure(
    String source,
    Failure failure, {
    bool Function()? onUnauthorized,
  }) {
    errorHandler.handleException(
      source,
      failure.appException,
      onUnauthorized: onUnauthorized,
    );
  }
}
