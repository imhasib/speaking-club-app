import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/sc_app_bar.dart';
import '../../../../shared/widgets/sc_filter_chip_bar.dart';
import '../../data/mistake_models.dart';
import '../providers/mistakes_provider.dart';

class MistakesScreen extends ConsumerStatefulWidget {
  const MistakesScreen({super.key});

  @override
  ConsumerState<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends ConsumerState<MistakesScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mistakesProvider.notifier).load();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 300) {
      ref.read(mistakesProvider.notifier).loadMore();
    }
  }

  static const _categoryChoices = [
    null,
    MistakeCategory.grammar,
    MistakeCategory.vocabulary,
    MistakeCategory.fluency,
    MistakeCategory.pronunciation,
  ];

  static const _categoryAccents = {
    MistakeCategory.grammar: Color(0xFF7A5AF8),
    MistakeCategory.vocabulary: AppColors.amber,
    MistakeCategory.fluency: Color(0xFF2DABD6),
    MistakeCategory.pronunciation: AppColors.redPrimary,
  };

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(mistakesProvider);
    final notifier = ref.read(mistakesProvider.notifier);

    final selectedIndex =
        _categoryChoices.indexOf(state.category).clamp(0, _categoryChoices.length - 1);

    final categoryCounts = _countByCategory(state.mistakes);

    final chips = <ScFilterChipData>[
      ScFilterChipData(
        label: 'All',
        count: state.mistakes.length.toString(),
        semanticsLabel: 'mistakes_filter_all',
      ),
      for (final cat in _categoryChoices.skip(1).cast<MistakeCategory>())
        ScFilterChipData(
          label: cat.label,
          count: (categoryCounts[cat] ?? 0).toString(),
          accentDot: _categoryAccents[cat],
          semanticsLabel: _semanticsLabelFor(cat),
        ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScAppBar(
            title: 'My Mistakes',
            right: IconButton(
              key: const Key('mistakes_refresh_button'),
              icon: const Icon(Icons.refresh, color: AppColors.ink),
              onPressed: () => notifier.refresh(),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => notifier.refresh(),
              child: _buildBody(
                state: state,
                chips: chips,
                selectedIndex: selectedIndex,
                onChipSelected: (i) =>
                    notifier.setCategory(_categoryChoices[i]),
                notifier: notifier,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _semanticsLabelFor(MistakeCategory cat) {
    switch (cat) {
      case MistakeCategory.grammar:
        return 'mistakes_filter_grammar';
      case MistakeCategory.vocabulary:
        return 'mistakes_filter_vocabulary';
      case MistakeCategory.fluency:
        return 'mistakes_filter_fluency';
      case MistakeCategory.pronunciation:
        return 'mistakes_filter_pronunciation';
    }
  }

  Map<MistakeCategory, int> _countByCategory(List<Mistake> list) {
    final counts = <MistakeCategory, int>{};
    for (final m in list) {
      counts[m.category] = (counts[m.category] ?? 0) + 1;
    }
    return counts;
  }

  Widget _buildBody({
    required MistakesUiState state,
    required List<ScFilterChipData> chips,
    required int selectedIndex,
    required ValueChanged<int> onChipSelected,
    required MistakesNotifier notifier,
  }) {
    if (state.isLoading && state.mistakes.isEmpty) {
      return const Center(
        key: Key('mistakes_loading'),
        child: CircularProgressIndicator(),
      );
    }

    if (state.hasError && state.mistakes.isEmpty) {
      return _ErrorView(
        message: state.errorMessage ?? 'Could not load mistakes',
        onRetry: () => notifier.load(),
      );
    }

    return CustomScrollView(
      key: const Key('mistakes_scroll'),
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              _SummaryStrip(summary: state.summary),
              const SizedBox(height: 16),
              ScFilterChipBar(
                chips: chips,
                selectedIndex: selectedIndex,
                onSelected: onChipSelected,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
        if (state.mistakes.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: _EmptyMistakes(),
          )
        else
          SliverList.builder(
            itemCount: state.mistakes.length + (state.isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index >= state.mistakes.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final mistake = state.mistakes[index];
              return _MistakeCard(
                key: Key('mistake_${mistake.id}'),
                mistake: mistake,
                accent: _categoryAccents[mistake.category] ?? AppColors.primary,
                onMarkFixed: () => notifier.markFixed(mistake.id),
                onSaveToVocab: () => notifier.saveToVocab(mistake.id),
              );
            },
          ),
        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }
}

class _SummaryStrip extends StatelessWidget {
  final MistakesSummary summary;

  const _SummaryStrip({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.indigoDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'This week',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Semantics(
                      label: 'mistakes_summary_thisweek',
                      child: Text(
                        '${summary.thisWeek}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      ' mistakes · ',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Semantics(
                      label: 'mistakes_summary_fixed',
                      child: Text(
                        '${summary.fixed}',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      ' fixed',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (summary.trend != null && summary.trend != 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.greenSoft,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                '${summary.trend! > 0 ? '+' : ''}${summary.trend}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.greenPrimary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MistakeCard extends StatelessWidget {
  final Mistake mistake;
  final Color accent;
  final VoidCallback onMarkFixed;
  final VoidCallback onSaveToVocab;

  const _MistakeCard({
    super.key,
    required this.mistake,
    required this.accent,
    required this.onMarkFixed,
    required this.onSaveToVocab,
  });

  @override
  Widget build(BuildContext context) {
    final fixed = mistake.isFixed;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: fixed ? AppColors.greenSoft : AppColors.line,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: accent, shape: BoxShape.circle),
              ),
              const SizedBox(width: 7),
              Text(
                mistake.category.label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: AppColors.mutedInk,
                  letterSpacing: 0.8,
                ),
              ),
              const Spacer(),
              if (fixed)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'Fixed',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.close, size: 16, color: AppColors.redPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.redSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mistake.wrong,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.redPrimary,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: AppColors.redPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check, size: 16, color: AppColors.greenPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    mistake.right,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.greenPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          if (mistake.explanation.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              'Why: ${mistake.explanation}',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.mutedInk,
                height: 1.4,
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 13, color: AppColors.mutedSoft),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  mistake.sessionLabel ?? '—',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedSoft,
                  ),
                ),
              ),
              _ActionPill(
                key: Key('mistake_save_to_vocab_${mistake.id}'),
                label: mistake.savedToVocab ? 'In vocab' : 'Save to vocab',
                onTap: mistake.savedToVocab ? null : onSaveToVocab,
              ),
              const SizedBox(width: 6),
              _ActionPill(
                key: Key('mistake_mark_fixed_${mistake.id}'),
                label: fixed ? 'Unfix' : 'Mark fixed',
                onTap: onMarkFixed,
                primary: !fixed,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionPill extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final bool primary;

  const _ActionPill({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.line
              : (primary ? AppColors.primary : AppColors.lavenderBg),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: disabled
                ? AppColors.mutedInk
                : (primary ? Colors.white : AppColors.lavenderText),
          ),
        ),
      ),
    );
  }
}

class _EmptyMistakes extends StatelessWidget {
  const _EmptyMistakes();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      key: Key('mistakes_empty'),
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.celebration_outlined,
              size: 56, color: AppColors.mutedSoft),
          SizedBox(height: 12),
          Text(
            'No mistakes yet',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Keep practising and we\'ll show what to improve here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: AppColors.mutedInk),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      key: const Key('mistakes_error'),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 56, color: AppColors.redPrimary),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.mutedInk),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
