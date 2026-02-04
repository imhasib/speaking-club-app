import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// In-call controls widget with mute, video, speaker, camera switch, and end call buttons
class CallControls extends StatelessWidget {
  final bool isAudioMuted;
  final bool isVideoEnabled;
  final bool isSpeakerOn;
  final VoidCallback onToggleAudio;
  final VoidCallback onToggleVideo;
  final VoidCallback onToggleSpeaker;
  final VoidCallback onSwitchCamera;
  final VoidCallback onEndCall;

  const CallControls({
    super.key,
    required this.isAudioMuted,
    required this.isVideoEnabled,
    required this.isSpeakerOn,
    required this.onToggleAudio,
    required this.onToggleVideo,
    required this.onToggleSpeaker,
    required this.onSwitchCamera,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(32),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mute audio
          _ControlButton(
            icon: isAudioMuted ? Icons.mic_off : Icons.mic,
            isActive: !isAudioMuted,
            isMuted: isAudioMuted,
            onPressed: onToggleAudio,
            tooltip: isAudioMuted ? 'Unmute' : 'Mute',
          ),

          // Toggle video
          _ControlButton(
            icon: isVideoEnabled ? Icons.videocam : Icons.videocam_off,
            isActive: isVideoEnabled,
            isMuted: !isVideoEnabled,
            onPressed: onToggleVideo,
            tooltip: isVideoEnabled ? 'Turn off camera' : 'Turn on camera',
          ),

          // Toggle speaker
          _ControlButton(
            icon: isSpeakerOn ? Icons.volume_up : Icons.volume_down,
            isActive: isSpeakerOn,
            onPressed: onToggleSpeaker,
            tooltip: isSpeakerOn ? 'Use earpiece' : 'Use speaker',
          ),

          // Switch camera
          _ControlButton(
            icon: Icons.cameraswitch,
            isActive: true,
            onPressed: onSwitchCamera,
            tooltip: 'Switch camera',
          ),

          // End call
          _ControlButton(
            icon: Icons.call_end,
            isEndCall: true,
            onPressed: onEndCall,
            tooltip: 'End call',
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool isEndCall;
  final bool isMuted;
  final VoidCallback onPressed;
  final String? tooltip;

  const _ControlButton({
    required this.icon,
    this.isActive = true,
    this.isEndCall = false,
    this.isMuted = false,
    required this.onPressed,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color iconColor;

    if (isEndCall) {
      backgroundColor = AppColors.callEndButton;
      iconColor = Colors.white;
    } else if (isMuted) {
      backgroundColor = AppColors.callControlMuted.withOpacity(0.3);
      iconColor = AppColors.callControlMuted;
    } else {
      backgroundColor = isActive ? Colors.white24 : Colors.white.withOpacity(0.1);
      iconColor = isActive
          ? AppColors.callControlActive
          : AppColors.callControlInactive;
    }

    final button = Material(
      color: backgroundColor,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Container(
          width: 52,
          height: 52,
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: iconColor,
            size: 24,
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}

/// Accept/Reject call buttons for incoming call screen
class IncomingCallButtons extends StatelessWidget {
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const IncomingCallButtons({
    super.key,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Reject button
        _CallActionButton(
          icon: Icons.call_end,
          color: AppColors.callEndButton,
          onPressed: onReject,
          label: 'Decline',
        ),

        // Accept button
        _CallActionButton(
          icon: Icons.call,
          color: AppColors.callAcceptButton,
          onPressed: onAccept,
          label: 'Accept',
        ),
      ],
    );
  }
}

class _CallActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;
  final String label;

  const _CallActionButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          color: color,
          shape: const CircleBorder(),
          elevation: 4,
          child: InkWell(
            onTap: onPressed,
            customBorder: const CircleBorder(),
            child: Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              child: Icon(
                icon,
                color: Colors.white,
                size: 32,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
