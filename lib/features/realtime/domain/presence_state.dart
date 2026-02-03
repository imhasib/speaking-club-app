import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/online_user.dart';
import '../data/socket_service.dart';

part 'presence_state.freezed.dart';

/// Presence state for managing online/offline status and online users list
@freezed
sealed class PresenceState with _$PresenceState {
  const factory PresenceState({
    @Default(SocketConnectionState.disconnected)
    SocketConnectionState connectionState,
    @Default(UserStatus.offline) UserStatus userStatus,
    @Default([]) List<OnlineUser> onlineUsers,
    @Default(false) bool isLoading,
    String? error,
  }) = _PresenceState;

  const PresenceState._();

  bool get isConnected =>
      connectionState == SocketConnectionState.connected;

  bool get isOnline => userStatus == UserStatus.online;

  bool get isWaiting => userStatus == UserStatus.waiting;

  bool get isInCall => userStatus == UserStatus.inCall;
}
