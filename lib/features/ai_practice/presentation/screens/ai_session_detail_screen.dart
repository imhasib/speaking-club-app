import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/ai_session.dart';
import '../providers/ai_history_provider.dart';

/// Displays the full detail of a past AI practice session.
class AiSessionDetailScreen extends ConsumerWidget {
  final String sessionId;

  const AiSessionDetailScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncSession = ref.watch(aiSessionDetailProvider(sessionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Session Detail'),
      ),
      body: asyncSession.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _buildError(context, ref, error),
        data: (session) => _buildContent(context, session),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AiSession session) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Session meta
          _SessionMetaCard(session: session),
          const SizedBox(height: 16),

          // Transcript
          _TranscriptSection(messages: session.messages),
          const SizedBox(height: 16),

          // Corrections
          _CorrectionsSection(corrections: session.corrections),
          const SizedBox(height: 16),

          // Vocabulary
          _VocabularySection(stats: session.stats),
          const SizedBox(height: 32),

          // Practice Again
          FilledButton.icon(
            onPressed: () => context.go(Routes.aiPractice),
            icon: const Icon(Icons.replay),
            label: const Text('Practice Again'),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Back to History'),
          ),
        ],
      ),
    );
  }

  Widget _buildError(BuildContext context, WidgetRef ref, Object error) {
    final isNotFound = error.toString().contains('404') ||
        error.toString().toLowerCase().contains('not found');

    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isNotFound ? Icons.search_off : Icons.error_outline,
              size: 64,
              color: colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              isNotFound ? 'Session not found' : 'Failed to load session',
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            if (!isNotFound)
              OutlinedButton.icon(
                onPressed: () => ref.invalidate(aiSessionDetailProvider(sessionId)),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Sub-widgets
// =============================================================================

class _SessionMetaCard extends StatelessWidget {
  final AiSession session;

  const _SessionMetaCard({required this.session});

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
                Icon(
                  Icons.info_outline,
                  color: colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Session Info',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(height: 24),
            _InfoRow(
              label: 'Mode',
              value: session.mode.displayName,
            ),
            if (session.topicOrScenarioDisplay != session.mode.displayName)
              _InfoRow(
                label: session.mode.isTopic ? 'Topic' : 'Scenario',
                value: session.topicOrScenarioDisplay,
              ),
            _InfoRow(
              label: 'Duration',
              value: session.formattedDuration,
            ),
            _InfoRow(
              label: 'Words spoken',
              value: '${session.stats.wordsSpoken}',
            ),
            _InfoRow(
              label: 'Speaking time',
              value: '${session.stats.speakingTimePercent}%',
            ),
            _InfoRow(
              label: 'Corrections',
              value: '${session.corrections.length}',
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style:
                textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _TranscriptSection extends StatelessWidget {
  final List<AiMessage> messages;

  const _TranscriptSection({required this.messages});

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
                Icon(Icons.chat_bubble_outline,
                    color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Conversation',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(height: 24),
            if (messages.isEmpty)
              Text(
                'No messages recorded',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              )
            else
              ...messages.map((msg) => _MessageBubble(message: msg)),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final AiMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser ? colorScheme.primary : colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message.content,
          style: textTheme.bodyMedium?.copyWith(
            color: isUser ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _CorrectionsSection extends StatelessWidget {
  final List<Correction> corrections;

  const _CorrectionsSection({required this.corrections});

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
                Icon(Icons.edit_outlined, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Corrections',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(height: 24),
            if (corrections.isEmpty)
              Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 8),
                  Text(
                    'No corrections — great job!',
                    style: textTheme.bodyMedium
                        ?.copyWith(color: AppColors.success),
                  ),
                ],
              )
            else
              ...corrections.map(
                (c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _CorrectionCard(correction: c),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CorrectionCard extends StatelessWidget {
  final Correction correction;

  const _CorrectionCard({required this.correction});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.close, color: AppColors.error, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  correction.original,
                  style: textTheme.bodySmall?.copyWith(
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
              const Icon(Icons.check, color: AppColors.success, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  correction.corrected,
                  style: textTheme.bodySmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            correction.explanation,
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

class _VocabularySection extends StatelessWidget {
  final SessionStats stats;

  const _VocabularySection({required this.stats});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final words = stats.vocabularyUsed;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.abc, color: colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Vocabulary Used',
                  style: textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const Divider(height: 24),
            if (words.isEmpty)
              Text(
                'No vocabulary recorded',
                style: textTheme.bodyMedium
                    ?.copyWith(color: colorScheme.onSurfaceVariant),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: words
                    .map(
                      (word) => Chip(
                        label: Text(word),
                        labelStyle: textTheme.labelSmall,
                        backgroundColor: colorScheme.primaryContainer,
                        side: BorderSide.none,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}
