import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityService {
  final Connectivity _connectivity;
  final InternetConnection _connectionChecker;

  final StreamController<bool> _statusController =
      StreamController<bool>.broadcast();

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _lastStatus = false;

  ConnectivityService({
    required Connectivity connectivity,
    required InternetConnection connectionChecker,
  }) : _connectivity = connectivity,
       _connectionChecker = connectionChecker;

  Stream<bool> get onStatusChanged => _statusController.stream;
  bool get isConnected => _lastStatus;

  Future<void> init() async {
    _lastStatus = await _checkNow();
    _statusController.add(_lastStatus);
    _subscription = _connectivity.onConnectivityChanged.listen(_onChange);
  }

  Future<bool> _checkNow() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (results.length == 1 && results.contains(ConnectivityResult.none)) {
        return false;
      }
      return await _connectionChecker.hasInternetAccess.timeout(
        const Duration(seconds: 5),
      );
    } catch (_) {
      return false;
    }
  }

  Future<void> _onChange(List<ConnectivityResult> results) async {
    final hasConnectivity =
        !(results.length == 1 && results.contains(ConnectivityResult.none));
    if (!hasConnectivity) {
      if (_lastStatus) {
        _lastStatus = false;
        _statusController.add(false);
      }
      return;
    }
    final hasInternet = await _checkNow();
    if (hasInternet != _lastStatus) {
      _lastStatus = hasInternet;
      _statusController.add(hasInternet);
    }
  }

  void dispose() {
    _subscription?.cancel();
    _statusController.close();
  }
}
