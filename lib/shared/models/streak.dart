import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak.freezed.dart';
part 'streak.g.dart';

/// Daily streak info for the Home screen streak card.
@freezed
sealed class Streak with _$Streak {
  const factory Streak({
    @Default(0) int streakDays,
    @Default(0) int todayMinutes,
    @Default(5) int dailyGoalMinutes,
    @Default([false, false, false, false, false, false, false])
    List<bool> weekDays,
  }) = _Streak;

  factory Streak.fromJson(Map<String, dynamic> json) => _$StreakFromJson(json);
}

/// Aggregated lifetime stats shown on the Profile screen.
@freezed
sealed class UserStats with _$UserStats {
  const factory UserStats({
    @Default(0) int totalSessions,
    @Default(0) int totalWords,
    @Default(0) int streakDays,
    DateTime? memberSince,
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
