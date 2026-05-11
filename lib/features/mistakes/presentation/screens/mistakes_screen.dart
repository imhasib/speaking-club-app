import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/sc_app_bar.dart';
import '../../../../shared/widgets/sc_filter_chip_bar.dart';
import '../../../../shared/widgets/section_header.dart';

class MistakesScreen extends StatefulWidget {
  const MistakesScreen({super.key});

  @override
  State<MistakesScreen> createState() => _MistakesScreenState();
}

class _MistakesScreenState extends State<MistakesScreen> {
  int _selectedFilter = 0;

  static const _chips = [
    ScFilterChipData(label: 'All', count: '12'),
    ScFilterChipData(
      label: 'Grammar',
      count: '5',
      accentDot: Color(0xFF7A5AF8),
    ),
    ScFilterChipData(
      label: 'Vocabulary',
      count: '4',
      accentDot: AppColors.amber,
    ),
    ScFilterChipData(
      label: 'Fluency',
      count: '2',
      accentDot: Color(0xFF2DABD6),
    ),
    ScFilterChipData(
      label: 'Pronunciation',
      count: '1',
      accentDot: AppColors.redPrimary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          ScAppBar(
            title: 'My Mistakes',
            right: IconButton(
              icon: const Icon(Icons.search, color: AppColors.ink),
              onPressed: () {},
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const SizedBox(height: 12),
                _SummaryStrip(),
                const SizedBox(height: 16),
                ScFilterChipBar(
                  chips: _chips,
                  selectedIndex: _selectedFilter,
                  onSelected: (i) => setState(() => _selectedFilter = i),
                ),
                const SizedBox(height: 4),
                const SectionHeader(
                  label: 'Grammar',
                  count: '5',
                  accent: Color(0xFF7A5AF8),
                ),
                _MistakeCard(
                  wrong: 'I am go to the market yesterday.',
                  right: 'I went to the market yesterday.',
                  explanation:
                      "Use past tense (went) with a past time marker like 'yesterday'.",
                  session: 'Free Chat · May 09 · 3:42 min',
                ),
                _MistakeCard(
                  wrong: "She don't like coffee in morning.",
                  right: "She doesn't like coffee in the morning.",
                  explanation:
                      "Third-person singular needs 'doesn't', and 'morning' takes the article 'the'.",
                  session: 'Topic Discussion · May 08',
                ),
                const SectionHeader(
                  label: 'Vocabulary',
                  count: '4',
                  accent: AppColors.amber,
                ),
                _MistakeCard(
                  wrong: 'I have a big amount of friends.',
                  right: 'I have a large number of friends.',
                  explanation:
                      "'Amount' is for uncountables; use 'number' for countable nouns like friends.",
                  session: 'Free Chat · May 07',
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStrip extends StatelessWidget {
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
              children: const [
                Text(
                  'This week',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '12 mistakes · 8 fixed',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.greenSoft,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              '↓ 23%',
              style: TextStyle(
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
  final String wrong;
  final String right;
  final String explanation;
  final String session;

  const _MistakeCard({
    required this.wrong,
    required this.right,
    required this.explanation,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.close, size: 16, color: AppColors.redPrimary),
              const SizedBox(width: 6),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.redSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    wrong,
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
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.greenSoft,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    right,
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
          const SizedBox(height: 10),
          Text(
            'Why: $explanation',
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.mutedInk,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.access_time, size: 13, color: AppColors.mutedSoft),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  session,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.mutedSoft,
                  ),
                ),
              ),
              _ActionPill(
                label: 'Save to vocab',
                onTap: () {},
              ),
              const SizedBox(width: 6),
              _ActionPill(
                label: 'Practice again',
                onTap: () {},
                primary: true,
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
  final VoidCallback onTap;
  final bool primary;

  const _ActionPill({
    required this.label,
    required this.onTap,
    this.primary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: primary ? AppColors.primary : AppColors.lavenderBg,
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: primary ? Colors.white : AppColors.lavenderText,
          ),
        ),
      ),
    );
  }
}
