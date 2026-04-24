import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../shared/models/ai_session.dart';

/// List tile representing a single AI practice session in the history list.
class AiSessionItem extends StatelessWidget {
  final AiSession session;
  final VoidCallback onTap;

  const AiSessionItem({
    super.key,
    required this.session,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Mode icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _modeIcon(session.mode),
                  color: colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),

              // Date, mode, duration
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(session.startedAt),
                      style: textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${session.mode.displayName} · ${session.formattedDuration}',
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (session.topicOrScenarioDisplay != session.mode.displayName) ...[
                      const SizedBox(height: 2),
                      Text(
                        session.topicOrScenarioDisplay,
                        style: textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // Corrections count badge
              if (session.corrections.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${session.corrections.length}',
                    style: textTheme.labelSmall?.copyWith(
                      color: colorScheme.onErrorContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.check,
                    size: 14,
                    color: Colors.green.shade700,
                  ),
                ),

              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _modeIcon(AiSessionMode mode) {
    switch (mode) {
      case AiSessionMode.freeChat:
        return Icons.chat_bubble_outline;
      case AiSessionMode.topic:
        return Icons.topic_outlined;
      case AiSessionMode.scenario:
        return Icons.theater_comedy_outlined;
    }
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final sessionDay = DateTime(dt.year, dt.month, dt.day);

    if (sessionDay == today) {
      return 'Today, ${DateFormat.jm().format(dt)}';
    } else if (sessionDay == yesterday) {
      return 'Yesterday, ${DateFormat.jm().format(dt)}';
    } else {
      return DateFormat('MMM d, y · h:mm a').format(dt);
    }
  }
}
