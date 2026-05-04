import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:Speaking_club/features/ai_practice/data/ai_session_repository.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late AiSessionRepository repo;

  setUp(() {
    // Dio is injected but never called in these parsing-only tests.
    repo = AiSessionRepository(dio: _MockDio());
  });

  group('EphemeralKeyResponse parsing', () {
    test('succeeds with a valid data payload', () {
      final response = repo.parseEphemeralKeyResponseForTest({
        'data': {
          'ephemeralKey': 'ek-abc123',
          'sessionId': 'sess-999',
          'remainingSeconds': 300,
          'expiresAt': DateTime.now().toUtc().toIso8601String(),
        },
      });

      expect(response.ephemeralKey, 'ek-abc123');
      expect(response.sessionId, 'sess-999');
      expect(response.remainingSeconds, 300);
    });

    test('throws FormatException when "data" key is absent', () {
      expect(
        () => repo.parseEphemeralKeyResponseForTest({'status': 'ok'}),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('data'),
        )),
      );
    });

    test('throws FormatException when ephemeralKey is missing', () {
      expect(
        () => repo.parseEphemeralKeyResponseForTest({
          'data': {
            'sessionId': 'sess-1',
            'remainingSeconds': 300,
            'expiresAt': DateTime.now().toUtc().toIso8601String(),
          },
        }),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('ephemeralKey'),
        )),
      );
    });

    test('throws FormatException when sessionId is missing and no fallback',
        () {
      expect(
        () => repo.parseEphemeralKeyResponseForTest({
          'data': {
            'ephemeralKey': 'ek-abc',
            'remainingSeconds': 300,
            'expiresAt': DateTime.now().toUtc().toIso8601String(),
          },
        }),
        throwsA(isA<FormatException>().having(
          (e) => e.message,
          'message',
          contains('sessionId'),
        )),
      );
    });

    test('uses fallbackSessionId when sessionId is absent (refresh endpoint)',
        () {
      final response = repo.parseEphemeralKeyResponseForTest(
        {
          'data': {
            'ephemeralKey': 'ek-fresh',
            'remainingSeconds': 250,
            'expiresAt': DateTime.now().toUtc().toIso8601String(),
          },
        },
        fallbackSessionId: 'sess-fallback',
      );

      expect(response.sessionId, 'sess-fallback');
      expect(response.ephemeralKey, 'ek-fresh');
    });

    test('throws FormatException when ephemeralKey is not a String', () {
      expect(
        () => repo.parseEphemeralKeyResponseForTest({
          'data': {
            'ephemeralKey': 12345, // wrong type
            'sessionId': 'sess-1',
            'remainingSeconds': 300,
            'expiresAt': DateTime.now().toUtc().toIso8601String(),
          },
        }),
        throwsA(isA<FormatException>()),
      );
    });

    test('throws FormatException when data is not a Map', () {
      expect(
        () => repo.parseEphemeralKeyResponseForTest({'data': 'unexpected string'}),
        throwsA(isA<FormatException>()),
      );
    });

    test('preserves expiresAt timestamp', () {
      final expiry = DateTime(2026, 6, 1, 12, 0, 0).toUtc();
      final response = repo.parseEphemeralKeyResponseForTest({
        'data': {
          'ephemeralKey': 'ek-x',
          'sessionId': 'sess-x',
          'remainingSeconds': 60,
          'expiresAt': expiry.toIso8601String(),
        },
      });

      expect(response.expiresAt.toUtc(), expiry);
    });
  });
}
