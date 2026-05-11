import 'package:freezed_annotation/freezed_annotation.dart';

part 'vocab_models.freezed.dart';
part 'vocab_models.g.dart';

/// Word usage example from a previous session.
@freezed
sealed class WordExample with _$WordExample {
  const factory WordExample({
    String? sessionLabel,
    String? sessionId,
    required String text,
    @Default(0) int highlightStart,
    @Default(0) int highlightEnd,
    @Default(true) bool isCorrect,
    String? correction,
  }) = _WordExample;

  factory WordExample.fromJson(Map<String, dynamic> json) =>
      _$WordExampleFromJson(json);
}

/// A single word in the user's vocabulary with usage stats + examples.
@freezed
sealed class UserWord with _$UserWord {
  const factory UserWord({
    required String word,
    @Default(0) int count,
    @Default(0) int usagePct,
    @Default(true) bool isCorrect,
    @Default([]) List<WordExample> examples,
  }) = _UserWord;

  factory UserWord.fromJson(Map<String, dynamic> json) =>
      _$UserWordFromJson(json);
}

/// Aggregated vocab stats for the dashboard header.
@freezed
sealed class VocabStats with _$VocabStats {
  const factory VocabStats({
    @Default(0) int uniqueWords,
    @Default(0) int correctUsagePct,
    @Default(0) int sessions,
    @Default(0) double totalHours,
    @Default(0) int weeklyNewWords,
    String? usageTrend,
  }) = _VocabStats;

  factory VocabStats.fromJson(Map<String, dynamic> json) =>
      _$VocabStatsFromJson(json);
}

/// Compact "rarely used" word entry on the dashboard.
@freezed
sealed class RarelyUsedWord with _$RarelyUsedWord {
  const factory RarelyUsedWord({
    required String word,
    @Default(0) int count,
  }) = _RarelyUsedWord;

  factory RarelyUsedWord.fromJson(Map<String, dynamic> json) =>
      _$RarelyUsedWordFromJson(json);
}

/// "Needs improvement" entry — word + example wrong/right pair.
@freezed
sealed class NeedsImprovementWord with _$NeedsImprovementWord {
  const factory NeedsImprovementWord({
    required String word,
    @Default(0) int misuses,
    String? example,
    String? correction,
  }) = _NeedsImprovementWord;

  factory NeedsImprovementWord.fromJson(Map<String, dynamic> json) =>
      _$NeedsImprovementWordFromJson(json);
}

/// Full payload returned by `GET /vocab` — stats + dashboard sections.
@freezed
sealed class VocabSummary with _$VocabSummary {
  const factory VocabSummary({
    required VocabStats stats,
    @Default([]) List<RarelyUsedWord> rarelyUsed,
    @Default([]) List<NeedsImprovementWord> needsImprovement,
    @Default([]) List<UserWord> allWords,
  }) = _VocabSummary;

  factory VocabSummary.fromJson(Map<String, dynamic> json) =>
      _$VocabSummaryFromJson(json);
}

/// Cursor-paginated word list page (browser).
class WordsPage {
  final List<UserWord> words;
  final String? cursor;

  const WordsPage({required this.words, this.cursor});

  factory WordsPage.fromApiResponse(Map<String, dynamic> response) {
    final raw = response['data'] is Map<String, dynamic>
        ? response['data'] as Map<String, dynamic>
        : response;
    final words = (raw['words'] as List<dynamic>? ?? const [])
        .map((e) => UserWord.fromJson(e as Map<String, dynamic>))
        .toList();
    return WordsPage(
      words: words,
      cursor: raw['nextCursor'] as String?,
    );
  }
}

/// Word sort options for the "Browse all words" list.
enum WordSort {
  count,
  recent,
  az;

  String get apiValue {
    switch (this) {
      case WordSort.count:
        return 'count';
      case WordSort.recent:
        return 'recent';
      case WordSort.az:
        return 'az';
    }
  }

  String get label {
    switch (this) {
      case WordSort.count:
        return 'Count';
      case WordSort.recent:
        return 'Recent';
      case WordSort.az:
        return 'A–Z';
    }
  }
}

/// Word filter options for the "Browse all words" list.
enum WordFilter {
  all,
  correct,
  errors;

  String get apiValue {
    switch (this) {
      case WordFilter.all:
        return 'all';
      case WordFilter.correct:
        return 'correct';
      case WordFilter.errors:
        return 'errors';
    }
  }

  String get label {
    switch (this) {
      case WordFilter.all:
        return 'All';
      case WordFilter.correct:
        return 'Correct';
      case WordFilter.errors:
        return 'Errors';
    }
  }
}
