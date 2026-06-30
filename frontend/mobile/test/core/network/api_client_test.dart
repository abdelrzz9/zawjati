import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;
import 'package:zawjati_mobile/core/network/api_client.dart';
import 'package:zawjati_mobile/core/network/network_info.dart';
import 'package:zawjati_mobile/core/storage/app_local_storage.dart';
import 'package:zawjati_mobile/core/errors/failure.dart';

class MockHttpClient extends Mock implements http.Client {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockLocalStorage extends Mock implements LocalStorage {}

class FakeUri extends Fake implements Uri {}
class FakeResponse extends Fake implements http.Response {}

void main() {
  late MockHttpClient mockHttp;
  late MockNetworkInfo mockNetworkInfo;
  late MockLocalStorage mockStorage;
  late ApiClient apiClient;

  setUpAll(() async {
    await dotenv.load(fileName: '.env');
    registerFallbackValue(Uri());
  });

  setUp(() {
    mockHttp = MockHttpClient();
    mockNetworkInfo = MockNetworkInfo();
    mockStorage = MockLocalStorage();
    apiClient = ApiClient(
      client: mockHttp,
      networkInfo: mockNetworkInfo,
      localStorage: mockStorage,
    );
  });

  group('ApiClient', () {
    test('throws NetworkFailure when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      expect(
        () => apiClient.get('/test'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('sends GET request successfully', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"key": "value"}', 200));

      final result = await apiClient.get('/test');
      expect(result, isA<Map>());
      expect(result['key'], 'value');
    });

    test('sends POST request successfully', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.post(any(),
          headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{"id": "123"}', 201));

      final result = await apiClient.post('/create', body: {'name': 'test'});
      expect(result['id'], '123');
    });

    test('handles 401 Unauthorized', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"message": "Unauthorized"}', 401));

      expect(
        () => apiClient.get('/protected'),
        throwsA(isA<UnauthorizedFailure>()),
      );
    });

    test('handles 404 NotFound', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"message": "Not found"}', 404));

      expect(
        () => apiClient.get('/nonexistent'),
        throwsA(isA<NotFoundFailure>()),
      );
    });

    test('handles 429 RateLimit', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"message": "Too fast"}', 429));

      expect(
        () => apiClient.get('/ratelimited'),
        throwsA(isA<RateLimitFailure>()),
      );
    });

    test('handles 500 ServerError', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockHttp.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('{"message": "Server error"}', 500));

      expect(
        () => apiClient.get('/error'),
        throwsA(isA<ServerFailure>()),
      );
    });
  });
}
