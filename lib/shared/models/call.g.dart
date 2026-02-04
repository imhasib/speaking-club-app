// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Call _$CallFromJson(Map<String, dynamic> json) => _Call(
  id: json['_id'] as String,
  participants: (json['participants'] as List<dynamic>)
      .map((e) => CallParticipant.fromJson(e as Map<String, dynamic>))
      .toList(),
  initiatedBy: CallParticipant.fromJson(
    json['initiatedBy'] as Map<String, dynamic>,
  ),
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: json['endedAt'] == null
      ? null
      : DateTime.parse(json['endedAt'] as String),
  status: $enumDecode(_$CallStatusEnumMap, json['status']),
  duration: (json['duration'] as num?)?.toInt(),
  type:
      $enumDecodeNullable(_$CallTypeEnumMap, json['callType']) ??
      CallType.random,
);

Map<String, dynamic> _$CallToJson(_Call instance) => <String, dynamic>{
  '_id': instance.id,
  'participants': instance.participants,
  'initiatedBy': instance.initiatedBy,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'status': _$CallStatusEnumMap[instance.status]!,
  'duration': instance.duration,
  'callType': _$CallTypeEnumMap[instance.type]!,
};

const _$CallStatusEnumMap = {
  CallStatus.completed: 'completed',
  CallStatus.missed: 'missed',
  CallStatus.cancelled: 'cancelled',
  CallStatus.rejected: 'rejected',
};

const _$CallTypeEnumMap = {
  CallType.random: 'random',
  CallType.matchmaking: 'matchmaking',
  CallType.direct: 'direct',
};

_CallParticipant _$CallParticipantFromJson(Map<String, dynamic> json) =>
    _CallParticipant(
      id: json['_id'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$CallParticipantToJson(_CallParticipant instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
    };

_MatchmakingResult _$MatchmakingResultFromJson(Map<String, dynamic> json) =>
    _MatchmakingResult(
      callId: json['callId'] as String,
      dbCallId: json['dbCallId'] as String,
      peerId: json['peerId'] as String,
      peerInfo: PeerInfo.fromJson(json['peerInfo'] as Map<String, dynamic>),
      initiator: json['initiator'] as bool? ?? false,
    );

Map<String, dynamic> _$MatchmakingResultToJson(_MatchmakingResult instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'dbCallId': instance.dbCallId,
      'peerId': instance.peerId,
      'peerInfo': instance.peerInfo,
      'initiator': instance.initiator,
    };

_PeerInfo _$PeerInfoFromJson(Map<String, dynamic> json) => _PeerInfo(
  id: json['id'] as String,
  username: json['username'] as String,
  avatar: json['avatar'] as String?,
);

Map<String, dynamic> _$PeerInfoToJson(_PeerInfo instance) => <String, dynamic>{
  'id': instance.id,
  'username': instance.username,
  'avatar': instance.avatar,
};

_IncomingCall _$IncomingCallFromJson(Map<String, dynamic> json) =>
    _IncomingCall(
      callId: json['callId'] as String,
      dbCallId: json['dbCallId'] as String?,
      callerId: json['callerId'] as String,
      callerInfo: PeerInfo.fromJson(json['callerInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IncomingCallToJson(_IncomingCall instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'dbCallId': instance.dbCallId,
      'callerId': instance.callerId,
      'callerInfo': instance.callerInfo,
    };

_CallAccepted _$CallAcceptedFromJson(Map<String, dynamic> json) =>
    _CallAccepted(
      callId: json['callId'] as String,
      dbCallId: json['dbCallId'] as String,
      recipientInfo: PeerInfo.fromJson(
        json['recipientInfo'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$CallAcceptedToJson(_CallAccepted instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'dbCallId': instance.dbCallId,
      'recipientInfo': instance.recipientInfo,
    };

_CallRejected _$CallRejectedFromJson(Map<String, dynamic> json) =>
    _CallRejected(
      callId: json['callId'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$CallRejectedToJson(_CallRejected instance) =>
    <String, dynamic>{'callId': instance.callId, 'reason': instance.reason};

_CallCancelled _$CallCancelledFromJson(Map<String, dynamic> json) =>
    _CallCancelled(
      callId: json['callId'] as String,
      reason: json['reason'] as String,
    );

Map<String, dynamic> _$CallCancelledToJson(_CallCancelled instance) =>
    <String, dynamic>{'callId': instance.callId, 'reason': instance.reason};

_CallEnded _$CallEndedFromJson(Map<String, dynamic> json) =>
    _CallEnded(reason: json['reason'] as String);

Map<String, dynamic> _$CallEndedToJson(_CallEnded instance) =>
    <String, dynamic>{'reason': instance.reason};

_RTCSessionDesc _$RTCSessionDescFromJson(Map<String, dynamic> json) =>
    _RTCSessionDesc(type: json['type'] as String, sdp: json['sdp'] as String);

Map<String, dynamic> _$RTCSessionDescToJson(_RTCSessionDesc instance) =>
    <String, dynamic>{'type': instance.type, 'sdp': instance.sdp};

_RTCOfferSignal _$RTCOfferSignalFromJson(Map<String, dynamic> json) =>
    _RTCOfferSignal(
      from: json['from'] as String,
      offer: RTCSessionDesc.fromJson(json['offer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RTCOfferSignalToJson(_RTCOfferSignal instance) =>
    <String, dynamic>{'from': instance.from, 'offer': instance.offer};

_RTCAnswerSignal _$RTCAnswerSignalFromJson(Map<String, dynamic> json) =>
    _RTCAnswerSignal(
      from: json['from'] as String,
      answer: RTCSessionDesc.fromJson(json['answer'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$RTCAnswerSignalToJson(_RTCAnswerSignal instance) =>
    <String, dynamic>{'from': instance.from, 'answer': instance.answer};

_IceCandidateData _$IceCandidateDataFromJson(Map<String, dynamic> json) =>
    _IceCandidateData(
      candidate: json['candidate'] as String,
      sdpMid: json['sdpMid'] as String?,
      sdpMLineIndex: (json['sdpMLineIndex'] as num?)?.toInt(),
    );

Map<String, dynamic> _$IceCandidateDataToJson(_IceCandidateData instance) =>
    <String, dynamic>{
      'candidate': instance.candidate,
      'sdpMid': instance.sdpMid,
      'sdpMLineIndex': instance.sdpMLineIndex,
    };

_RTCIceSignal _$RTCIceSignalFromJson(Map<String, dynamic> json) =>
    _RTCIceSignal(
      from: json['from'] as String,
      candidate: IceCandidateData.fromJson(
        json['candidate'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$RTCIceSignalToJson(_RTCIceSignal instance) =>
    <String, dynamic>{'from': instance.from, 'candidate': instance.candidate};
