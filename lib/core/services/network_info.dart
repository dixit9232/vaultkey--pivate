import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Abstract network info interface
abstract class NetworkInfo {
  /// Check if device is connected to internet
  Future<bool> get isConnected;

  /// Stream of connectivity changes
  Stream<bool> get onConnectivityChanged;
}

/// Implementation of network info using connectivity_plus
class NetworkInfoImpl implements NetworkInfo {
  final Connectivity _connectivity;
  StreamController<bool>? _connectivityController;

  NetworkInfoImpl({Connectivity? connectivity}) : _connectivity = connectivity ?? Connectivity() {
    _initConnectivityStream();
  }

  void _initConnectivityStream() {
    _connectivityController = StreamController<bool>.broadcast();

    _connectivity.onConnectivityChanged.listen((results) {
      final hasConnection = _hasActiveConnection(results);
      _connectivityController?.add(hasConnection);
    });
  }

  @override
  Future<bool> get isConnected async {
    final results = await _connectivity.checkConnectivity();
    return _hasActiveConnection(results);
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivityController?.stream ?? Stream.value(false);

  bool _hasActiveConnection(List<ConnectivityResult> results) {
    return results.any((result) => result == ConnectivityResult.mobile || result == ConnectivityResult.wifi || result == ConnectivityResult.ethernet || result == ConnectivityResult.vpn);
  }

  /// Dispose resources
  void dispose() {
    _connectivityController?.close();
  }
}
