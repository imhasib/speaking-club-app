// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ai_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AiSession _$AiSessionFromJson(Map<String, dynamic> json) => _AiSession(
  id: json['id'] as String,
  odId: json['odId'] as String,
  startedAt: DateTime.parse(json['startedAt'] as String),
  endedAt: DateTime.parse(json['endedAt'] as String),
  durationSeconds: (json['durationSeconds'] as num).toInt(),
  mode: $enumDecode(_$AiSessionModeEnumMap, json['mode']),
  persona:
      $enumDecodeNullable(_$AiPersonaEnumMap, json['persona']) ??
      AiPersona.emma,
  topic: json['topic'] as String?,
  scenario: json['scenario'] as String?,
  messages: (json['messages'] as List<dynamic>)
      .map((e) => AiMessage.fromJson(e as Map<String, dynamic>))
      .toList(),
  corrections: (json['corrections'] as List<dynamic>)
      .map((e) => Correction.fromJson(e as Map<String, dynamic>))
      .toList(),
  stats: SessionStats.fromJson(json['stats'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AiSessionToJson(_AiSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'odId': instance.odId,
      'startedAt': instance.startedAt.toIso8601String(),
      'endedAt': instance.endedAt.toIso8601String(),
      'durationSeconds': instance.durationSeconds,
      'mode': _$AiSessionModeEnumMap[instance.mode]!,
      'persona': _$AiPersonaEnumMap[instance.persona]!,
      'topic': instance.topic,
      'scenario': instance.scenario,
      'messages': instance.messages,
      'corrections': instance.corrections,
      'stats': instance.stats,
    };

const _$AiSessionModeEnumMap = {
  AiSessionMode.freeChat: 'free_chat',
  AiSessionMode.topic: 'topic',
  AiSessionMode.scenario: 'scenario',
};

const _$AiPersonaEnumMap = {AiPersona.emma: 'emma'};

_AiMessage _$AiMessageFromJson(Map<String, dynamic> json) => _AiMessage(
  role: json['role'] as String,
  content: json['content'] as String,
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$AiMessageToJson(_AiMessage instance) =>
    <String, dynamic>{
      'role': instance.role,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
    };

_Correction _$CorrectionFromJson(Map<String, dynamic> json) => _Correction(
  original: json['original'] as String,
  corrected: json['corrected'] as String,
  explanation: json['explanation'] as String,
);

Map<String, dynamic> _$CorrectionToJson(_Correction instance) =>
    <String, dynamic>{
      'original': instance.original,
      'corrected': instance.corrected,
      'explanation': instance.explanation,
    };

_SessionStats _$SessionStatsFromJson(Map<String, dynamic> json) =>
    _SessionStats(
      wordsSpoken: (json['wordsSpoken'] as num?)?.toInt() ?? 0,
      averageSentenceLength:
          (json['averageSentenceLength'] as num?)?.toInt() ?? 0,
      speakingTimePercent: (json['speakingTimePercent'] as num?)?.toInt() ?? 0,
      vocabularyUsed:
          (json['vocabularyUsed'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$SessionStatsToJson(_SessionStats instance) =>
    <String, dynamic>{
      'wordsSpoken': instance.wordsSpoken,
      'averageSentenceLength': instance.averageSentenceLength,
      'speakingTimePercent': instance.speakingTimePercent,
      'vocabularyUsed': instance.vocabularyUsed,
    };

_EphemeralKeyResponse _$EphemeralKeyResponseFromJson(
  Map<String, dynamic> json,
) => _EphemeralKeyResponse(
  ephemeralKey: json['ephemeralKey'] as String,
  expiresAt: DateTime.parse(json['expiresAt'] as String),
  sessionId: json['sessionId'] as String,
  remainingSeconds: (json['remainingSeconds'] as num).toInt(),
);

Map<String, dynamic> _$EphemeralKeyResponseToJson(
  _EphemeralKeyResponse instance,
) => <String, dynamic>{
  'ephemeralKey': instance.ephemeralKey,
  'expiresAt': instance.expiresAt.toIso8601String(),
  'sessionId': instance.sessionId,
  'remainingSeconds': instance.remainingSeconds,
};

_AiUsageInfo _$AiUsageInfoFromJson(Map<String, dynamic> json) => _AiUsageInfo(
  usedSeconds: (json['usedSeconds'] as num).toInt(),
  remainingSeconds: (json['remainingSeconds'] as num).toInt(),
  dailyLimitSeconds: (json['limitSeconds'] as num).toInt(),
  resetsAt: DateTime.parse(json['resetsAt'] as String),
);

Map<String, dynamic> _$AiUsageInfoToJson(_AiUsageInfo instance) =>
    <String, dynamic>{
      'usedSeconds': instance.usedSeconds,
      'remainingSeconds': instance.remainingSeconds,
      'limitSeconds': instance.dailyLimitSeconds,
      'resetsAt': instance.resetsAt.toIso8601String(),
    };

_TopicCategory _$TopicCategoryFromJson(Map<String, dynamic> json) =>
    _TopicCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
      topics: (json['topics'] as List<dynamic>)
          .map((e) => Topic.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TopicCategoryToJson(_TopicCategory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'icon': instance.icon,
      'topics': instance.topics,
    };

_Topic _$TopicFromJson(Map<String, dynamic> json) => _Topic(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String?,
);

Map<String, dynamic> _$TopicToJson(_Topic instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
};

_Scenario _$ScenarioFromJson(Map<String, dynamic> json) => _Scenario(
  id: json['id'] as String,
  name: json['name'] as String,
  aiRole: json['aiRole'] as String,
  userRole: json['userRole'] as String,
  description: json['description'] as String,
  instructions: json['instructions'] as String?,
);

Map<String, dynamic> _$ScenarioToJson(_Scenario instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'aiRole': instance.aiRole,
  'userRole': instance.userRole,
  'description': instance.description,
  'instructions': instance.instructions,
};
