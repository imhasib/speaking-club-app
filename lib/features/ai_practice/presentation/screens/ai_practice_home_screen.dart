import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../shared/models/ai_session.dart';
import '../../../auth/domain/auth_state.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/ai_session_repository.dart';
import '../../domain/ai_practice_state.dart';

/// Entry screen for AI Practice — shows the tier-aware buttons.
///
/// Visibility rules driven by JWT `plan`:
/// - Free user: both buttons visible. Pro is locked, taps show upsell.
/// - Premium user: only Pro is visible.
class AiPracticeHomeScreen extends ConsumerStatefulWidget {
  const AiPracticeHomeScreen({super.key});

  @override
  ConsumerState<AiPracticeHomeScreen> createState() =>
      _AiPracticeHomeScreenState();
}

class _AiPracticeHomeScreenState extends ConsumerState<AiPracticeHomeScreen> {
  AiUsageInfo? _usage;
  bool _loadingUsage = true;
  String? _usageError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadUsage());
  }

  Future<void> _loadUsage() async {
    setState(() {
      _loadingUsage = true;
      _usageError = null;
    });
    try {
      final repo = ref.read(aiSessionRepositoryProvider);
      final info = await repo.getUsageInfo();
      if (mounted) {
        setState(() {
          _usage = info;
          _loadingUsage = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loadingUsage = false;
          _usageError = e.toString();
        });
      }
    }
  }

  void _openModeSelection(PracticeType type) {
    context.push(Routes.aiPracticeModes, extra: type);
  }

  void _showUpsellSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Upgrade to Premium for unlimited AI practice with realtime quality',
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authProvider);
    final plan = authState.user?.plan ?? 'free';
    final isPremium = plan == 'premium';

    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Practice'),
      ),
      body: RefreshIndicator(
        onRefresh: _loadUsage,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Choose your practice mode',
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              isPremium
                  ? 'Realtime, premium quality conversations.'
                  : 'Practice for free, or upgrade to Pro for premium quality.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),

            // Free tier — hidden entirely for premium users.
            if (!isPremium) ...[
              Semantics(
                identifier: 'aiPracticeFreeButton',
                child: _TierButton(
                  key: const Key('aiPracticeFreeButton'),
                  title: 'AI Practice',
                  subtitle: '5 minutes daily, free',
                  icon: Icons.smart_toy_outlined,
                  color: colorScheme.primary,
                  onTap: () => _openModeSelection(PracticeType.free),
                ),
              ),
              const SizedBox(height: 8),
              _RemainingTimeLabel(
                practiceType: PracticeType.free,
                usage: _usage,
                loading: _loadingUsage,
                error: _usageError,
                isActiveTier: !isPremium,
              ),
              const SizedBox(height: 24),
            ],

            // Pro tier — locked for free users, active for premium.
            Semantics(
              identifier: 'aiPracticeProButton',
              child: _TierButton(
                key: const Key('aiPracticeProButton'),
                title: 'AI Practice Pro',
                subtitle: isPremium
                    ? '1 hour daily, realtime quality'
                    : 'Upgrade to Premium',
                icon: Icons.smart_toy,
                color: isPremium
                    ? colorScheme.tertiary
                    : colorScheme.onSurfaceVariant,
                locked: !isPremium,
                showCrown: isPremium,
                onTap: isPremium
                    ? () => _openModeSelection(PracticeType.premium)
                    : _showUpsellSnackbar,
              ),
            ),
            if (isPremium) ...[
              const SizedBox(height: 8),
              _RemainingTimeLabel(
                practiceType: PracticeType.premium,
                usage: _usage,
                loading: _loadingUsage,
                error: _usageError,
                isActiveTier: true,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TierButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool locked;
  final bool showCrown;
  final VoidCallback onTap;

  const _TierButton({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
    this.locked = false,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: locked ? 0.55 : 1.0,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (showCrown) ...[
                            const SizedBox(width: 6),
                            Icon(
                              Icons.workspace_premium,
                              size: 18,
                              color: colorScheme.tertiary,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                if (locked)
                  Semantics(
                    identifier: 'aiPracticeProLockIcon',
                    child: Icon(
                      Icons.lock_outline,
                      key: const Key('aiPracticeProLockIcon'),
                      color: colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RemainingTimeLabel extends StatelessWidget {
  final PracticeType practiceType;
  final AiUsageInfo? usage;
  final bool loading;
  final String? error;
  final bool isActiveTier;

  const _RemainingTimeLabel({
    required this.practiceType,
    required this.usage,
    required this.loading,
    required this.error,
    required this.isActiveTier,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    String text;
    if (loading) {
      text = 'Loading remaining time…';
    } else if (error != null) {
      text = 'Daily limit: ${_formatLimit(practiceType.dailyLimitSeconds)}';
    } else if (usage != null) {
      text =
          '${usage!.formattedRemaining} remaining of ${_formatLimit(practiceType.dailyLimitSeconds)} today';
    } else {
      text = 'Daily limit: ${_formatLimit(practiceType.dailyLimitSeconds)}';
    }

    final identifier = practiceType == PracticeType.free
        ? 'aiPracticeRemainingTime'
        : 'aiPracticeRemainingTimePro';
    return Semantics(
      identifier: identifier,
      child: Padding(
        key: Key(identifier),
        padding: const EdgeInsets.only(left: 12),
        child: Text(
          text,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  String _formatLimit(int seconds) {
    if (seconds >= 3600) return '${seconds ~/ 3600} hr';
    if (seconds >= 60) return '${seconds ~/ 60} min';
    return '${seconds}s';
  }
}
