# Phase 5: Calling Features - Implementation Documentation

## Overview

Phase 5 implements the core calling features for the Speaking Club app, including random matchmaking, WebRTC video calls, in-call controls, and direct calling between users.

---

## Architecture

### Feature Structure

```
lib/features/call/
├── call.dart                           # Barrel export
├── data/
│   └── webrtc_service.dart             # WebRTC peer connection management
├── domain/
│   ├── call_state.dart                 # Call state (Freezed)
│   ├── call_state.freezed.dart         # Generated
│   ├── matchmaking_state.dart          # Matchmaking state (Freezed)
│   └── matchmaking_state.freezed.dart  # Generated
├── presentation/
│   ├── providers/
│   │   ├── call_provider.dart          # Active call state management
│   │   └── matchmaking_provider.dart   # Queue management
│   ├── screens/
│   │   ├── waiting_screen.dart         # Matchmaking waiting UI
│   │   ├── call_screen.dart            # Active call UI
│   │   └── incoming_call_screen.dart   # Incoming call UI
│   └── widgets/
│       ├── call_controls.dart          # Mute/video/speaker/end buttons
│       ├── call_timer.dart             # Duration timer
│       ├── video_view.dart             # RTCVideoRenderer wrapper
│       └── peer_info_card.dart         # Peer avatar/username display
```

---

## Socket Events

### Client → Server Events

| Event | Payload | Description |
|-------|---------|-------------|
| `matchmaking:join` | None | Join the matchmaking queue |
| `matchmaking:leave` | None | Leave the matchmaking queue |
| `call:offer` | `{ to, offer: { type, sdp } }` | Send WebRTC offer |
| `call:answer` | `{ to, answer: { type, sdp } }` | Send WebRTC answer |
| `call:ice-candidate` | `{ to, candidate }` | Send ICE candidate |
| `call:end` | None | End current call |
| `call:initiate` | `{ targetUserId }` | Initiate direct call |
| `call:accept` | `{ callId }` | Accept incoming call |
| `call:reject` | `{ callId }` | Reject incoming call |

### Server → Client Events

| Event | Payload | Description |
|-------|---------|-------------|
| `matchmaking:matched` | `{ callId, dbCallId, peerId, initiator, peerInfo }` | Match found |
| `call:offer` | `{ from, offer }` | Incoming WebRTC offer |
| `call:answer` | `{ from, answer }` | Incoming WebRTC answer |
| `call:ice-candidate` | `{ from, candidate }` | Incoming ICE candidate |
| `call:ended` | `{ reason }` | Call ended |
| `call:incoming` | `{ callId, dbCallId, callerId, callerInfo }` | Incoming direct call |
| `call:accepted` | `{ callId, dbCallId, recipientInfo }` | Call accepted |
| `call:rejected` | `{ callId, reason }` | Call rejected |
| `call:cancelled` | `{ callId, reason }` | Call cancelled |

---

## Data Models

### Call-Related Models (lib/shared/models/call.dart)

```dart
// Matchmaking result when users are matched
MatchmakingResult {
  String callId,       // Socket session call ID
  String dbCallId,     // Database call record ID
  String peerId,       // Matched peer's user ID
  PeerInfo peerInfo,   // Peer info (id, username, avatar)
  bool initiator,      // Whether this user creates the WebRTC offer
}

// Peer information
PeerInfo {
  String id,
  String username,
  String? avatar,
}

// Incoming direct call
IncomingCall {
  String callId,
  String? dbCallId,
  String callerId,
  PeerInfo callerInfo,
}

// Call accepted response
CallAccepted {
  String callId,
  String dbCallId,
  PeerInfo recipientInfo,
}

// Call rejected/cancelled responses
CallRejected { String callId, String reason }
CallCancelled { String callId, String reason }
CallEnded { String reason }

// WebRTC signaling
RTCSessionDesc { String type, String sdp }
RTCOfferSignal { String from, RTCSessionDesc offer }
RTCAnswerSignal { String from, RTCSessionDesc answer }
IceCandidateData { String candidate, String? sdpMid, int? sdpMLineIndex }
RTCIceSignal { String from, IceCandidateData candidate }
```

---

## State Management

### CallState (Riverpod)

```dart
enum CallPhase {
  idle,         // No active call
  initiating,   // Initiating direct call
  incoming,     // Received incoming call
  connecting,   // WebRTC connecting
  connected,    // Call active
  reconnecting, // Temporarily disconnected
  ending,       // Call ending
}

CallState {
  CallPhase phase,
  String? callId,
  String? dbCallId,
  PeerInfo? peerInfo,
  bool isInitiator,
  CallType callType,
  WebRTCConnectionState rtcState,

  // Media state
  bool isAudioMuted,
  bool isVideoEnabled,
  bool isSpeakerOn,
  bool isFrontCamera,

  // Timing
  DateTime? callStartTime,
  int callDurationSeconds,
  String? error,
}
```

### MatchmakingState (Riverpod)

```dart
enum MatchmakingPhase {
  idle,     // Not in queue
  joining,  // Joining queue
  waiting,  // Waiting for match
  matched,  // Match found
  error,    // Error occurred
}

MatchmakingState {
  MatchmakingPhase phase,
  DateTime? joinedAt,
  int waitingSeconds,
  String? error,
}
```

---

## WebRTC Service

### Configuration

```dart
// STUN servers for NAT traversal
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
```

### Key Methods

| Method | Description |
|--------|-------------|
| `initializeLocalStream({audio, video})` | Get user media (camera/mic) |
| `createPeerConnection(peerId, isInitiator)` | Create RTCPeerConnection |
| `handleOffer(sdp)` | Process incoming offer, create answer |
| `handleAnswer(sdp)` | Process incoming answer |
| `handleIceCandidate(candidate)` | Add ICE candidate |
| `toggleAudioMute(muted)` | Mute/unmute microphone |
| `toggleVideo(enabled)` | Enable/disable camera |
| `switchCamera()` | Switch front/back camera |
| `close()` | Cleanup resources |

### Connection States

```dart
enum WebRTCConnectionState {
  idle,         // No connection
  initializing, // Getting user media
  connecting,   // Establishing peer connection
  connected,    // Call active
  reconnecting, // Temporarily disconnected
  failed,       // Connection failed
  closed,       // Connection closed
}
```

---

## User Flows

### Random Matchmaking Flow

```
1. User taps "Find Match" on HomeScreen
2. Navigate to WaitingScreen
3. WaitingScreen calls matchmakingProvider.joinQueue()
4. Socket emits matchmaking:join
5. Server matches two users, sends matchmaking:matched to both
6. CallProvider receives match, initializes WebRTC
7. Initiator creates and sends offer
8. Non-initiator receives offer, creates and sends answer
9. ICE candidates exchanged
10. Connection established, navigate to CallScreen
11. User taps "End Call"
12. Socket emits call:end
13. Navigate back to HomeScreen
```

### Direct Call Flow

```
Caller:
1. Tap on online user card
2. Confirm dialog appears
3. Call callProvider.initiateCall()
4. Socket emits call:initiate
5. Wait for call:accepted or call:rejected

Recipient:
1. call:incoming event received
2. Navigate to IncomingCallScreen
3. User taps Accept/Reject
4. If accepted: call:accept emitted, WebRTC initialized
5. If rejected: call:reject emitted, return to home

After Accept:
1. Caller receives call:accepted
2. Both users initialize WebRTC
3. Caller creates offer (is initiator)
4. Standard WebRTC flow continues
```

---

## Routes

| Route | Screen | Description |
|-------|--------|-------------|
| `/waiting` | WaitingScreen | Matchmaking queue waiting |
| `/call` | CallScreen | Active video call |
| `/call/incoming` | IncomingCallScreen | Incoming call notification |

All routes are protected (require authentication).

---

## UI Components

### CallScreen Features
- Full-screen remote video
- PIP (Picture-in-Picture) local video
- Tap to show/hide controls
- Double-tap to swap video views
- Peer info display (avatar, username)
- Call duration timer
- Reconnecting overlay

### CallControls
- Mute/unmute microphone
- Enable/disable camera
- Toggle speaker/earpiece
- Switch camera (front/back)
- End call button

### WaitingScreen Features
- Animated search indicator
- Waiting time counter
- Cancel button

### IncomingCallScreen Features
- Caller avatar and name
- Accept button (green)
- Reject button (red)
- Pulse animation

---

## Error Handling

### Call Rejection Reasons
- `rejected` - User rejected the call
- `busy` - User is already in a call

### Call Cancellation Reasons
- `timeout` - Call timed out (no answer)
- `caller_cancelled` - Caller cancelled
- `recipient_offline` - Recipient went offline

### Call End Reasons
- `User ended call` - Current user ended
- `Peer ended call` - Remote user ended
- `Peer disconnected` - Remote user lost connection
- `Connection failed` - WebRTC connection failed

---

## Dependencies

- `flutter_webrtc: ^1.3.0` - WebRTC implementation
- `socket_io_client: ^3.1.4` - Socket.IO for signaling
- `flutter_riverpod: ^3.1.0` - State management
- `go_router: ^17.0.1` - Navigation
- `permission_handler: ^12.0.1` - Camera/mic permissions

---

## Platform Permissions

### Android (AndroidManifest.xml)
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
<uses-permission android:name="android.permission.BLUETOOTH" />
```

### iOS (Info.plist)
```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for voice calls</string>
```

---

## Testing Checklist

### Matchmaking
- [ ] Join matchmaking queue
- [ ] Cancel matchmaking
- [ ] Match with another user
- [ ] Navigate to call screen on match

### WebRTC
- [ ] Local video displays correctly
- [ ] Remote video displays correctly
- [ ] Audio works both directions
- [ ] ICE candidates exchanged

### In-Call Controls
- [ ] Mute/unmute audio
- [ ] Enable/disable video
- [ ] Switch camera
- [ ] Toggle speaker
- [ ] End call

### Direct Calling
- [ ] Initiate direct call
- [ ] Receive incoming call notification
- [ ] Accept incoming call
- [ ] Reject incoming call
- [ ] Handle call cancelled/timeout

### Edge Cases
- [ ] Handle network disconnection during call
- [ ] Handle app backgrounded during call
- [ ] Handle peer disconnection
- [ ] Handle call rejection while connecting

---

## Troubleshooting

### Issue 1: Camera/Microphone Permissions Denied

**Symptoms:**
```
D/permissions_handler: No permissions found in manifest for: []
[log] WebRTC: Permission Permission.camera denied: PermissionStatus.denied
[log] WebRTC: Error initializing local stream: Exception: Camera/microphone permissions not granted
```

**Cause:**
The Android manifest and iOS Info.plist are missing the required permission declarations for camera and microphone access.

**Solution:**

#### Android (`android/app/src/main/AndroidManifest.xml`)

Add the following permissions inside the `<manifest>` tag, before `<application>`:

```xml
<!-- Permissions for WebRTC video/audio calls -->
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.RECORD_AUDIO"/>
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS"/>
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30"/>
<uses-permission android:name="android.permission.BLUETOOTH_CONNECT"/>

<uses-feature android:name="android.hardware.camera" android:required="false"/>
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false"/>
<uses-feature android:name="android.hardware.audio.output" android:required="false"/>
<uses-feature android:name="android.hardware.microphone" android:required="false"/>
```

#### iOS (`ios/Runner/Info.plist`)

Add the following keys inside the `<dict>` tag:

```xml
<key>NSCameraUsageDescription</key>
<string>Speaking Club needs camera access for video calls</string>
<key>NSMicrophoneUsageDescription</key>
<string>Speaking Club needs microphone access for voice calls</string>
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
    <string>voip</string>
</array>
```

**Important:** After updating the manifest, you must **uninstall the app** from the device and reinstall it. Android caches permission declarations at install time, so a simple rebuild won't work.

```bash
# Uninstall and reinstall
flutter clean && flutter run
```

---

### Issue 2: Remote Video Not Showing (WebRTC Signaling Race Condition)

**Symptoms:**
- Local video stream displays correctly
- Connection shows "Connecting..." indefinitely
- Remote video never appears
- Logs show offer and ICE candidates received but no `WebRTC: Handling offer` log

**Log Pattern:**
```
[log] 📥 Received matchmaking:matched: {...}
[log] 📥 Received call:offer: {...}
[log] 📥 Received call:ice-candidate: {...}
[log] 📥 Received call:ice-candidate: {...}
... (many ICE candidates)
[log] Call: Received offer from xxx
[log] Call: Received ICE candidate from xxx
[log] WebRTC: Creating peer connection (initiator: false, peer: xxx)
[log] WebRTC: Added audio track to peer connection
[log] WebRTC: Added video track to peer connection
```

Notice that `WebRTC: Handling offer` never appears after `Call: Received offer`.

**Cause:**
This is a race condition in the WebRTC initialization flow:

1. `matchmaking:matched` event is received
2. App starts `initializeLocalStream()` (slow - requests permissions, initializes camera)
3. The peer (who is the initiator) has already created their peer connection and sends the offer + ICE candidates
4. These signals arrive **before** `initializePeerConnection()` completes on the receiving end
5. `handleOffer()` and `handleIceCandidate()` check if `_peerConnection != null` - since it's still null, they return early without processing
6. The offer and ICE candidates are silently dropped
7. The connection never establishes because the answer is never sent

**Solution:**

Buffer incoming signals until the peer connection is ready. In `webrtc_service.dart`:

1. Add buffers for pending signals:
```dart
Map<String, dynamic>? _pendingOffer;
final List<Map<String, dynamic>> _pendingIceCandidates = [];
```

2. Update `handleOffer()` to buffer if peer connection isn't ready:
```dart
Future<void> handleOffer(Map<String, dynamic> sdp) async {
  if (_peerConnection == null) {
    dev.log('WebRTC: Buffering offer (peer connection not ready)');
    _pendingOffer = sdp;
    return;
  }
  await _processOffer(sdp);
}
```

3. Update `handleIceCandidate()` similarly:
```dart
Future<void> handleIceCandidate(Map<String, dynamic> candidateMap) async {
  if (_peerConnection == null) {
    dev.log('WebRTC: Buffering ICE candidate (peer connection not ready)');
    _pendingIceCandidates.add(candidateMap);
    return;
  }
  await _processIceCandidate(candidateMap);
}
```

4. Process buffered signals at the end of `initializePeerConnection()`:
```dart
Future<void> _processBufferedSignals() async {
  if (_pendingOffer != null) {
    dev.log('WebRTC: Processing buffered offer');
    final offer = _pendingOffer!;
    _pendingOffer = null;
    await _processOffer(offer);
  }

  if (_pendingIceCandidates.isNotEmpty) {
    dev.log('WebRTC: Processing ${_pendingIceCandidates.length} buffered ICE candidates');
    final candidates = List<Map<String, dynamic>>.from(_pendingIceCandidates);
    _pendingIceCandidates.clear();
    for (final candidate in candidates) {
      await _processIceCandidate(candidate);
    }
  }
}
```

5. Clear buffers in `close()` to prevent stale data:
```dart
_pendingOffer = null;
_pendingIceCandidates.clear();
```

**Correct Flow After Fix:**
```
1. matchmaking:matched → start initializeLocalStream() (slow)
2. Offer + ICE candidates arrive → BUFFERED (not dropped)
3. initializePeerConnection() completes
4. _processBufferedSignals() called
5. Buffered offer processed → answer sent
6. Buffered ICE candidates processed
7. Connection established successfully
```

---

### Issue 3: Call Works One-Way Only

**Symptoms:**
- One user can see/hear the other, but not vice versa
- Only initiator or only receiver has working media

**Possible Causes:**

1. **Initiator flag mismatch**: Ensure only ONE peer has `isInitiator: true`. The initiator creates the offer; the receiver creates the answer.

2. **Missing tracks**: Verify both peers add their local media tracks to the peer connection before signaling.

3. **NAT traversal issues**: If users are on different networks, STUN servers might not be enough. Consider adding TURN servers:
```dart
{
  'urls': 'turn:your-turn-server.com:3478',
  'username': 'username',
  'credential': 'password',
}
```

---

### Issue 4: Connection Fails on Mobile Networks

**Symptoms:**
- Works on WiFi but fails on mobile data
- ICE connection state goes to `failed`

**Cause:**
Symmetric NAT on mobile carriers blocks peer-to-peer connections. STUN servers can discover the public IP but can't punch through symmetric NAT.

**Solution:**
Add a TURN relay server to the ICE configuration. TURN relays traffic when direct peer connection fails.

```dart
static const Map<String, dynamic> _configuration = {
  'iceServers': [
    {'urls': 'stun:stun.l.google.com:19302'},
    {
      'urls': 'turn:your-turn-server.com:3478',
      'username': 'user',
      'credential': 'pass',
    },
  ],
  'sdpSemantics': 'unified-plan',
};
```

Consider using a TURN service like:
- Twilio Network Traversal Service
- Xirsys
- Self-hosted coturn

---

### Debugging Tips

1. **Enable verbose WebRTC logging:**
```dart
import 'package:flutter_webrtc/flutter_webrtc.dart';
// In main() or before using WebRTC:
WebRTC.platformIsDesktop; // Initialize
```

2. **Check ICE connection states:**
The `onIceConnectionState` callback shows the connection progress:
- `checking` → Looking for a connection path
- `connected` → Successfully connected
- `failed` → No connection path found (need TURN)
- `disconnected` → Temporarily lost (may recover)

3. **Verify signaling order:**
Correct order for non-initiator:
```
1. Receive offer
2. setRemoteDescription(offer)
3. createAnswer()
4. setLocalDescription(answer)
5. Send answer
6. Add ICE candidates (can be done anytime after setRemoteDescription)
```

4. **Check for permission errors:**
Always verify permissions are granted before accessing media:
```dart
final cameraStatus = await Permission.camera.status;
final micStatus = await Permission.microphone.status;
dev.log('Camera: $cameraStatus, Mic: $micStatus');
```
