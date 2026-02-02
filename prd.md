# Product Requirements Document (PRD)
## Spoken Club - Mobile Voice & Video Calling App

**Version:** 1.0
**Date:** January 29, 2026
**Status:** Draft
**Author:** Product Team

---

## 1. Project Overview

Spoken Club is a mobile application that enables users to connect with others through real-time audio and video calls. The app supports both direct calls to specific users and random matching with available users, similar to platforms like Omegle but with a focus on voice/video communication.

### Key Differentiators
- **Dual Connection Modes**: Users can either select specific people from an online list or get randomly matched with waiting users
- **Real-time Presence**: Live updates showing who's online, waiting, or in a call
- **Simple & Focused**: Audio/video calls only, no text chat cluttering the experience
- **Cross-platform**: Native iOS and Android apps built with Flutter

---

## 2. Goals & Objectives

### Primary Goals
1. **Enable seamless peer-to-peer communication** through WebRTC-based audio/video calls
2. **Foster spontaneous connections** via random matching feature
3. **Provide reliable real-time presence** so users know who's available
4. **Deliver a smooth mobile experience** with native performance on iOS and Android

### Success Metrics
- User registration completion rate > 80%
- Call connection success rate > 95%
- Average call duration > 3 minutes
- User retention (DAU/MAU ratio) > 30%
- App crash rate < 1%

---

## 3. Target Audience

### Primary Users
- **Age**: 18-35 years old
- **Tech-savvy**: Comfortable with mobile apps and video calling
- **Use Cases**:
  - Language learning practice (speaking with native speakers)
  - Meeting new people globally
  - Casual conversations
  - Networking and social connections

### User Personas
1. **The Language Learner**: Wants to practice speaking with native speakers
2. **The Social Explorer**: Enjoys meeting random people from different cultures
3. **The Networker**: Looking to expand professional/social connections

---

## 4. Features & Requirements

### 4.1 User Authentication & Registration

#### Registration (Email/Password)
- **Required Fields**:
  - Username (3-30 characters, unique, alphanumeric with underscores/hyphens)
  - Email (valid email format, unique)
  - Mobile Number (required, with country code picker, validated format)
  - Password (minimum 8 characters, must contain uppercase, lowercase, digit, special character)
  - Profile Avatar (optional during registration, can be added later)

- **Validation**:
  - Real-time field validation with error messages
  - Username availability check (debounced)
  - Email format validation
  - Password strength indicator
  - Mobile number format validation

- **Flow**:
  1. User opens app → sees welcome/onboarding screen
  2. Taps "Sign Up" → registration form
  3. Fills required fields with real-time validation
  4. Taps "Create Account" → API call to `/api/auth/register`
  5. On success: Navigate to home screen with tokens stored
  6. On error: Display specific error messages (email exists, username taken, etc.)

#### Google OAuth Authentication
- **Flow**:
  1. User taps "Continue with Google" button
  2. Google Sign-In sheet appears (native SDK integration)
  3. User selects Google account → authorizes
  4. App receives Google ID token
  5. Send token to `/api/auth/google` endpoint
  6. Backend auto-creates account or links existing email
  7. On success: Navigate to home screen with tokens stored

- **Implementation Notes**:
  - Uses `google_sign_in` Flutter package
  - Backend handles account creation/linking automatically
  - If email exists: Links Google account to existing user
  - If new user: Creates account with Google profile data (name, email, avatar)

#### Login (Email/Password)
- **Fields**: Email, Password
- **Features**:
  - Remember me checkbox (auto-login on app restart)
  - "Forgot Password" link (Phase 2 - not in MVP)
  - Biometric login option (fingerprint/face ID) after first login

- **Flow**:
  1. User enters email + password
  2. Taps "Login" → API call to `/api/auth/login`
  3. On success: Store access token + refresh token → Navigate to home
  4. On error: Display "Invalid email or password"

#### Token Management
- **Access Token**: 15-minute expiry, stored in secure storage
- **Refresh Token**: 7-day expiry, stored in secure storage
- **Auto-refresh**: When access token expires, automatically call `/api/auth/refresh`
- **Logout**: Call `/api/auth/logout`, clear tokens, navigate to login screen

---

### 4.2 User Profile Management

#### Profile Fields
- Username (editable)
- Email (read-only, set during registration)
- Mobile Number (read-only, set during registration)
- Avatar (uploadable image)

#### Avatar Upload
- **Sources**:
  - Device camera (take photo)
  - Photo gallery/library
- **Requirements**:
  - Max file size: 5MB
  - Supported formats: JPEG, PNG
  - Auto-crop to square aspect ratio
  - Compress before upload (optimize for mobile)
- **Upload Flow**:
  1. User taps avatar → shows bottom sheet (Camera / Gallery)
  2. User selects image → crop/edit screen
  3. Taps "Save" → uploads to server
  4. **Backend Change Needed**: New endpoint `POST /api/users/me/avatar` (multipart/form-data)
  5. Server returns uploaded avatar URL
  6. Update local state + UI

#### Edit Profile
- **Endpoint**: `PATCH /api/users/me`
- **Editable Fields**: Username, Avatar URL
- **Validation**: Username uniqueness check, 3-30 characters
- **Flow**:
  1. User taps "Edit Profile"
  2. Modify username → auto-save on field blur
  3. Upload new avatar → immediate update

#### View Profile
- **Endpoint**: `GET /api/users/me`
- **Display**: Username, Email, Mobile Number, Avatar, Member since date

---

### 4.3 Presence Management (Online/Offline Status)

#### Online/Offline Toggle
- **Mechanism**: WebSocket connection + Redis state tracking
- **User Actions**:
  - **Go Online**: User taps "Go Online" button → emits `user:go-online` event
  - **Go Offline**: User taps "Go Offline" button → emits `user:go-offline` event
  - **Auto-offline**: App goes to background → auto emit `user:go-offline`
  - **Auto-online**: App comes to foreground → auto emit `user:go-online`

#### Status States
- **OFFLINE**: Not connected to server
- **ONLINE**: Connected, available for calls
- **WAITING**: In matchmaking queue, waiting for random match
- **IN_CALL**: Currently on an active call

#### Real-time Updates
- **Server Event**: `user:status-changed` → Payload: `{ userId, status }`
- **Client Action**: Update online users list in real-time
- **Broadcast**: All connected clients receive status changes instantly

#### Online Users List
- **Endpoint**: `GET /api/users/online`
- **WebSocket Event**: `online:users-list` (real-time updates)
- **Display**:
  - Grid/list of online users
  - Show: Avatar, Username, Status badge (Online, Waiting, In Call)
  - Max 10 users (server limitation)
  - Sort by: Most recently online first
- **Refresh**:
  - Auto-updates via WebSocket events
  - Pull-to-refresh for manual refresh

---

### 4.4 Calling Features

#### 4.4.1 Direct Call (Call Specific User)

**⚠️ Backend Addition Required**: Direct calling is not yet implemented in the server. Currently only random matching exists.

**Flow**:
1. User browses online users list
2. Taps on a user → shows user profile card with "Call" button
3. Taps "Call" → emits `call:initiate` event with `{ recipientId }`
4. **Server needs to**:
   - Check if recipient is ONLINE and not IN_CALL
   - Set both users' status to IN_CALL
   - Create call record in MongoDB
   - Emit `call:incoming` to recipient with caller info
5. Recipient's phone rings → shows incoming call screen
6. Recipient can Accept or Reject
   - **Accept**: Emit `call:accept` → start WebRTC signaling
   - **Reject**: Emit `call:reject` → notify caller, revert statuses to ONLINE
7. WebRTC connection established → call begins

**Required Server Changes**:
- New socket events: `call:initiate`, `call:incoming`, `call:accept`, `call:reject`
- Validation: Check recipient availability before sending incoming call
- Ringing timeout: Auto-cancel call after 30 seconds if not answered

---

#### 4.4.2 Random Matching (Find Match)

**Already Implemented on Server** ✅

**Flow**:
1. User taps "Find Match" button on home screen
2. Emit `matchmaking:join` → user status changes to WAITING
3. Show waiting screen with "Searching for match..." animation
4. User can tap "Cancel" → emit `matchmaking:leave` → status back to ONLINE
5. When match found:
   - Server emits `matchmaking:matched` to both users
   - Payload: `{ callId, dbCallId, peerId, peerInfo: { id, username, avatar }, initiator: true/false }`
6. Navigate to call screen immediately
7. WebRTC signaling begins automatically

**Matchmaking Algorithm** (Server Implementation):
- FIFO queue: First user waits, second user gets matched instantly
- Atomic Redis operation prevents race conditions
- Users cannot match with themselves

---

#### 4.4.3 WebRTC Signaling & Connection

**Server Events** (Already Implemented ✅):
- `call:offer` - Send WebRTC offer (SDP) to peer
- `call:answer` - Send WebRTC answer (SDP) to peer
- `call:ice-candidate` - Exchange ICE candidates for NAT traversal

**WebRTC Configuration**:
- **STUN Servers**: Google public STUN servers
  - `stun:stun.l.google.com:19302`
  - `stun:stun1.l.google.com:19302`
- **TURN Servers**: Not required for MVP (future enhancement for restrictive networks)
- **ICE Candidate Policy**: All (gather all types)
- **SDP Semantics**: Unified Plan

**Flutter Package**: `flutter_webrtc` (official WebRTC plugin)

**Connection Flow**:
1. **Initiator** (matched first or caller):
   - Create RTCPeerConnection
   - Add local media stream (audio/video tracks)
   - Create offer → set local description
   - Emit `call:offer` with SDP
2. **Receiver** (matched second or callee):
   - Receive `call:offer` event
   - Create RTCPeerConnection
   - Add local media stream
   - Set remote description (offer)
   - Create answer → set local description
   - Emit `call:answer` with SDP
3. **Both Peers**:
   - Listen for `call:ice-candidate` events
   - Add remote ICE candidates to peer connection
   - Emit own ICE candidates as they're gathered
4. **Connection Established**:
   - Display remote video stream
   - Show call duration timer
   - Enable in-call controls

---

#### 4.4.4 In-Call Controls

**Call Screen UI**:
- Large video display (remote user's video)
- Small floating window (local user's video, picture-in-picture)
- Bottom control bar with buttons
- Top bar with user info and call duration

**Control Buttons**:

1. **Mute/Unmute Microphone**
   - Icon: Microphone / Microphone-off
   - Action: Toggle audio track enabled state
   - Visual feedback: Red background when muted
   - Audio cue: Brief tone when toggling

2. **Video On/Off**
   - Icon: Video camera / Video camera-off
   - Action: Toggle video track enabled state
   - When off: Show avatar/placeholder instead of video
   - Use case: Switch to audio-only mode to save bandwidth

3. **Speaker/Earpiece Toggle** (Mobile only)
   - Icon: Speaker / Phone
   - Action: Switch audio output route
   - Default: Earpiece for privacy
   - Toggle to speaker for hands-free

4. **Camera Switch** (Front/Back)
   - Icon: Camera rotate
   - Action: Switch between front and back camera
   - Only enabled during video calls
   - Smooth transition without disconnection

5. **End Call**
   - Icon: Phone hangup (red)
   - Action:
     - Emit `call:end` event
     - Close RTCPeerConnection
     - Stop all media tracks
     - Navigate back to home screen
     - Update call status to "completed" in backend

**Network Quality Indicator**:
- Green: Excellent connection
- Yellow: Moderate quality (packet loss < 5%)
- Red: Poor connection (packet loss > 10%, high latency)
- Auto-adjust to audio-only if quality degrades severely

---

### 4.5 Call History

**Already Implemented on Server** ✅

#### Display
- **Screen**: Dedicated "History" tab in bottom navigation
- **Layout**: List view with cards for each call
- **Information per Call**:
  - Participant avatar + username
  - Call date/time (relative: "2 hours ago", "Yesterday", "Jan 15")
  - Call duration (formatted: "5m 32s", "1h 12m")
  - Call status icon:
    - ✅ Completed (green checkmark)
    - ❌ Missed (red X)
    - 🚫 Cancelled (gray)
  - Call type: Random Match or Direct Call

#### Pagination
- **Initial load**: 20 most recent calls
- **Load more**: Infinite scroll (fetch next 20 when reaching bottom)
- **Endpoint**: `GET /api/calls/history?page=1&limit=20`

#### Filters (Phase 2 - Future Enhancement)
- Filter by status (Completed, Missed, Cancelled)
- Filter by date range
- Filter by participant

#### Actions
- Tap on call → View call details (full screen)
  - Participants
  - Start/end time
  - Duration
  - Call quality rating (if implemented)
- Swipe left → Delete from history (local only, doesn't delete from server)

---

### 4.6 Push Notifications

**⚠️ Backend Addition Required**: Push notification service not yet implemented.

#### Use Cases
1. **Incoming Direct Call** (when app is closed/background)
   - Notification: "John Doe is calling you"
   - Action buttons: Answer, Decline
   - Tap notification → opens app to call screen

2. **Missed Call**
   - Notification: "You missed a call from Jane Smith"
   - Tap → opens app to call history

3. **Random Match Found** (when app is background)
   - Notification: "Match found! Tap to connect"
   - Tap → opens app to call screen

#### Implementation
- **Service**: Firebase Cloud Messaging (FCM)
- **Packages**:
  - `firebase_messaging` for FCM
  - `flutter_local_notifications` for foreground notifications
- **Backend Requirements**:
  - Store FCM device tokens in User model
  - New endpoint: `POST /api/users/me/fcm-token` (save/update token)
  - Send FCM push when:
    - Direct call initiated (to recipient)
    - Call rejected/missed (to caller)
    - Random match found (to both users if backgrounded)

#### Notification Permissions
- Request permission on first app launch
- Explain benefit: "Get notified when someone calls you"
- Allow users to disable in app settings

---

## 5. Technical Architecture

### 5.1 Flutter App Stack

#### Core Framework
- **Flutter**: 3.19+ (latest stable)
- **Dart**: 3.3+
- **Platforms**: iOS 12+, Android 6.0+ (API level 23+)

#### State Management
- **Riverpod 2.0+**: Compile-safe, generator-based state management
- **Packages**:
  - `flutter_riverpod` ^2.4.0
  - `riverpod_annotation` ^2.3.0
  - `riverpod_generator` ^2.3.0

#### Navigation
- **GoRouter 14.0+**: Declarative routing with deep linking support

#### Networking
- **HTTP**: `dio` ^5.4.0 with interceptors for:
  - JWT token injection
  - Automatic token refresh
  - Error handling
  - Logging (debug mode only)
- **WebSocket**: `socket_io_client` ^2.0.0 for Socket.io connection

#### WebRTC
- **Package**: `flutter_webrtc` ^0.9.0
- **Permissions**:
  - `permission_handler` for camera/microphone access

#### Authentication
- **Google Sign-In**: `google_sign_in` ^6.1.0
- **Secure Storage**: `flutter_secure_storage` ^9.0.0 for token storage

#### Media & UI
- **Image Picker**: `image_picker` ^1.0.0 (avatar upload)
- **Image Cropper**: `image_cropper` ^5.0.0 (crop avatar to square)
- **Cached Network Image**: `cached_network_image` ^3.3.0 (avatar caching)
- **Country Code Picker**: `country_code_picker` ^3.0.0 (mobile number input)

#### Push Notifications
- **Firebase Core**: `firebase_core` ^2.24.0
- **Firebase Messaging**: `firebase_messaging` ^14.7.0
- **Local Notifications**: `flutter_local_notifications` ^16.3.0

#### Code Generation
- **Freezed**: `freezed` ^2.4.0 (immutable models)
- **JSON Serializable**: `json_annotation` ^4.8.0 + `json_serializable` ^6.7.0
- **Build Runner**: `build_runner` ^2.4.0

#### Utilities
- **Intl**: `intl` ^0.18.0 (date/time formatting)
- **Logger**: `logger` ^2.0.0 (debug logging)
- **Connectivity Plus**: `connectivity_plus` ^5.0.0 (network status)

---

### 5.2 Server APIs (Existing)

**Base URL**: `http://localhost:3000/api` (production URL TBD)

#### Authentication Endpoints
| Method | Endpoint | Description | Status |
|--------|----------|-------------|--------|
| POST | `/auth/register` | Register with email/password | ✅ Implemented |
| POST | `/auth/login` | Login with email/password | ✅ Implemented |
| POST | `/auth/google` | Google OAuth login | ✅ Implemented |
| POST | `/auth/logout` | Logout current user | ✅ Implemented |
| POST | `/auth/refresh` | Refresh access token | ✅ Implemented |

#### User Endpoints
| Method | Endpoint | Description | Status |
|--------|----------|-------------|--------|
| GET | `/users/me` | Get current user profile | ✅ Implemented |
| PATCH | `/users/me` | Update username/avatar | ✅ Implemented |
| GET | `/users/online` | Get online users list (max 10) | ✅ Implemented |
| POST | `/users/me/avatar` | Upload profile avatar | ❌ **Needs Implementation** |
| POST | `/users/me/fcm-token` | Save FCM device token | ❌ **Needs Implementation** |

#### Call History Endpoints
| Method | Endpoint | Description | Status |
|--------|----------|-------------|--------|
| GET | `/calls/history` | Get call history (paginated) | ✅ Implemented |
| GET | `/calls/:id` | Get specific call details | ✅ Implemented |

---

### 5.3 WebSocket Events (Existing)

**Server URL**: `http://localhost:3000` (Socket.io connection)

#### Connection
- **Client**: `io('http://localhost:3000', { auth: { token: 'jwt-access-token' } })`
- **Authentication**: JWT token verified on connection

#### Presence Events
| Event | Direction | Payload | Description | Status |
|-------|-----------|---------|-------------|--------|
| `user:go-online` | Client → Server | None | Mark user as ONLINE | ✅ Implemented |
| `user:go-offline` | Client → Server | None | Mark user as OFFLINE | ✅ Implemented |
| `user:status-changed` | Server → Client | `{ userId, status }` | Broadcast status change | ✅ Implemented |
| `online:users-list` | Server → Client | Array of users | Updated online users | ✅ Implemented |

#### Matchmaking Events
| Event | Direction | Payload | Description | Status |
|-------|-----------|---------|-------------|--------|
| `matchmaking:join` | Client → Server | None | Join random match queue | ✅ Implemented |
| `matchmaking:leave` | Client → Server | None | Leave match queue | ✅ Implemented |
| `matchmaking:matched` | Server → Client | `{ callId, dbCallId, peerId, peerInfo, initiator }` | Match found | ✅ Implemented |

#### WebRTC Signaling Events
| Event | Direction | Payload | Description | Status |
|-------|-----------|---------|-------------|--------|
| `call:offer` | Client → Server | `{ to, offer }` | Send WebRTC offer | ✅ Implemented |
| `call:answer` | Client → Server | `{ to, answer }` | Send WebRTC answer | ✅ Implemented |
| `call:ice-candidate` | Client → Server | `{ to, candidate }` | Send ICE candidate | ✅ Implemented |
| `call:offer` | Server → Client | `{ from, offer }` | Receive offer from peer | ✅ Implemented |
| `call:answer` | Server → Client | `{ from, answer }` | Receive answer from peer | ✅ Implemented |
| `call:ice-candidate` | Server → Client | `{ from, candidate }` | Receive ICE candidate | ✅ Implemented |
| `call:end` | Client → Server | None | End current call | ✅ Implemented |
| `call:ended` | Server → Client | `{ reason }` | Call ended notification | ✅ Implemented |

#### Direct Call Events (Not Yet Implemented)
| Event | Direction | Payload | Description | Status |
|-------|-----------|---------|-------------|--------|
| `call:initiate` | Client → Server | `{ recipientId }` | Initiate call to user | ❌ **Needs Implementation** |
| `call:incoming` | Server → Client | `{ callId, callerId, callerInfo }` | Incoming call notification | ❌ **Needs Implementation** |
| `call:accept` | Client → Server | `{ callId }` | Accept incoming call | ❌ **Needs Implementation** |
| `call:reject` | Client → Server | `{ callId }` | Reject incoming call | ❌ **Needs Implementation** |

#### Error Events
| Event | Direction | Payload | Description | Status |
|-------|-----------|---------|-------------|--------|
| `error` | Server → Client | `{ message, details? }` | Error notification | ✅ Implemented |

---

### 5.4 Data Models

#### User Model (Frontend)
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String username,
    required String email,
    required String mobileNumber,  // NEW FIELD
    String? avatar,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

#### Call Model (Frontend)
```dart
@freezed
class Call with _$Call {
  const factory Call({
    required String id,
    required List<User> participants,
    required User initiatedBy,
    required DateTime startedAt,
    DateTime? endedAt,
    required CallStatus status,
    int? duration, // in seconds
  }) = _Call;

  factory Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);
}

enum CallStatus {
  completed,
  missed,
  cancelled,
}
```

#### Online User Model
```dart
@freezed
class OnlineUser with _$OnlineUser {
  const factory OnlineUser({
    required String id,
    required String username,
    String? avatar,
    required UserStatus status,
  }) = _OnlineUser;

  factory OnlineUser.fromJson(Map<String, dynamic> json) => _$OnlineUserFromJson(json);
}

enum UserStatus {
  online,
  waiting,
  inCall,
  offline,
}
```

---

## 6. User Flows

### 6.1 Registration & Onboarding Flow
```
1. Launch App
   ↓
2. Onboarding Screens (3 slides)
   - Slide 1: "Connect with people worldwide"
   - Slide 2: "Audio & Video calls"
   - Slide 3: "Random or Direct calls"
   ↓
3. Welcome Screen
   - "Sign Up" button
   - "Login" button
   - "Continue with Google" button
   ↓
4a. Sign Up Flow
   - Enter username
   - Enter email
   - Select country code + mobile number
   - Enter password
   - (Optional) Upload avatar
   - Tap "Create Account"
   - API call → Success
   ↓
5. Home Screen (Online Users List)
```

### 6.2 Login Flow
```
1. Welcome Screen
   ↓
2a. Email/Password Login
   - Enter email
   - Enter password
   - Tap "Login"
   ↓
2b. Google OAuth Login
   - Tap "Continue with Google"
   - Google Sign-In sheet
   - Select account
   - Authorize
   ↓
3. Home Screen (Auto go online)
```

### 6.3 Random Matching Flow
```
1. Home Screen (User is ONLINE)
   ↓
2. Tap "Find Match" button
   ↓
3. Status changes to WAITING
   ↓
4. Waiting Screen
   - "Searching for match..." animation
   - "Cancel" button
   ↓
5a. Match Found
   - Receive `matchmaking:matched` event
   - Navigate to Call Screen
   - Start WebRTC signaling
   - Call connects
   ↓
5b. User Cancels
   - Tap "Cancel"
   - Emit `matchmaking:leave`
   - Return to Home Screen
   - Status back to ONLINE
```

### 6.4 Direct Call Flow
```
1. Home Screen (Online Users List)
   ↓
2. Tap on user card
   ↓
3. User Profile Modal
   - Avatar, username
   - "Call" button
   ↓
4. Tap "Call"
   ↓
5. Emit `call:initiate` with recipientId
   ↓
6. Caller: Show "Calling..." screen
   Callee: Receive `call:incoming` → Show incoming call screen
   ↓
7a. Callee Accepts
   - Emit `call:accept`
   - Both navigate to Call Screen
   - Start WebRTC signaling
   - Call connects
   ↓
7b. Callee Rejects
   - Emit `call:reject`
   - Caller receives notification
   - Both return to Home
   ↓
7c. Timeout (30 seconds)
   - Auto-cancel call
   - Mark as "missed" in history
```

### 6.5 In-Call Flow
```
1. Call Screen
   - Remote video (large)
   - Local video (floating PiP)
   - Control buttons at bottom
   ↓
2. During Call
   - Tap "Mute" → toggle audio
   - Tap "Video Off" → disable camera
   - Tap "Speaker" → toggle speaker/earpiece
   - Tap "Camera Switch" → front/back
   ↓
3. End Call
   - Tap red "End Call" button
   - Emit `call:end`
   - Close peer connection
   - Stop media tracks
   - Navigate to Home Screen
   - Call saved in history
```

---

## 7. UI/UX Requirements

### 7.1 Design System

#### Theme
- **Design Language**: Material Design 3 (Material You)
- **Color Scheme**:
  - Primary: Custom brand color (e.g., Teal #00897B)
  - Secondary: Accent color (e.g., Orange #FF6F00)
  - Surface: Dynamic Material You colors
- **Dark Mode**: Full support with auto-switch based on system preference
- **Typography**:
  - Headings: Roboto Bold
  - Body: Roboto Regular
  - Monospace: Roboto Mono (for call duration)

#### Spacing & Layout
- **Grid**: 8px baseline grid
- **Padding**: 16px standard screen padding
- **Card elevation**: 2dp for resting, 8dp for raised
- **Border radius**: 12px for cards, 24px for buttons

---

### 7.2 Screen Layouts

#### Home Screen (Online Users)
- **Top App Bar**:
  - Title: "Spoken Club"
  - Actions: Profile icon, Settings icon
  - Status indicator: Green dot with "Online" text
- **Body**:
  - "Find Match" floating action button (large, center-bottom)
  - Grid/List of online users (2 columns on phones, 3+ on tablets)
  - Each user card shows: Avatar, Username, Status badge
  - Pull-to-refresh
  - Empty state: "No users online right now"
- **Bottom Navigation**:
  - Home (online users icon)
  - History (clock icon)
  - Profile (person icon)

#### Call Screen
- **Layout**:
  - Remote video: Full screen background
  - Local video: Floating PiP (top-right, draggable)
  - Top bar (overlay): Peer username, call duration, network indicator
  - Bottom bar (overlay): Control buttons in row
- **Controls**:
  - Mute, Video On/Off, Speaker, Camera Switch, End Call
  - Icons with labels
  - Red background for "End Call"
- **Landscape Mode**: Rotate video, controls remain at bottom

#### Call History Screen
- **List View**:
  - Each item: Avatar + Username + Time + Duration + Status icon
  - Grouped by date: Today, Yesterday, This Week, Older
  - Tap to expand → show full details
  - Pull-to-refresh
- **Empty State**: "No call history yet. Make your first call!"

#### Profile Screen
- **Sections**:
  - Profile picture (large, centered, tap to change)
  - Username (editable inline)
  - Email (read-only)
  - Mobile Number (read-only)
  - Member since date
  - Logout button (red, at bottom)

---

### 7.3 Animations & Feedback

#### Micro-interactions
- **Button taps**: Ripple effect (Material Design)
- **Status changes**: Smooth color transitions for status badges
- **Navigation**: Slide transitions between screens
- **Pull-to-refresh**: Material spinner

#### Call Animations
- **Ringing**: Pulsing avatar animation
- **Connecting**: Loading spinner with "Connecting..." text
- **Incoming call**: Full-screen modal with slide-up animation
- **Call ended**: Fade out to home screen

#### Loading States
- **Skeleton screens**: For user lists while loading
- **Shimmer effect**: For avatar placeholders
- **Progress indicators**: Linear for uploads, circular for network requests

---

## 8. Server API Gaps & Additions Needed

### 8.1 User Model Changes

**Add Mobile Number Field**:
```javascript
// /src/models/User.model.js
{
  // ... existing fields
  mobileNumber: {
    type: String,
    required: true,
    unique: true,
    validate: {
      validator: function(v) {
        return /^\+[1-9]\d{1,14}$/.test(v); // E.164 format
      },
      message: 'Invalid mobile number format'
    }
  }
}
```

**Update Registration Validator**:
```javascript
// /src/validators/auth.validator.js
const registerSchema = Joi.object({
  username: Joi.string().min(3).max(30).required(),
  email: Joi.string().email().required(),
  mobileNumber: Joi.string().pattern(/^\+[1-9]\d{1,14}$/).required(), // NEW
  password: Joi.string().min(8).pattern(...).required(),
  avatar: Joi.string().uri().optional()
});
```

---

### 8.2 Avatar Upload Endpoint

**New Route**: `POST /api/users/me/avatar`

**Implementation**:
```javascript
// Use multer for multipart/form-data
// Upload to cloud storage (AWS S3, Cloudinary, etc.)
// Return uploaded image URL
// Update user.avatar in database

// Validation:
// - Max file size: 5MB
// - Allowed types: image/jpeg, image/png
// - Auto-resize to 512x512 px
```

**Response**:
```json
{
  "success": true,
  "data": {
    "avatarUrl": "https://cdn.example.com/avatars/user123.jpg"
  }
}
```

---

### 8.3 Direct Call Events

**New Socket Events** (`/src/sockets/handlers/directCall.handler.js`):

1. **`call:initiate`** (Client → Server)
   - Payload: `{ recipientId: string }`
   - Validation: Recipient exists, is ONLINE, not IN_CALL
   - Actions:
     - Generate unique callId
     - Set caller status to IN_CALL
     - Emit `call:incoming` to recipient
     - Start 30-second timeout timer

2. **`call:incoming`** (Server → Client)
   - Payload: `{ callId, callerId, callerInfo: { username, avatar } }`
   - Recipient shows incoming call screen

3. **`call:accept`** (Client → Server)
   - Payload: `{ callId }`
   - Actions:
     - Set callee status to IN_CALL
     - Create call record in MongoDB
     - Notify caller that call was accepted
     - Allow WebRTC signaling to begin

4. **`call:reject`** (Client → Server)
   - Payload: `{ callId }`
   - Actions:
     - Revert both users to ONLINE status
     - Mark call as "missed" in MongoDB
     - Notify caller of rejection

5. **Call Timeout**:
   - After 30 seconds with no accept/reject:
     - Auto-cancel call
     - Mark as "missed"
     - Notify both users

---

### 8.4 Push Notification Service

**New Service**: `/src/services/notification.service.js`

**FCM Token Management**:
- **Endpoint**: `POST /api/users/me/fcm-token`
- **Payload**: `{ fcmToken: string }`
- **Action**: Save/update token in User model
- **User Model Update**:
  ```javascript
  fcmTokens: [{
    token: String,
    device: String, // 'ios' or 'android'
    updatedAt: Date
  }]
  ```

**Send Notifications**:
1. **Incoming Direct Call**:
   ```javascript
   async function sendIncomingCallNotification(recipientId, callerInfo) {
     const recipient = await User.findById(recipientId);
     const tokens = recipient.fcmTokens.map(t => t.token);

     const message = {
       notification: {
         title: 'Incoming Call',
         body: `${callerInfo.username} is calling you`
       },
       data: {
         type: 'incoming_call',
         callerId: callerInfo.id,
         callId: '...'
       },
       tokens: tokens
     };

     await admin.messaging().sendMulticast(message);
   }
   ```

2. **Missed Call**:
   - Title: "Missed Call"
   - Body: "You missed a call from [username]"

3. **Random Match Found** (when app backgrounded):
   - Title: "Match Found!"
   - Body: "Tap to connect with your match"

**Setup**:
- Install `firebase-admin` SDK
- Configure service account JSON
- Initialize in `/src/config/firebase.js`

---

## 9. Third-Party Integrations

### 9.1 Google OAuth
- **Client ID**: Obtain from Google Cloud Console
- **Scopes**: `email`, `profile`
- **Backend**: Uses `google-auth-library` to verify ID tokens
- **Frontend**: Uses `google_sign_in` Flutter package

### 9.2 Firebase Cloud Messaging
- **Project**: Create Firebase project
- **Android**: Download `google-services.json` → place in `/android/app/`
- **iOS**: Download `GoogleService-Info.plist` → place in `/ios/Runner/`
- **Backend**: Use Firebase Admin SDK with service account

### 9.3 WebRTC STUN Servers
- **Free Public STUN**:
  - `stun:stun.l.google.com:19302`
  - `stun:stun1.l.google.com:19302`
- **Future TURN Server**: For users behind restrictive NATs (corporate firewalls)
  - Options: Coturn (self-hosted), Twilio TURN, Xirsys

### 9.4 Cloud Storage (for Avatar Upload)
- **Option 1**: AWS S3 (recommended for production)
- **Option 2**: Cloudinary (easier setup, image transformations included)
- **Option 3**: Firebase Storage (tight integration with FCM)

---

## 10. Security & Privacy

### 10.1 Authentication Security
- **JWT Tokens**: Stored in secure storage (Keychain on iOS, Keystore on Android)
- **Token Expiry**: Access tokens expire in 15 minutes
- **Refresh Tokens**: Rotate on each refresh, stored securely
- **Logout**: Clear all tokens from secure storage

### 10.2 API Security
- **HTTPS Only**: All API calls over TLS 1.2+
- **Rate Limiting**:
  - Auth endpoints: 5 requests per 15 minutes
  - Other endpoints: 100 requests per 15 minutes
- **Input Validation**: Joi schemas on all endpoints
- **CORS**: Whitelist only mobile app domains

### 10.3 WebRTC Security
- **Peer-to-peer**: Media streams never pass through server (end-to-end encrypted by design)
- **DTLS-SRTP**: All media encrypted automatically by WebRTC
- **Signaling**: Secure WebSocket connection (WSS)

### 10.4 Privacy
- **No Call Recording**: App does not record calls (unless user explicitly enables local recording)
- **Data Collection**: Only collect necessary data (username, email, mobile, call metadata)
- **Call History**: Stored on server but users can delete locally
- **Permissions**:
  - Camera: Required for video calls
  - Microphone: Required for audio calls
  - Notifications: Optional, requested on first launch
  - Contacts: NOT required

### 10.5 User Blocking (Future)
- Allow users to block other users
- Blocked users cannot see each other in online list
- Blocked users cannot match randomly
- Blocked users cannot make direct calls

---

## 11. Performance Requirements

### 11.1 App Performance
- **Cold start time**: < 2 seconds on mid-range devices
- **Frame rate**: Maintain 60 FPS during navigation
- **Memory usage**: < 200 MB during calls
- **Battery drain**: < 5% per 10 minutes of video call
- **App size**:
  - Android: < 50 MB APK
  - iOS: < 60 MB IPA

### 11.2 Network Performance
- **API Response Time**: < 500ms for 95th percentile
- **WebSocket Latency**: < 100ms for signaling events
- **WebRTC Connection**: < 3 seconds to establish
- **Call Quality**:
  - Audio: Opus codec, 16-48 kHz sample rate
  - Video: VP8/H.264, 640x480 @ 15-30 fps, 500-1000 kbps
  - Adaptive bitrate based on network conditions

### 11.3 Scalability
- **Concurrent Users**: Support 10,000 online users
- **Concurrent Calls**: 5,000 simultaneous calls
- **WebSocket Connections**: 10,000+ connections per server instance
- **Redis**: Use Redis Cluster for horizontal scaling

---

## 12. Testing Strategy

### 12.1 Unit Tests
- **Coverage**: > 80% for business logic
- **Focus**:
  - Riverpod providers/notifiers
  - API service methods
  - Data models serialization
  - Validators and utilities

### 12.2 Widget Tests
- **Coverage**: All critical user flows
- **Focus**:
  - Registration form validation
  - Login form
  - Online users list
  - Call controls
  - Call history list

### 12.3 Integration Tests
- **Flow Tests**:
  - Complete registration → login → go online
  - Random matching → call → end call
  - Direct call → accept → in-call controls → end
  - View call history → load more

### 12.4 Manual Testing
- **Device Matrix**:
  - Android: Pixel 6, Samsung Galaxy S21, OnePlus 9 (Android 12+)
  - iOS: iPhone 12, iPhone 14 Pro (iOS 15+)
- **Network Conditions**:
  - WiFi (high speed)
  - 4G LTE
  - 3G (degraded mode)
  - Poor connection (packet loss simulation)
- **Edge Cases**:
  - Incoming call while in another call
  - App backgrounded during call
  - Network disconnection during call
  - Receiver rejects call
  - Caller cancels before answer

---

## 13. Deployment & Release

### 13.1 App Stores

#### Google Play Store (Android)
- **Package Name**: `com.spokenclub.app`
- **Min SDK**: 23 (Android 6.0)
- **Target SDK**: Latest (Android 14+)
- **Permissions**: Camera, Microphone, Internet, Notifications
- **Release Type**: Internal Testing → Closed Beta → Open Beta → Production

#### Apple App Store (iOS)
- **Bundle ID**: `com.spokenclub.app`
- **Min iOS**: 12.0
- **Capabilities**: Camera, Microphone, Background Modes (VOIP)
- **TestFlight**: Beta testing with 100 users
- **App Review**: Emphasize social/educational use case

---

### 13.2 Backend Deployment

**Production Environment**:
- **Server**: AWS EC2 / DigitalOcean / Railway
- **Database**: MongoDB Atlas (managed)
- **Redis**: Redis Cloud / AWS ElastiCache
- **Domain**: `api.spokenclub.com` (HTTPS with Let's Encrypt)
- **Monitoring**: PM2 process manager, CloudWatch logs
- **CI/CD**: GitHub Actions for automated deployment

---

## 14. Future Enhancements (Phase 2+)

### Phase 2
1. **Text Chat**: In-call messaging + standalone DMs
2. **User Profiles**: Bio, interests, profile completion percentage
3. **Favorites**: Save favorite users for quick access
4. **User Blocking**: Block/report abusive users
5. **Forgot Password**: Email-based password reset
6. **Custom TURN Server**: For better connectivity in restrictive networks

### Phase 3
1. **Group Calls**: 3-5 participants
2. **Call Recording**: Local recording with consent
3. **Screen Sharing**: Share screen during calls
4. **Virtual Backgrounds**: Blur or replace background
5. **Filters & Effects**: Fun AR filters during video calls
6. **Language Preferences**: Match with users who speak specific languages
7. **Call Quality Rating**: Rate call quality after each call

### Phase 4
1. **Web App**: Browser-based version
2. **Desktop Apps**: Windows/macOS native apps
3. **Subscription Model**: Premium features (no ads, priority matching)
4. **Analytics Dashboard**: User engagement metrics
5. **Admin Panel**: Moderation tools, user management

---

## 15. Success Metrics & KPIs

### User Acquisition
- **Target**: 10,000 registered users in first 3 months
- **Metric**: Daily new registrations

### Engagement
- **DAU (Daily Active Users)**: Target 30% of total users
- **MAU (Monthly Active Users)**: Target 60% of total users
- **Session Duration**: Average 10+ minutes per session
- **Calls per User**: Average 3 calls per day

### Technical Metrics
- **Call Success Rate**: > 95% (connected calls / attempted calls)
- **Average Call Duration**: 5+ minutes
- **App Crash Rate**: < 1%
- **API Error Rate**: < 2%
- **WebSocket Disconnection Rate**: < 5%

### Retention
- **Day 1 Retention**: > 40%
- **Day 7 Retention**: > 25%
- **Day 30 Retention**: > 15%

---

## 16. Project Timeline (Estimated)

### Week 1-2: Foundation
- Flutter project setup
- Implement authentication (email/password + Google OAuth)
- Build user registration/login UI
- Integrate with backend auth APIs

### Week 3-4: Core Features
- WebSocket connection and presence management
- Online users list with real-time updates
- User profile screen with avatar upload
- Random matching feature

### Week 5-6: WebRTC Implementation
- Integrate `flutter_webrtc`
- Implement WebRTC signaling
- Build call screen UI
- Implement in-call controls (mute, video toggle, speaker, camera switch)

### Week 7-8: Direct Calling & History
- Implement direct call feature (+ backend socket events)
- Build incoming call screen
- Call history screen with pagination
- Backend: Add mobile number field, avatar upload endpoint

### Week 9-10: Push Notifications & Polish
- Firebase Cloud Messaging integration
- Push notifications for incoming/missed calls
- UI polish and animations
- Performance optimization

### Week 11-12: Testing & Release
- Comprehensive testing (unit, widget, integration, manual)
- Bug fixes and edge case handling
- App store listing preparation
- Beta release (TestFlight + Internal Testing)
- Production release

---

## Appendices

### A. API Endpoint Reference

See Section 5.2 for complete API documentation.

### B. WebSocket Event Reference

See Section 5.3 for complete WebSocket event documentation.

### C. Environment Variables

**Flutter App** (`.env`):
```
API_BASE_URL=http://localhost:3000/api
SOCKET_URL=http://localhost:3000
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
```

**Backend Server** (`.env`):
```
NODE_ENV=production
PORT=3000
MONGODB_URI=mongodb://...
REDIS_HOST=localhost
REDIS_PORT=6379
JWT_SECRET=your-secret-key
JWT_ACCESS_EXPIRY=15m
JWT_REFRESH_EXPIRY=7d
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
CORS_ORIGIN=https://yourdomain.com
```

### D. Glossary

- **STUN**: Session Traversal Utilities for NAT - helps peers discover their public IP
- **TURN**: Traversal Using Relays around NAT - relay server for restricted networks
- **ICE**: Interactive Connectivity Establishment - finds best path between peers
- **SDP**: Session Description Protocol - describes media capabilities
- **WebRTC**: Web Real-Time Communication - browser-based peer-to-peer communication
- **FCM**: Firebase Cloud Messaging - push notification service
- **JWT**: JSON Web Token - authentication token format
- **Opus**: Audio codec optimized for real-time communication
- **VP8**: Video codec for WebRTC

---

**Document End**

---

**Next Steps**:
1. Review and approve this PRD
2. Backend team: Implement missing APIs (mobile number, avatar upload, direct call events, push notifications)
3. Flutter team: Initialize project and begin Week 1 development
4. DevOps: Set up Firebase project and cloud storage
5. Design team: Finalize UI mockups based on Material Design 3 guidelines
