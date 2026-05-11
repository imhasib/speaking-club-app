// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vocab_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WordExample _$WordExampleFromJson(Map<String, dynamic> json) => _WordExample(
  sessionLabel: json['sessionLabel'] as String?,
  sessionId: json['sessionId'] as String?,
  text: json['text'] as String,
  highlightStart: (json['highlightStart'] as num?)?.toInt() ?? 0,
  highlightEnd: (json['highlightEnd'] as num?)?.toInt() ?? 0,
  isCorrect: json['isCorrect'] as bool? ?? true,
  correction: json['correction'] as String?,
);

Map<String, dynamic> _$WordExampleToJson(_WordExample instance) =>
    <String, dynamic>{
      'sessionLabel': instance.sessionLabel,
      'sessionId': instance.sessionId,
      'text': instance.text,
      'highlightStart': instance.highlightStart,
      'highlightEnd': instance.highlightEnd,
      'isCorrect': instance.isCorrect,
      'correction': instance.correction,
    };

_UserWord _$UserWordFromJson(Map<String, dynamic> json) => _UserWord(
  word: json['word'] as String,
  count: (json['count'] as num?)?.toInt() ?? 0,
  usagePct: (json['usagePct'] as num?)?.toInt() ?? 0,
  isCorrect: json['isCorrect'] as bool? ?? true,
  examples:
      (json['examples'] as List<dynamic>?)
          ?.map((e) => WordExample.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$UserWordToJson(_UserWord instance) => <String, dynamic>{
  'word': instance.word,
  'count': instance.count,
  'usagePct': instance.usagePct,
  'isCorrect': instance.isCorrect,
  'examples': instance.examples,
};

_VocabStats _$VocabStatsFromJson(Map<String, dynamic> json) => _VocabStats(
  uniqueWords: (json['uniqueWords'] as num?)?.toInt() ?? 0,
  correctUsagePct: (json['correctUsagePct'] as num?)?.toInt() ?? 0,
  sessions: (json['sessions'] as num?)?.toInt() ?? 0,
  totalHours: (json['totalHours'] as num?)?.toDouble() ?? 0,
  weeklyNewWords: (json['weeklyNewWords'] as num?)?.toInt() ?? 0,
  usageTrend: json['usageTrend'] as String?,
);

Map<String, dynamic> _$VocabStatsToJson(_VocabStats instance) =>
    <String, dynamic>{
      'uniqueWords': instance.uniqueWords,
      'correctUsagePct': instance.correctUsagePct,
      'sessions': instance.sessions,
      'totalHours': instance.totalHours,
      'weeklyNewWords': instance.weeklyNewWords,
      'usageTrend': instance.usageTrend,
    };

_RarelyUsedWord _$RarelyUsedWordFromJson(Map<String, dynamic> json) =>
    _RarelyUsedWord(
      word: json['word'] as String,
      count: (json['count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RarelyUsedWordToJson(_RarelyUsedWord instance) =>
    <String, dynamic>{'word': instance.word, 'count': instance.count};

_NeedsImprovementWord _$NeedsImprovementWordFromJson(
  Map<String, dynamic> json,
) => _NeedsImprovementWord(
  word: json['word'] as String,
  misuses: (json['misuses'] as num?)?.toInt() ?? 0,
  example: json['example'] as String?,
  correction: json['correction'] as String?,
);

Map<String, dynamic> _$NeedsImprovementWordToJson(
  _NeedsImprovementWord instance,
) => <String, dynamic>{
  'word': instance.word,
  'misuses': instance.misuses,
  'example': instance.example,
  'correction': instance.correction,
};

_VocabSummary _$VocabSummaryFromJson(Map<String, dynamic> json) =>
    _VocabSummary(
      stats: VocabStats.fromJson(json['stats'] as Map<String, dynamic>),
      rarelyUsed:
          (json['rarelyUsed'] as List<dynamic>?)
              ?.map((e) => RarelyUsedWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      needsImprovement:
          (json['needsImprovement'] as List<dynamic>?)
              ?.map(
                (e) => NeedsImprovementWord.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      allWords:
          (json['allWords'] as List<dynamic>?)
              ?.map((e) => UserWord.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$VocabSummaryToJson(_VocabSummary instance) =>
    <String, dynamic>{
      'stats': instance.stats,
      'rarelyUsed': instance.rarelyUsed,
      'needsImprovement': instance.needsImprovement,
      'allWords': instance.allWords,
    };
