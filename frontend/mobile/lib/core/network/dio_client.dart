import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../errors/failure.dart';
import '../config/app_config.dart';

class DioClient {
  late final Dio _dio;
  final DioClientAuth _authInterceptor;
  final DioClientError _errorInterceptor;

  String? Function()? getAccessToken;
  Future<String?> Function()? onTokenRefresh;
  void Function()? onUnauthorized;

  DioClient({
    this.getAccessToken,
    this.onTokenRefresh,
    this.onUnauthorized,
    Duration connectTimeout = const Duration(seconds: 15),
    Duration receiveTimeout = const Duration(seconds: 15),
  }) : _authInterceptor = DioClientAuth(),
       _errorInterceptor = DioClientError() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.baseUrl,
        connectTimeout: connectTimeout,
        receiveTimeout: receiveTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      _authInterceptor,
      _errorInterceptor,
      if (kDebugMode)
        LogInterceptor(
          request: true,
          responseBody: true,
          error: true,
          requestHeader: false,
          responseHeader: false,
          logPrint: (obj) {
            final message = obj.toString();
            if (message.contains('Authorization') ||
                message.contains('Bearer ')) {
              return;
            }
            debugPrint('[DIO] $obj');
          },
        ),
    ]);
  }

  Future<Response<dynamic>> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    return _executeWithAuth(
      () => _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _buildOptions(requiresAuth),
      ),
      requiresAuth,
    );
  }

  Future<Response<dynamic>> post(
    String endpoint, {
    dynamic data,
    bool requiresAuth = false,
    Map<String, dynamic>? queryParameters,
  }) async {
    return _executeWithAuth(
      () => _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _buildOptions(requiresAuth),
      ),
      requiresAuth,
    );
  }

  Future<Response<dynamic>> put(
    String endpoint, {
    dynamic data,
    bool requiresAuth = true,
  }) async {
    return _executeWithAuth(
      () =>
          _dio.put(endpoint, data: data, options: _buildOptions(requiresAuth)),
      requiresAuth,
    );
  }

  Future<Response<dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    return _executeWithAuth(
      () => _dio.delete(endpoint, options: _buildOptions(requiresAuth)),
      requiresAuth,
    );
  }

  Future<Response<dynamic>> postMultipart(
    String endpoint, {
    required List<Map<String, dynamic>> files,
    bool requiresAuth = true,
  }) async {
    return _executeWithAuth(() async {
      final formData = FormData();
      for (final file in files) {
        formData.files.add(
          MapEntry(
            file['field'] as String,
            await MultipartFile.fromFile(
              file['path'] as String,
              filename: file['filename'] as String?,
            ),
          ),
        );
      }
      return _dio.post(
        endpoint,
        data: formData,
        options: _buildOptions(requiresAuth),
      );
    }, requiresAuth);
  }

  Options _buildOptions(bool requiresAuth) {
    final headers = <String, String>{};
    if (requiresAuth && getAccessToken != null) {
      final token = getAccessToken!();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }
    return Options(headers: headers);
  }

  Future<Response<dynamic>> _executeWithAuth(
    Future<Response<dynamic>> Function() request,
    bool requiresAuth,
  ) async {
    try {
      if (requiresAuth && getAccessToken != null) {
        final token = getAccessToken!();
        if (token == null && onTokenRefresh != null) {
          final newToken = await onTokenRefresh!();
          if (newToken == null) {
            onUnauthorized?.call();
            throw const UnauthorizedFailure('Session expired');
          }
        }
      }
      return await request();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && requiresAuth) {
        if (onTokenRefresh != null) {
          try {
            final newToken = await onTokenRefresh!();
            if (newToken != null) {
              return await request();
            }
          } catch (_) {}
        }
        onUnauthorized?.call();
        throw const UnauthorizedFailure(
          'Session expired. Please log in again.',
        );
      }
      throw _convertDioException(e);
    }
  }

  Failure _convertDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutFailure('Request timed out');
      case DioExceptionType.connectionError:
        return const NetworkFailure('Unable to connect');
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        if (statusCode == 429) {
          return const RateLimitFailure('Too many requests');
        }
        return ServerFailure(_parseDioError(e), statusCode);
      case DioExceptionType.cancel:
        return const CancelledFailure();
      case DioExceptionType.badCertificate:
        return const NetworkFailure('Connection not secure');
      default:
        return const UnknownFailure('Request failed');
    }
  }

  String _parseDioError(DioException e) {
    try {
      final data = e.response?.data;
      if (data is Map) {
        return (data['message'] as String?) ??
            (data['error'] as String?) ??
            'Server error ${e.response?.statusCode}';
      }
      return 'Server error ${e.response?.statusCode}';
    } catch (_) {
      return 'Server error ${e.response?.statusCode}';
    }
  }

  void updateBaseUrl(String url) {
    _dio.options.baseUrl = url;
  }

  Future<Response<ResponseBody>> postStream(
    String endpoint, {
    dynamic data,
    bool requiresAuth = false,
  }) async {
    return _executeStreamWithAuth(
      () => _dio.post(
        endpoint,
        data: data,
        options: Options(
          responseType: ResponseType.stream,
          headers: _buildOptions(requiresAuth).headers,
        ),
      ),
      requiresAuth,
    );
  }

  Future<Response<ResponseBody>> getStream(
    String endpoint, {
    bool requiresAuth = false,
  }) async {
    return _executeStreamWithAuth(
      () => _dio.get(
        endpoint,
        options: Options(
          responseType: ResponseType.stream,
          headers: _buildOptions(requiresAuth).headers,
        ),
      ),
      requiresAuth,
    );
  }

  Future<Response<ResponseBody>> _executeStreamWithAuth(
    Future<Response<ResponseBody>> Function() request,
    bool requiresAuth,
  ) async {
    try {
      if (requiresAuth && getAccessToken != null) {
        final token = getAccessToken!();
        if (token == null && onTokenRefresh != null) {
          final newToken = await onTokenRefresh!();
          if (newToken == null) {
            onUnauthorized?.call();
            throw const UnauthorizedFailure('Session expired');
          }
        }
      }
      return await request();
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && requiresAuth) {
        if (onTokenRefresh != null) {
          try {
            final newToken = await onTokenRefresh!();
            if (newToken != null) {
              return await request();
            }
          } catch (_) {}
        }
        onUnauthorized?.call();
        throw const UnauthorizedFailure(
          'Session expired. Please log in again.',
        );
      }
      throw _convertDioException(e);
    }
  }

  void dispose() {
    _dio.close();
  }
}

class DioClientAuth extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}

class DioClientError extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.next(err);
  }
}
