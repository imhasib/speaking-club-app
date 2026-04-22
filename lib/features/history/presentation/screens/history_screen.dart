import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/call.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/call_history_state.dart';
import '../providers/call_history_provider.dart';
import '../widgets/call_history_item.dart';

/// Call history screen with paginated list and date grouping
class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(callHistoryProvider.notifier).loadCallHistory();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isNearBottom) {
      ref.read(callHistoryProvider.notifier).loadMore();
    }
  }

  bool get _isNearBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll >= (maxScroll * 0.9);
  }

  Future<void> _handleRefresh() async {
    await ref.read(callHistoryProvider.notifier).refresh();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final historyState = ref.watch(callHistoryProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id ?? '';

    // Listen for errors
    ref.listen<CallHistoryState>(callHistoryProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: colorScheme.error,
            action: SnackBarAction(
              label: 'Retry',
              textColor: colorScheme.onError,
              onPressed: () {
                ref.read(callHistoryProvider.notifier).loadCallHistory();
              },
            ),
          ),
        );
        ref.read(callHistoryProvider.notifier).clearError();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Call History'),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildBody(context, historyState, colorScheme, textTheme, currentUserId),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    CallHistoryState state,
    ColorScheme colorScheme,
    TextTheme textTheme,
    String currentUserId,
  ) {
    // Initial loading state - show shimmer
    if (state.isLoading && state.calls.isEmpty) {
      return const ShimmerCallHistoryList(itemCount: 10);
    }

    // Empty state
    if (!state.isLoading && state.calls.isEmpty && !state.hasError) {
      return _buildEmptyState(colorScheme, textTheme);
    }

    // Error state with no data
    if (state.hasError && state.calls.isEmpty) {
      return _buildErrorState(colorScheme, textTheme);
    }

    // Build grouped list
    return _buildGroupedList(context, state, currentUserId);
  }

  Widget _buildEmptyState(ColorScheme colorScheme, TextTheme textTheme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        const AnimatedEmptyState(
          icon: Icons.history,
          title: 'No call history yet',
          subtitle: 'Make your first call to see history here',
        ),
      ],
    );
  }

  Widget _buildErrorState(ColorScheme colorScheme, TextTheme textTheme) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.15),
        AnimatedEmptyState(
          icon: Icons.error_outline,
          title: 'Failed to load history',
          subtitle: 'Pull down to try again',
          actionLabel: 'Retry',
          onAction: () {
            ref.read(callHistoryProvider.notifier).loadCallHistory();
          },
        ),
      ],
    );
  }

  Widget _buildGroupedList(
    BuildContext context,
    CallHistoryState state,
    String currentUserId,
  ) {
    final groupedCalls = state.groupedCalls;
    final groups = groupedCalls.keys.toList();

    // Build list items with headers
    final List<Widget> items = [];
    for (final group in groups) {
      // Add header
      items.add(DateGroupHeader(label: group.label));

      // Add calls for this group
      for (final call in groupedCalls[group]!) {
        items.add(CallHistoryItem(
          call: call,
          currentUserId: currentUserId,
          onTap: () => _showCallDetails(call),
        ));
      }
    }

    // Add loading indicator at the bottom if loading more
    if (state.isLoadingMore) {
      items.add(const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(child: CircularProgressIndicator()),
      ));
    }

    // Add bottom padding for FAB
    items.add(const SizedBox(height: 80));

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      children: items,
    );
  }

  void _showCallDetails(Call call) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.read(authProvider);
    final currentUserId = authState.user?.id ?? '';
    final otherParticipant = call.getOtherParticipant(currentUserId);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  child: Icon(
                    Icons.person,
                    size: 28,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherParticipant?.name ?? 'Unknown',
                        style: textTheme.titleLarge,
                      ),
                      Text(
                        call.type.isRandom ? 'Random Match' : 'Direct Call',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 16),
            // Details
            _buildDetailRow(
              context,
              icon: _getStatusIcon(call.status),
              iconColor: _getStatusColor(call.status),
              label: 'Status',
              value: _getStatusText(call.status),
            ),
            const SizedBox(height: 12),
            _buildDetailRow(
              context,
              icon: Icons.access_time,
              label: 'Date & Time',
              value: _formatDateTime(call.startedAt),
            ),
            if (call.status.isCompleted && call.duration != null) ...[
              const SizedBox(height: 12),
              _buildDetailRow(
                context,
                icon: Icons.timer_outlined,
                label: 'Duration',
                value: call.formattedDuration,
              ),
            ],
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    Color? iconColor,
    required String label,
    required String value,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: iconColor ?? colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  IconData _getStatusIcon(CallStatus status) {
    switch (status) {
      case CallStatus.completed:
        return Icons.call_made;
      case CallStatus.missed:
        return Icons.call_missed;
      case CallStatus.cancelled:
        return Icons.call_end;
      case CallStatus.rejected:
        return Icons.call_missed_outgoing;
    }
  }

  Color _getStatusColor(CallStatus status) {
    switch (status) {
      case CallStatus.completed:
        return Colors.green;
      case CallStatus.missed:
        return Colors.red;
      case CallStatus.cancelled:
        return Colors.grey;
      case CallStatus.rejected:
        return Colors.orange;
    }
  }

  String _getStatusText(CallStatus status) {
    switch (status) {
      case CallStatus.completed:
        return 'Completed';
      case CallStatus.missed:
        return 'Missed';
      case CallStatus.cancelled:
        return 'Cancelled';
      case CallStatus.rejected:
        return 'Rejected';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final hour = dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} at $hour:$minute $period';
  }
}
