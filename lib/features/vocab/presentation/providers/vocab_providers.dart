import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/vocab_models.dart';
import '../../data/vocab_repository.dart';

/// Summary fetch for the Vocab dashboard header / sections.
final vocabSummaryProvider = FutureProvider<VocabSummary>((ref) async {
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.fetchSummary();
});

/// Word detail fetch — cached per-word.
final vocabWordDetailProvider =
    FutureProvider.family<UserWord, String>((ref, word) async {
  final repo = ref.watch(vocabRepositoryProvider);
  return repo.fetchWordDetail(word);
});

/// Paginated word browser state.
class VocabWordsState {
  final List<UserWord> words;
  final String search;
  final WordSort sort;
  final WordFilter filter;
  final String? cursor;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasError;
  final String? errorMessage;

  const VocabWordsState({
    this.words = const [],
    this.search = '',
    this.sort = WordSort.count,
    this.filter = WordFilter.all,
    this.cursor,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasError = false,
    this.errorMessage,
  });

  bool get hasMore => cursor != null;

  VocabWordsState copyWith({
    List<UserWord>? words,
    String? search,
    WordSort? sort,
    WordFilter? filter,
    Object? cursor = _Sentinel,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasError,
    Object? errorMessage = _Sentinel,
  }) {
    return VocabWordsState(
      words: words ?? this.words,
      search: search ?? this.search,
      sort: sort ?? this.sort,
      filter: filter ?? this.filter,
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

/// Browser-list notifier with debounced search.
final vocabWordsProvider =
    NotifierProvider<VocabWordsNotifier, VocabWordsState>(
        VocabWordsNotifier.new);

class VocabWordsNotifier extends Notifier<VocabWordsState> {
  VocabRepository get _repo => ref.read(vocabRepositoryProvider);
  Timer? _searchDebounce;

  @override
  VocabWordsState build() {
    ref.onDispose(() {
      _searchDebounce?.cancel();
    });
    return const VocabWordsState();
  }

  Future<void> load() async {
    if (state.isLoading) return;
    state = state.copyWith(isLoading: true, hasError: false, errorMessage: null);
    try {
      final page = await _repo.fetchWords(
        search: state.search,
        sort: state.sort,
        filter: state.filter,
      );
      state = state.copyWith(
        words: page.words,
        cursor: page.cursor,
        isLoading: false,
      );
    } catch (e) {
      dev.log('Vocab: load failed: $e');
      state = state.copyWith(
        isLoading: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }

  /// Debounced search input — ~300 ms idle before issuing a request.
  void setSearch(String search) {
    state = state.copyWith(search: search);
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      state = state.copyWith(words: const [], cursor: null);
      load();
    });
  }

  Future<void> setSort(WordSort sort) async {
    if (state.sort == sort) return;
    state = state.copyWith(sort: sort, words: const [], cursor: null);
    await load();
  }

  Future<void> setFilter(WordFilter filter) async {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter, words: const [], cursor: null);
    await load();
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final page = await _repo.fetchWords(
        search: state.search,
        sort: state.sort,
        filter: state.filter,
        cursor: state.cursor,
      );
      state = state.copyWith(
        words: [...state.words, ...page.words],
        cursor: page.cursor,
        isLoadingMore: false,
      );
    } catch (e) {
      dev.log('Vocab: loadMore failed: $e');
      state = state.copyWith(
        isLoadingMore: false,
        hasError: true,
        errorMessage: e.toString(),
      );
    }
  }
}
