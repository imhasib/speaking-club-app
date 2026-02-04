import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

/// WebRTC video renderer wrapper widget
class VideoView extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;
  final RTCVideoViewObjectFit objectFit;
  final Widget? placeholder;

  const VideoView({
    super.key,
    required this.renderer,
    this.mirror = false,
    this.objectFit = RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    return RTCVideoView(
      renderer,
      mirror: mirror,
      objectFit: objectFit,
      placeholderBuilder: placeholder != null
          ? (context) => placeholder!
          : (context) {
              return Container(
                color: Colors.black,
                child: const Center(
                  child: Icon(
                    Icons.videocam_off,
                    color: Colors.white38,
                    size: 48,
                  ),
                ),
              );
            },
    );
  }
}

/// Small PIP (Picture-in-Picture) video view
class PipVideoView extends StatelessWidget {
  final RTCVideoRenderer renderer;
  final bool mirror;
  final VoidCallback? onTap;
  final double width;
  final double height;

  const PipVideoView({
    super.key,
    required this.renderer,
    this.mirror = true,
    this.onTap,
    this.width = 120,
    this.height = 160,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: VideoView(
          renderer: renderer,
          mirror: mirror,
          objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
        ),
      ),
    );
  }
}
