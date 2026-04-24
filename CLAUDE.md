# Speaking Club — Flutter Mobile App

Real-time voice/video calling app for language learners. Connects to `speaking-club-server` via REST (Dio) and Socket.io for WebRTC signaling.

## Tech Stack

- **Flutter** / Dart SDK ^3.10.3
- **State**: Riverpod (flutter_riverpod ^3, riverpod_annotation ^4) — code-gen style
- **Navigation**: go_router ^17
- **HTTP**: Dio ^5.4
- **Real-time**: socket_io_client ^3.1
- **WebRTC**: flutter_webrtc ^1.3
- **Images**: cached_network_image

## Commands

```bash
flutter pub get                                              # Install deps
flutter run                                                 # Run dev
flutter build apk --release                                 # Android build
flutter build ios --release                                 # iOS build
dart run build_runner build --delete-conflicting-outputs    # Regen providers
flutter test                                                # Tests
flutter analyze                                             # Static analysis
```

## Architecture

Feature-first structure under `lib/`:

```
lib/
├── core/
│   ├── config/        # App config, environment constants
│   ├── di/            # Dependency injection / provider overrides
│   ├── router/        # GoRouter setup and route definitions
│   └── theme/         # App theme, colors, text styles
├── features/
│   ├── auth/          # Login, registration, token management
│   ├── call/          # WebRTC session, call screen, controls
│   ├── matchmaking/   # Queue management, match status
│   ├── ai-practice/   # AI English practice session
│   └── history/       # Call history
├── shared/
│   ├── widgets/       # Reusable UI components
│   └── utils/         # Helpers, extensions
└── main.dart
```

Each feature folder:
```
{feature}/
├── data/
│   ├── datasources/   # Remote (API) and local (cache) data sources
│   ├── models/        # JSON-serializable data models
│   └── repositories/  # Repository implementations
├── domain/
│   └── entities/      # Pure domain entities
└── presentation/
    ├── screens/        # Full-page widgets
    ├── widgets/        # Feature-specific components
    └── providers/      # Riverpod providers/notifiers
```

## Riverpod Conventions

- Use `@riverpod` annotation — always code-gen, never manual `Provider()`
- `AsyncNotifier` for async state (API calls, streams)
- `Notifier` for sync state
- Run `dart run build_runner build` after any provider change
- Provider files end in `_provider.dart`, generated files in `*.g.dart`

## Navigation (go_router)

- All routes defined in `core/router/`
- Use `context.go()` / `context.push()` — never `Navigator.push()`
- Route constants in a single `AppRoutes` class to avoid string duplication

## WebRTC & Socket.io

- Socket.io singleton initialized in a Riverpod provider, connected on login
- Socket event names **must match** `speaking-club-server/src/constants/socket-events.js` exactly
- WebRTC flow: receive `matchmaking:matched` → navigate to call screen → exchange offer/answer/ICE via socket
- flutter_webrtc handles both mobile platforms; test on both Android and iOS emulators

## API Integration

- Base URL from app config (never hardcoded)
- Dio interceptor attaches `Authorization: Bearer <token>` to all requests
- Refresh token flow handled in the interceptor — transparent to feature code

## Key Patterns

- Never put business logic inside widgets — it belongs in Riverpod notifiers
- Never use `BuildContext` outside of widgets — pass data down, not context up
- Use `AsyncValue` pattern for loading/error/data states in UI
- Prefer `ref.watch` in widgets, `ref.read` in callbacks/handlers

## Environment

Config values (API URL, socket URL) come from compile-time constants or a config file — not `String.fromEnvironment` inline. Document any new config keys in `core/config/`.
