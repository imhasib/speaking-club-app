import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../../core/config/env.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/online_user.dart';
import '../../../shared/providers/core_providers.dart';

/// Socket connection state
enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
  error,
}

/// Socket events constants
class SocketEvents {
  SocketEvents._();

  // Presence events
  static const String goOnline = 'user:go-online';
  static const String goOffline = 'user:go-offline';
  static const String statusChanged = 'user:status-changed';
  static const String onlineUsersList = 'online:users-list';

  // Matchmaking events
  static const String matchmakingJoin = 'matchmaking:join';
  static const String matchmakingLeave = 'matchmaking:leave';
  static const String matchmakingMatched = 'matchmaking:matched';

  // WebRTC signaling events
  static const String callOffer = 'call:offer';
  static const String callAnswer = 'call:answer';
  static const String callIceCandidate = 'call:ice-candidate';
  static const String callEnd = 'call:end';
  static const String callEnded = 'call:ended';

  // Error events
  static const String error = 'error';
}

/// Socket service provider
final socketServiceProvider = Provider<SocketService>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return SocketService(secureStorage: secureStorage);
});

/// WebSocket service for real-time communication
class SocketService {
  final FlutterSecureStorage _secureStorage;

  io.Socket? _socket;
  SocketConnectionState _connectionState = SocketConnectionState.disconnected;
  int _reconnectAttempts = 0;
  static const int _maxReconnectAttempts = 5;
  static const Duration _reconnectDelay = Duration(seconds: 2);

  // Stream controllers for events
  final _connectionStateController =
      StreamController<SocketConnectionState>.broadcast();
  final _onlineUsersController = StreamController<List<OnlineUser>>.broadcast();
  final _statusChangedController =
      StreamController<UserStatusChange>.broadcast();
  final _errorController = StreamController<String>.broadcast();

  // Streams
  Stream<SocketConnectionState> get connectionState =>
      _connectionStateController.stream;
  Stream<List<OnlineUser>> get onlineUsers => _onlineUsersController.stream;
  Stream<UserStatusChange> get statusChanged => _statusChangedController.stream;
  Stream<String> get errors => _errorController.stream;

  SocketConnectionState get currentConnectionState => _connectionState;
  bool get isConnected => _connectionState == SocketConnectionState.connected;

  SocketService({required FlutterSecureStorage secureStorage})
      : _secureStorage = secureStorage;

  /// Connect to the socket server with JWT authentication
  Future<void> connect() async {
    if (_socket != null && _socket!.connected) {
      dev.log('🔌 Socket already connected');
      return;
    }

    _updateConnectionState(SocketConnectionState.connecting);

    try {
      final token =
          await _secureStorage.read(key: AppConstants.accessTokenKey);

      if (token == null) {
        dev.log('❌ No access token available for socket connection');
        _updateConnectionState(SocketConnectionState.error);
        _errorController.add('No authentication token available');
        return;
      }

      dev.log('🔌 Connecting to socket server: ${Env.socketUrl}');

      _socket = io.io(
        Env.socketUrl,
        io.OptionBuilder()
            .setTransports(['websocket'])
            .setAuth({'token': token})
            .enableAutoConnect()
            .enableReconnection()
            .setReconnectionAttempts(_maxReconnectAttempts)
            .setReconnectionDelay(_reconnectDelay.inMilliseconds)
            .build(),
      );

      _setupEventListeners();
      _socket!.connect();
    } catch (e) {
      dev.log('❌ Socket connection error: $e');
      _updateConnectionState(SocketConnectionState.error);
      _errorController.add(e.toString());
    }
  }

  /// Disconnect from the socket server
  void disconnect() {
    dev.log('🔌 Disconnecting socket...');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
    _reconnectAttempts = 0;
    _updateConnectionState(SocketConnectionState.disconnected);
  }

  /// Setup socket event listeners
  void _setupEventListeners() {
    if (_socket == null) return;

    // Connection events
    _socket!.onConnect((_) {
      dev.log('✅ Socket connected');
      _reconnectAttempts = 0;
      _updateConnectionState(SocketConnectionState.connected);
    });

    _socket!.onDisconnect((_) {
      dev.log('🔴 Socket disconnected');
      _updateConnectionState(SocketConnectionState.disconnected);
    });

    _socket!.onConnectError((error) {
      dev.log('❌ Socket connect error: $error');
      _updateConnectionState(SocketConnectionState.error);
      _errorController.add('Connection error: $error');
    });

    // Reconnection handling via custom events
    _socket!.on('reconnect', (_) {
      dev.log('🔄 Socket reconnected');
      _reconnectAttempts = 0;
      _updateConnectionState(SocketConnectionState.connected);
    });

    _socket!.on('reconnecting', (_) {
      dev.log('🔄 Socket reconnecting...');
      _reconnectAttempts++;
      _updateConnectionState(SocketConnectionState.reconnecting);
    });

    _socket!.on('reconnect_error', (error) {
      dev.log('❌ Socket reconnect error: $error');
      _errorController.add('Reconnection error: $error');
    });

    _socket!.on('reconnect_failed', (_) {
      dev.log('❌ Socket reconnection failed after $_maxReconnectAttempts attempts');
      _updateConnectionState(SocketConnectionState.error);
      _errorController.add('Failed to reconnect after multiple attempts');
    });

    // Presence events
    _socket!.on(SocketEvents.onlineUsersList, (data) {
      dev.log('📥 Received online users list: $data');
      try {
        final List<dynamic> usersJson = data as List<dynamic>;
        final users = usersJson
            .map((json) => OnlineUser.fromJson(json as Map<String, dynamic>))
            .toList();
        _onlineUsersController.add(users);
      } catch (e) {
        dev.log('❌ Error parsing online users list: $e');
        _errorController.add('Error parsing online users: $e');
      }
    });

    _socket!.on(SocketEvents.statusChanged, (data) {
      dev.log('📥 Received status changed: $data');
      try {
        final statusChange =
            UserStatusChange.fromJson(data as Map<String, dynamic>);
        _statusChangedController.add(statusChange);
      } catch (e) {
        dev.log('❌ Error parsing status change: $e');
        _errorController.add('Error parsing status change: $e');
      }
    });

    // Error events
    _socket!.on(SocketEvents.error, (data) {
      dev.log('📥 Received error: $data');
      final message = data is Map ? data['message'] ?? 'Unknown error' : '$data';
      _errorController.add(message);
    });
  }

  /// Update connection state and notify listeners
  void _updateConnectionState(SocketConnectionState state) {
    _connectionState = state;
    _connectionStateController.add(state);
  }

  /// Emit go online event
  void goOnline() {
    if (!isConnected) {
      dev.log('⚠️ Cannot go online: socket not connected');
      return;
    }
    dev.log('📤 Emitting go-online');
    _socket!.emit(SocketEvents.goOnline);
  }

  /// Emit go offline event
  void goOffline() {
    if (!isConnected) {
      dev.log('⚠️ Cannot go offline: socket not connected');
      return;
    }
    dev.log('📤 Emitting go-offline');
    _socket!.emit(SocketEvents.goOffline);
  }

  /// Join matchmaking queue
  void joinMatchmaking() {
    if (!isConnected) {
      dev.log('⚠️ Cannot join matchmaking: socket not connected');
      return;
    }
    dev.log('📤 Emitting matchmaking:join');
    _socket!.emit(SocketEvents.matchmakingJoin);
  }

  /// Leave matchmaking queue
  void leaveMatchmaking() {
    if (!isConnected) {
      dev.log('⚠️ Cannot leave matchmaking: socket not connected');
      return;
    }
    dev.log('📤 Emitting matchmaking:leave');
    _socket!.emit(SocketEvents.matchmakingLeave);
  }

  /// End current call
  void endCall() {
    if (!isConnected) {
      dev.log('⚠️ Cannot end call: socket not connected');
      return;
    }
    dev.log('📤 Emitting call:end');
    _socket!.emit(SocketEvents.callEnd);
  }

  /// Add listener for a specific event
  void on(String event, Function(dynamic) callback) {
    _socket?.on(event, callback);
  }

  /// Remove listener for a specific event
  void off(String event) {
    _socket?.off(event);
  }

  /// Emit a custom event
  void emit(String event, [dynamic data]) {
    if (!isConnected) {
      dev.log('⚠️ Cannot emit $event: socket not connected');
      return;
    }
    _socket!.emit(event, data);
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _connectionStateController.close();
    _onlineUsersController.close();
    _statusChangedController.close();
    _errorController.close();
  }
}
