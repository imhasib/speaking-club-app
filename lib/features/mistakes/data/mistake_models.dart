import 'package:freezed_annotation/freezed_annotation.dart';

part 'mistake_models.freezed.dart';
part 'mistake_models.g.dart';

/// Mistake category classification.
enum MistakeCategory {
  @JsonValue('grammar')
  grammar,
  @JsonValue('vocabulary')
  vocabulary,
  @JsonValue('fluency')
  fluency,
  @JsonValue('pronunciation')
  pronunciation;

  String get apiValue {
    switch (this) {
      case MistakeCategory.grammar:
        return 'grammar';
      case MistakeCategory.vocabulary:
        return 'vocabulary';
      case MistakeCategory.fluency:
        return 'fluency';
      case MistakeCategory.pronunciation:
        return 'pronunciation';
    }
  }

  String get label {
    switch (this) {
      case MistakeCategory.grammar:
        return 'Grammar';
      case MistakeCategory.vocabulary:
        return 'Vocabulary';
      case MistakeCategory.fluency:
        return 'Fluency';
      case MistakeCategory.pronunciation:
        return 'Pronunciation';
    }
  }
}

/// A single mistake captured from an AI practice session.
@freezed
sealed class Mistake with _$Mistake {
  const factory Mistake({
    required String id,
    required MistakeCategory category,
    required String wrong,
    required String right,
    required String explanation,
    String? sessionLabel,
    String? sessionId,
    required DateTime createdAt,
    @Default(false) bool isFixed,
    @Default(false) bool savedToVocab,
  }) = _Mistake;

  factory Mistake.fromJson(Map<String, dynamic> json) => _$MistakeFromJson(json);
}

/// Weekly summary numbers for the Mistakes screen header.
@freezed
sealed class MistakesSummary with _$MistakesSummary {
  const factory MistakesSummary({
    @Default(0) int thisWeek,
    @Default(0) int fixed,
    int? trend,
  }) = _MistakesSummary;

  factory MistakesSummary.fromJson(Map<String, dynamic> json) =>
      _$MistakesSummaryFromJson(json);
}

/// Cursor-paginated mistakes response.
class MistakesPage {
  final List<Mistake> mistakes;
  final MistakesSummary summary;
  final String? cursor;

  const MistakesPage({
    required this.mistakes,
    required this.summary,
    this.cursor,
  });

  factory MistakesPage.fromApiResponse(Map<String, dynamic> raw) {
    // Server returns the flat payload directly: { items, nextCursor, summary }.
    final mistakes = (raw['items'] as List<dynamic>? ?? const [])
        .map((e) => Mistake.fromJson(e as Map<String, dynamic>))
        .toList();
    final summaryJson = raw['summary'];
    final summary = summaryJson is Map<String, dynamic>
        ? MistakesSummary.fromJson(summaryJson)
        : const MistakesSummary();
    return MistakesPage(
      mistakes: mistakes,
      summary: summary,
      cursor: raw['nextCursor'] as String?,
    );
  }
}
