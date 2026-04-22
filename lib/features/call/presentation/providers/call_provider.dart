import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/call.dart';
import '../../../realtime/data/socket_service.dart';
import '../../../realtime/presentation/providers/presence_provider.dart';
import '../../data/webrtc_service.dart';
import '../../domain/call_state.dart';
import 'matchmaking_provider.dart';

/// Call provider for active call management
final callProvider = NotifierProvider<CallNotifier, CallState>(CallNotifier.new);

/// Call notifier for active call state management
class CallNotifier extends Notifier<CallState> {
  SocketService get _socketService => ref.read(socketServiceProvider);
  WebRTCService get _webrtcService => ref.read(webrtcServiceProvider);

  // Socket event subscriptions
  StreamSubscription<MatchmakingResult>? _matchedSub;
  StreamSubscription<IncomingCall>? _incomingSub;
  StreamSubscription<CallAccepted>? _acceptedSub;
  StreamSubscription<CallRejected>? _rejectedSub;
  StreamSubscription<CallCancelled>? _cancelledSub;
  StreamSubscription<CallEnded>? _endedSub;
  StreamSubscription<RTCOfferSignal>? _offerSub;
  StreamSubscription<RTCAnswerSignal>? _answerSub;
  StreamSubscription<RTCIceSignal>? _iceSub;
  StreamSubscription<WebRTCConnectionState>? _rtcStateSub;

  Timer? _durationTimer;

  @override
  CallState build() {
    _setupSubscriptions();

    ref.onDispose(() {
      _cancelSubscriptions();
      _durationTimer?.cancel();
    });

    return const CallState();
  }

  void _setupSubscriptions() {
    _matchedSub = _socketService.matchmakingMatched.listen(_onMatchmakingMatched);
    _incomingSub = _socketService.incomingCall.listen(_onIncomingCall);
    _acceptedSub = _socketService.callAccepted.listen(_onCallAccepted);
    _rejectedSub = _socketService.callRejected.listen(_onCallRejected);
    _cancelledSub = _socketService.callCancelled.listen(_onCallCancelled);
    _endedSub = _socketService.callEnded.listen(_onCallEnded);
    _offerSub = _socketService.callOffer.listen(_onCallOffer);
    _answerSub = _socketService.callAnswer.listen(_onCallAnswer);
    _iceSub = _socketService.iceCandidate.listen(_onIceCandidate);
    _rtcStateSub = _webrtcService.connectionState.listen(_onRTCStateChanged);
  }

  void _cancelSubscriptions() {
    _matchedSub?.cancel();
    _incomingSub?.cancel();
    _acceptedSub?.cancel();
    _rejectedSub?.cancel();
    _cancelledSub?.cancel();
    _endedSub?.cancel();
    _offerSub?.cancel();
    _answerSub?.cancel();
    _iceSub?.cancel();
    _rtcStateSub?.cancel();
  }

  // === Socket Event Handlers ===

  void _onMatchmakingMatched(MatchmakingResult result) async {
    dev.log('Call: Matched with ${result.peerInfo.name}');

    // Notify matchmaking provider
    ref.read(matchmakingProvider.notifier).onMatchFound();

    state = state.copyWith(
      phase: CallPhase.connecting,
      callId: result.callId,
      dbCallId: result.dbCallId,
      peerInfo: result.peerInfo,
      isInitiator: result.initiator,
      callType: CallType.random,
    );

    // Update presence to in-call
    ref.read(presenceProvider.notifier).setInCall();

    // Initialize WebRTC
    try {
      await _webrtcService.initializeLocalStream();
      await _webrtcService.initializePeerConnection(
        result.peerId,
        result.initiator,
      );
    } catch (e) {
      dev.log('Call: Error initializing WebRTC: $e');
      state = state.copyWith(
        error: 'Failed to initialize call: $e',
      );
    }
  }

  void _onIncomingCall(IncomingCall incoming) {
    dev.log('Call: Incoming call from ${incoming.callerInfo.name}');

    state = state.copyWith(
      phase: CallPhase.incoming,
      callId: incoming.callId,
      dbCallId: incoming.dbCallId,
      peerInfo: incoming.callerInfo,
      isInitiator: false,
      callType: CallType.direct,
    );
  }

  void _onCallAccepted(CallAccepted accepted) async {
    dev.log('Call: Call accepted by ${accepted.recipientInfo.name}');

    state = state.copyWith(
      phase: CallPhase.connecting,
      callId: accepted.callId,
      dbCallId: accepted.dbCallId,
      peerInfo: accepted.recipientInfo,
    );

    // Update presence to in-call
    ref.read(presenceProvider.notifier).setInCall();

    // Initialize WebRTC as initiator
    try {
      await _webrtcService.initializeLocalStream();
      await _webrtcService.initializePeerConnection(
        accepted.recipientInfo.id,
        true, // Caller is always initiator
      );
    } catch (e) {
      dev.log('Call: Error initializing WebRTC: $e');
      state = state.copyWith(
        error: 'Failed to initialize call: $e',
      );
    }
  }

  void _onCallRejected(CallRejected rejected) {
    dev.log('Call: Call rejected: ${rejected.reason}');
    _resetState(error: 'Call ${rejected.reason}');
  }

  void _onCallCancelled(CallCancelled cancelled) {
    dev.log('Call: Call cancelled: ${cancelled.reason}');
    String message;
    switch (cancelled.reason) {
      case 'timeout':
        message = 'Call timed out';
        break;
      case 'caller_cancelled':
        message = 'Caller cancelled';
        break;
      case 'recipient_offline':
        message = 'User is offline';
        break;
      default:
        message = 'Call was cancelled';
    }
    _resetState(error: message);
  }

  void _onCallEnded(CallEnded ended) async {
    dev.log('Call: Call ended: ${ended.reason}');
    await _endCall(ended.reason);
  }

  void _onCallOffer(RTCOfferSignal signal) async {
    dev.log('Call: Received offer from ${signal.from}');
    try {
      await _webrtcService.handleOffer({
        'type': signal.offer.type,
        'sdp': signal.offer.sdp,
      });
    } catch (e) {
      dev.log('Call: Error handling offer: $e');
    }
  }

  void _onCallAnswer(RTCAnswerSignal signal) async {
    dev.log('Call: Received answer from ${signal.from}');
    try {
      await _webrtcService.handleAnswer({
        'type': signal.answer.type,
        'sdp': signal.answer.sdp,
      });
    } catch (e) {
      dev.log('Call: Error handling answer: $e');
    }
  }

  void _onIceCandidate(RTCIceSignal signal) async {
    dev.log('Call: Received ICE candidate from ${signal.from}');
    try {
      await _webrtcService.handleIceCandidate({
        'candidate': signal.candidate.candidate,
        'sdpMid': signal.candidate.sdpMid,
        'sdpMLineIndex': signal.candidate.sdpMLineIndex,
      });
    } catch (e) {
      dev.log('Call: Error handling ICE candidate: $e');
    }
  }

  void _onRTCStateChanged(WebRTCConnectionState rtcState) {
    state = state.copyWith(rtcState: rtcState);

    if (rtcState == WebRTCConnectionState.connected &&
        state.phase == CallPhase.connecting) {
      state = state.copyWith(
        phase: CallPhase.connected,
        callStartTime: DateTime.now(),
      );
      _startDurationTimer();
    } else if (rtcState == WebRTCConnectionState.failed) {
      _endCall('Connection failed');
    } else if (rtcState == WebRTCConnectionState.reconnecting) {
      state = state.copyWith(phase: CallPhase.reconnecting);
    }
  }

  void _startDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (state.isActive) {
        state = state.copyWith(
          callDurationSeconds: state.callDurationSeconds + 1,
        );
      }
    });
  }

  // === Public Actions ===

  /// Initiate a direct call to a user
  Future<void> initiateCall(String targetUserId, PeerInfo peerInfo) async {
    dev.log('Call: Initiating call to ${peerInfo.name}');

    state = state.copyWith(
      phase: CallPhase.initiating,
      peerInfo: peerInfo,
      isInitiator: true,
      callType: CallType.direct,
    );

    _socketService.initiateCall(targetUserId);
  }

  /// Accept an incoming call
  Future<void> acceptCall() async {
    if (state.callId == null || !state.isIncoming) return;

    dev.log('Call: Accepting call');
    state = state.copyWith(phase: CallPhase.connecting);

    // Update presence to in-call
    ref.read(presenceProvider.notifier).setInCall();

    _socketService.acceptCall(state.callId!);

    // Initialize WebRTC as receiver (non-initiator)
    try {
      await _webrtcService.initializeLocalStream();
      await _webrtcService.initializePeerConnection(
        state.peerInfo!.id,
        false, // Receiver is not initiator
      );
    } catch (e) {
      dev.log('Call: Error initializing WebRTC: $e');
      state = state.copyWith(
        error: 'Failed to initialize call: $e',
      );
    }
  }

  /// Reject an incoming call
  void rejectCall() {
    if (state.callId == null || !state.isIncoming) return;

    dev.log('Call: Rejecting call');
    _socketService.rejectCall(state.callId!);
    _resetState();
  }

  /// Cancel an outgoing call (while waiting for accept)
  void cancelCall() {
    if (!state.isInitiating) return;

    dev.log('Call: Cancelling call');
    // The server will handle the cancellation
    _socketService.endCall();
    _resetState();
  }

  /// End an active call
  Future<void> endCall() async {
    dev.log('Call: Ending call');
    _socketService.endCall();
    await _endCall('User ended call');
  }

  Future<void> _endCall(String reason) async {
    _durationTimer?.cancel();
    await _webrtcService.close();

    // Update presence back to online
    ref.read(presenceProvider.notifier).setOnlineAfterCall();

    // Reset matchmaking state
    ref.read(matchmakingProvider.notifier).reset();

    _resetState();
  }

  void _resetState({String? error}) {
    state = CallState(error: error);
  }

  // === Media Controls ===

  void toggleAudioMute() {
    final muted = !state.isAudioMuted;
    _webrtcService.toggleAudioMute(muted);
    state = state.copyWith(isAudioMuted: muted);
  }

  void toggleVideo() {
    final enabled = !state.isVideoEnabled;
    _webrtcService.toggleVideo(enabled);
    state = state.copyWith(isVideoEnabled: enabled);
  }

  Future<void> switchCamera() async {
    await _webrtcService.switchCamera();
    state = state.copyWith(isFrontCamera: !state.isFrontCamera);
  }

  Future<void> toggleSpeaker() async {
    final enabled = !state.isSpeakerOn;
    await _webrtcService.toggleSpeaker(enabled);
    state = state.copyWith(isSpeakerOn: enabled);
  }

  /// Clear any error message
  void clearError() {
    state = state.copyWith(error: null);
  }
}
