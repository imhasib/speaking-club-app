import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/features/ai_practice/data/openai_realtime_service.dart';
import 'package:Speaking_club/shared/models/ai_session.dart';

import '../helpers/fake_web_socket_channel.dart';

void main() {
  late FakeWebSocketChannel fakeChannel;
  late OpenAIRealtimeService service;
  final List<OpenAIConnectionState> connectionStates = [];
  final List<String> textDeltas = [];
  final List<String> completedTexts = [];
  final List<String> errors = [];

  setUp(() {
    fakeChannel = FakeWebSocketChannel();
    service = OpenAIRealtimeService(
      channelFactory: (uri, protocols) => fakeChannel,
    );

    connectionStates.clear();
    textDeltas.clear();
    completedTexts.clear();
    errors.clear();

    service.onConnectionStateChange = connectionStates.add;
    service.onTextDelta = textDeltas.add;
    service.onTextComplete = completedTexts.add;
    service.onError = errors.add;
  });

  tearDown(() => service.dispose());

  // ─── Connection lifecycle ─────────────────────────────────────────────────

  group('connect()', () {
    test('transitions through connecting → connected', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      expect(
        connectionStates,
        containsAllInOrder([
          OpenAIConnectionState.connecting,
          OpenAIConnectionState.connected,
        ]),
      );
    });

    test('is idempotent when already connected', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      connectionStates.clear();

      // Second connect call should be a no-op.
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      expect(connectionStates, isEmpty);
    });

    test('sends session.update BEFORE signalling connected', () async {
      // The `connected` state change is the last thing connect() does, so
      // everything that fires synchronously in the callback (greeting trigger)
      // must see session.update already in the sent list.
      final List<String> sentAtConnectedTime = [];

      service.onConnectionStateChange = (s) {
        if (s == OpenAIConnectionState.connected) {
          // Capture whatever the service has already sent to the channel.
          sentAtConnectedTime.addAll(fakeChannel.sent);
        }
        connectionStates.add(s);
      };

      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      expect(sentAtConnectedTime, isNotEmpty);
      final firstEventType =
          (jsonDecode(sentAtConnectedTime.first) as Map<String, dynamic>)['type'];
      expect(firstEventType, 'session.update',
          reason: 'session.update must be sent before the connected callback fires '
              'so that triggerInitialGreeting sends response.create AFTER session config');
    });

    test('emits error state when channel.ready throws', () async {
      fakeChannel = FakeWebSocketChannel(readyImmediately: false);
      // We need a channel whose ready future throws.
      final throwingChannel = _ThrowingReadyChannel();
      service = OpenAIRealtimeService(
        channelFactory: (_, _) => throwingChannel,
      );
      service.onConnectionStateChange = connectionStates.add;
      service.onError = errors.add;

      await service.connect(
        ephemeralKey: 'bad-key',
        mode: AiSessionMode.freeChat,
      );

      expect(connectionStates.last, OpenAIConnectionState.error);
      expect(errors, isNotEmpty);
    });
  });

  group('disconnect()', () {
    test('emits disconnected and releases channel', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      connectionStates.clear();

      await service.disconnect();

      expect(connectionStates, contains(OpenAIConnectionState.disconnected));
      expect(service.isConnected, isFalse);
    });
  });

  // ─── Message sending ──────────────────────────────────────────────────────

  group('triggerInitialGreeting()', () {
    test('sends response.create event', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      final countBefore = fakeChannel.sent.length;

      service.triggerInitialGreeting();

      final newEvents = fakeChannel.sentEvents.skip(countBefore).toList();
      expect(newEvents.any((e) => e['type'] == 'response.create'), isTrue);
    });

    test('does nothing when not connected', () {
      // Should not throw and should not enqueue any event.
      expect(() => service.triggerInitialGreeting(), returnsNormally);
      expect(fakeChannel.sent, isEmpty);
    });
  });

  group('sendMessage()', () {
    test('sends conversation.item.create then response.create', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      final before = fakeChannel.sent.length;

      service.sendMessage('Hello!');

      final newTypes = fakeChannel.sentEvents
          .skip(before)
          .map((e) => e['type'] as String)
          .toList();

      expect(newTypes, containsAllInOrder([
        'conversation.item.create',
        'response.create',
      ]));
    });

    test('embeds user text in the conversation item', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      final before = fakeChannel.sent.length;

      service.sendMessage('How are you?');

      final items = fakeChannel.sentEvents
          .skip(before)
          .where((e) => e['type'] == 'conversation.item.create')
          .toList();
      expect(items, hasLength(1));
      final content = (items.first['item']['content'] as List).first;
      expect(content['text'], 'How are you?');
    });

    test('does nothing when not connected', () async {
      service.sendMessage('should be ignored');
      expect(fakeChannel.sent, isEmpty);
    });
  });

  // ─── Incoming events ──────────────────────────────────────────────────────

  group('incoming response.text.delta', () {
    test('forwards delta to onTextDelta callback', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      fakeChannel.addServerEvent({
        'type': 'response.text.delta',
        'delta': 'Hello',
      });
      await Future.microtask(() {});

      expect(textDeltas, contains('Hello'));
    });

    test('buffers delta when response begins with correction marker', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      // Simulate a response starting with an unclosed correction marker.
      fakeChannel.addServerEvent({
        'type': 'response.created',
      });
      fakeChannel.addServerEvent({
        'type': 'response.text.delta',
        'delta': '[CORRECTION: "go" → "went" | past tense',
      });
      await Future.microtask(() {});

      // Should NOT forward the marker text as a delta.
      expect(textDeltas, isEmpty);
    });
  });

  group('incoming response.text.done', () {
    test('fires onTextComplete with full accumulated text', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      fakeChannel.addServerEvent({
        'type': 'response.created',
      });
      fakeChannel.addServerEvent({
        'type': 'response.text.delta',
        'delta': 'Nice ',
      });
      fakeChannel.addServerEvent({
        'type': 'response.text.delta',
        'delta': 'to meet you!',
      });
      fakeChannel.addServerEvent({
        'type': 'response.text.done',
      });
      await Future.microtask(() {});

      expect(completedTexts, contains('Nice to meet you!'));
    });

    test('strips correction marker before calling onTextComplete', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      fakeChannel.addServerEvent({'type': 'response.created'});
      fakeChannel.addServerEvent({
        'type': 'response.text.delta',
        'delta': '[CORRECTION: "I go" → "I went" | past tense]\nGood effort!',
      });
      fakeChannel.addServerEvent({'type': 'response.text.done'});
      await Future.microtask(() {});

      expect(completedTexts, hasLength(1));
      expect(completedTexts.first, 'Good effort!');
      expect(completedTexts.first, isNot(contains('[CORRECTION:')));
    });
  });

  group('incoming response.done with failed status', () {
    test('emits error when response status is failed', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      fakeChannel.addServerEvent({
        'type': 'response.done',
        'response': {
          'status': 'failed',
          'status_details': {
            'error': {'message': 'Rate limit exceeded'},
          },
        },
      });
      await Future.microtask(() {});

      expect(errors, contains('Rate limit exceeded'));
    });
  });

  group('incoming error event', () {
    test('forwards error message to onError callback', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      fakeChannel.addServerEvent({
        'type': 'error',
        'error': {'message': 'Authentication failed'},
      });
      await Future.microtask(() {});

      expect(errors, contains('Authentication failed'));
    });
  });

  group('server closes connection', () {
    test('emits disconnected state', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );
      connectionStates.clear();

      fakeChannel.closeFromServer();
      await Future.microtask(() {});

      expect(connectionStates, contains(OpenAIConnectionState.disconnected));
    });
  });

  // ─── Session configuration ────────────────────────────────────────────────

  group('session.update content', () {
    test('includes system instructions', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.topic,
        topic: 'Travel',
      );

      final sessionUpdate = fakeChannel.sentEvents
          .firstWhere((e) => e['type'] == 'session.update');
      final instructions =
          sessionUpdate['session']['instructions'] as String;

      expect(instructions, contains('Travel'));
    });

    test('sets modalities to text only', () async {
      await service.connect(
        ephemeralKey: 'test-key',
        mode: AiSessionMode.freeChat,
      );

      final sessionUpdate = fakeChannel.sentEvents
          .firstWhere((e) => e['type'] == 'session.update');
      expect(sessionUpdate['session']['modalities'], ['text']);
    });
  });
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _ThrowingReadyChannel extends FakeWebSocketChannel {
  _ThrowingReadyChannel() : super(readyImmediately: false);

  @override
  Future<void> get ready => Future.error(Exception('Connection refused'));
}
