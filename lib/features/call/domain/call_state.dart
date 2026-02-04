import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../shared/models/call.dart';
import '../data/webrtc_service.dart';

part 'call_state.freezed.dart';

/// Active call phase
enum CallPhase {
  /// No active call
  idle,

  /// Initiating direct call, waiting for accept
  initiating,

  /// Received incoming call
  incoming,

  /// WebRTC connecting
  connecting,

  /// Call active
  connected,

  /// Temporarily disconnected, attempting reconnection
  reconnecting,

  /// Call ending
  ending,
}

/// Call state for active call management
@freezed
sealed class CallState with _$CallState {
  const CallState._();

  const factory CallState({
    @Default(CallPhase.idle) CallPhase phase,
    String? callId,
    String? dbCallId,
    PeerInfo? peerInfo,
    @Default(false) bool isInitiator,
    @Default(CallType.random) CallType callType,
    @Default(WebRTCConnectionState.idle) WebRTCConnectionState rtcState,

    // Media state
    @Default(false) bool isAudioMuted,
    @Default(true) bool isVideoEnabled,
    @Default(false) bool isSpeakerOn,
    @Default(true) bool isFrontCamera,

    // Call timing
    DateTime? callStartTime,
    @Default(0) int callDurationSeconds,

    // Error handling
    String? error,
  }) = _CallState;

  /// Whether the call is actively connected
  bool get isActive =>
      phase == CallPhase.connected || phase == CallPhase.reconnecting;

  /// Whether the call is in connecting phase
  bool get isConnecting => phase == CallPhase.connecting;

  /// Whether there's an incoming call
  bool get isIncoming => phase == CallPhase.incoming;

  /// Whether we're initiating a call (waiting for accept)
  bool get isInitiating => phase == CallPhase.initiating;

  /// Whether the call state is idle (no call)
  bool get isIdle => phase == CallPhase.idle;

  /// Whether we're in any call-related state
  bool get isInCall =>
      phase != CallPhase.idle && phase != CallPhase.incoming;

  /// Format call duration as string (e.g., "00:05" or "01:30:45")
  String get formattedDuration {
    final hours = callDurationSeconds ~/ 3600;
    final minutes = (callDurationSeconds % 3600) ~/ 60;
    final seconds = callDurationSeconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
