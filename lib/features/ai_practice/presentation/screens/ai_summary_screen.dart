import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/ai_session.dart';
import '../providers/ai_summary_provider.dart';

/// Session summary screen shown after ending an AI practice session.
///
/// Reads [AiSummaryState] from [aiSummaryProvider], which is populated by
/// [AiPracticeNotifier.endSession] before navigating here.
class AiSummaryScreen extends ConsumerWidget {
  const AiSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = ref.watch(aiSummaryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Summary'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Duration card
            _SummaryCard(
              icon: Icons.timer_outlined,
              title: 'Duration',
              content: _buildDurationContent(context, summary.durationSeconds),
            ),
            const SizedBox(height: 16),

            // Speaking stats card
            _SummaryCard(
              icon: Icons.mic_outlined,
              title: 'Speaking Stats',
              content: _buildStatsContent(
                context,
                summary.stats,
                summary.accuracyPct,
              ),
            ),
            const SizedBox(height: 16),

            // Analysis section — pending spinner, mistakes, new words, or
            // a failure fallback handled by [_AnalysisSection].
            _AnalysisSection(summary: summary),
            const SizedBox(height: 16),

            // Corrections card (in-session live corrections — distinct from
            // server-side mistakes analysis).
            if (summary.corrections.isNotEmpty) ...[
              _SummaryCard(
                icon: Icons.edit_outlined,
                title: 'Corrections',
                content: _buildCorrectionsContent(context, summary.corrections),
              ),
              const SizedBox(height: 16),
            ],

            const SizedBox(height: 16),

            // Action buttons
            FilledButton.icon(
              onPressed: () {
                context.go(Routes.aiPractice);
              },
              icon: const Icon(Icons.replay),
              label: const Text('Practice Again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                context.go(Routes.home);
              },
              icon: const Icon(Icons.home),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDurationContent(BuildContext context, int durationSeconds) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    final display = minutes > 0
        ? '$minutes:${seconds.toString().padLeft(2, '0')}'
        : '0:${seconds.toString().padLeft(2, '0')}';

    return Row(
      children: [
        Text(
          display,
          style: textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'minutes',
          style: textTheme.bodyLarge?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsContent(
    BuildContext context,
    SessionStats? stats,
    int? accuracyPct,
  ) {
    final wordsSpoken = stats?.wordsSpoken ?? 0;
    final avgSentenceLength = stats?.averageSentenceLength ?? 0;
    final speakingTimePercent = stats?.speakingTimePercent ?? 0;

    return Column(
      children: [
        _StatRow(
          label: 'Words spoken',
          value: '$wordsSpoken',
        ),
        const Divider(),
        _StatRow(
          label: 'Avg. sentence length',
          value: '$avgSentenceLength words',
        ),
        const Divider(),
        _StatRow(
          label: 'Speaking time',
          value: '$speakingTimePercent%',
        ),
        if (accuracyPct != null) ...[
          const Divider(),
          _StatRow(
            label: 'Accuracy',
            value: '$accuracyPct%',
          ),
        ],
      ],
    );
  }

  Widget _buildCorrectionsContent(
    BuildContext context,
    List<Correction> corrections,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    if (corrections.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.success,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'No corrections in this session — nice work!',
                style: textTheme.bodyLarge?.copyWith(
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: corrections.map((correction) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.close, color: AppColors.error, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      correction.original,
                      style: textTheme.bodyMedium?.copyWith(
                        decoration: TextDecoration.lineThrough,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check, color: AppColors.success, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      correction.corrected,
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.lightbulb_outline,
                    color: AppColors.warning,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      correction.explanation,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
              if (corrections.last != correction) const Divider(height: 24),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _AnalysisSection extends StatelessWidget {
  final AiSummaryState summary;
  const _AnalysisSection({required this.summary});

  @override
  Widget build(BuildContext context) {
    switch (summary.analysisStatus) {
      case AnalysisStatus.pending:
        return const Card(
          key: Key('summary_analysis_pending'),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Analysing your session…',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        );
      case AnalysisStatus.failed:
      case AnalysisStatus.none:
        return const SizedBox.shrink();
      case AnalysisStatus.completed:
        return Column(
          key: const Key('summary_analysis_completed'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (summary.mistakes.isNotEmpty)
              _SummaryCard(
                icon: Icons.warning_amber_outlined,
                title: 'Mistakes',
                content: _MistakesList(items: summary.mistakes),
              ),
            if (summary.mistakes.isNotEmpty && summary.newWords.isNotEmpty)
              const SizedBox(height: 16),
            if (summary.newWords.isNotEmpty)
              _SummaryCard(
                icon: Icons.auto_awesome_outlined,
                title: 'New words',
                content: _NewWordsBadges(words: summary.newWords),
              ),
          ],
        );
    }
  }
}

class _MistakesList extends StatelessWidget {
  final List<Correction> items;
  const _MistakesList({required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.close,
                        size: 16, color: AppColors.redPrimary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        items[i].original,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.redPrimary,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: AppColors.redPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check,
                        size: 16, color: AppColors.greenPrimary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        items[i].corrected,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.greenPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (i < items.length - 1) const Divider(height: 8),
        ],
      ],
    );
  }
}

class _NewWordsBadges extends StatelessWidget {
  final List<String> words;
  const _NewWordsBadges({required this.words});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (final word in words)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.lavenderBg,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Text(
              word,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.lavenderText,
              ),
            ),
          ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget content;

  const _SummaryCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            content,
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          Text(
            value,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
