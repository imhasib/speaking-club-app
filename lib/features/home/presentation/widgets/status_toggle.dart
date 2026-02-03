import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/online_user.dart';
import '../../../realtime/data/socket_service.dart';

/// Widget for displaying and toggling user status
class StatusToggle extends StatelessWidget {
  final UserStatus status;
  final SocketConnectionState connectionState;
  final VoidCallback onTap;

  const StatusToggle({
    super.key,
    required this.status,
    required this.connectionState,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // Show loading state when connecting
    if (connectionState == SocketConnectionState.connecting ||
        connectionState == SocketConnectionState.reconnecting) {
      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Connecting...',
              style: textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    // Show error state
    if (connectionState == SocketConnectionState.error) {
      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Reconnect',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show disconnected state
    if (connectionState == SocketConnectionState.disconnected) {
      return Container(
        margin: const EdgeInsets.only(right: 16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.offline,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Connect',
                  style: textTheme.bodyMedium?.copyWith(
                    color: AppColors.offline,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Show current status with toggle
    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status);

    return Container(
      margin: const EdgeInsets.only(right: 16),
      child: InkWell(
        onTap: status == UserStatus.online || status == UserStatus.offline
            ? onTap
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                statusText,
                style: textTheme.bodyMedium?.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (status == UserStatus.online || status == UserStatus.offline)
                const SizedBox(width: 4),
              if (status == UserStatus.online || status == UserStatus.offline)
                Icon(
                  Icons.arrow_drop_down,
                  size: 20,
                  color: statusColor,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return AppColors.online;
      case UserStatus.waiting:
        return AppColors.waiting;
      case UserStatus.inCall:
        return AppColors.inCall;
      case UserStatus.offline:
        return AppColors.offline;
    }
  }

  String _getStatusText(UserStatus status) {
    switch (status) {
      case UserStatus.online:
        return 'Online';
      case UserStatus.waiting:
        return 'Waiting...';
      case UserStatus.inCall:
        return 'In Call';
      case UserStatus.offline:
        return 'Offline';
    }
  }
}
