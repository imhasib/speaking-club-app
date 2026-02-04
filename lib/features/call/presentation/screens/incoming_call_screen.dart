import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/call_state.dart';
import '../providers/call_provider.dart';
import '../widgets/call_controls.dart';
import '../widgets/peer_info_card.dart';

/// Incoming call screen displayed when receiving a direct call
class IncomingCallScreen extends ConsumerStatefulWidget {
  const IncomingCallScreen({super.key});

  @override
  ConsumerState<IncomingCallScreen> createState() => _IncomingCallScreenState();
}

class _IncomingCallScreenState extends ConsumerState<IncomingCallScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // Pulse animation for the avatar
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(
        parent: _pulseController,
        curve: Curves.easeInOut,
      ),
    );

    // Vibrate on incoming call (if supported)
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onAccept() {
    ref.read(callProvider.notifier).acceptCall();
  }

  void _onReject() {
    ref.read(callProvider.notifier).rejectCall();
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callProvider);
    final peerInfo = callState.peerInfo;

    // Navigate based on call state changes
    ref.listen(callProvider, (previous, next) {
      if (next.phase == CallPhase.connecting ||
          next.phase == CallPhase.connected) {
        context.go(Routes.call);
      } else if (next.isIdle && previous != null && !previous.isIdle) {
        // Call was cancelled or rejected
        if (context.canPop()) {
          context.pop();
        } else {
          context.go(Routes.home);
        }
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _onReject();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.primary,
        body: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Animated caller avatar
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: child,
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 4,
                    ),
                  ),
                  child: peerInfo != null
                      ? LargePeerInfo(
                          peerInfo: peerInfo,
                          subtitle: 'Incoming call...',
                        )
                      : const CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.white24,
                          child: Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),

              if (peerInfo == null) ...[
                const SizedBox(height: 24),
                Text(
                  'Unknown Caller',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Incoming call...',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ],

              const Spacer(flex: 3),

              // Accept/Reject buttons
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48.0),
                child: IncomingCallButtons(
                  onAccept: _onAccept,
                  onReject: _onReject,
                ),
              ),

              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
