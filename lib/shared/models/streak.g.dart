// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Streak _$StreakFromJson(Map<String, dynamic> json) => _Streak(
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  todayMinutes: (json['todayMinutes'] as num?)?.toInt() ?? 0,
  dailyGoalMinutes: (json['dailyGoalMinutes'] as num?)?.toInt() ?? 5,
  weekDays:
      (json['weekDays'] as List<dynamic>?)?.map((e) => e as bool).toList() ??
      const [false, false, false, false, false, false, false],
);

Map<String, dynamic> _$StreakToJson(_Streak instance) => <String, dynamic>{
  'streakDays': instance.streakDays,
  'todayMinutes': instance.todayMinutes,
  'dailyGoalMinutes': instance.dailyGoalMinutes,
  'weekDays': instance.weekDays,
};

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
  totalSessions: (json['totalSessions'] as num?)?.toInt() ?? 0,
  totalWords: (json['totalWords'] as num?)?.toInt() ?? 0,
  streakDays: (json['streakDays'] as num?)?.toInt() ?? 0,
  memberSince: json['memberSince'] == null
      ? null
      : DateTime.parse(json['memberSince'] as String),
);

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'totalSessions': instance.totalSessions,
      'totalWords': instance.totalWords,
      'streakDays': instance.streakDays,
      'memberSince': instance.memberSince?.toIso8601String(),
    };
