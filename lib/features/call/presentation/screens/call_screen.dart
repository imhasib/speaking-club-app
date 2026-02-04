import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/router/routes.dart';
import '../../data/webrtc_service.dart';
import '../../domain/call_state.dart';
import '../providers/call_provider.dart';
import '../widgets/call_controls.dart';
import '../widgets/call_timer.dart';
import '../widgets/peer_info_card.dart';
import '../widgets/video_view.dart';

/// Active call screen with video and controls
class CallScreen extends ConsumerStatefulWidget {
  const CallScreen({super.key});

  @override
  ConsumerState<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends ConsumerState<CallScreen> {
  final RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  final RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  bool _isLocalVideoSmall = true;
  bool _controlsVisible = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _initializeRenderers();
    _setFullScreen(true);
    _startHideControlsTimer();
  }

  Future<void> _initializeRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    // Get WebRTC service and set up streams
    final webrtcService = ref.read(webrtcServiceProvider);

    // Set initial streams if available
    if (webrtcService.currentLocalStream != null) {
      _localRenderer.srcObject = webrtcService.currentLocalStream;
    }
    if (webrtcService.currentRemoteStream != null) {
      _remoteRenderer.srcObject = webrtcService.currentRemoteStream;
    }

    // Listen to stream changes
    webrtcService.localStream.listen((stream) {
      if (mounted) {
        setState(() {
          _localRenderer.srcObject = stream;
        });
      }
    });

    webrtcService.remoteStream.listen((stream) {
      if (mounted) {
        setState(() {
          _remoteRenderer.srcObject = stream;
        });
      }
    });
  }

  void _setFullScreen(bool fullScreen) {
    if (fullScreen) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _controlsVisible = false;
        });
      }
    });
  }

  void _toggleControlsVisibility() {
    setState(() {
      _controlsVisible = !_controlsVisible;
    });
    if (_controlsVisible) {
      _startHideControlsTimer();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _setFullScreen(false);
    super.dispose();
  }

  void _onEndCall() {
    ref.read(callProvider.notifier).endCall();
  }

  void _swapVideoViews() {
    setState(() {
      _isLocalVideoSmall = !_isLocalVideoSmall;
    });
  }

  @override
  Widget build(BuildContext context) {
    final callState = ref.watch(callProvider);

    // Navigate back when call ends
    ref.listen(callProvider, (previous, next) {
      if (next.isIdle && previous != null && !previous.isIdle) {
        // Show reason if available
        if (next.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(next.error!)),
          );
        }
        context.go(Routes.home);
      }
    });

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControlsVisibility,
          child: Stack(
            children: [
              // Main video (remote or local based on swap state)
              Positioned.fill(
                child: GestureDetector(
                  onDoubleTap: _swapVideoViews,
                  child: VideoView(
                    renderer:
                        _isLocalVideoSmall ? _remoteRenderer : _localRenderer,
                    mirror: !_isLocalVideoSmall,
                    objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  ),
                ),
              ),

              // Overlay gradient for better visibility
              if (_controlsVisible) ...[
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 150,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 200,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],

              // Small video (PIP)
              Positioned(
                top: MediaQuery.of(context).padding.top + 16,
                right: 16,
                child: AnimatedOpacity(
                  opacity: _controlsVisible ? 1.0 : 0.7,
                  duration: const Duration(milliseconds: 200),
                  child: PipVideoView(
                    renderer:
                        _isLocalVideoSmall ? _localRenderer : _remoteRenderer,
                    mirror: _isLocalVideoSmall,
                    onTap: _swapVideoViews,
                  ),
                ),
              ),

              // Top info bar
              if (_controlsVisible)
                Positioned(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (callState.peerInfo != null)
                        PeerInfoCard(peerInfo: callState.peerInfo!),
                      const SizedBox(height: 8),
                      CallTimer(
                        duration: callState.formattedDuration,
                        isConnecting: callState.isConnecting,
                      ),
                    ],
                  ),
                ),

              // Bottom controls
              if (_controlsVisible)
                Positioned(
                  bottom: MediaQuery.of(context).padding.bottom + 24,
                  left: 0,
                  right: 0,
                  child: CallControls(
                    isAudioMuted: callState.isAudioMuted,
                    isVideoEnabled: callState.isVideoEnabled,
                    isSpeakerOn: callState.isSpeakerOn,
                    onToggleAudio: () =>
                        ref.read(callProvider.notifier).toggleAudioMute(),
                    onToggleVideo: () =>
                        ref.read(callProvider.notifier).toggleVideo(),
                    onToggleSpeaker: () =>
                        ref.read(callProvider.notifier).toggleSpeaker(),
                    onSwitchCamera: () =>
                        ref.read(callProvider.notifier).switchCamera(),
                    onEndCall: _onEndCall,
                  ),
                ),

              // Reconnecting indicator
              if (callState.phase == CallPhase.reconnecting)
                Positioned.fill(
                  child: Container(
                    color: Colors.black54,
                    child: const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(color: Colors.white),
                          SizedBox(height: 16),
                          Text(
                            'Reconnecting...',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
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
