import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../realtime/data/socket_service.dart';

/// WebRTC connection state
enum WebRTCConnectionState {
  /// No active connection
  idle,

  /// Initializing local media
  initializing,

  /// Connecting to peer
  connecting,

  /// Successfully connected
  connected,

  /// Temporarily disconnected, reconnecting
  reconnecting,

  /// Connection failed
  failed,

  /// Connection closed
  closed,
}

/// WebRTC service provider
final webrtcServiceProvider = Provider<WebRTCService>((ref) {
  final socketService = ref.watch(socketServiceProvider);
  final service = WebRTCService(socketService: socketService);
  ref.onDispose(() {
    service.dispose();
  });
  return service;
});

/// WebRTC service for peer connection management
class WebRTCService {
  final SocketService _socketService;

  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;
  MediaStream? _remoteStream;

  String? _currentPeerId;
  bool _isInitiator = false;
  bool _isDisposed = false;

  // Buffered signals (received before peer connection is ready)
  Map<String, dynamic>? _pendingOffer;
  final List<Map<String, dynamic>> _pendingIceCandidates = [];

  // STUN/TURN servers configuration
  static const Map<String, dynamic> _configuration = {
    'iceServers': [
      {'urls': 'stun:stun.l.google.com:19302'},
      {'urls': 'stun:stun1.l.google.com:19302'},
      {'urls': 'stun:stun2.l.google.com:19302'},
      {'urls': 'stun:stun3.l.google.com:19302'},
      {'urls': 'stun:stun4.l.google.com:19302'},
    ],
    'sdpSemantics': 'unified-plan',
  };

  // Media constraints for video
  static const Map<String, dynamic> _videoConstraints = {
    'mandatory': {
      'minWidth': '640',
      'minHeight': '480',
      'minFrameRate': '30',
    },
    'facingMode': 'user',
    'optional': <Map<String, dynamic>>[],
  };

  // Stream controllers
  final _connectionStateController =
      StreamController<WebRTCConnectionState>.broadcast();
  final _localStreamController = StreamController<MediaStream?>.broadcast();
  final _remoteStreamController = StreamController<MediaStream?>.broadcast();

  // Public streams
  Stream<WebRTCConnectionState> get connectionState =>
      _connectionStateController.stream;
  Stream<MediaStream?> get localStream => _localStreamController.stream;
  Stream<MediaStream?> get remoteStream => _remoteStreamController.stream;

  // Current state getters
  MediaStream? get currentLocalStream => _localStream;
  MediaStream? get currentRemoteStream => _remoteStream;
  RTCPeerConnection? get peerConnection => _peerConnection;
  String? get currentPeerId => _currentPeerId;
  bool get isInitiator => _isInitiator;

  WebRTCService({required SocketService socketService})
      : _socketService = socketService;

  // Safe stream add methods (won't throw if disposed)
  void _safeAddState(WebRTCConnectionState state) {
    if (!_isDisposed) {
      _connectionStateController.add(state);
    }
  }

  void _safeAddLocalStream(MediaStream? stream) {
    if (!_isDisposed) {
      _localStreamController.add(stream);
    }
  }

  void _safeAddRemoteStream(MediaStream? stream) {
    if (!_isDisposed) {
      _remoteStreamController.add(stream);
    }
  }

  /// Request camera and microphone permissions
  Future<bool> _requestPermissions({
    bool audio = true,
    bool video = true,
  }) async {
    final permissions = <Permission>[];
    if (audio) permissions.add(Permission.microphone);
    if (video) permissions.add(Permission.camera);

    if (permissions.isEmpty) return true;

    dev.log('WebRTC: Requesting permissions: $permissions');
    final statuses = await permissions.request();

    for (final entry in statuses.entries) {
      if (!entry.value.isGranted) {
        dev.log('WebRTC: Permission ${entry.key} denied: ${entry.value}');
        return false;
      }
    }

    dev.log('WebRTC: All permissions granted');
    return true;
  }

  /// Initialize local media stream
  Future<MediaStream> initializeLocalStream({
    bool audio = true,
    bool video = true,
  }) async {
    dev.log('WebRTC: Initializing local stream (audio: $audio, video: $video)');
    _safeAddState(WebRTCConnectionState.initializing);

    try {
      // Request permissions first
      final hasPermissions = await _requestPermissions(audio: audio, video: video);
      if (!hasPermissions) {
        throw Exception('Camera/microphone permissions not granted');
      }

      final constraints = {
        'audio': audio,
        'video': video ? _videoConstraints : false,
      };

      _localStream = await navigator.mediaDevices.getUserMedia(constraints);
      _safeAddLocalStream(_localStream);

      dev.log('WebRTC: Local stream initialized with ${_localStream!.getTracks().length} tracks');
      return _localStream!;
    } catch (e) {
      dev.log('WebRTC: Error initializing local stream: $e');
      _safeAddState(WebRTCConnectionState.failed);
      rethrow;
    }
  }

  /// Create peer connection and setup handlers
  Future<void> initializePeerConnection(String peerId, bool isInitiator) async {
    _currentPeerId = peerId;
    _isInitiator = isInitiator;

    dev.log('WebRTC: Creating peer connection (initiator: $isInitiator, peer: $peerId)');
    _safeAddState(WebRTCConnectionState.connecting);

    try {
      _peerConnection = await createPeerConnection(_configuration);

      // Add local stream tracks to peer connection
      if (_localStream != null) {
        for (var track in _localStream!.getTracks()) {
          await _peerConnection!.addTrack(track, _localStream!);
          dev.log('WebRTC: Added ${track.kind} track to peer connection');
        }
      }

      // Setup event handlers
      _setupPeerConnectionHandlers();

      // If initiator, create and send offer
      if (isInitiator) {
        await _createAndSendOffer();
      }

      // Process any buffered signals
      await _processBufferedSignals();
    } catch (e) {
      dev.log('WebRTC: Error creating peer connection: $e');
      _safeAddState(WebRTCConnectionState.failed);
      rethrow;
    }
  }

  /// Process buffered offer and ICE candidates
  Future<void> _processBufferedSignals() async {
    // Process pending offer first
    if (_pendingOffer != null) {
      dev.log('WebRTC: Processing buffered offer');
      final offer = _pendingOffer!;
      _pendingOffer = null;
      await _processOffer(offer);
    }

    // Process pending ICE candidates
    if (_pendingIceCandidates.isNotEmpty) {
      dev.log('WebRTC: Processing ${_pendingIceCandidates.length} buffered ICE candidates');
      final candidates = List<Map<String, dynamic>>.from(_pendingIceCandidates);
      _pendingIceCandidates.clear();
      for (final candidate in candidates) {
        await _processIceCandidate(candidate);
      }
    }
  }

  void _setupPeerConnectionHandlers() {
    if (_peerConnection == null) return;

    _peerConnection!.onIceCandidate = (RTCIceCandidate candidate) {
      dev.log('WebRTC: ICE candidate generated');
      if (_currentPeerId != null) {
        _socketService.sendIceCandidate(_currentPeerId!, {
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      }
    };

    _peerConnection!.onIceConnectionState = (RTCIceConnectionState state) {
      dev.log('WebRTC: ICE connection state: $state');
      switch (state) {
        case RTCIceConnectionState.RTCIceConnectionStateConnected:
        case RTCIceConnectionState.RTCIceConnectionStateCompleted:
          _safeAddState(WebRTCConnectionState.connected);
          break;
        case RTCIceConnectionState.RTCIceConnectionStateFailed:
          _safeAddState(WebRTCConnectionState.failed);
          break;
        case RTCIceConnectionState.RTCIceConnectionStateDisconnected:
          _safeAddState(WebRTCConnectionState.reconnecting);
          break;
        case RTCIceConnectionState.RTCIceConnectionStateClosed:
          _safeAddState(WebRTCConnectionState.closed);
          break;
        default:
          break;
      }
    };

    _peerConnection!.onTrack = (RTCTrackEvent event) {
      dev.log('WebRTC: Remote track received: ${event.track.kind}');
      if (event.streams.isNotEmpty) {
        _remoteStream = event.streams[0];
        _safeAddRemoteStream(_remoteStream);
      }
    };

    _peerConnection!.onConnectionState = (RTCPeerConnectionState state) {
      dev.log('WebRTC: Peer connection state: $state');
    };

    _peerConnection!.onSignalingState = (RTCSignalingState state) {
      dev.log('WebRTC: Signaling state: $state');
    };
  }

  Future<void> _createAndSendOffer() async {
    if (_peerConnection == null || _currentPeerId == null) return;

    dev.log('WebRTC: Creating offer');
    try {
      final offer = await _peerConnection!.createOffer({
        'offerToReceiveAudio': true,
        'offerToReceiveVideo': true,
      });
      await _peerConnection!.setLocalDescription(offer);

      _socketService.sendOffer(_currentPeerId!, {
        'type': offer.type,
        'sdp': offer.sdp,
      });
      dev.log('WebRTC: Offer sent');
    } catch (e) {
      dev.log('WebRTC: Error creating/sending offer: $e');
      rethrow;
    }
  }

  /// Handle incoming offer
  Future<void> handleOffer(Map<String, dynamic> sdp) async {
    if (_peerConnection == null) {
      dev.log('WebRTC: Buffering offer (peer connection not ready)');
      _pendingOffer = sdp;
      return;
    }

    await _processOffer(sdp);
  }

  /// Process the offer (internal method)
  Future<void> _processOffer(Map<String, dynamic> sdp) async {
    dev.log('WebRTC: Handling offer');
    try {
      final description = RTCSessionDescription(
        sdp['sdp'] as String,
        sdp['type'] as String,
      );
      await _peerConnection!.setRemoteDescription(description);

      // Create and send answer
      final answer = await _peerConnection!.createAnswer();
      await _peerConnection!.setLocalDescription(answer);

      if (_currentPeerId != null) {
        _socketService.sendAnswer(_currentPeerId!, {
          'type': answer.type,
          'sdp': answer.sdp,
        });
        dev.log('WebRTC: Answer sent');
      }
    } catch (e) {
      dev.log('WebRTC: Error handling offer: $e');
      rethrow;
    }
  }

  /// Handle incoming answer
  Future<void> handleAnswer(Map<String, dynamic> sdp) async {
    if (_peerConnection == null) return;

    dev.log('WebRTC: Handling answer');
    try {
      final description = RTCSessionDescription(
        sdp['sdp'] as String,
        sdp['type'] as String,
      );
      await _peerConnection!.setRemoteDescription(description);
      dev.log('WebRTC: Remote description set');
    } catch (e) {
      dev.log('WebRTC: Error handling answer: $e');
      rethrow;
    }
  }

  /// Handle incoming ICE candidate
  Future<void> handleIceCandidate(Map<String, dynamic> candidateMap) async {
    if (_peerConnection == null) {
      dev.log('WebRTC: Buffering ICE candidate (peer connection not ready)');
      _pendingIceCandidates.add(candidateMap);
      return;
    }

    await _processIceCandidate(candidateMap);
  }

  /// Process an ICE candidate (internal method)
  Future<void> _processIceCandidate(Map<String, dynamic> candidateMap) async {
    dev.log('WebRTC: Handling ICE candidate');
    try {
      final candidate = RTCIceCandidate(
        candidateMap['candidate'] as String?,
        candidateMap['sdpMid'] as String?,
        candidateMap['sdpMLineIndex'] as int?,
      );
      await _peerConnection!.addCandidate(candidate);
      dev.log('WebRTC: ICE candidate added');
    } catch (e) {
      dev.log('WebRTC: Error handling ICE candidate: $e');
      // Don't rethrow - ICE candidate errors are often recoverable
    }
  }

  /// Toggle audio mute
  void toggleAudioMute(bool muted) {
    if (_localStream != null) {
      for (var track in _localStream!.getAudioTracks()) {
        track.enabled = !muted;
        dev.log('WebRTC: Audio ${muted ? "muted" : "unmuted"}');
      }
    }
  }

  /// Toggle video
  void toggleVideo(bool enabled) {
    if (_localStream != null) {
      for (var track in _localStream!.getVideoTracks()) {
        track.enabled = enabled;
        dev.log('WebRTC: Video ${enabled ? "enabled" : "disabled"}');
      }
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_localStream != null) {
      final videoTrack = _localStream!.getVideoTracks().firstOrNull;
      if (videoTrack != null) {
        await Helper.switchCamera(videoTrack);
        dev.log('WebRTC: Camera switched');
      }
    }
  }

  /// Toggle speaker (platform-specific)
  Future<void> toggleSpeaker(bool enabled) async {
    // flutter_webrtc handles speaker routing internally
    // On some platforms, you may need to use platform channels
    dev.log('WebRTC: Speaker ${enabled ? "enabled" : "disabled"}');
  }

  /// Close peer connection and cleanup
  Future<void> close() async {
    if (_isDisposed) return;

    dev.log('WebRTC: Closing connection');

    // Stop and dispose local stream tracks
    if (_localStream != null) {
      for (var track in _localStream!.getTracks()) {
        await track.stop();
      }
      await _localStream!.dispose();
      _localStream = null;
      _safeAddLocalStream(null);
    }

    // Dispose remote stream
    if (_remoteStream != null) {
      await _remoteStream!.dispose();
      _remoteStream = null;
      _safeAddRemoteStream(null);
    }

    // Close peer connection
    if (_peerConnection != null) {
      await _peerConnection!.close();
      _peerConnection = null;
    }

    _currentPeerId = null;
    _isInitiator = false;
    _pendingOffer = null;
    _pendingIceCandidates.clear();
    _safeAddState(WebRTCConnectionState.idle);
  }

  /// Dispose all resources
  Future<void> dispose() async {
    if (_isDisposed) return;

    await close();
    _isDisposed = true;
    _connectionStateController.close();
    _localStreamController.close();
    _remoteStreamController.close();
  }
}
