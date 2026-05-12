import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/ai_session.dart';
import '../../../home/presentation/providers/streak_provider.dart';
import '../../data/ai_session_repository.dart';

/// Lifecycle status of the post-session analysis.
enum AnalysisStatus {
  none,
  pending,
  completed,
  failed,
}

AnalysisStatus _statusFromString(String? raw) {
  switch (raw) {
    case 'pending':
      return AnalysisStatus.pending;
    case 'completed':
      return AnalysisStatus.completed;
    case 'failed':
      return AnalysisStatus.failed;
    default:
      return AnalysisStatus.none;
  }
}

/// Snapshot of data needed by the summary screen.
class AiSummaryState {
  final String? sessionId;
  final int durationSeconds;
  final SessionStats? stats;
  final List<Correction> corrections;

  /// Mistakes returned by the session-detail endpoint (extended in M3).
  /// Each entry has the same shape as a [Correction] for the summary list.
  final List<Correction> mistakes;

  /// New vocab words introduced this session.
  final List<String> newWords;

  /// Accuracy percentage for the session (0-100), null if not yet computed.
  final int? accuracyPct;

  final AnalysisStatus analysisStatus;

  const AiSummaryState({
    this.sessionId,
    this.durationSeconds = 0,
    this.stats,
    this.corrections = const [],
    this.mistakes = const [],
    this.newWords = const [],
    this.accuracyPct,
    this.analysisStatus = AnalysisStatus.none,
  });

  AiSummaryState copyWith({
    String? sessionId,
    int? durationSeconds,
    SessionStats? stats,
    List<Correction>? corrections,
    List<Correction>? mistakes,
    List<String>? newWords,
    Object? accuracyPct = _Sentinel,
    AnalysisStatus? analysisStatus,
  }) {
    return AiSummaryState(
      sessionId: sessionId ?? this.sessionId,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      stats: stats ?? this.stats,
      corrections: corrections ?? this.corrections,
      mistakes: mistakes ?? this.mistakes,
      newWords: newWords ?? this.newWords,
      accuracyPct: accuracyPct == _Sentinel
          ? this.accuracyPct
          : accuracyPct as int?,
      analysisStatus: analysisStatus ?? this.analysisStatus,
    );
  }
}

class _Sentinel {
  const _Sentinel._();
}

/// Holds the last session's summary data and polls the server for the
/// async analysis result.
class AiSummaryNotifier extends Notifier<AiSummaryState> {
  Timer? _pollTimer;
  Timer? _pollTimeoutTimer;
  bool _disposed = false;

  @override
  AiSummaryState build() {
    ref.onDispose(() {
      _disposed = true;
      _pollTimer?.cancel();
      _pollTimeoutTimer?.cancel();
    });
    return const AiSummaryState();
  }

  /// Called by [AiPracticeNotifier.endSession] before navigation. Seeds the
  /// screen with locally-computed values, then kicks off a poll for the
  /// server-side analysis (mistakes / new words / accuracy).
  void set({
    required int durationSeconds,
    required SessionStats stats,
    required List<Correction> corrections,
    String? sessionId,
  }) {
    _pollTimer?.cancel();
    _pollTimeoutTimer?.cancel();
    state = AiSummaryState(
      sessionId: sessionId,
      durationSeconds: durationSeconds,
      stats: stats,
      corrections: corrections,
      analysisStatus: sessionId != null
          ? AnalysisStatus.pending
          : AnalysisStatus.none,
    );

    if (sessionId != null) {
      _startPolling(sessionId);
    }
  }

  /// Poll `/ai/sessions/:id` every 3s for up to 30s waiting for the analysis
  /// to flip from `pending` to `completed` or `failed`.
  void _startPolling(String sessionId) {
    final repo = ref.read(aiSessionRepositoryProvider);

    Future<void> pollOnce() async {
      if (_disposed) return;
      try {
        // Use the raw fetch so we can read the extended fields
        // (mistakes, newWords, accuracyPct, analysisStatus) that aren't part
        // of the strongly-typed [AiSession] yet.
        final raw = await repo.getSessionRaw(sessionId);
        if (_disposed) return;
        _applyRaw(raw);
      } catch (_) {
        // Silent — the next poll will retry.  If the timeout fires before
        // success we leave the screen showing the local values.
      }
    }

    // Fire once immediately, then on a periodic schedule.
    pollOnce();
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (state.analysisStatus == AnalysisStatus.completed ||
          state.analysisStatus == AnalysisStatus.failed) {
        _pollTimer?.cancel();
        _pollTimer = null;
        return;
      }
      pollOnce();
    });

    // Hard cap at 30s — if the server is still pending, give up gracefully.
    _pollTimeoutTimer = Timer(const Duration(seconds: 30), () {
      _pollTimer?.cancel();
      _pollTimer = null;
      if (_disposed) return;
      if (state.analysisStatus == AnalysisStatus.pending) {
        state = state.copyWith(analysisStatus: AnalysisStatus.failed);
      }
    });
  }

  /// Read the extended fields off the raw session payload.
  void _applyRaw(Map<String, dynamic> raw) {
    final analysisStatus =
        _statusFromString(raw['analysisStatus'] as String?);
    final accuracy =
        raw['accuracyPct'] is num ? (raw['accuracyPct'] as num).toInt() : null;
    final newWords = (raw['newWords'] as List<dynamic>? ?? const [])
        .map((e) => e is Map ? (e['word'] ?? '').toString() : e.toString())
        .where((w) => w.isNotEmpty)
        .toList();
    final mistakesRaw = (raw['mistakes'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(
          (m) => Correction(
            original: (m['wrong'] ?? m['original'] ?? '').toString(),
            corrected: (m['right'] ?? m['corrected'] ?? '').toString(),
            explanation: (m['explanation'] ?? '').toString(),
          ),
        )
        .toList();

    // If the server doesn't include analysisStatus at all yet, treat the
    // arrival of any analysis fields as "completed".
    final resolvedStatus = analysisStatus == AnalysisStatus.none
        ? (accuracy != null || mistakesRaw.isNotEmpty || newWords.isNotEmpty
            ? AnalysisStatus.completed
            : state.analysisStatus)
        : analysisStatus;

    final priorStatus = state.analysisStatus;
    state = state.copyWith(
      mistakes: mistakesRaw.isEmpty ? state.mistakes : mistakesRaw,
      newWords: newWords.isEmpty ? state.newWords : newWords,
      accuracyPct: accuracy,
      analysisStatus: resolvedStatus,
    );

    // When the server-side post-session analysis flips to "completed", the
    // streak / activity / lifetime-stats writes have all landed (recordActivity
    // runs before analysisStatus = 'completed' on the server). Invalidate the
    // Home/Profile providers so the next read reflects the new numbers
    // instead of the cached zero-streak from before the session started.
    if (resolvedStatus == AnalysisStatus.completed &&
        priorStatus != AnalysisStatus.completed) {
      ref.invalidate(streakProvider);
      ref.invalidate(userStatsProvider);
    }
  }
}

final aiSummaryProvider =
    NotifierProvider<AiSummaryNotifier, AiSummaryState>(AiSummaryNotifier.new);
