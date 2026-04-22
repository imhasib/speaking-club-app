import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/online_user.dart';

/// Card widget for displaying an online user
class OnlineUserCard extends StatelessWidget {
  final OnlineUser user;
  final VoidCallback? onTap;

  const OnlineUserCard({
    super.key,
    required this.user,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: user.status.isAvailable ? onTap : null,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar with status badge
              Stack(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    child: user.profilePicture != null && user.profilePicture!.isNotEmpty
                        ? ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: user.profilePicture!,
                              width: 64,
                              height: 64,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Icon(
                                Icons.person,
                                size: 32,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.person,
                                size: 32,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 32,
                            color: colorScheme.onSurfaceVariant,
                          ),
                  ),
                  // Status badge
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: _getStatusColor(user.status),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Name
              Text(
                user.name,
                style: textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              // Status text
              Text(
                _getStatusText(user.status),
                style: textTheme.bodySmall?.copyWith(
                  color: _getStatusColor(user.status),
                  fontWeight: FontWeight.w500,
                ),
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
        return 'Waiting';
      case UserStatus.inCall:
        return 'In Call';
      case UserStatus.offline:
        return 'Offline';
    }
  }
}
