// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mistake_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Mistake _$MistakeFromJson(Map<String, dynamic> json) => _Mistake(
  id: json['id'] as String,
  category: $enumDecode(_$MistakeCategoryEnumMap, json['category']),
  wrong: json['wrong'] as String,
  right: json['right'] as String,
  explanation: json['explanation'] as String,
  sessionLabel: json['sessionLabel'] as String?,
  sessionId: json['sessionId'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  isFixed: json['isFixed'] as bool? ?? false,
  savedToVocab: json['savedToVocab'] as bool? ?? false,
);

Map<String, dynamic> _$MistakeToJson(_Mistake instance) => <String, dynamic>{
  'id': instance.id,
  'category': _$MistakeCategoryEnumMap[instance.category]!,
  'wrong': instance.wrong,
  'right': instance.right,
  'explanation': instance.explanation,
  'sessionLabel': instance.sessionLabel,
  'sessionId': instance.sessionId,
  'createdAt': instance.createdAt.toIso8601String(),
  'isFixed': instance.isFixed,
  'savedToVocab': instance.savedToVocab,
};

const _$MistakeCategoryEnumMap = {
  MistakeCategory.grammar: 'grammar',
  MistakeCategory.vocabulary: 'vocabulary',
  MistakeCategory.fluency: 'fluency',
  MistakeCategory.pronunciation: 'pronunciation',
};

_MistakesSummary _$MistakesSummaryFromJson(Map<String, dynamic> json) =>
    _MistakesSummary(
      thisWeek: (json['thisWeek'] as num?)?.toInt() ?? 0,
      fixed: (json['fixed'] as num?)?.toInt() ?? 0,
      trend: json['trend'] as String?,
    );

Map<String, dynamic> _$MistakesSummaryToJson(_MistakesSummary instance) =>
    <String, dynamic>{
      'thisWeek': instance.thisWeek,
      'fixed': instance.fixed,
      'trend': instance.trend,
    };
