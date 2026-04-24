import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/ai_session.dart';
import '../../data/ai_session_repository.dart';

/// State for paginated AI session history.
class AiHistoryState {
  final List<AiSession> sessions;
  final int currentPage;
  final bool hasMore;
  final bool isLoadingMore;
  final bool isRefreshing;
  final String? error;

  const AiHistoryState({
    this.sessions = const [],
    this.currentPage = 0,
    this.hasMore = true,
    this.isLoadingMore = false,
    this.isRefreshing = false,
    this.error,
  });

  AiHistoryState copyWith({
    List<AiSession>? sessions,
    int? currentPage,
    bool? hasMore,
    bool? isLoadingMore,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
  }) {
    return AiHistoryState(
      sessions: sessions ?? this.sessions,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

/// Paginated notifier for AI session history.
///
/// Call [loadFirstPage] on initial mount or after pull-to-refresh.
/// Call [loadNextPage] when near the end of the list.
class AiHistoryNotifier extends AsyncNotifier<AiHistoryState> {
  static const int _pageSize = 20;

  AiSessionRepository get _repository => ref.read(aiSessionRepositoryProvider);

  @override
  Future<AiHistoryState> build() async {
    final result = await _fetchPage(1);
    return result;
  }

  /// Reload from the first page (pull-to-refresh).
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(1));
  }

  /// Load the next page and append to the current list.
  Future<void> loadNextPage() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    // Optimistically mark as loading more
    state = AsyncValue.data(current.copyWith(isLoadingMore: true));

    try {
      final nextPage = current.currentPage + 1;
      final paginated = await _repository.getSessions(
        page: nextPage,
        limit: _pageSize,
      );

      state = AsyncValue.data(
        (state.value ?? current).copyWith(
          sessions: [
            ...(state.value?.sessions ?? current.sessions),
            ...paginated.sessions,
          ],
          currentPage: nextPage,
          hasMore: paginated.hasMore,
          isLoadingMore: false,
          clearError: true,
        ),
      );
    } catch (e) {
      dev.log('AiHistory: loadNextPage error: $e');
      state = AsyncValue.data(
        (state.value ?? current).copyWith(
          isLoadingMore: false,
          error: 'Failed to load more sessions',
        ),
      );
    }
  }

  Future<AiHistoryState> _fetchPage(int page) async {
    final paginated = await _repository.getSessions(
      page: page,
      limit: _pageSize,
    );
    return AiHistoryState(
      sessions: paginated.sessions,
      currentPage: page,
      hasMore: paginated.hasMore,
    );
  }
}

final aiHistoryProvider =
    AsyncNotifierProvider<AiHistoryNotifier, AiHistoryState>(
        AiHistoryNotifier.new);

/// Family provider to fetch a single session by ID (used by detail screen).
final aiSessionDetailProvider =
    FutureProvider.family<AiSession, String>((ref, sessionId) async {
  final repository = ref.watch(aiSessionRepositoryProvider);
  return repository.getSessionById(sessionId);
});
