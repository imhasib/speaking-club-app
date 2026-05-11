import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/models/call.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../../../shared/widgets/app_avatar.dart';
import '../../../../shared/widgets/sc_app_bar.dart';
import '../../../../shared/widgets/sc_filter_chip_bar.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/call_history_state.dart';
import '../providers/call_history_provider.dart';

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  int _selectedFilter = 0;

  static const _chips = [
    ScFilterChipData(label: 'All'),
    ScFilterChipData(label: 'AI'),
    ScFilterChipData(label: 'People'),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
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
    final historyState = ref.watch(callHistoryProvider);
    final authState = ref.watch(authProvider);
    final currentUserId = authState.user?.id ?? '';

    ref.listen<CallHistoryState>(callHistoryProvider, (previous, next) {
      if (next.hasError && next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.redPrimary,
            action: SnackBarAction(
              label: 'Retry',
              textColor: Colors.white,
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
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const ScAppBar(title: 'Call History'),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: ScFilterChipBar(
              chips: _chips,
              selectedIndex: _selectedFilter,
              onSelected: (i) => setState(() => _selectedFilter = i),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: _buildBody(historyState, currentUserId),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(CallHistoryState state, String currentUserId) {
    if (state.isLoading && state.calls.isEmpty) {
      return const ShimmerCallHistoryList(itemCount: 10);
    }

    if (!state.isLoading && state.calls.isEmpty && !state.hasError) {
      return _buildEmptyState();
    }

    if (state.hasError && state.calls.isEmpty) {
      return _buildErrorState();
    }

    return _buildGroupedList(state, currentUserId);
  }

  Widget _buildEmptyState() {
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

  Widget _buildErrorState() {
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

  Widget _buildGroupedList(CallHistoryState state, String currentUserId) {
    final groupedCalls = state.groupedCalls;
    final groups = groupedCalls.keys.toList();

    final List<Widget> items = [];
    for (final group in groups) {
      items.add(_DateGroupHeader(label: group.label));
      for (final call in groupedCalls[group]!) {
        items.add(_HistoryCard(
          call: call,
          currentUserId: currentUserId,
          onTap: () => _showCallDetails(call),
        ));
      }
    }

    if (state.isLoadingMore) {
      items.add(const Padding(
        padding: EdgeInsets.all(16),
        child: Center(child: CircularProgressIndicator()),
      ));
    }

    items.add(const SizedBox(height: 32));

    return ListView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: items,
    );
  }

  void _showCallDetails(Call call) {
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
            Row(
              children: [
                AppAvatar(name: otherParticipant?.name ?? '?', size: 48),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        otherParticipant?.name ?? 'Unknown',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        call.type.isRandom ? 'Random Match' : 'Direct Call',
                        style: const TextStyle(color: AppColors.mutedInk),
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
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.access_time,
              label: 'Date',
              value: _formatDateTime(call.startedAt),
            ),
            if (call.status.isCompleted && call.duration != null) ...[
              const SizedBox(height: 8),
              _DetailRow(
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

  String _formatDateTime(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final h = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} at $h:$min $period';
  }
}

class _DateGroupHeader extends StatelessWidget {
  final String label;

  const _DateGroupHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.mutedInk,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final Call call;
  final String currentUserId;
  final VoidCallback onTap;

  const _HistoryCard({
    required this.call,
    required this.currentUserId,
    required this.onTap,
  });

  bool get _isAiCall => call.type == CallType.direct;

  @override
  Widget build(BuildContext context) {
    final other = call.getOtherParticipant(currentUserId);
    final name = other?.name ?? 'Unknown';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.line),
        ),
        child: Row(
          children: [
            AppAvatar(name: name, size: 42),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _buildSubtitle(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedInk,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            _TagPill(isAi: _isAiCall),
          ],
        ),
      ),
    );
  }

  String _buildSubtitle() {
    final parts = <String>[];
    final dt = call.startedAt;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    parts.add('${months[dt.month - 1]} ${dt.day}');
    if (call.status.isCompleted) {
      parts.add(call.formattedDuration);
    }
    return parts.join(' · ');
  }
}

class _TagPill extends StatelessWidget {
  final bool isAi;

  const _TagPill({required this.isAi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: isAi ? AppColors.lavenderBg : const Color(0xFFFFE4EE),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        isAi ? 'AI' : 'Match',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: isAi ? AppColors.lavenderText : const Color(0xFFB0375A),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.mutedInk),
        const SizedBox(width: 10),
        Text(label, style: const TextStyle(color: AppColors.mutedInk)),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
