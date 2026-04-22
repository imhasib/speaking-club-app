import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/animations/animations.dart';
import '../../domain/call_state.dart';
import '../providers/call_provider.dart';
import '../providers/matchmaking_provider.dart';

/// Waiting screen for matchmaking queue
class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key});

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.15).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Join queue on screen load only for random matchmaking (not direct calls)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final callState = ref.read(callProvider);
      // Don't join matchmaking queue if we're already initiating a direct call
      if (!callState.isInitiating) {
        ref.read(matchmakingProvider.notifier).joinQueue();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onCancel() {
    final callState = ref.read(callProvider);
    if (callState.isInitiating) {
      // Cancel direct call
      ref.read(callProvider.notifier).cancelCall();
    } else {
      // Leave matchmaking queue
      ref.read(matchmakingProvider.notifier).leaveQueue();
    }
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(Routes.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final matchmakingState = ref.watch(matchmakingProvider);
    final callState = ref.watch(callProvider);
    final isDirectCall = callState.isInitiating;

    // Navigate to call screen when matched and connecting
    ref.listen(callProvider, (previous, next) {
      if (next.phase == CallPhase.connecting ||
          next.phase == CallPhase.connected) {
        context.go(Routes.call);
      }
      // Handle direct call rejection/cancellation - go back if call becomes idle
      if (previous?.isInitiating == true && next.isIdle) {
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.home);
        }
      }
    });

    // Handle errors
    ref.listen(matchmakingProvider, (previous, next) {
      if (next.hasError && next.error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!)),
        );
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onCancel();
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // App bar with back button
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: _onCancel,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Animated search indicator with radar effect
              Stack(
                alignment: Alignment.center,
                children: [
                  SearchingIndicator(
                    size: 160,
                    color: AppColors.primary,
                    duration: const Duration(milliseconds: 2000),
                  ),
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.primary.withOpacity(0.2),
                          ),
                          child: Icon(
                            isDirectCall ? Icons.call : Icons.person_search,
                            size: 40,
                            color: AppColors.primary,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 40),

              Text(
                isDirectCall
                    ? 'Calling ${callState.peerInfo?.name ?? 'user'}...'
                    : 'Finding someone to talk to...',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),

              const SizedBox(height: 16),

              // Waiting time (only for matchmaking)
              if (!isDirectCall)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.timer_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        matchmakingState.formattedWaitTime,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),

              const Spacer(),

              // Cancel button
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _onCancel,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
