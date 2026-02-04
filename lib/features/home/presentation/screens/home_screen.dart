import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../shared/models/call.dart';
import '../../../../shared/models/online_user.dart';
import '../../../call/call.dart';
import '../../../realtime/data/socket_service.dart';
import '../../../realtime/domain/presence_state.dart';
import '../../../realtime/presentation/providers/presence_provider.dart';
import '../widgets/online_user_card.dart';
import '../widgets/status_toggle.dart';

/// Home screen showing online users list
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Connect to socket when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connectAndGoOnline();
    });
  }

  Future<void> _connectAndGoOnline() async {
    final presenceNotifier = ref.read(presenceProvider.notifier);
    await presenceNotifier.connect();
    // Go online after successful connection
    if (ref.read(presenceProvider).isConnected) {
      presenceNotifier.goOnline();
    }
  }

  void _handleStatusToggle() {
    final presenceNotifier = ref.read(presenceProvider.notifier);
    final state = ref.read(presenceProvider);

    if (state.connectionState == SocketConnectionState.disconnected ||
        state.connectionState == SocketConnectionState.error) {
      // Reconnect
      _connectAndGoOnline();
    } else if (state.isConnected) {
      // Toggle online/offline status
      presenceNotifier.toggleOnlineStatus();
    }
  }

  void _handleFindMatch() {
    final state = ref.read(presenceProvider);

    if (!state.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please connect first to find a match'),
        ),
      );
      return;
    }

    if (!state.isOnline) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please go online first to find a match'),
        ),
      );
      return;
    }

    if (state.isWaiting) {
      // Cancel matchmaking - leave queue via matchmaking provider
      ref.read(matchmakingProvider.notifier).leaveQueue();
    } else {
      // Navigate to waiting screen (which will join the queue)
      context.push(Routes.waiting);
    }
  }

  void _handleUserTap(OnlineUser user) {
    // Show confirmation dialog for direct calling
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Call ${user.username}?'),
        content: const Text('Start a video call with this user?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Initiate direct call
              ref.read(callProvider.notifier).initiateCall(
                user.id,
                PeerInfo(
                  id: user.id,
                  username: user.username,
                  avatar: user.avatar,
                ),
              );
              // Navigate to waiting screen for outgoing call
              context.push(Routes.waiting);
            },
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Refresh by reconnecting
    final presenceNotifier = ref.read(presenceProvider.notifier);
    presenceNotifier.disconnect();
    await Future.delayed(const Duration(milliseconds: 500));
    await _connectAndGoOnline();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final presenceState = ref.watch(presenceProvider);

    // Show error snackbar if there's an error
    ref.listen<PresenceState>(presenceProvider, (previous, next) {
      final currentError = next.error;
      final previousError = previous?.error;
      if (currentError != null && currentError != previousError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(currentError),
            backgroundColor: colorScheme.error,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: colorScheme.onError,
              onPressed: () {
                ref.read(presenceProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    // Listen for incoming calls to navigate to incoming call screen
    ref.listen<CallState>(callProvider, (previous, next) {
      if (next.phase == CallPhase.incoming &&
          previous?.phase != CallPhase.incoming) {
        context.push(Routes.incomingCall);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Speaking Club'),
        actions: [
          StatusToggle(
            status: presenceState.userStatus,
            connectionState: presenceState.connectionState,
            onTap: _handleStatusToggle,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildBody(context, presenceState, colorScheme, textTheme),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleFindMatch,
        icon: Icon(presenceState.isWaiting ? Icons.close : Icons.shuffle),
        label: Text(presenceState.isWaiting ? 'Cancel' : 'Find Match'),
        backgroundColor: presenceState.isWaiting
            ? colorScheme.errorContainer
            : colorScheme.primaryContainer,
        foregroundColor: presenceState.isWaiting
            ? colorScheme.onErrorContainer
            : colorScheme.onPrimaryContainer,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(
    BuildContext context,
    presenceState,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    // Loading state
    if (presenceState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    // Error or disconnected state
    if (presenceState.connectionState == SocketConnectionState.disconnected ||
        presenceState.connectionState == SocketConnectionState.error) {
      return _buildDisconnectedState(context, colorScheme, textTheme);
    }

    // Connecting state
    if (presenceState.connectionState == SocketConnectionState.connecting ||
        presenceState.connectionState == SocketConnectionState.reconnecting) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Connecting to server...'),
          ],
        ),
      );
    }

    // Empty state - no online users
    if (presenceState.onlineUsers.isEmpty) {
      return _buildEmptyState(context, colorScheme, textTheme);
    }

    // Online users grid
    return _buildOnlineUsersGrid(context, presenceState.onlineUsers);
  }

  Widget _buildDisconnectedState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.cloud_off,
              size: 80,
              color: colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 24),
            Text(
              'Not connected',
              style: textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tap to connect to the server',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _connectAndGoOnline,
              icon: const Icon(Icons.refresh),
              label: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.25),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.people_outline,
                  size: 80,
                  color: colorScheme.primary.withOpacity(0.5),
                ),
                const SizedBox(height: 24),
                Text(
                  'No users online right now',
                  style: textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Pull down to refresh or tap "Find Match" to start random matching',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOnlineUsersGrid(BuildContext context, List<OnlineUser> users) {
    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.9,
      ),
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return OnlineUserCard(
          user: user,
          onTap: user.status.isAvailable ? () => _handleUserTap(user) : null,
        );
      },
    );
  }
}
