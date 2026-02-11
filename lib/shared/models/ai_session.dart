import 'package:freezed_annotation/freezed_annotation.dart';

part 'ai_session.freezed.dart';
part 'ai_session.g.dart';

/// AI session mode enum
enum AiSessionMode {
  @JsonValue('free_chat')
  freeChat,
  @JsonValue('topic')
  topic,
  @JsonValue('scenario')
  scenario;

  bool get isFreeChat => this == AiSessionMode.freeChat;
  bool get isTopic => this == AiSessionMode.topic;
  bool get isScenario => this == AiSessionMode.scenario;

  /// API value for serialization (snake_case format)
  String get apiValue {
    switch (this) {
      case AiSessionMode.freeChat:
        return 'free_chat';
      case AiSessionMode.topic:
        return 'topic';
      case AiSessionMode.scenario:
        return 'scenario';
    }
  }

  String get displayName {
    switch (this) {
      case AiSessionMode.freeChat:
        return 'Free Chat';
      case AiSessionMode.topic:
        return 'Topic Discussion';
      case AiSessionMode.scenario:
        return 'Scenario Roleplay';
    }
  }
}

/// AI persona enum - currently only Emma, more planned for future
enum AiPersona {
  @JsonValue('emma')
  emma;

  String get displayName {
    switch (this) {
      case AiPersona.emma:
        return 'Emma';
    }
  }

  String get description {
    switch (this) {
      case AiPersona.emma:
        return 'Friendly English Tutor';
    }
  }
}

/// AI session model for practice history
@freezed
sealed class AiSession with _$AiSession {
  const AiSession._();

  const factory AiSession({
    @JsonKey(name: '_id') required String id,
    required String odId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required AiSessionMode mode,
    @Default(AiPersona.emma) AiPersona persona,
    String? topic,
    String? scenario,
    required List<AiMessage> messages,
    required List<Correction> corrections,
    required SessionStats stats,
  }) = _AiSession;

  factory AiSession.fromJson(Map<String, dynamic> json) =>
      _$AiSessionFromJson(json);

  /// Format duration as string (e.g., "5m 32s" or "1h 12m")
  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  /// Get topic or scenario display name
  String get topicOrScenarioDisplay {
    if (mode.isFreeChat) return 'Free Chat';
    if (mode.isTopic && topic != null) return topic!;
    if (mode.isScenario && scenario != null) return scenario!;
    return mode.displayName;
  }
}

/// AI message model for conversation transcript
@freezed
sealed class AiMessage with _$AiMessage {
  const factory AiMessage({
    required String role, // 'user' or 'assistant'
    required String content,
    required DateTime timestamp,
  }) = _AiMessage;

  factory AiMessage.fromJson(Map<String, dynamic> json) =>
      _$AiMessageFromJson(json);
}

/// Correction model for grammar/vocabulary feedback
@freezed
sealed class Correction with _$Correction {
  const factory Correction({
    required String original,
    required String corrected,
    required String explanation,
  }) = _Correction;

  factory Correction.fromJson(Map<String, dynamic> json) =>
      _$CorrectionFromJson(json);
}

/// Session stats model for speaking statistics
@freezed
sealed class SessionStats with _$SessionStats {
  const factory SessionStats({
    @Default(0) int wordsSpoken,
    @Default(0) int averageSentenceLength,
    @Default(0) int speakingTimePercent,
    @Default([]) List<String> vocabularyUsed,
  }) = _SessionStats;

  factory SessionStats.fromJson(Map<String, dynamic> json) =>
      _$SessionStatsFromJson(json);
}

/// Ephemeral key response from backend
@freezed
sealed class EphemeralKeyResponse with _$EphemeralKeyResponse {
  const factory EphemeralKeyResponse({
    required String ephemeralKey,
    required DateTime expiresAt,
    required String sessionId,
    required int remainingSeconds,
  }) = _EphemeralKeyResponse;

  factory EphemeralKeyResponse.fromJson(Map<String, dynamic> json) =>
      _$EphemeralKeyResponseFromJson(json);
}

/// AI usage info from backend
@freezed
sealed class AiUsageInfo with _$AiUsageInfo {
  const AiUsageInfo._();

  const factory AiUsageInfo({
    required int usedSeconds,
    required int remainingSeconds,
    @JsonKey(name: 'limitSeconds') required int dailyLimitSeconds,
    required DateTime resetsAt,
  }) = _AiUsageInfo;

  factory AiUsageInfo.fromJson(Map<String, dynamic> json) =>
      _$AiUsageInfoFromJson(json);

  /// Format remaining time as string (e.g., "4:32")
  String get formattedRemaining {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Check if user has time remaining
  bool get hasTimeRemaining => remainingSeconds > 0;
}

/// Topic category for topic-based discussions
@freezed
sealed class TopicCategory with _$TopicCategory {
  const factory TopicCategory({
    required String id,
    required String name,
    required String icon,
    required List<Topic> topics,
  }) = _TopicCategory;

  factory TopicCategory.fromJson(Map<String, dynamic> json) =>
      _$TopicCategoryFromJson(json);
}

/// Individual topic
@freezed
sealed class Topic with _$Topic {
  const factory Topic({
    required String id,
    required String name,
    String? description,
  }) = _Topic;

  factory Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);
}

/// Scenario for roleplay
@freezed
sealed class Scenario with _$Scenario {
  const factory Scenario({
    required String id,
    required String name,
    required String aiRole,
    required String userRole,
    required String description,
    String? instructions,
  }) = _Scenario;

  factory Scenario.fromJson(Map<String, dynamic> json) =>
      _$ScenarioFromJson(json);
}
