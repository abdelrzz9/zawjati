import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dio/dio.dart';
import 'package:zawjati_mobile/core/constants/end_points.dart';
import 'package:zawjati_mobile/core/network/dio_client.dart';
import 'package:zawjati_mobile/features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:zawjati_mobile/features/chat/data/models/chat_request_model.dart';

class MockDioClient extends Mock implements DioClient {}
class MockResponse extends Mock implements Response<dynamic> {}
class MockStreamResponse extends Mock implements Response<ResponseBody> {}
class MockResponseBody extends Mock implements ResponseBody {}

class FakeRequestOptions extends Fake implements RequestOptions {}

void main() {
  late MockDioClient mockDioClient;
  late ChatRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(EndPoints.chat);
    registerFallbackValue(const ChatRequestModel(message: ''));
  });

  setUp(() {
    mockDioClient = MockDioClient();
    dataSource = ChatRemoteDataSource(dioClient: mockDioClient);
  });

  group('ChatRemoteDataSource', () {
    test('sendMessage returns response model', () async {
      final request = ChatRequestModel(
        message: 'Hello',
        userId: 'user-1',
      );

      when(() => mockDioClient.post(any(), data: any(named: 'data')))
          .thenAnswer((_) async {
        final response = MockResponse();
        when(() => response.data).thenReturn({
          'reply': 'Hi there!',
          'request_id': 'req-1',
        });
        return response;
      });

      final result = await dataSource.sendMessage(request);
      expect(result.reply, 'Hi there!');
      expect(result.requestId, 'req-1');
    });

    test('throws DioException on request failure', () async {
      final request = ChatRequestModel(
        message: 'Hello',
        userId: 'user-1',
      );

      when(() => mockDioClient.post(
        any(),
        data: any(named: 'data'),
      )).thenThrow(DioException(
        requestOptions: RequestOptions(path: '/chat'),
      ));

      expect(
        () => dataSource.sendMessage(request),
        throwsA(isA<DioException>()),
      );
    });

    test('streamMessage parses SSE events', () async {
      final mockResponse = MockStreamResponse();
      final mockBody = MockResponseBody();

      when(() => mockResponse.data).thenReturn(mockBody);
      when(() => mockBody.stream).thenAnswer((_) =>
        Stream.fromIterable([
          Uint8List.fromList([101, 118, 101, 110, 116, 58, 32, 116, 111, 107, 101, 110, 10, 100, 97, 116, 97, 58, 32, 123, 34, 116, 111, 107, 101, 110, 34, 58, 34, 72, 105, 34, 125, 10, 10]), // event: token\ndata: {"token":"Hi"}\n\n
        ]),
      );

      when(() => mockDioClient.postStream(
        any(),
        data: any(named: 'data'),
      )).thenAnswer((_) async => mockResponse);

      final request = ChatRequestModel(
        message: 'Hello',
        userId: 'user-1',
      );

      final tokens = await dataSource.streamMessage(request).toList();
      expect(tokens, contains('Hi'));
    });
  });
}
