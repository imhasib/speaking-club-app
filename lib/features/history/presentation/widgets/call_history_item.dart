import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/call.dart';

/// Widget for displaying a single call history item
class CallHistoryItem extends StatelessWidget {
  final Call call;
  final String currentUserId;
  final VoidCallback? onTap;

  const CallHistoryItem({
    super.key,
    required this.call,
    required this.currentUserId,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final otherParticipant = call.getOtherParticipant(currentUserId);

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              // Avatar
              _buildAvatar(colorScheme, otherParticipant),
              const SizedBox(width: 12),
              // Call info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name and call type
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            otherParticipant?.name ?? 'Unknown',
                            style: textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildCallTypeBadge(context),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Status and time
                    Row(
                      children: [
                        _buildStatusIcon(),
                        const SizedBox(width: 4),
                        Text(
                          _formatRelativeTime(call.startedAt),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (call.status.isCompleted && call.duration != null) ...[
                          Text(
                            ' - ',
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            call.formattedDuration,
                            style: textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Icon(
                Icons.chevron_right,
                color: colorScheme.onSurfaceVariant.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(ColorScheme colorScheme, CallParticipant? participant) {
    return CircleAvatar(
      radius: 24,
      backgroundColor: colorScheme.surfaceContainerHighest,
      child: participant?.profilePicture != null && participant!.profilePicture!.isNotEmpty
          ? ClipOval(
              child: CachedNetworkImage(
                imageUrl: participant.profilePicture!,
                width: 48,
                height: 48,
                fit: BoxFit.cover,
                placeholder: (context, url) => Icon(
                  Icons.person,
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  size: 24,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          : Icon(
              Icons.person,
              size: 24,
              color: colorScheme.onSurfaceVariant,
            ),
    );
  }

  Widget _buildStatusIcon() {
    switch (call.status) {
      case CallStatus.completed:
        return const Icon(
          Icons.call_made,
          size: 16,
          color: AppColors.success,
        );
      case CallStatus.missed:
        return const Icon(
          Icons.call_missed,
          size: 16,
          color: AppColors.error,
        );
      case CallStatus.cancelled:
        return Icon(
          Icons.call_end,
          size: 16,
          color: AppColors.offline,
        );
      case CallStatus.rejected:
        return const Icon(
          Icons.call_missed_outgoing,
          size: 16,
          color: AppColors.warning,
        );
    }
  }

  Widget _buildCallTypeBadge(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isRandom = call.type.isRandom;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isRandom
            ? colorScheme.tertiaryContainer
            : colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        isRandom ? 'Random' : 'Direct',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isRandom
              ? colorScheme.onTertiaryContainer
              : colorScheme.onSecondaryContainer,
        ),
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      // Format as date
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      return '${months[dateTime.month - 1]} ${dateTime.day}';
    }
  }
}

/// Widget for displaying date group headers
class DateGroupHeader extends StatelessWidget {
  final String label;

  const DateGroupHeader({
    super.key,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        label,
        style: textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
