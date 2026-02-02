// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'call.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Call _$CallFromJson(Map<String, dynamic> json) => _Call(
  id: json['id'] as String,
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
  type: $enumDecodeNullable(_$CallTypeEnumMap, json['type']) ?? CallType.random,
);

Map<String, dynamic> _$CallToJson(_Call instance) => <String, dynamic>{
  'id': instance.id,
  'participants': instance.participants,
  'initiatedBy': instance.initiatedBy,
  'startedAt': instance.startedAt.toIso8601String(),
  'endedAt': instance.endedAt?.toIso8601String(),
  'status': _$CallStatusEnumMap[instance.status]!,
  'duration': instance.duration,
  'type': _$CallTypeEnumMap[instance.type]!,
};

const _$CallStatusEnumMap = {
  CallStatus.completed: 'completed',
  CallStatus.missed: 'missed',
  CallStatus.cancelled: 'cancelled',
};

const _$CallTypeEnumMap = {
  CallType.random: 'random',
  CallType.direct: 'direct',
};

_CallParticipant _$CallParticipantFromJson(Map<String, dynamic> json) =>
    _CallParticipant(
      id: json['id'] as String,
      username: json['username'] as String,
      avatar: json['avatar'] as String?,
    );

Map<String, dynamic> _$CallParticipantToJson(_CallParticipant instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
    };

_MatchmakingResult _$MatchmakingResultFromJson(Map<String, dynamic> json) =>
    _MatchmakingResult(
      callId: json['callId'] as String,
      dbCallId: json['dbCallId'] as String,
      peerId: json['peerId'] as String,
      peerInfo: PeerInfo.fromJson(json['peerInfo'] as Map<String, dynamic>),
      initiator: json['initiator'] as bool,
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
      callerId: json['callerId'] as String,
      callerInfo: PeerInfo.fromJson(json['callerInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$IncomingCallToJson(_IncomingCall instance) =>
    <String, dynamic>{
      'callId': instance.callId,
      'callerId': instance.callerId,
      'callerInfo': instance.callerInfo,
    };
