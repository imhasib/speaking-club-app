import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/online_user.dart';
import '../../data/socket_service.dart';
import '../../domain/presence_state.dart';

/// Presence notifier provider
final presenceProvider =
    NotifierProvider<PresenceNotifier, PresenceState>(PresenceNotifier.new);

/// App lifecycle observer for presence management
class PresenceLifecycleObserver extends WidgetsBindingObserver {
  final PresenceNotifier _notifier;

  PresenceLifecycleObserver(this._notifier) {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState appState) {
    _notifier.handleAppLifecycleChange(appState);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}

/// Notifier for managing presence state
class PresenceNotifier extends Notifier<PresenceState> {
  SocketService get _socketService => ref.read(socketServiceProvider);

  StreamSubscription<SocketConnectionState>? _connectionStateSub;
  StreamSubscription<List<OnlineUser>>? _onlineUsersSub;
  StreamSubscription<UserStatusChange>? _statusChangedSub;
  StreamSubscription<String>? _errorSub;
  PresenceLifecycleObserver? _lifecycleObserver;

  bool _wasOnlineBeforeBackground = false;
  bool _hasConnectedOnce = false;

  @override
  PresenceState build() {
    // Initialize lifecycle observer
    _lifecycleObserver = PresenceLifecycleObserver(this);

    // Setup subscriptions
    _setupSubscriptions();

    // Cleanup on dispose
    ref.onDispose(() {
      _connectionStateSub?.cancel();
      _onlineUsersSub?.cancel();
      _statusChangedSub?.cancel();
      _errorSub?.cancel();
      _lifecycleObserver?.dispose();
    });

    return const PresenceState();
  }

  /// Setup stream subscriptions
  void _setupSubscriptions() {
    _connectionStateSub =
        _socketService.connectionState.listen((connectionState) {
      dev.log('🔄 Connection state changed: $connectionState');

      // Clear loading when connected (even if no users list yet)
      if (connectionState == SocketConnectionState.connected) {
        state = state.copyWith(
          connectionState: connectionState,
          isLoading: false,
        );

        // Auto go online on initial connection or when returning from background
        if (!_hasConnectedOnce) {
          // First time connecting after login - go online by default
          _hasConnectedOnce = true;
          goOnline();
        } else if (_wasOnlineBeforeBackground) {
          // Reconnecting after being in background while online
          goOnline();
          _wasOnlineBeforeBackground = false;
        }
      } else {
        state = state.copyWith(connectionState: connectionState);
      }
    });

    _onlineUsersSub = _socketService.onlineUsers.listen((users) {
      dev.log('👥 Online users updated: ${users.length} users');
      state = state.copyWith(
        onlineUsers: users,
        isLoading: false,
      );
    });

    _statusChangedSub = _socketService.statusChanged.listen((statusChange) {
      dev.log(
          '📊 User status changed: ${statusChange.userId} -> ${statusChange.status}');
      // Update the specific user in the list
      final updatedUsers = state.onlineUsers.map((user) {
        if (user.id == statusChange.userId) {
          return user.copyWith(status: statusChange.status);
        }
        return user;
      }).toList();

      // Remove user if they went offline
      if (statusChange.status == UserStatus.offline) {
        updatedUsers.removeWhere((user) => user.id == statusChange.userId);
      }

      state = state.copyWith(onlineUsers: updatedUsers);
    });

    _errorSub = _socketService.errors.listen((error) {
      dev.log('❌ Socket error: $error');
      state = state.copyWith(error: error);
    });
  }

  /// Connect to the socket server
  Future<void> connect() async {
    dev.log('🔌 Connecting to socket server...');
    state = state.copyWith(isLoading: true, error: null);
    await _socketService.connect();
  }

  /// Disconnect from the socket server
  void disconnect() {
    dev.log('🔌 Disconnecting from socket server...');
    _socketService.disconnect();
    _hasConnectedOnce = false; // Reset so next login will auto go online
    state = state.copyWith(
      userStatus: UserStatus.offline,
      onlineUsers: [],
    );
  }

  /// Go online
  void goOnline() {
    dev.log('🟢 Going online...');
    _socketService.goOnline();
    state = state.copyWith(userStatus: UserStatus.online);
  }

  /// Go offline
  void goOffline() {
    dev.log('🔴 Going offline...');
    _socketService.goOffline();
    state = state.copyWith(userStatus: UserStatus.offline);
  }

  /// Toggle online/offline status
  void toggleOnlineStatus() {
    if (state.isOnline) {
      goOffline();
    } else {
      goOnline();
    }
  }

  /// Update presence to waiting (called by matchmaking provider after joining queue)
  void setWaiting() {
    state = state.copyWith(userStatus: UserStatus.waiting);
  }

  /// Update presence back to online (called by matchmaking provider after leaving queue)
  void setOnlineAfterMatchmaking() {
    state = state.copyWith(userStatus: UserStatus.online);
  }

  /// Update user status to in_call
  void setInCall() {
    state = state.copyWith(userStatus: UserStatus.inCall);
  }

  /// Update user status back to online after call ends
  void setOnlineAfterCall() {
    state = state.copyWith(userStatus: UserStatus.online);
  }

  /// Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Handle app lifecycle state changes
  void handleAppLifecycleChange(AppLifecycleState appState) {
    dev.log('📱 App lifecycle state changed: $appState');

    switch (appState) {
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
        // App is going to background
        if (state.isOnline || state.isWaiting) {
          _wasOnlineBeforeBackground = true;
          goOffline();
        }
        break;
      case AppLifecycleState.resumed:
        // App is coming back to foreground
        if (_wasOnlineBeforeBackground && state.isConnected) {
          goOnline();
          _wasOnlineBeforeBackground = false;
        } else if (_wasOnlineBeforeBackground && !state.isConnected) {
          // Reconnect if we were online before
          connect();
        }
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        // App is being terminated or hidden
        break;
    }
  }
}
