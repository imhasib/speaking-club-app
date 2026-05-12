import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/sc_app_bar.dart';
import '../../data/vocab_models.dart';
import '../providers/vocab_providers.dart';

class VocabScreen extends ConsumerStatefulWidget {
  const VocabScreen({super.key});

  @override
  ConsumerState<VocabScreen> createState() => _VocabScreenState();
}

class _VocabScreenState extends ConsumerState<VocabScreen> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String? _expandedWord;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(vocabWordsProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(vocabWordsProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final summaryAsync = ref.watch(vocabSummaryProvider);
    final wordsState = ref.watch(vocabWordsProvider);
    final wordsNotifier = ref.read(vocabWordsProvider.notifier);

    return Scaffold(
      key: const Key('vocab_screen'),
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScAppBar(
            title: 'Vocabulary',
            right: IconButton(
              key: const Key('vocab_refresh_button'),
              icon: const Icon(Icons.refresh, color: AppColors.ink),
              onPressed: () {
                ref.invalidate(vocabSummaryProvider);
                wordsNotifier.load();
              },
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                ref.invalidate(vocabSummaryProvider);
                await wordsNotifier.load();
              },
              child: CustomScrollView(
                key: const Key('vocab_scroll'),
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                      child: summaryAsync.when(
                        data: (summary) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _StatsGrid(stats: summary.stats),
                            const SizedBox(height: 20),
                            if (summary.rarelyUsed.isNotEmpty) ...[
                              _RarelyUsedSection(
                                key: const Key('vocab_section_most_used'),
                                words: summary.rarelyUsed,
                              ),
                              const SizedBox(height: 20),
                            ],
                            if (summary.needsImprovement.isNotEmpty) ...[
                              _NeedsImprovementSection(
                                key: const Key(
                                    'vocab_section_needs_improvement'),
                                items: summary.needsImprovement,
                              ),
                              const SizedBox(height: 20),
                            ],
                            _BrowseHeader(
                              key: const Key('vocab_section_browse_all'),
                              total: summary.stats.uniqueWords,
                              controller: _searchController,
                              search: wordsState.search,
                              sort: wordsState.sort,
                              filter: wordsState.filter,
                              onSearchChanged: wordsNotifier.setSearch,
                              onSortChanged: wordsNotifier.setSort,
                              onFilterChanged: wordsNotifier.setFilter,
                            ),
                          ],
                        ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 40),
                          child: Center(
                            child: CircularProgressIndicator(
                              key: Key('vocab_loading'),
                            ),
                          ),
                        ),
                        error: (e, _) => _ErrorView(
                          message: e.toString(),
                          onRetry: () => ref.invalidate(vocabSummaryProvider),
                        ),
                      ),
                    ),
                  ),
                  _buildWordsSliver(wordsState, wordsNotifier),
                  const SliverToBoxAdapter(child: SizedBox(height: 32)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordsSliver(
    VocabWordsState state,
    VocabWordsNotifier notifier,
  ) {
    if (state.isLoading && state.words.isEmpty) {
      return const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 32),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (state.hasError && state.words.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _ErrorView(
            message: state.errorMessage ?? 'Could not load words',
            onRetry: () => notifier.load(),
          ),
        ),
      );
    }

    if (state.words.isEmpty) {
      return SliverToBoxAdapter(
        child: Padding(
          key: const Key('vocab_words_empty'),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Semantics(
            container: true,
            label: 'vocab_empty',
            child: Column(
            children: [
              Icon(Icons.search_off, size: 48, color: AppColors.mutedSoft),
              SizedBox(height: 8),
              Text(
                'No words match',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mutedInk,
                ),
              ),
            ],
          ),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverList.builder(
        itemCount: state.words.length + (state.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.words.length) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final entry = state.words[index];
          final isLast = index == state.words.length - 1;
          final expanded = _expandedWord == entry.word;
          return Column(
            key: Key('vocab_word_${entry.word}'),
            children: [
              _WordRow(
                entry: entry,
                expanded: expanded,
                onTap: () => setState(() {
                  _expandedWord = expanded ? null : entry.word;
                }),
              ),
              if (expanded)
                _ExpandedExamples(
                  key: Key('vocab_word_detail_${entry.word}'),
                  word: entry.word,
                ),
              if (!isLast)
                const Divider(
                  height: 1,
                  indent: 16,
                  endIndent: 16,
                  color: AppColors.lineSoft,
                ),
            ],
          );
        },
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final VocabStats stats;

  const _StatsGrid({required this.stats});

  @override
  Widget build(BuildContext context) {
    final cards = <_StatCardData>[
      _StatCardData(
        value: stats.uniqueWords.toString(),
        label: 'Unique words',
        sub: '+${stats.weeklyNewWords} this week',
        subColor: AppColors.greenPrimary,
        valueSemLabel: 'vocab_stat_unique_words',
        subSemLabel: 'vocab_stat_weekly_new',
      ),
      _StatCardData(
        value: '${stats.correctUsagePct}%',
        label: 'Correct usage',
        sub: stats.usageTrend ?? '—',
        subColor: AppColors.greenPrimary,
        valueSemLabel: 'vocab_stat_correct_pct',
        subSemLabel: 'vocab_stat_trend',
      ),
      _StatCardData(
        value: stats.sessions.toString(),
        label: 'Sessions',
        sub: '${stats.totalHours.toStringAsFixed(1)} hrs',
        subColor: AppColors.primary,
        valueSemLabel: 'vocab_stat_sessions',
        subSemLabel: 'vocab_stat_hours',
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < cards.length; i++) ...[
          _StatCard(data: cards[i]),
          if (i < cards.length - 1) const SizedBox(width: 10),
        ],
      ],
    );
  }
}

class _StatCardData {
  final String value;
  final String label;
  final String sub;
  final Color subColor;
  final String? valueSemLabel;
  final String? subSemLabel;
  const _StatCardData({
    required this.value,
    required this.label,
    required this.sub,
    required this.subColor,
    this.valueSemLabel,
    this.subSemLabel,
  });
}

class _StatCard extends StatelessWidget {
  final _StatCardData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: data.valueSemLabel,
              child: Text(
                data.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 1),
            Text(
              data.label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedInk,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Semantics(
              label: data.subSemLabel,
              child: Text(
                data.sub,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: data.subColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RarelyUsedSection extends StatelessWidget {
  final List<RarelyUsedWord> words;
  const _RarelyUsedSection({super.key, required this.words});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Rarely used words',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Used 1–2 times. Try working these into your next session.',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.mutedInk,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final w in words)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.lavenderBg,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      w.word,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.lavenderText,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NeedsImprovementSection extends StatelessWidget {
  final List<NeedsImprovementWord> items;
  const _NeedsImprovementSection({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Needs improvement',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.amberSoft,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '${items.length} word${items.length == 1 ? '' : 's'}',
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amber,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < items.length; i++) ...[
          _ImprovementCard(item: items[i]),
          if (i < items.length - 1) const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _ImprovementCard extends StatelessWidget {
  final NeedsImprovementWord item;
  const _ImprovementCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                item.word,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${item.misuses} misuse${item.misuses == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.amber,
                  ),
                ),
              ),
            ],
          ),
          if (item.example != null) ...[
            const SizedBox(height: 8),
            Text(
              item.example!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.redPrimary,
                decoration: TextDecoration.lineThrough,
                decorationColor: AppColors.redPrimary,
              ),
            ),
          ],
          if (item.correction != null) ...[
            const SizedBox(height: 4),
            Text(
              item.correction!,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.greenPrimary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _BrowseHeader extends StatelessWidget {
  final int total;
  final TextEditingController controller;
  final String search;
  final WordSort sort;
  final WordFilter filter;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<WordSort> onSortChanged;
  final ValueChanged<WordFilter> onFilterChanged;

  const _BrowseHeader({
    super.key,
    required this.total,
    required this.controller,
    required this.search,
    required this.sort,
    required this.filter,
    required this.onSearchChanged,
    required this.onSortChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Browse all words',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.mutedInk),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  key: const Key('vocab_search_field'),
                  controller: controller,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    hintText: 'Search $total words…',
                    hintStyle: const TextStyle(
                      fontSize: 14,
                      color: AppColors.mutedSoft,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _Segmented<WordSort>(
                values: WordSort.values,
                selected: sort,
                labelOf: (v) => v.label,
                semanticsLabelOf: (v) {
                  switch (v) {
                    case WordSort.count:
                      return 'vocab_sort_count';
                    case WordSort.recent:
                      return 'vocab_sort_recent';
                    case WordSort.az:
                      return 'vocab_sort_az';
                  }
                },
                onChanged: onSortChanged,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _Segmented<WordFilter>(
                values: WordFilter.values,
                selected: filter,
                labelOf: (v) => v.label,
                semanticsLabelOf: (v) {
                  switch (v) {
                    case WordFilter.all:
                      return 'vocab_filter_all';
                    case WordFilter.correct:
                      return 'vocab_filter_correct';
                    case WordFilter.errors:
                      return 'vocab_filter_errors';
                  }
                },
                onChanged: onFilterChanged,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          // Word rows render below via the sliver list, but the outer card
          // shape is preserved by Padding around the sliver.
          height: 0,
        ),
      ],
    );
  }
}

class _Segmented<T> extends StatelessWidget {
  final List<T> values;
  final T selected;
  final String Function(T) labelOf;
  final String Function(T)? semanticsLabelOf;
  final ValueChanged<T> onChanged;

  const _Segmented({
    required this.values,
    required this.selected,
    required this.labelOf,
    required this.onChanged,
    this.semanticsLabelOf,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: AppColors.surfaceSubtle,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Row(
        children: [
          for (final v in values)
            Expanded(
              child: Semantics(
                label: semanticsLabelOf?.call(v),
                button: true,
                selected: v == selected,
                child: GestureDetector(
                onTap: () => onChanged(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                    color: v == selected ? AppColors.surface : Colors.transparent,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    labelOf(v),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: v == selected
                          ? AppColors.ink
                          : AppColors.mutedInk,
                    ),
                  ),
                ),
              ),
              ),
            ),
        ],
      ),
    );
  }
}

class _WordRow extends StatelessWidget {
  final UserWord entry;
  final bool expanded;
  final VoidCallback onTap;

  const _WordRow({
    required this.entry,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final pct = entry.usagePct;
    final isOk = entry.isCorrect;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 11, 16, 11),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.word,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 5),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (pct / 100).clamp(0, 1),
                      minHeight: 5,
                      backgroundColor: AppColors.line,
                      valueColor: AlwaysStoppedAnimation(
                        isOk ? AppColors.greenPrimary : AppColors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${entry.count}x',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.mutedInk,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '$pct%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isOk ? AppColors.greenPrimary : AppColors.amber,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              expanded
                  ? Icons.keyboard_arrow_up
                  : Icons.keyboard_arrow_down,
              size: 18,
              color: AppColors.mutedInk,
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandedExamples extends ConsumerWidget {
  final String word;
  const _ExpandedExamples({super.key, required this.word});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(vocabWordDetailProvider(word));
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
      color: AppColors.surfaceSubtle,
      child: detail.when(
        loading: () => const Padding(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Center(
            child: SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        ),
        error: (e, _) => Text(
          'Could not load examples',
          style: const TextStyle(fontSize: 12, color: AppColors.mutedInk),
        ),
        data: (word) {
          if (word.examples.isEmpty) {
            return const Text(
              'No examples yet.',
              style: TextStyle(fontSize: 12, color: AppColors.mutedInk),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final example in word.examples) ...[
                _ExampleRow(example: example),
                const SizedBox(height: 8),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _ExampleRow extends StatelessWidget {
  final WordExample example;
  const _ExampleRow({required this.example});

  @override
  Widget build(BuildContext context) {
    final spans = _buildHighlightSpans(
      text: example.text,
      start: example.highlightStart,
      end: example.highlightEnd,
      isCorrect: example.isCorrect,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (example.sessionLabel != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              example.sessionLabel!,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedSoft,
              ),
            ),
          ),
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.ink,
              height: 1.4,
            ),
            children: spans,
          ),
        ),
        if (!example.isCorrect && example.correction != null) ...[
          const SizedBox(height: 4),
          Text(
            '→ ${example.correction!}',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.greenPrimary,
            ),
          ),
        ],
      ],
    );
  }

  List<TextSpan> _buildHighlightSpans({
    required String text,
    required int start,
    required int end,
    required bool isCorrect,
  }) {
    if (start < 0 || end <= start || start >= text.length) {
      return [TextSpan(text: text)];
    }
    final safeEnd = end.clamp(0, text.length);
    final highlightColor =
        isCorrect ? AppColors.greenSoft : AppColors.redSoft;
    final textColor =
        isCorrect ? AppColors.greenPrimary : AppColors.redPrimary;
    return [
      TextSpan(text: text.substring(0, start)),
      TextSpan(
        text: text.substring(start, safeEnd),
        style: TextStyle(
          backgroundColor: highlightColor,
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
      if (safeEnd < text.length) TextSpan(text: text.substring(safeEnd)),
    ];
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('vocab_error'),
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.error_outline,
              size: 48, color: AppColors.redPrimary),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.mutedInk),
          ),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
