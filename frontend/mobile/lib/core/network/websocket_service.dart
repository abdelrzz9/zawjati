import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:meta/meta.dart';

enum WebSocketConnectionState { disconnected, connecting, connected, reconnecting }

class WebSocketMessage {
  final String id;
  final String type;
  final Map<String, dynamic> data;
  final DateTime timestamp;

  WebSocketMessage({
    required this.id,
    required this.type,
    required this.data,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type,
    'data': data,
    'timestamp': timestamp.toIso8601String(),
  };

  factory WebSocketMessage.fromJson(Map<String, dynamic> json) {
    return WebSocketMessage(
      id: json['id'] as String,
      type: json['type'] as String,
      data: json['data'] as Map<String, dynamic>? ?? {},
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }
}

class WebSocketService {
  final String url;
  final Duration pingInterval;
  final Duration connectionTimeout;
  final int maxRetries;
  final double baseDelay;
  final double maxDelay;

  WebSocketChannel? _channel;
  Timer? _pingTimer;
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  StreamSubscription? _subscription;
  int _retryCount = 0;
  bool _intentionalClose = false;
  final Set<String> _receivedMessageIds = {};
  final List<Map<String, dynamic>> _pendingMessages = [];
  String? _sessionId;
  String? _lastMessageId;

  final StreamController<WebSocketConnectionState> _connectionStateController =
      StreamController<WebSocketConnectionState>.broadcast();
  final StreamController<WebSocketMessage> _messageController =
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<WebSocketMessage> _sentMessageController =
      StreamController<WebSocketMessage>.broadcast();
  final StreamController<Map<String, dynamic>> _errorController =
      StreamController<Map<String, dynamic>>.broadcast();

  WebSocketConnectionState _state = WebSocketConnectionState.disconnected;

  WebSocketService({
    required this.url,
    this.pingInterval = const Duration(seconds: 25),
    this.connectionTimeout = const Duration(seconds: 10),
    this.maxRetries = 10,
    this.baseDelay = 1.0,
    this.maxDelay = 30.0,
  });

  Stream<WebSocketConnectionState> get connectionState => _connectionStateController.stream;
  Stream<WebSocketMessage> get messages => _messageController.stream;
  Stream<WebSocketMessage> get sentMessages => _sentMessageController.stream;
  Stream<Map<String, dynamic>> get errors => _errorController.stream;

  WebSocketConnectionState get state => _state;

  void _setState(WebSocketConnectionState newState) {
    _state = newState;
    _connectionStateController.add(newState);
  }

  Future<void> connect({Map<String, String>? headers}) async {
    if (_state == WebSocketConnectionState.connecting ||
        _state == WebSocketConnectionState.connected) {
      return;
    }

    _intentionalClose = false;
    _setState(WebSocketConnectionState.connecting);

    try {
      final uri = Uri.parse(url).replace(queryParameters: {
        if (headers != null) ...headers,
        if (_sessionId != null) 'session_id': _sessionId,
      });

      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready.timeout(connectionTimeout);

      _retryCount = 0;
      _sessionId = _sessionId ?? _generateSessionId();
      _setState(WebSocketConnectionState.connected);
      _startPing();
      _startHeartbeat();
      _listen();
      _flushPendingMessages();
    } catch (e) {
      _setState(WebSocketConnectionState.disconnected);
      _scheduleReconnect();
      _errorController.add({'type': 'connection_error', 'message': e.toString()});
    }
  }

  void _listen() {
    _subscription?.cancel();
    _subscription = _channel!.stream.listen(
      (data) {
        _handleMessage(data);
      },
      onError: (error) {
        _errorController.add({'type': 'stream_error', 'message': error.toString()});
        _scheduleReconnect();
      },
      onDone: () {
        if (!_intentionalClose) {
          _scheduleReconnect();
        }
      },
    );
  }

  void _handleMessage(dynamic data) {
    try {
      final json = data is String
          ? jsonDecode(data) as Map<String, dynamic>
          : data as Map<String, dynamic>;

      if (json['type'] == 'pong') {
        _heartbeatTimer?.cancel();
        _heartbeatTimer = Timer(pingInterval * 1.5, _checkHeartbeat);
        return;
      }

      if (json['type'] == 'ack' && json['message_id'] != null) {
        _receivedMessageIds.add(json['message_id'] as String);
        return;
      }

      final message = WebSocketMessage.fromJson(json);

      if (_receivedMessageIds.contains(message.id)) return;
      _receivedMessageIds.add(message.id);

      if (_receivedMessageIds.length > 1000) {
        final oldest = _receivedMessageIds.take(500).toList();
        for (final id in oldest) {
          _receivedMessageIds.remove(id);
        }
      }

      _messageController.add(message);
    } catch (e) {
      _errorController.add({'type': 'parse_error', 'message': e.toString()});
    }
  }

  void sendMessage(String type, Map<String, dynamic> data) {
    final message = WebSocketMessage(
      id: _generateMessageId(),
      type: type,
      data: data,
    );

    if (_state != WebSocketConnectionState.connected) {
      _pendingMessages.add(message.toJson());
      return;
    }

    _sendJson(message.toJson());
  }

  void _sendJson(Map<String, dynamic> json) {
    try {
      _channel?.sink.add(jsonEncode(json));
      _lastMessageId = json['id'] as String?;
      _sentMessageController.add(WebSocketMessage.fromJson(json));
    } catch (e) {
      _pendingMessages.add(json);
      _errorController.add({'type': 'send_error', 'message': e.toString()});
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(pingInterval, (_) {
      if (_state == WebSocketConnectionState.connected) {
        _sendJson({'type': 'ping', 'timestamp': DateTime.now().toIso8601String()});
      }
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer(pingInterval * 1.5, _checkHeartbeat);
  }

  void _checkHeartbeat() {
    if (_state == WebSocketConnectionState.connected) {
      _scheduleReconnect();
    }
  }

  double _calculateBackoff() {
    final delay = min(baseDelay * pow(2, _retryCount), maxDelay);
    final jitter = Random().nextDouble() * 0.5 * delay;
    return delay + jitter;
  }

  void _scheduleReconnect() {
    _pingTimer?.cancel();
    _heartbeatTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close();

    if (_intentionalClose || _retryCount >= maxRetries) {
      _setState(WebSocketConnectionState.disconnected);
      if (_retryCount >= maxRetries) {
        _errorController.add({'type': 'max_retries_exceeded', 'message': 'Max reconnection attempts reached'});
      }
      return;
    }

    _setState(WebSocketConnectionState.reconnecting);
    final delay = _calculateBackoff();
    _retryCount++;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(Duration(milliseconds: (delay * 1000).round()), () {
      connect();
    });
  }

  void _flushPendingMessages() {
    if (_pendingMessages.isEmpty) return;
    final pending = List<Map<String, dynamic>>.from(_pendingMessages);
    _pendingMessages.clear();
    for (final msg in pending) {
      _sendJson(msg);
    }
  }

  String _generateSessionId() {
    final random = Random();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  String _generateMessageId() {
    final random = Random();
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final randomPart = random.nextInt(999999);
    return 'msg_${timestamp}_$randomPart';
  }

  void resubscribe() {
    if (_sessionId != null) {
      _sendJson({
        'type': 'resubscribe',
        'session_id': _sessionId,
        'last_message_id': _lastMessageId,
      });
    }
  }

  void dispose() {
    _intentionalClose = true;
    _pingTimer?.cancel();
    _heartbeatTimer?.cancel();
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _channel?.sink.close(status.goingAway);
    _setState(WebSocketConnectionState.disconnected);
    _connectionStateController.close();
    _messageController.close();
    _sentMessageController.close();
    _errorController.close();
    _pendingMessages.clear();
    _receivedMessageIds.clear();
  }
}
