# Product Requirements Document (PRD)
## Speaking Club - Milestone 2: AI English Practice

**Version:** 1.0
**Date:** February 10, 2026
**Status:** Draft
**Author:** Product Team

---

## 1. Overview

Milestone 2 introduces an AI-powered English practice feature that allows users to have voice conversations with an AI tutor. This feature enables users to practice speaking English anytime, without needing to find a human partner.

### Key Value Proposition
- **24/7 Availability**: Practice English anytime, no waiting for matches
- **Low Pressure Environment**: Users can make mistakes without embarrassment
- **Structured Learning**: Topic-based discussions and scenario roleplay
- **Cost-Effective & Secure**: On-device STT/TTS with ephemeral keys for direct OpenAI connection

### Architecture Overview
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                                                                             │
│  User speaks → On-device STT → Text                                        │
│                                   ↓                                         │
│                    ┌──────────────────────────────┐                        │
│                    │  OpenAI Realtime API         │                        │
│                    │  (WebSocket + Ephemeral Key) │                        │
│                    └──────────────────────────────┘                        │
│                                   ↓                                         │
│                              Text response → On-device TTS → User hears    │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘

Backend Role: Only provides short-lived ephemeral API keys (valid ~60 seconds)
```

### Security Model
- **Main API Key**: Stored securely on backend server only
- **Ephemeral Key**: Short-lived token (~60s) generated per session
- **Direct Connection**: Flutter app connects directly to OpenAI via WebSocket
- **No Proxy**: Text messages don't route through your server (lower latency)

---

## 2. Goals & Objectives

### Primary Goals
1. **Enable solo English practice** through AI-powered voice conversations
2. **Provide structured learning** with topics and real-world scenarios
3. **Offer meaningful feedback** to help users improve their English
4. **Optimize costs & security** using on-device STT/TTS with ephemeral keys for direct OpenAI connection

### Success Metrics
- Daily active users practicing with AI > 40% of total DAU
- Average AI session duration > 3 minutes
- User satisfaction rating > 4.0/5.0
- API cost per user per day < $0.05
- Session completion rate > 70%

---

## 3. Features & Requirements

### 3.1 AI Tutor Persona

#### Current: Single Tutor Character
- **Name**: "Emma" (or configurable)
- **Personality**: Friendly, patient, encouraging English tutor
- **Speaking Style**: Clear, moderate pace, uses simple vocabulary initially
- **Behavior**:
  - Asks follow-up questions to keep conversation flowing
  - Gently corrects grammar mistakes without being judgmental
  - Adapts complexity based on user's English level
  - Provides encouragement and positive reinforcement

#### Planned: Multiple Personas (Near Future)
| Persona | Role | Use Case |
|---------|------|----------|
| **Teacher** | Formal English tutor | Grammar lessons, structured learning |
| **Friend** | Casual conversation buddy | Informal chat, slang, everyday English |
| **Interviewer** | HR/Hiring manager | Job interview preparation |
| **Customer Service** | Support representative | Professional communication practice |
| **Travel Guide** | Local tour guide | Travel-related vocabulary |
| **Business Partner** | Corporate professional | Business English, meetings |

**Implementation Notes**:
- Personas will be selectable from a list before starting session
- Each persona has unique system prompt and personality
- Persona selection stored in session for analytics
- Architecture already supports this via configurable system prompts

#### System Prompt (Base)
```
You are Emma, a friendly and patient English tutor. You're having a voice conversation with someone practicing their English.

Guidelines:
- Keep responses concise (1-3 sentences) for natural conversation flow
- Ask follow-up questions to encourage the user to speak more
- If you notice a grammar mistake, gently correct it in a supportive way
- Adapt your vocabulary complexity to match the user's level
- Be encouraging and positive
- Stay on topic but allow natural conversation tangents
- Remember context from earlier in the conversation
```

---

### 3.2 Conversation Modes

#### 3.2.1 Free Conversation
- **Description**: Open-ended casual chat with the AI tutor
- **Entry**: User selects "Free Chat" option
- **Behavior**: AI engages in natural conversation on any topic the user brings up
- **Use Case**: General speaking practice, building confidence

#### 3.2.2 Topic-Based Discussions
- **Description**: Structured conversations around specific themes
- **Topics Available**:
  | Category | Topics |
  |----------|--------|
  | Daily Life | Family, Hobbies, Food & Cooking, Shopping, Health |
  | Travel | Vacation Planning, At the Airport, Hotel Check-in, Directions |
  | Work & Career | Job Interview, Workplace, Meetings, Presentations |
  | Technology | Smartphones, Social Media, AI & Future, Gaming |
  | Culture | Movies & TV, Music, Sports, Festivals |
  | Current Events | News Discussion, Environment, Education |

- **Flow**:
  1. User selects a topic category
  2. User picks specific topic (or "Random" for surprise)
  3. AI initiates conversation about the topic
  4. AI guides discussion with relevant questions

#### 3.2.3 Scenario Roleplay
- **Description**: Practice real-world situations with AI playing different roles
- **Scenarios Available**:
  | Scenario | AI Role | User Role |
  |----------|---------|-----------|
  | Job Interview | Interviewer | Job Candidate |
  | Restaurant | Waiter/Waitress | Customer |
  | Hotel Check-in | Receptionist | Guest |
  | Shopping | Store Clerk | Shopper |
  | Doctor Visit | Doctor | Patient |
  | Airport | Check-in Agent | Traveler |
  | Phone Call | Customer Service | Caller |
  | Directions | Local Person | Tourist |

- **Flow**:
  1. User selects scenario
  2. App shows brief context/instructions
  3. AI sets the scene and starts the roleplay
  4. Natural conversation within the scenario context
  5. AI provides feedback at the end

---

### 3.3 Speech-to-Text (On-Device)

#### Technology
- **Package**: `speech_to_text` Flutter package
- **Platforms**:
  - iOS: Uses native Speech Framework
  - Android: Uses native SpeechRecognizer

#### Configuration
```dart
final speechToText = SpeechToText();

// Initialization
await speechToText.initialize(
  onError: (error) => handleError(error),
  onStatus: (status) => handleStatus(status),
);

// Start listening
await speechToText.listen(
  onResult: (result) => handleResult(result),
  localeId: 'en_US', // or 'en_GB', 'en_AU'
  listenMode: ListenMode.dictation,
  pauseFor: Duration(seconds: 3), // Auto-stop after 3s silence
);
```

#### Supported Languages
- English (US) - `en_US`
- English (UK) - `en_GB`
- English (Australian) - `en_AU`
- English (Indian) - `en_IN`

#### UI Feedback
- **Listening indicator**: Pulsing microphone icon
- **Real-time transcription**: Show words as they're recognized
- **Confidence visualization**: Dim text for low-confidence words

#### Error Handling
- **No speech detected**: "I didn't catch that. Please try again."
- **Recognition failed**: Retry automatically, show error after 3 attempts
- **Microphone permission denied**: Guide user to settings

---

### 3.4 LLM Integration (OpenAI Realtime API)

#### Architecture
```
┌─────────────┐      1. Request Key      ┌─────────────────┐
│ Flutter App │ ───────────────────────► │  Your Backend   │
│             │ ◄─────────────────────── │                 │
└─────────────┘   2. Ephemeral Key       └─────────────────┘
       │                                          │
       │ 3. WebSocket Connect                     │ Generates key via
       │    (with ephemeral key)                  │ OpenAI REST API
       ▼                                          ▼
┌─────────────────────────────────────────────────────────────┐
│                   OpenAI Realtime API                       │
│              wss://api.openai.com/v1/realtime               │
└─────────────────────────────────────────────────────────────┘
```

#### Step 1: Get Ephemeral Key from Backend

**Endpoint**: `POST /api/ai/session/token`

**Request**:
```json
{
  "mode": "free_chat",
  "topic": "travel",
  "scenario": null
}
```

**Response**:
```json
{
  "success": true,
  "data": {
    "ephemeralKey": "ek_abc123...",
    "expiresAt": "2026-02-10T12:01:00Z",
    "sessionId": "uuid-session-id",
    "remainingSeconds": 285
  }
}
```

#### Step 2: Connect to OpenAI Realtime API

**WebSocket URL**: `wss://api.openai.com/v1/realtime?model=gpt-4o-mini-realtime-preview`

**Connection Headers**:
```dart
final channel = WebSocketChannel.connect(
  Uri.parse('wss://api.openai.com/v1/realtime?model=gpt-4o-mini-realtime-preview'),
  headers: {
    'Authorization': 'Bearer $ephemeralKey',
    'OpenAI-Beta': 'realtime=v1',
  },
);
```

#### Step 3: Session Configuration

After connecting, send session configuration:
```json
{
  "type": "session.update",
  "session": {
    "modalities": ["text"],
    "instructions": "You are Emma, a friendly English tutor...",
    "temperature": 0.7,
    "max_response_output_tokens": 150
  }
}
```

#### Step 4: Send/Receive Messages

**Send User Message**:
```json
{
  "type": "conversation.item.create",
  "item": {
    "type": "message",
    "role": "user",
    "content": [
      {
        "type": "input_text",
        "text": "I went to the beach yesterday"
      }
    ]
  }
}
```

**Trigger Response**:
```json
{
  "type": "response.create"
}
```

**Receive AI Response** (streaming):
```json
{
  "type": "response.text.delta",
  "delta": "That sounds lovely! "
}
```

#### OpenAI Realtime API Configuration
- **Model**: `gpt-4o-mini-realtime-preview`
- **Modalities**: Text only (no audio)
- **Ephemeral Key TTL**: ~60 seconds (request new key if session >1 min)
- **Pricing**: ~$0.60 per 1M input tokens, ~$2.40 per 1M output tokens

#### Key Refresh Strategy
- Ephemeral keys expire in ~60 seconds
- For sessions >1 minute, request new key before expiry
- Maintain WebSocket connection, just update auth if needed
- Backend tracks total session time for usage limits

#### Error Handling
- **Key expired**: Request new ephemeral key, reconnect
- **WebSocket disconnect**: Auto-reconnect with new key
- **Rate limit**: Exponential backoff, notify user
- **Invalid response**: Fallback to generic message

---

### 3.5 Text-to-Speech (On-Device)

#### Technology
- **Package**: `flutter_tts` Flutter package
- **Platforms**:
  - iOS: Uses native AVSpeechSynthesizer
  - Android: Uses native TextToSpeech engine

#### Configuration
```dart
final flutterTts = FlutterTts();

// Setup
await flutterTts.setLanguage('en-US');
await flutterTts.setSpeechRate(0.5); // Slower for learners
await flutterTts.setVolume(1.0);
await flutterTts.setPitch(1.0);

// Speak
await flutterTts.speak("Hello! How can I help you today?");
```

#### Voice Selection
- **Default**: Female voice (matches "Emma" persona)
- **Settings option**: Allow user to change voice
- **Speech rate**: Adjustable (0.3 - 0.7, default 0.5)

#### UI Integration
- **Speaking indicator**: Visual feedback when AI is speaking
- **Interrupt capability**: User can tap to stop AI mid-speech
- **Queue management**: Handle rapid responses gracefully

---

### 3.6 Practice Session UI

#### Entry Point
- **Location**: New "Practice with AI" button on home screen
- **Design**: Prominent button below or alongside "Find Match"
- **Icon**: Robot/AI icon or graduation cap

#### Mode Selection Screen
```
┌─────────────────────────────────┐
│     Practice with AI            │
│                                 │
│  ┌─────────┐  ┌─────────┐      │
│  │  Free   │  │  Topic  │      │
│  │  Chat   │  │  Based  │      │
│  └─────────┘  └─────────┘      │
│                                 │
│       ┌─────────────┐          │
│       │  Scenario   │          │
│       │  Roleplay   │          │
│       └─────────────┘          │
│                                 │
│  Daily limit: 5:00 remaining   │
└─────────────────────────────────┘
```

#### AI Call Screen (Audio-Only UI with Live Transcript)
```
┌─────────────────────────────────┐
│         AI Practice             │
│      02:34  ⏱️ 2:26 left        │
│                                 │
│     ┌─────────────────┐        │
│     │  ≋≋≋≋≋≋≋≋≋≋≋≋  │        │
│     │   Audio Wave    │        │
│     │  ≋≋≋≋≋≋≋≋≋≋≋≋  │        │
│     └─────────────────┘        │
│        "Emma" is speaking       │
│                                 │
│  ┌───────────────────────────┐ │
│  │ 📜 Conversation Transcript │ │
│  ├───────────────────────────┤ │
│  │ 🤖 Emma:                   │ │
│  │ That sounds lovely! What   │ │
│  │ did you do at the beach?   │ │
│  │                            │ │
│  │ 👤 You:                    │ │
│  │ I swimming and eating...   │ │
│  │ (speaking...)              │ │
│  └───────────────────────────┘ │
│                                 │
│  ┌─────┐  ┌─────┐  ┌─────┐    │
│  │ 🎤  │  │ 🔊  │  │ 📞  │    │
│  │Mute │  │Spkr │  │ End │    │
│  └─────┘  └─────┘  └─────┘    │
└─────────────────────────────────┘
```

#### Conversation Transcript Display
- **Layout**: Scrollable chat-like view showing full conversation
- **User Messages (👤 You)**:
  - Appears in real-time as STT converts speech to text
  - Shows "(speaking...)" indicator while actively listening
  - Text updates live as words are recognized
  - Styled with user bubble/background color
- **AI Messages (🤖 Emma)**:
  - Appears when AI response is received
  - Streams in real-time as OpenAI sends text deltas
  - Highlighted while TTS is speaking that message
  - Styled with AI bubble/background color
- **Auto-scroll**: Automatically scrolls to latest message
- **Tap to expand**: Tap any message to see full text if truncated

#### UI Components
- **Timer**: Shows elapsed time AND remaining daily limit
- **Audio Waveform**: Visual representation of current speaker (user or AI)
- **Conversation Transcript**: Live scrollable view of all messages (STT output + LLM responses)
- **Speaking Indicator**: Shows who is currently speaking ("Emma is speaking" / "Listening...")
- **Controls**: Mute, Speaker toggle, End session

---

### 3.7 Feedback System

#### Real-Time Corrections
- **Trigger**: When AI detects grammar/vocabulary mistakes
- **Delivery**: AI naturally incorporates correction in response
- **Example**:
  - User: "I go to store yesterday"
  - AI: "You went to the store yesterday? What did you buy?"

#### End-of-Session Summary
**Screen**: Shown after ending AI practice session

```
┌─────────────────────────────────┐
│      Session Summary            │
│                                 │
│  Duration: 4:32                 │
│  Topic: Free Chat               │
│                                 │
│  ─────────────────────────────  │
│  Speaking Stats                 │
│  • Words spoken: 127            │
│  • Average sentence: 8 words    │
│  • Speaking time: 65%           │
│                                 │
│  ─────────────────────────────  │
│  Corrections (3)                │
│                                 │
│  ❌ "I go to store"             │
│  ✅ "I went to the store"       │
│  💡 Use past tense for          │
│     completed actions           │
│                                 │
│  ❌ "More better"               │
│  ✅ "Much better" or "Better"   │
│  💡 Don't use "more" with       │
│     comparative adjectives      │
│                                 │
│  ─────────────────────────────  │
│  Vocabulary Used                │
│  shopping, yesterday, store...  │
│                                 │
│  ┌─────────────────────────┐   │
│  │     Practice Again      │   │
│  └─────────────────────────┘   │
│                                 │
│  ┌─────────────────────────┐   │
│  │     Back to Home        │   │
│  └─────────────────────────┘   │
└─────────────────────────────────┘
```

#### Feedback Data Stored
```json
{
  "sessionId": "uuid",
  "duration": 272,
  "mode": "free_chat",
  "wordsSpoken": 127,
  "corrections": [...],
  "vocabularyUsed": ["shopping", "yesterday", ...],
  "speakingTimePercent": 65
}
```

---

### 3.8 Session History

#### AI Sessions List
- **Location**: New section in History tab or dedicated AI History tab
- **Display**:
  - Session date/time
  - Duration
  - Mode (Free Chat / Topic / Scenario)
  - Topic/Scenario name
  - Number of corrections

#### Session Detail View
- Full conversation transcript
- All corrections with explanations
- Vocabulary list
- Option to replay similar session

#### Data Model
```dart
@freezed
class AiSession with _$AiSession {
  const factory AiSession({
    required String id,
    required String odId,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationSeconds,
    required AiSessionMode mode,
    required AiPersona persona,  // Current: always 'emma', future: selectable
    String? topic,
    String? scenario,
    required List<AiMessage> messages,
    required List<Correction> corrections,
    required SessionStats stats,
  }) = _AiSession;
}

enum AiSessionMode { freeChat, topic, scenario }

// Currently only 'emma', more personas planned for near future
enum AiPersona {
  emma,           // Default: Friendly tutor
  // Planned personas:
  // teacher,      // Formal English teacher
  // friend,       // Casual conversation buddy
  // interviewer,  // Job interview practice
  // customerService, // Professional communication
  // travelGuide,  // Travel vocabulary
  // businessPartner, // Business English
}

@freezed
class AiMessage with _$AiMessage {
  const factory AiMessage({
    required String role, // 'user' or 'assistant'
    required String content,
    required DateTime timestamp,
  }) = _AiMessage;
}

@freezed
class Correction with _$Correction {
  const factory Correction({
    required String original,
    required String corrected,
    required String explanation,
  }) = _Correction;
}
```

---

### 3.9 Usage Limits & Cost Management

#### Daily Free Limit
- **Limit**: 5 minutes per day
- **Reset**: Midnight local time
- **Display**: Show remaining time on mode selection screen
- **Enforcement**:
  - Warn user at 1 minute remaining
  - Auto-end session when limit reached
  - Show "Limit Reached" screen with reset countdown

#### Limit Reached Screen
```
┌─────────────────────────────────┐
│                                 │
│     Daily Limit Reached         │
│                                 │
│     You've used your 5 minutes  │
│     of AI practice today.       │
│                                 │
│     Resets in: 14:32:15         │
│                                 │
│     ─────────────────────────   │
│                                 │
│     Want unlimited practice?    │
│     Upgrade to Premium          │
│     (Coming Soon)               │
│                                 │
│  ┌─────────────────────────┐   │
│  │     Back to Home        │   │
│  └─────────────────────────┘   │
└─────────────────────────────────┘
```

#### Cost Estimation
| Component | Cost per Session (5 min) |
|-----------|-------------------------|
| OpenAI Realtime API (text-only) | ~$0.02-0.05 |
| On-device STT | $0.00 |
| On-device TTS | $0.00 |
| **Total** | **~$0.02-0.05** |

**Note**: OpenAI Realtime API pricing (text modality):
- Input: ~$0.60 per 1M tokens
- Output: ~$2.40 per 1M tokens
- Estimated ~20-30 message exchanges in 5 min session

---

## 4. Technical Architecture

### 4.1 Flutter App Components

#### New Packages Required
```yaml
dependencies:
  speech_to_text: ^6.6.0       # On-device STT
  flutter_tts: ^3.8.0          # On-device TTS
  audio_waveforms: ^1.0.5      # Audio visualization
  web_socket_channel: ^2.4.0   # WebSocket for OpenAI Realtime API
```

#### State Management (Riverpod)
```dart
// AI Session Provider
@riverpod
class AiSessionNotifier extends _$AiSessionNotifier {
  @override
  AiSessionState build() => AiSessionState.initial();

  Future<void> startSession(AiSessionMode mode, {String? topic}) async {...}
  Future<void> sendMessage(String text) async {...}
  Future<void> endSession() async {...}
}

// Usage Limit Provider
@riverpod
Future<int> remainingSeconds(RemainingSecondsRef ref) async {
  final api = ref.watch(apiServiceProvider);
  return api.getAiRemainingSeconds();
}
```

#### Screen Flow
```
Home Screen
    │
    ▼
Mode Selection Screen
    │
    ├── Free Chat ──────┐
    ├── Topic Select ───┼──► AI Call Screen ──► Session Summary
    └── Scenario Select─┘
```

### 4.2 Backend API Reference

> **Note**: Full backend implementation details are in the server PRD at `speaking-club-server/prd-milestone-2.md`

#### Endpoints Used by Flutter App

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/ai/session/token` | Get ephemeral key for OpenAI Realtime API |
| POST | `/api/ai/session/end` | End session, save conversation data |
| POST | `/api/ai/session/refresh-token` | Get new ephemeral key for long sessions |
| GET | `/api/ai/sessions` | Get AI session history (paginated) |
| GET | `/api/ai/sessions/:id` | Get specific session details |
| GET | `/api/ai/usage` | Get daily usage stats |

### 4.3 OpenAI Realtime API Integration

#### WebSocket Connection
```dart
// /lib/services/openai_realtime_service.dart

class OpenAIRealtimeService {
  WebSocketChannel? _channel;

  Future<void> connect(String ephemeralKey) async {
    final uri = Uri.parse(
      'wss://api.openai.com/v1/realtime?model=gpt-4o-mini-realtime-preview'
    );

    _channel = WebSocketChannel.connect(uri);

    // Send auth after connection
    _channel!.sink.add(jsonEncode({
      'type': 'session.update',
      'session': {
        'modalities': ['text'],
        'instructions': _systemPrompt,
        'temperature': 0.7,
        'max_response_output_tokens': 150,
      }
    }));

    // Listen for responses
    _channel!.stream.listen(_handleMessage);
  }

  void sendMessage(String text) {
    _channel?.sink.add(jsonEncode({
      'type': 'conversation.item.create',
      'item': {
        'type': 'message',
        'role': 'user',
        'content': [{'type': 'input_text', 'text': text}]
      }
    }));

    _channel?.sink.add(jsonEncode({'type': 'response.create'}));
  }

  void _handleMessage(dynamic message) {
    final data = jsonDecode(message);
    switch (data['type']) {
      case 'response.text.delta':
        // Stream text to TTS
        break;
      case 'response.text.done':
        // Response complete
        break;
      case 'error':
        // Handle error
        break;
    }
  }
}
```

#### Message Flow
```
1. App requests ephemeral key from backend
2. Backend generates key via OpenAI REST API
3. App connects to OpenAI WebSocket with ephemeral key
4. App sends session.update with system prompt
5. User speaks → STT → App sends conversation.item.create
6. App sends response.create to trigger AI
7. OpenAI streams response.text.delta events
8. App accumulates text → TTS speaks when complete
9. Repeat 5-8 for conversation
10. App disconnects, backend saves session to DB
```

---

## 5. User Flows

### 5.1 Start AI Practice Session
```
1. User on Home Screen
   ↓
2. Taps "Practice with AI" button
   ↓
3. Mode Selection Screen
   - Shows remaining daily time
   - Three mode options
   ↓
4. User selects mode
   ↓
5a. Free Chat → Proceed to step 6
5b. Topic → Select topic category → Select specific topic → Step 6
5c. Scenario → Select scenario → View instructions → Step 6
   ↓
6. App requests ephemeral key from backend
   - Backend generates key via OpenAI API
   - Returns ephemeral key + session ID
   ↓
7. App connects to OpenAI Realtime API (WebSocket)
   - Uses ephemeral key for auth
   - Sends session config with system prompt
   ↓
8. AI Call Screen
   - App starts listening
   - AI greets user based on mode
   ↓
9. Conversation loop:
   - User speaks → On-device STT → WebSocket to OpenAI → Response → On-device TTS
   ↓
10. User taps "End" or limit reached
   ↓
11. App disconnects WebSocket, sends session data to backend
   ↓
12. Session Summary Screen
   - Duration, stats, corrections
   ↓
13. User taps "Back to Home" or "Practice Again"
```

### 5.2 During AI Conversation
```
1. AI finishes speaking (TTS complete)
   - AI message fully visible in transcript
   ↓
2. App auto-starts listening (microphone active)
   - Status: "Listening..."
   - New user message bubble appears in transcript
   ↓
3. User speaks
   - Real-time transcription shown in user bubble (on-device STT)
   - Text updates live as words are recognized
   - Shows "(speaking...)" indicator
   - Silence detection (3 seconds)
   ↓
4. User stops speaking or 3s silence
   - User message finalized in transcript
   ↓
5. Transcription sent directly to OpenAI via WebSocket
   - conversation.item.create + response.create
   ↓
6. Show "AI is thinking..." indicator
   - New AI message bubble appears with typing indicator
   ↓
7. Receive AI response (streaming via WebSocket)
   - AI text streams into transcript in real-time
   - Each text delta appended to AI bubble
   ↓
8. TTS speaks the response
   - AI bubble highlighted while speaking
   - Show waveform animation
   ↓
9. Return to step 1
```

### 5.3 Handle Limit Reached
```
1. User in active session
   ↓
2. 1 minute remaining
   - Show warning toast: "1 minute remaining"
   ↓
3. Time reaches 0
   ↓
4. Show "Session ending..." message
   ↓
5. AI says farewell message
   ↓
6. Navigate to Session Summary
   ↓
7. Show "Limit Reached" banner on summary
```

---

## 6. UI/UX Requirements

### 6.1 Design Consistency
- Follow existing Material Design 3 theme from Milestone 1
- Use same color palette, typography, spacing
- Consistent iconography and button styles

### 6.2 New Design Elements

#### AI Practice Button
- **Style**: Large floating button or card on home screen
- **Color**: Secondary accent color to differentiate from "Find Match"
- **Icon**: Robot, graduation cap, or speech bubble with AI indicator

#### Audio Waveform
- **Style**: Smooth, animated bars representing audio levels
- **Colors**:
  - AI speaking: Primary color (teal)
  - User speaking: Secondary color (orange)
  - Idle: Gray

#### Mode Selection Cards
- **Layout**: Grid of 3 cards (or 2+1 layout)
- **Content**: Icon, title, brief description
- **Interaction**: Tap to select, subtle animation

### 6.3 Accessibility
- **VoiceOver/TalkBack**: Full support for screen readers
- **High contrast**: Ensure text readable on waveform background
- **Touch targets**: Minimum 48x48dp for all buttons

---

## 7. Error Handling

### 7.1 Speech Recognition Errors
| Error | User Message | Action |
|-------|-------------|--------|
| No speech detected | "I didn't hear anything. Please try again." | Auto-restart listening |
| Recognition failed | "Sorry, I couldn't understand. Please repeat." | Show retry button |
| Microphone denied | "Microphone access needed for voice practice." | Link to settings |

### 7.2 Network Errors
| Error | User Message | Action |
|-------|-------------|--------|
| API timeout | "Taking longer than expected..." | Auto-retry once |
| Connection lost | "Connection lost. Reconnecting..." | Auto-reconnect |
| Server error | "Something went wrong. Please try again." | Show retry button |

### 7.3 TTS Errors
| Error | User Message | Action |
|-------|-------------|--------|
| TTS initialization failed | Show response as text | Fallback to text display |
| Speech interrupted | None | Allow, continue on next message |

---

## 8. Analytics & Monitoring

### 8.1 Events to Track
- `ai_session_started` - mode, topic/scenario
- `ai_session_ended` - duration, messages_count, was_limit_reached
- `ai_message_sent` - message_length, response_time
- `ai_correction_given` - correction_type
- `ai_limit_reached` - time_of_day

### 8.2 Metrics Dashboard
- Daily/weekly AI sessions
- Average session duration
- Most popular topics/scenarios
- API cost per user
- Error rates

---

## 9. Security & Privacy

### 9.1 Data Handling
- **Ephemeral keys**: Short-lived tokens (~60s) obtained from backend
- **Direct connection**: App connects directly to OpenAI (no message proxying)
- **Session data**: Sent to backend only when session ends

### 9.2 Content Moderation
- OpenAI's built-in content filtering (applies to Realtime API)
- Daily usage limits enforced by backend

---

## 10. Testing Strategy

### 10.1 Unit Tests
- STT initialization and error handling
- TTS playback controls
- Usage limit calculations
- Session state management

### 10.2 Integration Tests
- Full conversation flow (STT → API → TTS)
- Session history save/load
- Usage limit enforcement

### 10.3 Manual Testing
- Test on various accents (US, UK, Indian English)
- Network conditions (WiFi, 4G, poor connection)
- Background/foreground transitions
- Long sessions (approaching limit)

---

## 11. Implementation Phases

### Phase 1: Core Infrastructure
- [ ] Add `speech_to_text`, `flutter_tts`, and `web_socket_channel` packages
- [ ] Create OpenAI Realtime API service (WebSocket connection)
- [ ] Create backend API service for token/session management
- [ ] Implement Riverpod providers for AI session state

### Phase 2: Basic Conversation
- [ ] Build AI call screen UI with waveform and transcript
- [ ] Implement STT → WebSocket → TTS flow
- [ ] Add mode selection screen
- [ ] Implement free chat mode

### Phase 3: Topics & Scenarios
- [ ] Add topic selection UI and logic
- [ ] Add scenario selection with instructions
- [ ] Implement mode-specific UI flows

### Phase 4: Feedback System
- [ ] Parse corrections from AI responses
- [ ] Build session summary screen
- [ ] Implement stats calculation (words spoken, speaking time)
- [ ] Send session data to backend on end

### Phase 5: Usage Limits & History
- [ ] Display remaining daily time from backend
- [ ] Add limit warning and enforcement in UI
- [ ] Build AI session history list
- [ ] Add session detail view

### Phase 6: Polish & Testing
- [ ] Error handling and edge cases
- [ ] Performance optimization
- [ ] Comprehensive testing
- [ ] UI polish and animations

---

## 12. Dependencies & Risks

### Dependencies
- OpenAI Realtime API availability and pricing stability
- On-device STT accuracy for non-native speakers
- On-device TTS voice quality
- WebSocket connection stability

### Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| High API costs | Medium | Daily limits, usage monitoring |
| Poor STT accuracy | High | Support multiple English variants, allow text input fallback |
| OpenAI rate limits | Medium | Queue ephemeral key requests, implement retry logic |
| User privacy concerns | Medium | Clear privacy policy, option to delete history |
| Ephemeral key expiry mid-session | Medium | Auto-refresh key before expiry, graceful reconnection |
| WebSocket disconnection | Medium | Auto-reconnect with new ephemeral key, preserve conversation state |

---

## 13. Future Enhancements

### Near Future (Milestone 2.x)
1. **Multiple AI Personas**: Teacher, Friend, Interviewer, Customer Service, etc.
   - Selectable before starting session
   - Each with unique personality and system prompt
   - Already architected for easy addition
2. **Difficulty levels**: Beginner, Intermediate, Advanced modes
3. **Premium tier**: Unlimited daily practice time

### Later Enhancements
1. **Pronunciation feedback**: Analyze and score pronunciation
2. **Progress tracking**: Long-term improvement metrics
3. **Vocabulary builder**: Save and review new words
4. **Voice customization**: Different AI voices/accents (cloud TTS)
5. **Offline mode**: Basic practice with on-device LLM
6. **Conversation sharing**: Share interesting conversations

---

## Appendix

### A. System Prompts by Mode

#### Free Chat
```
You are Emma, a friendly English tutor having a casual conversation.
Keep responses brief (1-3 sentences). Ask follow-up questions.
Gently correct grammar mistakes naturally in your responses.
```

#### Topic: Travel
```
You are Emma, an English tutor. You're discussing travel with your student.
Ask about their travel experiences, dream destinations, travel tips.
Keep responses brief. Correct mistakes naturally.
```

#### Scenario: Job Interview
```
You are a hiring manager conducting a job interview.
Ask typical interview questions one at a time.
Respond professionally to answers.
At the end, provide feedback on their interview English.
```

### B. Topic & Scenario Configurations

Topics and scenarios are configured on the server side. The Flutter app receives the appropriate system prompt when requesting an ephemeral key.

---

**Document End**

---

**Next Steps**:
1. Review and approve this PRD
2. Add STT/TTS/WebSocket packages to Flutter project
3. Build AI practice screens and OpenAI WebSocket integration
4. Design team: Create AI-specific UI components and animations
5. Coordinate with backend team (see `speaking-club-server/prd-milestone-2.md`)
