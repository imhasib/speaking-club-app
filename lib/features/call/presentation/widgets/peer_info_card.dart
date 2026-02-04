import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../shared/models/call.dart';

/// Peer information card widget displaying avatar and username
class PeerInfoCard extends StatelessWidget {
  final PeerInfo peerInfo;

  const PeerInfoCard({
    super.key,
    required this.peerInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white24,
            child: peerInfo.avatar != null
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: peerInfo.avatar!,
                      width: 32,
                      height: 32,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 16,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Icon(
                    Icons.person,
                    size: 16,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(width: 8),
          Text(
            peerInfo.username,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// Large peer info display for incoming call screen
class LargePeerInfo extends StatelessWidget {
  final PeerInfo peerInfo;
  final String? subtitle;

  const LargePeerInfo({
    super.key,
    required this.peerInfo,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Avatar
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.white24,
          child: peerInfo.avatar != null
              ? ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: peerInfo.avatar!,
                    width: 120,
                    height: 120,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
        ),

        const SizedBox(height: 24),

        // Username
        Text(
          peerInfo.username,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
        ),

        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.white70,
                ),
          ),
        ],
      ],
    );
  }
}
