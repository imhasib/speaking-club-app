# Speaking Club - Milestone 2: AI English Practice - Development Progress

**Last Updated:** February 10, 2026
**Milestone Started:** February 10, 2026

## Overview

This document tracks the implementation progress of Milestone 2: AI English Practice feature, which allows users to have voice conversations with an AI tutor using on-device STT/TTS and OpenAI Realtime API.

---

## Phase 1: Core Infrastructure ✅ COMPLETE

### Task: Add Required Packages ✅
- **Status:** Completed
- **Files Updated:**
  - `pubspec.yaml`
- **Packages Added:**
  - `speech_to_text: ^6.6.0` - On-device STT
  - `flutter_tts: ^3.8.0` - On-device TTS
  - `audio_waveforms: ^1.0.5` - Audio visualization
  - `web_socket_channel: ^2.4.0` - WebSocket for OpenAI Realtime API

### Task: Create OpenAI Realtime API Service ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/data/openai_realtime_service.dart`
- **Features:**
  - WebSocket connection to `wss://api.openai.com/v1/realtime`
  - Ephemeral key authentication
  - Session configuration (modalities, instructions, temperature)
  - Message send/receive handling (text deltas, text complete)
  - Connection state management (disconnected, connecting, connected, error)
  - Callbacks for connection state, text delta, text complete, errors

### Task: Create Backend API Service for Token/Session Management ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/data/ai_session_repository.dart`
- **Endpoints Implemented:**
  - `POST /api/ai/session/token` - Get ephemeral key
  - `POST /api/ai/session/end` - End session, save data
  - `POST /api/ai/session/refresh-token` - Refresh key for long sessions
  - `GET /api/ai/topics` - Get topic categories
  - `GET /api/ai/scenarios` - Get scenarios
  - `GET /api/ai/usage` - Get daily usage stats

### Task: Implement Riverpod Providers for AI Session State ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/domain/ai_practice_state.dart`
  - `lib/features/ai_practice/domain/ai_practice_state.freezed.dart`
  - `lib/features/ai_practice/presentation/providers/ai_practice_provider.dart`
- **Features:**
  - `AiPracticeNotifier` - Session state management
  - `ModeSelectionNotifier` - Mode selection state
  - OpenAI service provider
  - Speech service provider
  - TTS service provider
  - Session phases (initializing, requestingToken, connecting, ready, listening, thinking, aiSpeaking, ending, error)
  - Duration timer with 1-second updates
  - Ephemeral key refresh before expiry
  - Time limit enforcement with 1-minute warning

### Task: Create AI Session Data Model ✅
- **Status:** Completed
- **Files Created:**
  - `lib/shared/models/ai_session.dart`
  - `lib/shared/models/ai_session.freezed.dart`
  - `lib/shared/models/ai_session.g.dart`
- **Models:**
  - `AiSession` - Session with messages, corrections, stats
  - `AiSessionMode` - freeChat, topic, scenario
  - `AiPersona` - emma (default)
  - `AiMessage` - role, content, timestamp
  - `Correction` - original, corrected, explanation
  - `SessionStats` - wordsSpoken, averageSentenceLength, speakingTimePercent, vocabularyUsed
  - `EphemeralKeyResponse` - ephemeralKey, expiresAt, sessionId, remainingSeconds
  - `AiUsageInfo` - usedSeconds, remainingSeconds, dailyLimitSeconds, resetsAt
  - `TopicCategory` - id, name, icon, topics
  - `Topic` - id, name, description
  - `Scenario` - id, name, aiRole, userRole, description, instructions

---

## Phase 2: Basic Conversation ✅ COMPLETE

### Task: Build AI Call Screen UI ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/presentation/screens/ai_session_screen.dart`
  - `lib/features/ai_practice/presentation/widgets/audio_waveform.dart`
  - `lib/features/ai_practice/presentation/widgets/conversation_transcript.dart`
- **Features:**
  - Audio waveform visualization (color changes for user/AI speaking)
  - Live conversation transcript with message bubbles
  - Header with mode display, elapsed timer, remaining time
  - Status indicator (Listening, Thinking, AI Speaking, Ready)
  - Controls (Mute toggle, Main mic button, End session)
  - End session confirmation dialog
  - PopScope handling to prevent accidental exits
  - Error snackbar display

### Task: Implement STT → WebSocket → TTS Flow ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/data/speech_service.dart`
  - `lib/features/ai_practice/data/tts_service.dart`
- **Features:**
  - On-device speech recognition with callbacks
  - Real-time transcription display (currentUserText)
  - Automatic send when speech recognized as final
  - Text sent to OpenAI via WebSocket
  - Response streamed via text deltas
  - TTS speaks complete response
  - Listening auto-restarts after AI finishes speaking

### Task: Add Mode Selection Screen ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/presentation/screens/mode_selection_screen.dart`
- **Features:**
  - Usage info card with progress bar and remaining time
  - Three mode cards (Free Chat, Topic Discussion, Scenario Roleplay)
  - Staggered animation on cards
  - Cards disabled when no time remaining
  - Navigation to topic/scenario pickers or direct to session

### Task: Implement Free Chat Mode ✅
- **Status:** Completed
- **Features:**
  - System prompt for Emma tutor
  - Open-ended conversation
  - Natural flow with follow-up questions
  - Word counting and stats tracking

---

## Phase 3: Topics & Scenarios ✅ COMPLETE

### Task: Add Topic Selection UI ✅
- **Status:** Completed
- **Files Updated:**
  - `lib/features/ai_practice/presentation/screens/mode_selection_screen.dart` (TopicPickerSheet)
- **Features:**
  - DraggableScrollableSheet bottom sheet
  - Expandable topic categories with icons
  - Topic list with descriptions
  - Selection triggers session start with topic context

### Task: Add Scenario Selection with Instructions ✅
- **Status:** Completed
- **Files Updated:**
  - `lib/features/ai_practice/presentation/screens/mode_selection_screen.dart` (ScenarioPickerSheet)
- **Features:**
  - DraggableScrollableSheet bottom sheet
  - Scenario tiles with name and description
  - Role chips (AI role, User role)
  - Selection triggers session start with scenario context

### Task: Implement Mode-Specific UI Flows ✅
- **Status:** Completed
- **Features:**
  - Context-aware session start (mode, topic, scenario passed to provider)
  - Mode indicator on call screen header
  - Topic/scenario sent to backend for appropriate system prompts

---

## Phase 4: Feedback System 🔄 IN PROGRESS

### Task: Parse Corrections from AI Responses
- **Status:** Pending
- **Requirements:**
  - Detect grammar corrections in AI responses
  - Extract original and corrected text
  - Generate explanations
- **Notes:** Currently using placeholder data in summary screen

### Task: Build Session Summary Screen ✅
- **Status:** Completed
- **Files Created:**
  - `lib/features/ai_practice/presentation/screens/ai_summary_screen.dart`
- **Features:**
  - Duration display card
  - Speaking stats card (words spoken, avg sentence length, speaking time %)
  - Corrections card with original/corrected/explanation display
  - "Practice Again" button (navigates to mode selection)
  - "Back to Home" button
- **Notes:** Currently using placeholder data for stats/corrections

### Task: Implement Stats Calculation ✅
- **Status:** Completed
- **Implementation in:** `ai_practice_provider.dart`
- **Features:**
  - Word count tracking during session
  - Average sentence length calculation
  - Speaking time percentage calculation
  - Vocabulary extraction (unique words from user messages)

### Task: Send Session Data to Backend on End ✅
- **Status:** Completed
- **Implementation in:** `ai_practice_provider.dart` (endSession method)
- **Features:**
  - Collect all messages
  - Gather corrections
  - Calculate final stats
  - POST to `/api/ai/session/end` via EndSessionRequest

---

## Phase 5: Usage Limits & History 🔄 PARTIAL

### Task: Display Remaining Daily Time ✅
- **Status:** Completed
- **Implementation in:**
  - `mode_selection_screen.dart` - Usage card with progress bar
  - `ai_session_screen.dart` - Remaining time badge in header
- **Features:**
  - Fetch from `/api/ai/usage`
  - Color-coded progress (red when low)
  - Time formatted as "M:SS"

### Task: Add Limit Warning and Enforcement ✅
- **Status:** Completed
- **Implementation in:** `ai_practice_provider.dart`
- **Features:**
  - Warning at 1 minute remaining (error snackbar)
  - Auto-end session when limit reaches 0
  - Mode cards disabled when no time remaining

### Task: Build AI Session History List
- **Status:** Pending
- **Files to Create:**
  - `lib/features/ai_practice/presentation/screens/ai_history_screen.dart`
  - `lib/features/ai_practice/presentation/widgets/ai_session_item.dart`
- **Requirements:**
  - Paginated list from `/api/ai/sessions`
  - Session date/time, duration, mode
  - Number of corrections indicator

### Task: Add Session Detail View
- **Status:** Pending
- **Files to Create:**
  - `lib/features/ai_practice/presentation/screens/ai_session_detail_screen.dart`
- **Requirements:**
  - Full conversation transcript
  - All corrections with explanations
  - Vocabulary list
  - "Practice Again" option

---

## Phase 6: Polish & Testing ⏳ PENDING

### Task: Error Handling and Edge Cases
- **Status:** Pending
- **Requirements:**
  - STT errors (no speech, recognition failed, permission denied)
  - Network errors (timeout, connection lost, server error)
  - TTS errors (initialization failed, interrupted)
  - WebSocket disconnection handling
  - Ephemeral key refresh on expiry

### Task: Performance Optimization
- **Status:** Pending
- **Requirements:**
  - Efficient WebSocket message handling
  - Smooth audio waveform rendering
  - Memory management for long sessions

### Task: Comprehensive Testing
- **Status:** Pending
- **Requirements:**
  - Unit tests for services
  - Widget tests for UI components
  - Integration tests for conversation flow

### Task: UI Polish and Animations
- **Status:** Pending
- **Requirements:**
  - Smooth transitions between screens
  - Audio waveform animations
  - Speaking/listening state transitions
  - Loading states

---

## Project Structure (AI Practice Feature)

```
lib/features/ai_practice/
├── data/
│   ├── ai_session_repository.dart       ✅
│   ├── openai_realtime_service.dart     ✅
│   ├── speech_service.dart              ✅
│   └── tts_service.dart                 ✅
├── domain/
│   ├── ai_practice_state.dart           ✅
│   └── ai_practice_state.freezed.dart   ✅
├── presentation/
│   ├── providers/
│   │   └── ai_practice_provider.dart    ✅
│   ├── screens/
│   │   ├── ai_session_screen.dart       ✅
│   │   ├── ai_summary_screen.dart       ✅
│   │   ├── mode_selection_screen.dart   ✅
│   │   ├── ai_history_screen.dart       ⏳
│   │   └── ai_session_detail_screen.dart ⏳
│   └── widgets/
│       ├── audio_waveform.dart          ✅
│       ├── conversation_transcript.dart ✅
│       └── ai_session_item.dart         ⏳
└── ai_practice.dart                     ✅
```

---

## Dependencies Added

```yaml
# AI Practice (Milestone 2)
speech_to_text: ^6.6.0        # On-device STT
flutter_tts: ^3.8.0           # On-device TTS
audio_waveforms: ^1.0.5       # Audio visualization
web_socket_channel: ^2.4.0    # WebSocket for OpenAI Realtime API
```

---

## API Endpoints (Backend)

| Method | Endpoint | Status |
|--------|----------|--------|
| POST | `/api/ai/session/token` | ✅ Implemented |
| POST | `/api/ai/session/end` | ✅ Implemented |
| POST | `/api/ai/session/refresh-token` | ✅ Implemented |
| GET | `/api/ai/topics` | ✅ Implemented |
| GET | `/api/ai/scenarios` | ✅ Implemented |
| GET | `/api/ai/usage` | ✅ Implemented |
| GET | `/api/ai/sessions` | ⏳ Pending |
| GET | `/api/ai/sessions/:id` | ⏳ Pending |

---

## Progress Summary

| Phase | Tasks | Completed | Status |
|-------|-------|-----------|--------|
| Phase 1: Core Infrastructure | 5 | 5 | ✅ Complete |
| Phase 2: Basic Conversation | 4 | 4 | ✅ Complete |
| Phase 3: Topics & Scenarios | 3 | 3 | ✅ Complete |
| Phase 4: Feedback System | 4 | 3 | 🔄 In Progress (75%) |
| Phase 5: Usage Limits & History | 4 | 2 | 🔄 Partial (50%) |
| Phase 6: Polish & Testing | 4 | 0 | ⏳ Pending |
| **Total** | **24** | **17** | **71%** |

---

## Remaining Work

### High Priority
1. **Corrections Parsing** - Parse grammar corrections from AI responses
2. **Wire Summary Screen** - Connect summary screen to actual session data (not placeholders)
3. **AI Session History** - Build history list and detail screens

### Medium Priority
4. **Error Handling** - Comprehensive error handling for all edge cases
5. **Performance Optimization** - Smooth animations and memory management

### Lower Priority
6. **Testing** - Unit tests, widget tests, integration tests
7. **UI Polish** - Final animations and transitions

---

## Notes

- Backend PRD: `speaking-club-server/prd-milestone-2.md`
- Flutter PRD: `prd-milestone-2.md`
- Daily free limit: 5 minutes per user
- Ephemeral keys expire in ~60 seconds (auto-refresh implemented)
- On-device STT/TTS for cost efficiency
- Direct WebSocket connection to OpenAI (no message proxying)
