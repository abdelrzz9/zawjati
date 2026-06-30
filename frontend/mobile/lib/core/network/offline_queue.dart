import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class OfflineQueueItem {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic>? body;
  final DateTime queuedAt;
  int retryCount;
  bool isProcessing;

  OfflineQueueItem({
    required this.id,
    required this.endpoint,
    required this.method,
    this.body,
    DateTime? queuedAt,
    this.retryCount = 0,
    this.isProcessing = false,
  }) : queuedAt = queuedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'endpoint': endpoint,
    'method': method,
    'body': body,
    'queuedAt': queuedAt.toIso8601String(),
    'retryCount': retryCount,
  };

  factory OfflineQueueItem.fromJson(Map<String, dynamic> json) {
    return OfflineQueueItem(
      id: json['id'] as String,
      endpoint: json['endpoint'] as String,
      method: json['method'] as String,
      body: json['body'] as Map<String, dynamic>?,
      queuedAt: DateTime.parse(json['queuedAt'] as String),
      retryCount: json['retryCount'] as int? ?? 0,
    );
  }
}

class OfflineQueue {
  final SharedPreferences _prefs;
  final InternetConnection _connectivity;
  late final StreamSubscription<InternetStatus>? _subscription;
  final List<OfflineQueueItem> _queue = [];
  bool _isProcessing = false;
  int _maxRetries = 5;

  final StreamController<OfflineQueueItem> _itemAddedController =
      StreamController<OfflineQueueItem>.broadcast();
  final StreamController<OfflineQueueItem> _itemProcessedController =
      StreamController<OfflineQueueItem>.broadcast();
  final StreamController<OfflineQueueItem> _itemFailedController =
      StreamController<OfflineQueueItem>.broadcast();

  Stream<OfflineQueueItem> get onItemAdded => _itemAddedController.stream;
  Stream<OfflineQueueItem> get onItemProcessed => _itemProcessedController.stream;
  Stream<OfflineQueueItem> get onItemFailed => _itemFailedController.stream;

  bool get hasPending => _queue.any((item) => !item.isProcessing);
  int get pendingCount => _queue.where((item) => !item.isProcessing).length;

  OfflineQueue({
    required SharedPreferences prefs,
    required InternetConnection connectivity,
  })  : _prefs = prefs,
        _connectivity = connectivity {
    _subscription = connectivity.onStatusChange.listen((status) {
      if (status == InternetStatus.connected) {
        processQueue();
      }
    });
    _loadQueue();
  }

  void _loadQueue() {
    final data = _prefs.getString('offline_queue');
    if (data == null) return;
    try {
      final list = jsonDecode(data) as List;
      for (final item in list) {
        _queue.add(OfflineQueueItem.fromJson(item as Map<String, dynamic>));
      }
    } catch (_) {}
  }

  Future<void> _saveQueue() async {
    final data = jsonEncode(_queue.map((e) => e.toJson()).toList());
    await _prefs.setString('offline_queue', data);
  }

  Future<void> enqueue(OfflineQueueItem item) async {
    _queue.add(item);
    _itemAddedController.add(item);
    await _saveQueue();

    if (await _connectivity.hasInternetAccess) {
      processQueue();
    }
  }

  Future<void> processQueue() async {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;

    while (_queue.isNotEmpty) {
      final item = _queue.first;
      if (item.retryCount >= _maxRetries) {
        _queue.removeAt(0);
        _itemFailedController.add(item);
        continue;
      }

      item.isProcessing = true;
      try {
        await _processItem(item);
        _queue.removeAt(0);
        _itemProcessedController.add(item);
      } catch (_) {
        item.retryCount++;
        item.isProcessing = false;
        _queue.removeAt(0);
        _queue.add(item);
        break;
      }
    }

    await _saveQueue();
    _isProcessing = false;
  }

  Future<void> _processItem(OfflineQueueItem item) async {
    switch (item.method.toUpperCase()) {
      case 'POST':
        await _post(item.endpoint, item.body);
        break;
      case 'DELETE':
        await _delete(item.endpoint);
        break;
      case 'PUT':
        await _put(item.endpoint, item.body);
        break;
    }
  }

  Future<void> _post(String endpoint, Map<String, dynamic>? body) async {
    final response = await Future.delayed(
      const Duration(seconds: 1),
      () => true,
    );
    if (!response) throw Exception('Failed to process offline item');
  }

  Future<void> _delete(String endpoint) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  Future<void> _put(String endpoint, Map<String, dynamic>? body) async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void clear() {
    _queue.clear();
    _prefs.remove('offline_queue');
  }

  void dispose() {
    _subscription?.cancel();
    _itemAddedController.close();
    _itemProcessedController.close();
    _itemFailedController.close();
  }
}
