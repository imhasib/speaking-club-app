import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/ai_session.dart';

/// Snapshot of data needed by the summary screen.
class AiSummaryState {
  final int durationSeconds;
  final SessionStats? stats;
  final List<Correction> corrections;

  const AiSummaryState({
    this.durationSeconds = 0,
    this.stats,
    this.corrections = const [],
  });
}

/// Simple [Notifier] that holds the last session's summary data.
///
/// [AiPracticeNotifier.endSession] calls [set] before resetting its own state,
/// so the summary screen can read real values instead of zeros.
class AiSummaryNotifier extends Notifier<AiSummaryState> {
  @override
  AiSummaryState build() => const AiSummaryState();

  void set({
    required int durationSeconds,
    required SessionStats stats,
    required List<Correction> corrections,
  }) {
    state = AiSummaryState(
      durationSeconds: durationSeconds,
      stats: stats,
      corrections: corrections,
    );
  }
}

final aiSummaryProvider =
    NotifierProvider<AiSummaryNotifier, AiSummaryState>(AiSummaryNotifier.new);
