import 'package:freezed_annotation/freezed_annotation.dart';

part 'matchmaking_state.freezed.dart';

/// Matchmaking queue phase
enum MatchmakingPhase {
  /// Not in queue
  idle,

  /// Joining the queue
  joining,

  /// Waiting for a match
  waiting,

  /// Match found
  matched,

  /// Error occurred
  error,
}

/// Matchmaking state for queue management
@freezed
sealed class MatchmakingState with _$MatchmakingState {
  const MatchmakingState._();

  const factory MatchmakingState({
    @Default(MatchmakingPhase.idle) MatchmakingPhase phase,
    DateTime? joinedAt,
    @Default(0) int waitingSeconds,
    String? error,
  }) = _MatchmakingState;

  /// Whether the user is waiting in queue
  bool get isWaiting => phase == MatchmakingPhase.waiting;

  /// Whether the state is idle
  bool get isIdle => phase == MatchmakingPhase.idle;

  /// Whether a match was found
  bool get isMatched => phase == MatchmakingPhase.matched;

  /// Whether there's an error
  bool get hasError => phase == MatchmakingPhase.error;

  /// Format waiting time as string (e.g., "00:45" or "02:30")
  String get formattedWaitTime {
    final minutes = waitingSeconds ~/ 60;
    final seconds = waitingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
