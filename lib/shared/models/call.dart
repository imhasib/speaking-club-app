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
  cancelled,
  @JsonValue('rejected')
  rejected;

  bool get isCompleted => this == CallStatus.completed;
  bool get isMissed => this == CallStatus.missed;
  bool get isCancelled => this == CallStatus.cancelled;
  bool get isRejected => this == CallStatus.rejected;
}

/// Call type enum
enum CallType {
  @JsonValue('random')
  random,
  @JsonValue('matchmaking')
  matchmaking,
  @JsonValue('direct')
  direct;

  bool get isRandom => this == CallType.random || this == CallType.matchmaking;
  bool get isDirect => this == CallType.direct;
}

/// Call model for call history
@freezed
sealed class Call with _$Call {
  const Call._();

  const factory Call({
    @JsonKey(name: '_id') required String id,
    required List<CallParticipant> participants,
    required CallParticipant initiatedBy,
    required DateTime startedAt,
    DateTime? endedAt,
    required CallStatus status,
    int? duration,
    @JsonKey(name: 'callType') @Default(CallType.random) CallType type,
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
    @JsonKey(name: '_id') required String id,
    required String name,
    String? profilePicture,
  }) = _CallParticipant;

  factory CallParticipant.fromJson(Map<String, dynamic> json) =>
      _$CallParticipantFromJson(json);

  factory CallParticipant.fromUser(User user) => CallParticipant(
        id: user.id,
        name: user.name,
        profilePicture: user.profilePicture,
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
    @Default(false) bool initiator,
  }) = _MatchmakingResult;

  factory MatchmakingResult.fromJson(Map<String, dynamic> json) =>
      _$MatchmakingResultFromJson(json);
}

/// Peer info in matchmaking
@freezed
sealed class PeerInfo with _$PeerInfo {
  const factory PeerInfo({
    required String id,
    required String name,
    String? profilePicture,
  }) = _PeerInfo;

  factory PeerInfo.fromJson(Map<String, dynamic> json) =>
      _$PeerInfoFromJson(json);
}

/// Incoming call info for direct calls
@freezed
sealed class IncomingCall with _$IncomingCall {
  const factory IncomingCall({
    required String callId,
    String? dbCallId,
    required String callerId,
    required PeerInfo callerInfo,
  }) = _IncomingCall;

  factory IncomingCall.fromJson(Map<String, dynamic> json) =>
      _$IncomingCallFromJson(json);
}

/// Call accepted response (for direct calls)
@freezed
sealed class CallAccepted with _$CallAccepted {
  const factory CallAccepted({
    required String callId,
    required String dbCallId,
    required PeerInfo recipientInfo,
  }) = _CallAccepted;

  factory CallAccepted.fromJson(Map<String, dynamic> json) =>
      _$CallAcceptedFromJson(json);
}

/// Call rejected response
@freezed
sealed class CallRejected with _$CallRejected {
  const factory CallRejected({
    required String callId,
    required String reason, // 'rejected', 'busy'
  }) = _CallRejected;

  factory CallRejected.fromJson(Map<String, dynamic> json) =>
      _$CallRejectedFromJson(json);
}

/// Call cancelled response
@freezed
sealed class CallCancelled with _$CallCancelled {
  const factory CallCancelled({
    required String callId,
    required String reason, // 'timeout', 'caller_cancelled', 'recipient_offline'
  }) = _CallCancelled;

  factory CallCancelled.fromJson(Map<String, dynamic> json) =>
      _$CallCancelledFromJson(json);
}

/// Call ended response
@freezed
sealed class CallEnded with _$CallEnded {
  const factory CallEnded({
    required String reason, // 'User ended call', 'Peer ended call', 'Peer disconnected'
  }) = _CallEnded;

  factory CallEnded.fromJson(Map<String, dynamic> json) =>
      _$CallEndedFromJson(json);
}

/// WebRTC session description (offer/answer)
@freezed
sealed class RTCSessionDesc with _$RTCSessionDesc {
  const factory RTCSessionDesc({
    required String type, // 'offer' or 'answer'
    required String sdp,
  }) = _RTCSessionDesc;

  factory RTCSessionDesc.fromJson(Map<String, dynamic> json) =>
      _$RTCSessionDescFromJson(json);
}

/// WebRTC offer signal (incoming)
@freezed
sealed class RTCOfferSignal with _$RTCOfferSignal {
  const factory RTCOfferSignal({
    required String from,
    required RTCSessionDesc offer,
  }) = _RTCOfferSignal;

  factory RTCOfferSignal.fromJson(Map<String, dynamic> json) =>
      _$RTCOfferSignalFromJson(json);
}

/// WebRTC answer signal (incoming)
@freezed
sealed class RTCAnswerSignal with _$RTCAnswerSignal {
  const factory RTCAnswerSignal({
    required String from,
    required RTCSessionDesc answer,
  }) = _RTCAnswerSignal;

  factory RTCAnswerSignal.fromJson(Map<String, dynamic> json) =>
      _$RTCAnswerSignalFromJson(json);
}

/// ICE candidate data
@freezed
sealed class IceCandidateData with _$IceCandidateData {
  const factory IceCandidateData({
    required String candidate,
    String? sdpMid,
    int? sdpMLineIndex,
  }) = _IceCandidateData;

  factory IceCandidateData.fromJson(Map<String, dynamic> json) =>
      _$IceCandidateDataFromJson(json);
}

/// WebRTC ICE candidate signal (incoming)
@freezed
sealed class RTCIceSignal with _$RTCIceSignal {
  const factory RTCIceSignal({
    required String from,
    required IceCandidateData candidate,
  }) = _RTCIceSignal;

  factory RTCIceSignal.fromJson(Map<String, dynamic> json) =>
      _$RTCIceSignalFromJson(json);
}
