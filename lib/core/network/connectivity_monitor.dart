import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Connectivity status enum
enum ConnectivityStatus {
  connected,
  disconnected,
  connecting,
}

/// Connectivity state with additional info
class ConnectivityState {
  const ConnectivityState({
    required this.status,
    this.connectionType,
    this.lastConnected,
  });

  final ConnectivityStatus status;
  final String? connectionType;
  final DateTime? lastConnected;

  bool get isConnected => status == ConnectivityStatus.connected;
  bool get isDisconnected => status == ConnectivityStatus.disconnected;

  ConnectivityState copyWith({
    ConnectivityStatus? status,
    String? connectionType,
    DateTime? lastConnected,
  }) {
    return ConnectivityState(
      status: status ?? this.status,
      connectionType: connectionType ?? this.connectionType,
      lastConnected: lastConnected ?? this.lastConnected,
    );
  }
}

/// Connectivity monitor provider
final connectivityProvider = NotifierProvider<ConnectivityMonitor, ConnectivityState>(
  ConnectivityMonitor.new,
);

/// Connectivity monitor for tracking network status
class ConnectivityMonitor extends Notifier<ConnectivityState> {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;

  @override
  ConnectivityState build() {
    // Initialize connectivity monitoring
    _initialize();

    // Cleanup on dispose
    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const ConnectivityState(status: ConnectivityStatus.connecting);
  }

  void _initialize() async {
    // Check initial status
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);

    // Listen for changes
    _subscription = _connectivity.onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;

    if (result == ConnectivityResult.none) {
      state = state.copyWith(
        status: ConnectivityStatus.disconnected,
        connectionType: null,
      );
    } else {
      state = ConnectivityState(
        status: ConnectivityStatus.connected,
        connectionType: _getConnectionTypeName(result),
        lastConnected: DateTime.now(),
      );
    }
  }

  String _getConnectionTypeName(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return 'WiFi';
      case ConnectivityResult.mobile:
        return 'Mobile Data';
      case ConnectivityResult.ethernet:
        return 'Ethernet';
      case ConnectivityResult.bluetooth:
        return 'Bluetooth';
      case ConnectivityResult.vpn:
        return 'VPN';
      case ConnectivityResult.other:
        return 'Other';
      case ConnectivityResult.none:
        return 'None';
    }
  }

  /// Manually check connectivity
  Future<bool> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateStatus(results);
    return state.isConnected;
  }
}

/// Helper extension for easy connectivity checks
extension ConnectivityRefExtension on WidgetRef {
  /// Check if currently connected to the internet
  bool get isConnected => watch(connectivityProvider).isConnected;

  /// Get the current connection type
  String? get connectionType => watch(connectivityProvider).connectionType;
}
