import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../errors/failure.dart';
import 'network_info.dart';
import '../constants/end_points.dart';
import '../constants/storage_keys.dart';
import '../storage/app_local_storage.dart';

class ApiClient {
  final http.Client _client;
  final NetworkInfo _networkInfo;
  final LocalStorage? _localStorage;

  String? _accessToken;
  void Function()? onUnauthorized;

  ApiClient({
    http.Client? client,
    required NetworkInfo networkInfo,
    LocalStorage? localStorage,
  }) : _client = client ?? http.Client(),
       _networkInfo = networkInfo,
       _localStorage = localStorage;

  String get baseUrl => EndPoints.baseUrl;

  void setAccessToken(String token) => _accessToken = token;
  void clearAccessToken() => _accessToken = null;

  String? get currentAccessToken => _accessToken;

  Future<Map<String, String>> _getHeaders({bool requiresAuth = false}) async {
    final headers = <String, String>{'Content-Type': 'application/json'};
    if (_accessToken != null) {
      headers['Authorization'] = 'Bearer $_accessToken';
    }

    try {
      final info = await PackageInfo.fromPlatform();
      headers['X-App-Version'] = '${info.version}+${info.buildNumber}';
    } catch (_) {}

    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        headers['X-Device-Info'] = '${androidInfo.brand}/${androidInfo.model}';
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        headers['X-Device-Info'] = '${iosInfo.name}/${iosInfo.model}';
      }
    } catch (_) {}

    return headers;
  }

  static const _requestTimeout = Duration(seconds: 30);

  Future<void> checkConnection() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkFailure();
    }
  }

  Future<dynamic> get(String endpoint) async {
    final headers = await _getHeaders();
    return _executeWithAuth(
      () => _client.get(Uri.parse('$baseUrl$endpoint'), headers: headers),
    );
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final requestBody = body != null ? jsonEncode(body) : null;
    return _executeWithAuth(
      () => _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: requestBody,
      ),
    );
  }

  Future<void> postVoid(
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    final headers = await _getHeaders(requiresAuth: requiresAuth);
    final requestBody = body != null ? jsonEncode(body) : null;
    await _executeWithAuthVoid(
      () => _client.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: requestBody,
      ),
    );
  }

  Future<void> delete(String endpoint) async {
    final headers = await _getHeaders();
    await _executeWithAuthVoid(
      () => _client.delete(Uri.parse('$baseUrl$endpoint'), headers: headers),
    );
  }

  void _handleVoidResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 204) return;
    _throwForStatus(response);
  }

  Future<void> postMultipart(
    String endpoint, {
    required List<File> files,
    required List<String> fieldNames,
    bool requiresAuth = false,
  }) async {
    await checkConnection();
    final uri = Uri.parse('$baseUrl$endpoint');
    final request = http.MultipartRequest('POST', uri);

    if (_accessToken != null) {
      request.headers['Authorization'] = 'Bearer $_accessToken';
    }

    try {
      final info = await PackageInfo.fromPlatform();
      request.headers['X-App-Version'] = '${info.version}+${info.buildNumber}';
    } catch (_) {}

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final stream = http.ByteStream(file.openRead());
      final length = await file.length();
      final ext = file.path.split('.').last.toLowerCase();

      request.files.add(
        http.MultipartFile(
          fieldNames[i],
          stream,
          length,
          filename: file.path.split('/').last,
          contentType: MediaType('image', _mimeTypeFromExtension(ext)),
        ),
      );
    }

    final streamedResponse = await request.send().timeout(_requestTimeout);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) return;
    _throwForStatus(response);
  }

  String _mimeTypeFromExtension(String ext) {
    switch (ext) {
      case 'png':
        return 'png';
      case 'heic':
      case 'heif':
        return 'heic';
      case 'webp':
        return 'webp';
      default:
        return 'jpeg';
    }
  }

  Future<Uint8List> getBytes(String url) async {
    final headers = await _getHeaders();
    final response = await _executeWithAuthRaw(
      () => _client.get(Uri.parse('$baseUrl$url'), headers: headers),
    );
    if (response.statusCode == 200) return response.bodyBytes;
    throw ServerFailure(
      'Failed to fetch bytes: ${response.statusCode}',
      response.statusCode,
    );
  }

  Future<dynamic> _executeWithAuth(
    Future<http.Response> Function() request,
  ) async {
    await checkConnection();
    try {
      final response = await request().timeout(_requestTimeout);
      return _handleResponse(response);
    } on UnauthorizedFailure {
      if (await _tryRefreshToken()) {
        final response = await request().timeout(_requestTimeout);
        return _handleResponse(response);
      }
      onUnauthorized?.call();
      rethrow;
    } on TimeoutException {
      throw const NetworkFailure('Request timed out');
    }
  }

  Future<void> _executeWithAuthVoid(
    Future<http.Response> Function() request,
  ) async {
    await checkConnection();
    try {
      final response = await request().timeout(_requestTimeout);
      _handleVoidResponse(response);
    } on UnauthorizedFailure {
      if (await _tryRefreshToken()) {
        final response = await request().timeout(_requestTimeout);
        _handleVoidResponse(response);
        return;
      }
      onUnauthorized?.call();
      rethrow;
    } on TimeoutException {
      throw const NetworkFailure('Request timed out');
    }
  }

  Future<http.Response> _executeWithAuthRaw(
    Future<http.Response> Function() request,
  ) async {
    await checkConnection();
    try {
      final response = await request().timeout(_requestTimeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response;
      }
      _throwForStatus(response);
    } on UnauthorizedFailure {
      if (await _tryRefreshToken()) {
        final response = await request().timeout(_requestTimeout);
        if (response.statusCode >= 200 && response.statusCode < 300) {
          return response;
        }
        _throwForStatus(response);
      }
      onUnauthorized?.call();
      rethrow;
    } on TimeoutException {
      throw const NetworkFailure('Request timed out');
    }
    // unreachable, keep compiler happy
    throw const UnknownFailure('Unexpected error');
  }

  Future<bool> _tryRefreshToken() async {
    final storage = _localStorage;
    if (storage == null) return false;
    try {
      final refreshToken = await storage.getSecureString(
        StorageKeys.refreshToken,
      );
      if (refreshToken == null || refreshToken.isEmpty) return false;

      final response = await _client
          .post(
            Uri.parse('$baseUrl${EndPoints.refresh}'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(_requestTimeout);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        final newAccessToken = json['access_token'] as String?;
        final newRefreshToken = json['refresh_token'] as String?;
        if (newAccessToken != null) {
          _accessToken = newAccessToken;
          await storage.setSecureString(
            StorageKeys.accessToken,
            newAccessToken,
          );
        }
        if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
          await storage.setSecureString(
            StorageKeys.refreshToken,
            newRefreshToken,
          );
        }
        return newAccessToken != null;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    }
    _throwForStatus(response);
  }

  void _throwForStatus(http.Response response) {
    switch (response.statusCode) {
      case 400:
      case 422:
        throw ServerFailure(_parseError(response), response.statusCode);
      case 401:
        throw const UnauthorizedFailure(
          'Session expired. Please log in again.',
        );
      case 403:
        throw const ServerFailure('Access denied.');
      case 404:
        throw NotFoundFailure(_parseError(response));
      case 429:
        throw const RateLimitFailure('Too many attempts. Try again later.');
      case 500:
        throw ServerFailure(_parseError(response), response.statusCode);
      default:
        throw ServerFailure(_parseError(response), response.statusCode);
    }
  }

  String _parseError(http.Response response) {
    try {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      return body['message'] as String? ??
          body['error'] as String? ??
          'Unknown server error';
    } catch (_) {
      return 'Server error ${response.statusCode}';
    }
  }
}
