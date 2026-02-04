import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/call_history_repository.dart';
import '../../domain/call_history_state.dart';

/// Call history notifier provider
final callHistoryProvider =
    NotifierProvider<CallHistoryNotifier, CallHistoryState>(
        CallHistoryNotifier.new);

/// Notifier for managing call history state
class CallHistoryNotifier extends Notifier<CallHistoryState> {
  CallHistoryRepository get _repository =>
      ref.read(callHistoryRepositoryProvider);

  @override
  CallHistoryState build() {
    return const CallHistoryState();
  }

  /// Load initial call history
  Future<void> loadCallHistory() async {
    if (state.isLoading) return;

    dev.log('📜 Loading call history...');
    state = state.copyWith(
      isLoading: true,
      hasError: false,
      errorMessage: null,
    );

    try {
      final result = await _repository.getCallHistory(page: 1);
      dev.log(
          '✅ Loaded ${result.calls.length} calls (page 1 of ${result.totalPages})');

      state = state.copyWith(
        calls: result.calls,
        currentPage: result.page,
        totalPages: result.totalPages,
        totalCalls: result.total,
        isLoading: false,
      );
    } catch (e) {
      dev.log('❌ Failed to load call history: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// Load more calls (pagination)
  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore) return;

    final nextPage = state.currentPage + 1;
    dev.log('📜 Loading more calls (page $nextPage)...');

    state = state.copyWith(isLoadingMore: true);

    try {
      final result = await _repository.getCallHistory(page: nextPage);
      dev.log(
          '✅ Loaded ${result.calls.length} more calls (page $nextPage of ${result.totalPages})');

      state = state.copyWith(
        calls: [...state.calls, ...result.calls],
        currentPage: result.page,
        totalPages: result.totalPages,
        totalCalls: result.total,
        isLoadingMore: false,
      );
    } catch (e) {
      dev.log('❌ Failed to load more calls: $e');
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// Refresh call history (pull to refresh)
  Future<void> refresh() async {
    dev.log('🔄 Refreshing call history...');

    // Reset state and reload
    state = const CallHistoryState();
    await loadCallHistory();
  }

  /// Clear error state
  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
