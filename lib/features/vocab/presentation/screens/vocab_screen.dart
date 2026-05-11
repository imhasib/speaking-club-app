import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/sc_app_bar.dart';

class VocabScreen extends StatelessWidget {
  const VocabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScAppBar(
            title: 'Vocabulary',
            right: IconButton(
              icon: const Icon(Icons.auto_awesome_outlined, color: AppColors.ink),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                const SizedBox(height: 14),
                _StatsRow(),
                const SizedBox(height: 20),
                _RarelyUsedSection(),
                const SizedBox(height: 20),
                _NeedsImprovementSection(),
                const SizedBox(height: 20),
                _BrowseAllSection(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatCard(
          value: '412',
          label: 'Unique words',
          sub: '+34 this week',
          subColor: AppColors.greenPrimary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: '86%',
          label: 'Correct usage',
          sub: '↑ 4% vs last',
          subColor: AppColors.greenPrimary,
        ),
        const SizedBox(width: 10),
        _StatCard(
          value: '23',
          label: 'Sessions',
          sub: '2.4 hrs',
          subColor: AppColors.primary,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final String sub;
  final Color subColor;

  const _StatCard({
    required this.value,
    required this.label,
    required this.sub,
    required this.subColor,
  });

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
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.mutedInk,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              sub,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: subColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RarelyUsedSection extends StatelessWidget {
  static const _words = [
    ('nonetheless', true),
    ('elaborate', false),
    ('ambiguous', false),
    ('reluctant', false),
    ('emphasize', false),
    ('hesitate', false),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Rarely used words',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppColors.primary,
              ),
              child: const Text(
                'Practice →',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Used 1–2 times. Try working these into your next session to expand your active vocabulary.',
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
            children: _words.map((entry) {
              final word = entry.$1;
              final isDark = entry.$2;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primary : AppColors.lavenderBg,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.lavenderText,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _NeedsImprovementSection extends StatelessWidget {
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
              child: const Text(
                '3 words',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.amber,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ImprovementCard(
          word: 'amount',
          misuses: 2,
          wrong: 'I have a big amount of friends.',
          right: 'I have a large number of friends.',
        ),
        const SizedBox(height: 8),
        _ImprovementCard(
          word: 'borrow',
          misuses: 1,
          wrong: 'Can I borrow you my pen?',
          right: 'Can I lend you my pen? / Can you lend me your pen?',
        ),
      ],
    );
  }
}

class _ImprovementCard extends StatelessWidget {
  final String word;
  final int misuses;
  final String wrong;
  final String right;

  const _ImprovementCard({
    required this.word,
    required this.misuses,
    required this.wrong,
    required this.right,
  });

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
                word,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.amberSoft,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '$misuses misuse${misuses > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            wrong,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.redPrimary,
              decoration: TextDecoration.lineThrough,
              decorationColor: AppColors.redPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            right,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.greenPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BrowseAllSection extends StatelessWidget {
  static const _words = [
    _WordEntry('beautiful', 18, 0.92, true),
    _WordEntry('amount', 7, 0.62, false),
    _WordEntry('achievement', 5, 0.48, true),
    _WordEntry('because', 24, 0.95, true),
    _WordEntry('borrow', 3, 0.30, false),
  ];

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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line),
          ),
          child: Row(
            children: [
              const Icon(Icons.search, size: 18, color: AppColors.mutedInk),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Search 412 words…',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.mutedSoft,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceSubtle,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: const Text(
                  'A–Z',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.mutedInk,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.line),
          ),
          child: Column(
            children: List.generate(_words.length, (i) {
              final entry = _words[i];
              final isLast = i == _words.length - 1;
              return Column(
                children: [
                  _WordRow(entry: entry),
                  if (!isLast)
                    const Divider(
                      height: 1,
                      indent: 16,
                      endIndent: 16,
                      color: AppColors.lineSoft,
                    ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _WordEntry {
  final String word;
  final int count;
  final double accuracy;
  final bool isOk;

  const _WordEntry(this.word, this.count, this.accuracy, this.isOk);
}

class _WordRow extends StatelessWidget {
  final _WordEntry entry;

  const _WordRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final pct = (entry.accuracy * 100).round();
    return Padding(
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
                    value: entry.accuracy,
                    minHeight: 5,
                    backgroundColor: AppColors.line,
                    valueColor: AlwaysStoppedAnimation(
                      entry.isOk ? AppColors.greenPrimary : AppColors.amber,
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
              color: entry.isOk ? AppColors.greenPrimary : AppColors.amber,
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            entry.isOk ? Icons.check_circle_outline : Icons.warning_amber_outlined,
            size: 18,
            color: entry.isOk ? AppColors.greenPrimary : AppColors.amber,
          ),
        ],
      ),
    );
  }
}
