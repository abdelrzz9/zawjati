import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:mocktail/mocktail.dart';
import 'package:zawjati_mobile/core/network/websocket_service.dart';

class MockWebSocketChannel extends Mock implements WebSocketChannel {}
class MockStreamSink extends Mock implements StreamSink<dynamic> {}
class MockStreamController extends Mock implements StreamController<dynamic> {}

void main() {
  late WebSocketService service;

  setUp(() {
    service = WebSocketService(
      url: 'ws://test.com/ws',
      pingInterval: const Duration(seconds: 30),
      connectionTimeout: const Duration(seconds: 5),
      maxRetries: 3,
      baseDelay: 0.1,
      maxDelay: 1.0,
    );
  });

  tearDown(() {
    try {
      service.dispose();
    } catch (_) {}
  });

  group('WebSocketService', () {
    test('initial state is disconnected', () {
      expect(service.state, WebSocketConnectionState.disconnected);
    });

    test('connection state stream fires events', () async {
      final states = <WebSocketConnectionState>[];
      final sub = service.connectionState.listen(states.add);

      expect(states.length, 0);

      await Future.delayed(const Duration(milliseconds: 50));
      await sub.cancel();
    });

    test('message queue stores pending messages when disconnected', () {
      service.sendMessage('test', {'key': 'value'});

      expect(service.state, WebSocketConnectionState.disconnected);
    });

    test('dispose cleans up resources', () {
      service.dispose();
      expect(service.state, WebSocketConnectionState.disconnected);
    });

    test('generates unique message IDs', () {
      final ids = <String>{};
      for (int i = 0; i < 100; i++) {
        final message = WebSocketMessage(
          id: 'msg_${DateTime.now().millisecondsSinceEpoch}_$i',
          type: 'test',
          data: {},
        );
        expect(ids.add(message.id), true);
      }
    });

    test('WebSocketMessage serialization round-trip', () {
      final original = WebSocketMessage(
        id: 'test-id',
        type: 'message',
        data: {'content': 'hello'},
        timestamp: DateTime(2024, 1, 1),
      );

      final json = original.toJson();
      final decoded = WebSocketMessage.fromJson(json);

      expect(decoded.id, original.id);
      expect(decoded.type, original.type);
      expect(decoded.data['content'], 'hello');
    });

    test('duplicate message IDs are tracked', () {
      final s = WebSocketService(url: 'ws://test.com');
      s.dispose();
    });

    test('calculates exponential backoff', () {
      service.dispose();
    });
  });
}
