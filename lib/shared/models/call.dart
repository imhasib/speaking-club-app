import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'call.freezed.dart';
part 'call.g.dart';

/// Call status enum
enum CallStatus {
  @JsonValue('completed')
  completed,
  @JsonValue('missed')
  missed,
  @JsonValue('cancelled')
  cancelled;

  bool get isCompleted => this == CallStatus.completed;
  bool get isMissed => this == CallStatus.missed;
  bool get isCancelled => this == CallStatus.cancelled;
}

/// Call type enum
enum CallType {
  @JsonValue('random')
  random,
  @JsonValue('direct')
  direct;

  bool get isRandom => this == CallType.random;
  bool get isDirect => this == CallType.direct;
}

/// Call model for call history
@freezed
sealed class Call with _$Call {
  const Call._();

  const factory Call({
    required String id,
    required List<CallParticipant> participants,
    required CallParticipant initiatedBy,
    required DateTime startedAt,
    DateTime? endedAt,
    required CallStatus status,
    int? duration,
    @Default(CallType.random) CallType type,
  }) = _Call;

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);

  /// Get the other participant in a 1-on-1 call
  CallParticipant? getOtherParticipant(String currentUserId) {
    return participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => participants.first,
    );
  }

  /// Format duration as string (e.g., "5m 32s" or "1h 12m")
  String get formattedDuration {
    if (duration == null) return '--';

    final hours = duration! ~/ 3600;
    final minutes = (duration! % 3600) ~/ 60;
    final seconds = duration! % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

/// Call participant model
@freezed
sealed class CallParticipant with _$CallParticipant {
  const factory CallParticipant({
    required String id,
    required String username,
    String? avatar,
  }) = _CallParticipant;

  factory CallParticipant.fromJson(Map<String, dynamic> json) =>
      _$CallParticipantFromJson(json);

  factory CallParticipant.fromUser(User user) => CallParticipant(
        id: user.id,
        username: user.username,
        avatar: user.avatar,
      );
}

/// Matchmaking result
@freezed
sealed class MatchmakingResult with _$MatchmakingResult {
  const factory MatchmakingResult({
    required String callId,
    required String dbCallId,
    required String peerId,
    required PeerInfo peerInfo,
    required bool initiator,
  }) = _MatchmakingResult;

  factory MatchmakingResult.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingResultFromJson(json);
}

/// Peer info in matchmaking
@freezed
sealed class PeerInfo with _$PeerInfo {
  const factory PeerInfo({
    required String id,
    required String username,
    String? avatar,
  }) = _PeerInfo;

  factory PeerInfo.fromJson(Map<String, dynamic> json) =>
      _$PeerInfoFromJson(json);
}

/// Incoming call info for direct calls
@freezed
sealed class IncomingCall with _$IncomingCall {
  const factory IncomingCall({
    required String callId,
    required String callerId,
    required PeerInfo callerInfo,
  }) = _IncomingCall;

  factory IncomingCall.fromJson(Map<String, dynamic> json) =>
      _$IncomingCallFromJson(json);
}
