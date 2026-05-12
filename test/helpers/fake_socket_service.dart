import 'dart:async';

import 'package:speaking_club/features/realtime/data/socket_service.dart';
import 'package:speaking_club/shared/models/call.dart';
import 'package:speaking_club/shared/models/online_user.dart';

/// Controllable fake [SocketService] for use in unit tests.
///
/// All streams are backed by broadcast [StreamController]s so tests can push
/// events directly.  [isConnected] defaults to `true` so most provider tests
/// don't have to set it up explicitly.
class FakeSocketService implements SocketService {
  bool _isConnected;

  FakeSocketService({bool isConnected = true}) : _isConnected = isConnected;

  // Stream controllers – tests can push events via .add()
  final connectionStateController =
      StreamController<SocketConnectionState>.broadcast();
  final onlineUsersController =
      StreamController<List<OnlineUser>>.broadcast();
  final statusChangedController =
      StreamController<UserStatusChange>.broadcast();
  final errorsController = StreamController<String>.broadcast();
  final matchmakingMatchedController =
      StreamController<MatchmakingResult>.broadcast();
  final incomingCallController = StreamController<IncomingCall>.broadcast();
  final callAcceptedController = StreamController<CallAccepted>.broadcast();
  final callRejectedController = StreamController<CallRejected>.broadcast();
  final callCancelledController = StreamController<CallCancelled>.broadcast();
  final callEndedController = StreamController<CallEnded>.broadcast();
  final callOfferController = StreamController<RTCOfferSignal>.broadcast();
  final callAnswerController = StreamController<RTCAnswerSignal>.broadcast();
  final iceCandidateController = StreamController<RTCIceSignal>.broadcast();

  // Recorded call counts for assertion
  int connectCalls = 0;
  int disconnectCalls = 0;
  int joinMatchmakingCalls = 0;
  int leaveMatchmakingCalls = 0;
  int goOnlineCalls = 0;
  int goOfflineCalls = 0;

  void setConnected(bool value) => _isConnected = value;

  // ── SocketService streams ──────────────────────────────────────────────────

  @override
  Stream<SocketConnectionState> get connectionState =>
      connectionStateController.stream;

  @override
  Stream<List<OnlineUser>> get onlineUsers => onlineUsersController.stream;

  @override
  Stream<UserStatusChange> get statusChanged => statusChangedController.stream;

  @override
  Stream<String> get errors => errorsController.stream;

  @override
  Stream<MatchmakingResult> get matchmakingMatched =>
      matchmakingMatchedController.stream;

  @override
  Stream<IncomingCall> get incomingCall => incomingCallController.stream;

  @override
  Stream<CallAccepted> get callAccepted => callAcceptedController.stream;

  @override
  Stream<CallRejected> get callRejected => callRejectedController.stream;

  @override
  Stream<CallCancelled> get callCancelled => callCancelledController.stream;

  @override
  Stream<CallEnded> get callEnded => callEndedController.stream;

  @override
  Stream<RTCOfferSignal> get callOffer => callOfferController.stream;

  @override
  Stream<RTCAnswerSignal> get callAnswer => callAnswerController.stream;

  @override
  Stream<RTCIceSignal> get iceCandidate => iceCandidateController.stream;

  // ── State ──────────────────────────────────────────────────────────────────

  @override
  SocketConnectionState get currentConnectionState => _isConnected
      ? SocketConnectionState.connected
      : SocketConnectionState.disconnected;

  @override
  bool get isConnected => _isConnected;

  // ── Commands ───────────────────────────────────────────────────────────────

  @override
  Future<void> connect() async => connectCalls++;

  @override
  void disconnect() => disconnectCalls++;

  @override
  void updateAuthToken(String token) {}

  @override
  void joinMatchmaking() => joinMatchmakingCalls++;

  @override
  void leaveMatchmaking() => leaveMatchmakingCalls++;

  @override
  void goOnline() => goOnlineCalls++;

  @override
  void goOffline() => goOfflineCalls++;

  @override
  void endCall() {}

  @override
  void initiateCall(String targetUserId) {}

  @override
  void acceptCall(String callId) {}

  @override
  void rejectCall(String callId) {}

  @override
  void sendOffer(String to, Map<String, dynamic> offer) {}

  @override
  void sendAnswer(String to, Map<String, dynamic> answer) {}

  @override
  void sendIceCandidate(String to, Map<String, dynamic> candidate) {}

  @override
  void on(String event, Function(dynamic) callback) {}

  @override
  void off(String event) {}

  @override
  void emit(String event, [dynamic data]) {}

  @override
  void dispose() {
    connectionStateController.close();
    onlineUsersController.close();
    statusChangedController.close();
    errorsController.close();
    matchmakingMatchedController.close();
    incomingCallController.close();
    callAcceptedController.close();
    callRejectedController.close();
    callCancelledController.close();
    callEndedController.close();
    callOfferController.close();
    callAnswerController.close();
    iceCandidateController.close();
  }
}
