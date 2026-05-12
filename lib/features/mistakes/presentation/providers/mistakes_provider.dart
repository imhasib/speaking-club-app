import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/mistake_models.dart';
import '../../data/mistakes_repository.dart';

/// Snapshot of state for the Mistakes screen.
class MistakesUiState {
  final List<Mistake> mistakes;
  final MistakesSummary summary;
  final MistakeCategory? category;
  final bool? fixedFilter;
  final String? cursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;

  const MistakesUiState({
    this.mistakes = const [],
    this.summary = const MistakesSummary(),
    this.category,
    this.fixedFilter,
    this.cursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
  });

  bool get hasMore => cursor != null;

  MistakesUiState copyWith({
    List<Mistake>? mistakes,
    MistakesSummary? summary,
    Object? category = _Sentinel,
    Object? fixedFilter = _Sentinel,
    Object? cursor = _Sentinel,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    Object? errorMessage = _Sentinel,
  }) {
    return MistakesUiState(
      mistakes: mistakes ?? this.mistakes,
      summary: summary ?? this.summary,
      category:
          category == _Sentinel ? this.category : category as MistakeCategory?,
      fixedFilter:
          fixedFilter == _Sentinel ? this.fixedFilter : fixedFilter as bool?,
      cursor: cursor == _Sentinel ? this.cursor : cursor as String?,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasError: hasError ?? this.hasError,
      errorMessage:
          errorMessage == _Sentinel ? this.errorMessage : errorMessage as String?,
    );
  }
}

class _Sentinel {
  const _Sentinel._();
}

/// Mistakes notifier — filter state + paginated list + optimistic actions.
final mistakesProvider =
    NotifierProvider<MistakesNotifier, MistakesUiState>(MistakesNotifier.new);

class MistakesNotifier extends Notifier<MistakesUiState> {
  MistakesRepository get _repo => ref.read(mistakesRepositoryProvider);

  @override
  MistakesUiState build() => const MistakesUiState();

  /// Initial load (or invoked from an empty state).
  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
    try {
      final page = await _repo.fetchMistakes(
        category: state.category,
        fixed: state.fixedFilter,
      );
      state = state.copyWith(
        mistakes: page.mistakes,
        summary: page.summary,
        cursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      dev.log('Mistakes: load failed: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> setCategory(MistakeCategory? category) async {
    if (state.category == category) return;
    state = state.copyWith(
      category: category,
      mistakes: const [],
      cursor: null,
    );
    await load();
  }

  Future<void> setFixedFilter(bool? fixed) async {
    if (state.fixedFilter == fixed) return;
    state = state.copyWith(
      fixedFilter: fixed,
      mistakes: const [],
      cursor: null,
    );
    await load();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await _repo.fetchMistakes(
        category: state.category,
        fixed: state.fixedFilter,
        cursor: state.cursor,
      );
      state = state.copyWith(
        mistakes: [...state.mistakes, ...page.mistakes],
        cursor: page.cursor,
        isLoadingMore: false,
      );
    } catch (e) {
      dev.log('Mistakes: loadMore failed: $e');
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> refresh() async {
    state = MistakesUiState(
      category: state.category,
      fixedFilter: state.fixedFilter,
    );
    await load();
  }

  /// Optimistically toggle the `isFixed` flag on a mistake.
  Future<void> markFixed(String id) async {
    final original = state.mistakes;
    final updated = original
        .map((m) => m.id == id ? m.copyWith(isFixed: !m.isFixed) : m)
        .toList();
    state = state.copyWith(mistakes: updated);
    try {
      await _repo.markFixed(id);
    } catch (e) {
      dev.log('Mistakes: markFixed failed, rolling back: $e');
      state = state.copyWith(mistakes: original, errorMessage: e.toString());
    }
  }

  /// Optimistically flag a mistake as saved to vocab.
  Future<void> saveToVocab(String id) async {
    final original = state.mistakes;
    final updated = original
        .map((m) => m.id == id ? m.copyWith(savedToVocab: true) : m)
        .toList();
    state = state.copyWith(mistakes: updated);
    try {
      await _repo.saveToVocab(id);
    } catch (e) {
      dev.log('Mistakes: saveToVocab failed, rolling back: $e');
      state = state.copyWith(mistakes: original, errorMessage: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(hasError: false, errorMessage: null);
  }
}
