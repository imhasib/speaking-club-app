import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../realtime/data/socket_service.dart';
import '../../../realtime/presentation/providers/presence_provider.dart';
import '../../domain/matchmaking_state.dart';

/// Matchmaking provider
final matchmakingProvider =
    NotifierProvider<MatchmakingNotifier, MatchmakingState>(
  MatchmakingNotifier.new,
);

/// Matchmaking notifier for queue management
class MatchmakingNotifier extends Notifier<MatchmakingState> {
  SocketService get _socketService => ref.read(socketServiceProvider);

  Timer? _waitingTimer;

  @override
  MatchmakingState build() {
    ref.onDispose(() {
      _waitingTimer?.cancel();
    });

    return const MatchmakingState();
  }

  /// Join the matchmaking queue
  void joinQueue() {
    if (!_socketService.isConnected) {
      state = state.copyWith(
        phase: MatchmakingPhase.error,
        error: 'Not connected to server',
      );
      return;
    }

    dev.log('Matchmaking: Joining queue');

    state = state.copyWith(
      phase: MatchmakingPhase.joining,
    );

    _socketService.joinMatchmaking();

    // Transition to waiting state
    state = state.copyWith(
      phase: MatchmakingPhase.waiting,
      joinedAt: DateTime.now(),
      waitingSeconds: 0,
    );

    // Update presence to waiting
    ref.read(presenceProvider.notifier).setWaiting();

    _startWaitingTimer();
  }

  /// Leave the matchmaking queue
  void leaveQueue() {
    if (!state.isWaiting) return;

    dev.log('Matchmaking: Leaving queue');

    _socketService.leaveMatchmaking();
    _waitingTimer?.cancel();

    // Update presence back to online
    ref.read(presenceProvider.notifier).setOnlineAfterMatchmaking();

    state = const MatchmakingState();
  }

  /// Called when a match is found (from call provider)
  void onMatchFound() {
    dev.log('Matchmaking: Match found');
    _waitingTimer?.cancel();
    state = state.copyWith(phase: MatchmakingPhase.matched);
  }

  /// Reset to idle state
  void reset() {
    dev.log('Matchmaking: Reset');
    _waitingTimer?.cancel();
    state = const MatchmakingState();
  }

  void _startWaitingTimer() {
    _waitingTimer?.cancel();
    _waitingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isWaiting) {
        state = state.copyWith(
          waitingSeconds: state.waitingSeconds + 1,
        );
      }
    });
  }

  /// Clear any error
  void clearError() {
    state = state.copyWith(
      phase: MatchmakingPhase.idle,
      error: null,
    );
  }
}
