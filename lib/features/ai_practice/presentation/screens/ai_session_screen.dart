import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/ai_practice_state.dart';
import '../providers/ai_practice_provider.dart';
import '../widgets/audio_waveform.dart';
import '../widgets/conversation_transcript.dart';

/// Screen for active AI practice session
class AiSessionScreen extends ConsumerStatefulWidget {
  const AiSessionScreen({super.key});

  @override
  ConsumerState<AiSessionScreen> createState() => _AiSessionScreenState();
}

class _AiSessionScreenState extends ConsumerState<AiSessionScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _handleMicTap() {
    final state = ref.read(aiPracticeProvider);
    final notifier = ref.read(aiPracticeProvider.notifier);

    if (state.phase == AiPracticePhase.listening) {
      notifier.stopListening();
    } else if (state.canSpeak) {
      notifier.startListening();
    }
  }

  void _handleEndSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Session?'),
        content: const Text('Are you sure you want to end this practice session?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(aiPracticeProvider.notifier).endSession();
              context.go(Routes.aiSummary);
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.callEndButton,
            ),
            child: const Text('End Session'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final state = ref.watch(aiPracticeProvider);

    // Listen for session end
    ref.listen<AiPracticeState>(aiPracticeProvider, (previous, next) {
      if (previous?.isActive == true && !next.isActive) {
        // Session ended, navigate to summary or home
        if (context.mounted) {
          context.go(Routes.aiSummary);
        }
      }

      // Show error snackbar
      if (next.error != null && next.error != previous?.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            action: SnackBarAction(
              label: 'Dismiss',
              onPressed: () {
                ref.read(aiPracticeProvider.notifier).clearError();
              },
            ),
          ),
        );
      }
    });

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleEndSession();
        }
      },
      child: Scaffold(
        backgroundColor: colorScheme.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(colorScheme, textTheme, state),

              // Waveform area
              Expanded(
                flex: 2,
                child: _buildWaveformArea(colorScheme, textTheme, state),
              ),

              // Transcript
              Expanded(
                flex: 3,
                child: ConversationTranscript(
                  messages: state.messages,
                  currentUserText: state.currentUserText,
                  currentAiText: state.currentAiText,
                  isListening: state.phase == AiPracticePhase.listening,
                  isThinking: state.phase == AiPracticePhase.thinking,
                ),
              ),

              // Controls
              _buildControls(colorScheme, state),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AiPracticeState state,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Persona info
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AI Practice',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                state.mode.displayName,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 4),
                Text(
                  state.formattedDuration,
                  style: textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Remaining time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: state.isTimeLow
                  ? colorScheme.errorContainer
                  : colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              '${state.formattedRemaining} left',
              style: textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: state.isTimeLow
                    ? colorScheme.onErrorContainer
                    : colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaveformArea(
    ColorScheme colorScheme,
    TextTheme textTheme,
    AiPracticeState state,
  ) {
    final isConnecting = state.isConnecting;
    final isListening = state.phase == AiPracticePhase.listening;
    final isAiSpeaking = state.phase == AiPracticePhase.aiSpeaking;

    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Waveform or loading indicator
          if (isConnecting)
            Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  state.statusText,
                  style: textTheme.bodyLarge,
                ),
              ],
            )
          else
            AudioWaveformWidget(
              isActive: isListening || isAiSpeaking,
              color: isListening ? AppColors.secondary : AppColors.primary,
              height: 80,
            ),
          const SizedBox(height: 24),

          // Status text
          if (!isConnecting)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildStatusIcon(state),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      state.statusText,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(AiPracticeState state) {
    switch (state.phase) {
      case AiPracticePhase.listening:
        return const Icon(Icons.mic, color: AppColors.secondary, size: 20);
      case AiPracticePhase.thinking:
        return SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Theme.of(context).colorScheme.primary,
          ),
        );
      case AiPracticePhase.aiSpeaking:
        return const Icon(Icons.volume_up, color: AppColors.primary, size: 20);
      default:
        return Icon(
          Icons.touch_app_outlined,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          size: 20,
        );
    }
  }

  Widget _buildControls(ColorScheme colorScheme, AiPracticeState state) {
    final isListening = state.phase == AiPracticePhase.listening;
    final canInteract = state.isInConversation;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute button
          _ControlButton(
            icon: state.isMuted ? Icons.mic_off : Icons.mic_none,
            label: state.isMuted ? 'Unmute' : 'Mute',
            isActive: !state.isMuted,
            onTap: canInteract
                ? () => ref.read(aiPracticeProvider.notifier).toggleMute()
                : null,
          ),

          // Main mic button
          GestureDetector(
            onTap: canInteract ? _handleMicTap : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isListening
                    ? AppColors.secondary
                    : canInteract
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                boxShadow: isListening
                    ? [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: Icon(
                isListening ? Icons.stop : Icons.mic,
                size: 36,
                color: isListening
                    ? Colors.white
                    : canInteract
                        ? colorScheme.onPrimaryContainer
                        : colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          // End button
          _ControlButton(
            icon: Icons.call_end,
            label: 'End',
            isActive: true,
            isDestructive: true,
            onTap: _handleEndSession,
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final bool isDestructive;
  final VoidCallback? onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    this.isActive = true,
    this.isDestructive = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Color backgroundColor;
    Color iconColor;

    if (isDestructive) {
      backgroundColor = AppColors.callEndButton;
      iconColor = Colors.white;
    } else if (!isActive) {
      backgroundColor = colorScheme.errorContainer;
      iconColor = colorScheme.onErrorContainer;
    } else {
      backgroundColor = colorScheme.surfaceContainerHighest;
      iconColor = colorScheme.onSurfaceVariant;
    }

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: backgroundColor,
            ),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
