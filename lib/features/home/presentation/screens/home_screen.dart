import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/call.dart';
import '../../../../shared/models/online_user.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../call/call.dart';
import '../../../realtime/data/socket_service.dart';
import '../../../realtime/domain/presence_state.dart';
import '../../../realtime/presentation/providers/presence_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectAndGoOnline();
    });
  }

  Future<void> _connectAndGoOnline() async {
    final presenceNotifier = ref.read(presenceProvider.notifier);
    await presenceNotifier.connect();
    if (ref.read(presenceProvider).isConnected) {
      presenceNotifier.goOnline();
    }
  }

  void _handleStatusToggle() {
    final presenceNotifier = ref.read(presenceProvider.notifier);
    final state = ref.read(presenceProvider);

    if (state.connectionState == SocketConnectionState.disconnected ||
        state.connectionState == SocketConnectionState.error) {
      _connectAndGoOnline();
    } else if (state.isConnected) {
      presenceNotifier.toggleOnlineStatus();
    }
  }

  void _handleFindMatch() {
    final state = ref.read(presenceProvider);

    if (!state.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please connect first to find a match')),
      );
      return;
    }

    if (!state.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please go online first to find a match')),
      );
      return;
    }

    if (state.isWaiting) {
      ref.read(matchmakingProvider.notifier).leaveQueue();
    } else {
      context.push(Routes.waiting);
    }
  }

  void _handleUserTap(OnlineUser user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${user.name}?'),
        content: const Text('Start a video call with this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(callProvider.notifier).initiateCall(
                    user.id,
                    PeerInfo(
                      id: user.id,
                      name: user.name,
                      profilePicture: user.profilePicture,
                    ),
                  );
              context.push(Routes.waiting);
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    final presenceNotifier = ref.read(presenceProvider.notifier);
    presenceNotifier.disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    await _connectAndGoOnline();
  }

  @override
  Widget build(BuildContext context) {
    final presenceState = ref.watch(presenceProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id;

    ref.listen<PresenceState>(presenceProvider, (previous, next) {
      final currentError = next.error;
      final previousError = previous?.error;
      if (currentError != null && currentError != previousError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentError),
            backgroundColor: AppColors.redPrimary,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () {
                ref.read(presenceProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    ref.listen<CallState>(callProvider, (previous, next) {
      if (next.phase == CallPhase.incoming &&
          previous?.phase != CallPhase.incoming) {
        context.push(Routes.incomingCall);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: _TopBar(
                  presenceState: presenceState,
                  onToggleStatus: _handleStatusToggle,
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: _StreakCard(),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: _QuickActionsRow(
                    presenceState: presenceState,
                    onAiPractice: () => context.push(Routes.aiPractice),
                    onFindMatch: _handleFindMatch,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: _buildOnlineSection(
                  presenceState,
                  currentUserId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOnlineSection(
    PresenceState presenceState,
    String? currentUserId,
  ) {
    if (presenceState.isLoading) {
      return const Padding(
        padding: EdgeInsets.only(top: 16),
        child: ShimmerUserGrid(itemCount: 4),
      );
    }

    if (presenceState.connectionState == SocketConnectionState.disconnected ||
        presenceState.connectionState == SocketConnectionState.error) {
      return Padding(
        padding: const EdgeInsets.only(top: 24),
        child: AnimatedEmptyState(
          icon: Icons.cloud_off,
          title: 'Not connected',
          subtitle: 'Tap to connect to the server',
          actionLabel: 'Connect',
          onAction: _connectAndGoOnline,
        ),
      );
    }

    if (presenceState.connectionState == SocketConnectionState.connecting ||
        presenceState.connectionState == SocketConnectionState.reconnecting) {
      return const Padding(
        padding: EdgeInsets.only(top: 48),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final others = presenceState.onlineUsers
        .where((u) => u.id != currentUserId)
        .toList();

    if (others.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 32),
        child: AnimatedEmptyState(
          icon: Icons.people_outline,
          title: 'No users online right now',
          subtitle: 'Pull down to refresh or tap "Find Match"',
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Online now',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.greenSoft,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  '${others.length} people →',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.greenPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.1,
            ),
            itemCount: others.length,
            itemBuilder: (context, index) {
              final user = others[index];
              return _OnlineUserTile(
                user: user,
                onTap: user.status.isAvailable
                    ? () => _handleUserTap(user)
                    : null,
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  final PresenceState presenceState;
  final VoidCallback onToggleStatus;

  const _TopBar({
    required this.presenceState,
    required this.onToggleStatus,
  });

  @override
  Widget build(BuildContext context) {
    final isOnline = presenceState.isOnline;

    return Container(
      color: AppColors.surface,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 10,
        left: 20,
        right: 16,
        bottom: 10,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Speaking Club',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.5,
              ),
            ),
          ),
          GestureDetector(
            onTap: onToggleStatus,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: isOnline ? AppColors.greenSoft : AppColors.surfaceSubtle,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isOnline
                          ? AppColors.greenPrimary
                          : AppColors.mutedSoft,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isOnline
                          ? AppColors.greenPrimary
                          : AppColors.mutedInk,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  static const _days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  static const _activeDays = [true, true, true, true, true, true, false];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.indigoDeep],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                '🔥 7-day streak',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Text(
                'TODAY · 3 / 5 min',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xB3FFFFFF),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: 0.6,
              minHeight: 8,
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation(AppColors.liveMint),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(_days.length, (i) {
              final active = _activeDays[i];
              return Column(
                children: [
                  Text(
                    _days[i],
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withValues(alpha: active ? 0.9 : 0.4),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? AppColors.liveMint
                          : Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsRow extends StatelessWidget {
  final PresenceState presenceState;
  final VoidCallback onAiPractice;
  final VoidCallback onFindMatch;

  const _QuickActionsRow({
    required this.presenceState,
    required this.onAiPractice,
    required this.onFindMatch,
  });

  @override
  Widget build(BuildContext context) {
    final isWaiting = presenceState.isWaiting;
    final onlineCount = presenceState.onlineUsers.length;

    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: onAiPractice,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: const [
                  Icon(
                    Icons.smart_toy_outlined,
                    color: Colors.white,
                    size: 22,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'AI Practice',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            onTap: onFindMatch,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.line),
              ),
              child: Row(
                children: [
                  Icon(
                    isWaiting ? Icons.close : Icons.shuffle,
                    color: isWaiting ? AppColors.redPrimary : AppColors.ink,
                    size: 22,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isWaiting ? 'Cancel' : 'Find Match',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: isWaiting
                                ? AppColors.redPrimary
                                : AppColors.ink,
                          ),
                        ),
                        if (onlineCount > 0)
                          Text(
                            '$onlineCount online',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.greenPrimary,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OnlineUserTile extends StatelessWidget {
  final OnlineUser user;
  final VoidCallback? onTap;

  const _OnlineUserTile({required this.user, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAvatar(
            name: user.name,
            size: 44,
            showOnline: user.status.isAvailable,
          ),
          const SizedBox(height: 8),
          Text(
            user.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.lavenderBg,
              borderRadius: BorderRadius.circular(99),
            ),
            child: const Text(
              'B2',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.lavenderText,
              ),
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                color: onTap != null ? AppColors.primary : AppColors.line,
                borderRadius: BorderRadius.circular(99),
              ),
              child: Text(
                'Call',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: onTap != null ? Colors.white : AppColors.mutedInk,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
