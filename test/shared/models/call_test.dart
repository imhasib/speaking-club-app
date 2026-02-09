import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/models/call.dart';

void main() {
  group('Call', () {
    final testParticipant = CallParticipant(
      id: 'user1',
      username: 'User 1',
    );

    final testParticipant2 = CallParticipant(
      id: 'user2',
      username: 'User 2',
    );

    test('creates call with required fields', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant, testParticipant2],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1, 10, 0),
      );

      expect(call.id, 'call-123');
      expect(call.type, CallType.random);
      expect(call.status, CallStatus.completed);
      expect(call.duration, isNull);
    });

    test('creates call with all fields', () {
      final call = Call(
        id: 'call-123',
        type: CallType.direct,
        status: CallStatus.completed,
        participants: [testParticipant, testParticipant2],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1, 10, 0),
        endedAt: DateTime(2024, 1, 1, 10, 30),
        duration: 1800,
      );

      expect(call.duration, 1800);
      expect(call.endedAt, isNotNull);
      expect(call.participants.length, 2);
    });

    test('formattedDuration returns correct format for hours', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
        duration: 3720, // 1 hour, 2 minutes
      );

      expect(call.formattedDuration, '1h 2m');
    });

    test('formattedDuration returns correct format for minutes', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
        duration: 185, // 3 minutes 5 seconds
      );

      expect(call.formattedDuration, '3m 5s');
    });

    test('formattedDuration returns correct format for seconds only', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
        duration: 45,
      );

      expect(call.formattedDuration, '45s');
    });

    test('formattedDuration returns -- for null duration', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
      );

      expect(call.formattedDuration, '--');
    });

    test('getOtherParticipant returns correct participant', () {
      final call = Call(
        id: 'call-123',
        type: CallType.direct,
        status: CallStatus.completed,
        participants: [testParticipant, testParticipant2],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
      );

      final other = call.getOtherParticipant('user1');
      expect(other?.id, 'user2');
      expect(other?.username, 'User 2');
    });

    test('getOtherParticipant returns first participant if not found', () {
      final call = Call(
        id: 'call-123',
        type: CallType.direct,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime(2024, 1, 1),
      );

      final other = call.getOtherParticipant('unknown');
      expect(other?.id, 'user1');
    });

    test('fromJson creates call correctly', () {
      final json = {
        '_id': 'call-123',
        'callType': 'random',
        'status': 'completed',
        'participants': [
          {'_id': 'user1', 'username': 'User 1'},
        ],
        'initiatedBy': {'_id': 'user1', 'username': 'User 1'},
        'startedAt': '2024-01-01T10:00:00.000Z',
        'duration': 1800,
      };

      final call = Call.fromJson(json);

      expect(call.id, 'call-123');
      expect(call.type, CallType.random);
      expect(call.status, CallStatus.completed);
      expect(call.duration, 1800);
    });

    test('toJson converts call correctly', () {
      final call = Call(
        id: 'call-123',
        type: CallType.random,
        status: CallStatus.completed,
        participants: [testParticipant],
        initiatedBy: testParticipant,
        startedAt: DateTime.utc(2024, 1, 1, 10, 0),
        duration: 1800,
      );

      final json = call.toJson();

      expect(json['_id'], 'call-123');
      expect(json['callType'], 'random');
      expect(json['status'], 'completed');
      expect(json['duration'], 1800);
    });
  });

  group('CallStatus', () {
    test('isCompleted returns true for completed status', () {
      expect(CallStatus.completed.isCompleted, isTrue);
    });

    test('isCompleted returns false for other statuses', () {
      expect(CallStatus.missed.isCompleted, isFalse);
      expect(CallStatus.cancelled.isCompleted, isFalse);
      expect(CallStatus.rejected.isCompleted, isFalse);
    });

    test('isMissed returns true for missed status', () {
      expect(CallStatus.missed.isMissed, isTrue);
    });

    test('isCancelled returns true for cancelled status', () {
      expect(CallStatus.cancelled.isCancelled, isTrue);
    });

    test('isRejected returns true for rejected status', () {
      expect(CallStatus.rejected.isRejected, isTrue);
    });
  });

  group('CallType', () {
    test('isRandom returns true for random type', () {
      expect(CallType.random.isRandom, isTrue);
    });

    test('isRandom returns true for matchmaking type', () {
      expect(CallType.matchmaking.isRandom, isTrue);
    });

    test('isRandom returns false for direct type', () {
      expect(CallType.direct.isRandom, isFalse);
    });

    test('isDirect returns true for direct type', () {
      expect(CallType.direct.isDirect, isTrue);
    });

    test('isDirect returns false for random type', () {
      expect(CallType.random.isDirect, isFalse);
    });
  });

  group('CallParticipant', () {
    test('creates participant with required fields', () {
      const participant = CallParticipant(
        id: 'user1',
        username: 'User 1',
      );

      expect(participant.id, 'user1');
      expect(participant.username, 'User 1');
      expect(participant.avatar, isNull);
    });

    test('creates participant with avatar', () {
      const participant = CallParticipant(
        id: 'user1',
        username: 'User 1',
        avatar: 'https://example.com/avatar.jpg',
      );

      expect(participant.avatar, 'https://example.com/avatar.jpg');
    });

    test('fromJson creates participant correctly', () {
      final json = {
        '_id': 'user1',
        'username': 'User 1',
        'avatar': 'https://example.com/avatar.jpg',
      };

      final participant = CallParticipant.fromJson(json);

      expect(participant.id, 'user1');
      expect(participant.username, 'User 1');
      expect(participant.avatar, 'https://example.com/avatar.jpg');
    });
  });

  group('PeerInfo', () {
    test('creates peer info correctly', () {
      const peer = PeerInfo(
        id: 'user1',
        username: 'User 1',
      );

      expect(peer.id, 'user1');
      expect(peer.username, 'User 1');
    });

    test('fromJson creates peer info correctly', () {
      final json = {
        'id': 'user1',
        'username': 'User 1',
        'avatar': 'https://example.com/avatar.jpg',
      };

      final peer = PeerInfo.fromJson(json);

      expect(peer.id, 'user1');
      expect(peer.username, 'User 1');
      expect(peer.avatar, 'https://example.com/avatar.jpg');
    });
  });

  group('MatchmakingResult', () {
    test('creates matchmaking result correctly', () {
      const result = MatchmakingResult(
        callId: 'call-123',
        dbCallId: 'db-call-123',
        peerId: 'user1',
        peerInfo: PeerInfo(id: 'user1', username: 'User 1'),
        initiator: true,
      );

      expect(result.callId, 'call-123');
      expect(result.initiator, isTrue);
      expect(result.peerInfo.username, 'User 1');
    });

    test('fromJson creates result correctly', () {
      final json = {
        'callId': 'call-123',
        'dbCallId': 'db-call-123',
        'peerId': 'user1',
        'peerInfo': {
          'id': 'user1',
          'username': 'User 1',
        },
        'initiator': true,
      };

      final result = MatchmakingResult.fromJson(json);

      expect(result.callId, 'call-123');
      expect(result.initiator, isTrue);
    });
  });

  group('IncomingCall', () {
    test('creates incoming call correctly', () {
      const incoming = IncomingCall(
        callId: 'call-123',
        callerId: 'user1',
        callerInfo: PeerInfo(id: 'user1', username: 'User 1'),
      );

      expect(incoming.callId, 'call-123');
      expect(incoming.callerInfo.username, 'User 1');
    });

    test('fromJson creates incoming call correctly', () {
      final json = {
        'callId': 'call-123',
        'callerId': 'user1',
        'callerInfo': {
          'id': 'user1',
          'username': 'User 1',
        },
      };

      final incoming = IncomingCall.fromJson(json);

      expect(incoming.callId, 'call-123');
      expect(incoming.callerInfo.id, 'user1');
    });
  });

  group('CallEnded', () {
    test('creates call ended correctly', () {
      const ended = CallEnded(reason: 'User ended call');

      expect(ended.reason, 'User ended call');
    });

    test('fromJson creates call ended correctly', () {
      final json = {'reason': 'Peer ended call'};

      final ended = CallEnded.fromJson(json);

      expect(ended.reason, 'Peer ended call');
    });
  });

  group('CallRejected', () {
    test('creates call rejected correctly', () {
      const rejected = CallRejected(callId: 'call-123', reason: 'rejected');

      expect(rejected.callId, 'call-123');
      expect(rejected.reason, 'rejected');
    });

    test('fromJson creates call rejected correctly', () {
      final json = {'callId': 'call-123', 'reason': 'busy'};

      final rejected = CallRejected.fromJson(json);

      expect(rejected.callId, 'call-123');
      expect(rejected.reason, 'busy');
    });
  });
}
