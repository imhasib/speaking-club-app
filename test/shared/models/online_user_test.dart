import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/models/online_user.dart';

void main() {
  group('OnlineUser', () {
    test('creates online user with required fields', () {
      const user = OnlineUser(
        id: '123',
        name: 'testuser',
        status: UserStatus.online,
      );

      expect(user.id, '123');
      expect(user.name, 'testuser');
      expect(user.status, UserStatus.online);
      expect(user.profilePicture, isNull);
    });

    test('creates online user with all fields', () {
      const user = OnlineUser(
        id: '123',
        name: 'testuser',
        status: UserStatus.online,
        profilePicture: 'https://example.com/pic.jpg',
      );

      expect(user.profilePicture, 'https://example.com/pic.jpg');
    });

    test('fromJson creates online user correctly', () {
      final json = {
        'id': '123',
        'name': 'testuser',
        'status': 'ONLINE',
        'profilePicture': 'https://example.com/pic.jpg',
      };

      final user = OnlineUser.fromJson(json);

      expect(user.id, '123');
      expect(user.name, 'testuser');
      expect(user.status, UserStatus.online);
      expect(user.profilePicture, 'https://example.com/pic.jpg');
    });

    test('toJson converts online user correctly', () {
      const user = OnlineUser(
        id: '123',
        name: 'testuser',
        status: UserStatus.online,
      );

      final json = user.toJson();

      expect(json['id'], '123');
      expect(json['name'], 'testuser');
      expect(json['status'], 'ONLINE');
    });

    test('copyWith creates new user with updated fields', () {
      const user = OnlineUser(
        id: '123',
        name: 'testuser',
        status: UserStatus.online,
      );

      final updatedUser = user.copyWith(status: UserStatus.inCall);

      expect(updatedUser.id, '123');
      expect(updatedUser.status, UserStatus.inCall);
    });
  });

  group('UserStatus', () {
    test('isAvailable returns true for online status', () {
      expect(UserStatus.online.isAvailable, isTrue);
    });

    test('isAvailable returns false for offline status', () {
      expect(UserStatus.offline.isAvailable, isFalse);
    });

    test('isAvailable returns false for inCall status', () {
      expect(UserStatus.inCall.isAvailable, isFalse);
    });

    test('isAvailable returns false for waiting status', () {
      expect(UserStatus.waiting.isAvailable, isFalse);
    });

    test('isWaiting returns true for waiting status', () {
      expect(UserStatus.waiting.isWaiting, isTrue);
    });

    test('isInCall returns true for inCall status', () {
      expect(UserStatus.inCall.isInCall, isTrue);
    });

    test('isOffline returns true for offline status', () {
      expect(UserStatus.offline.isOffline, isTrue);
    });
  });

  group('UserStatusConverter', () {
    const converter = UserStatusConverter();

    test('fromJson parses ONLINE correctly', () {
      expect(converter.fromJson('ONLINE'), UserStatus.online);
    });

    test('fromJson parses OFFLINE correctly', () {
      expect(converter.fromJson('OFFLINE'), UserStatus.offline);
    });

    test('fromJson parses IN_CALL correctly', () {
      expect(converter.fromJson('IN_CALL'), UserStatus.inCall);
    });

    test('fromJson parses WAITING correctly', () {
      expect(converter.fromJson('WAITING'), UserStatus.waiting);
    });

    test('fromJson handles case insensitivity', () {
      expect(converter.fromJson('online'), UserStatus.online);
      expect(converter.fromJson('Online'), UserStatus.online);
    });

    test('fromJson returns online for unknown status', () {
      expect(converter.fromJson('unknown'), UserStatus.online);
    });

    test('toJson returns ONLINE for online status', () {
      expect(converter.toJson(UserStatus.online), 'ONLINE');
    });

    test('toJson returns OFFLINE for offline status', () {
      expect(converter.toJson(UserStatus.offline), 'OFFLINE');
    });

    test('toJson returns IN_CALL for inCall status', () {
      expect(converter.toJson(UserStatus.inCall), 'IN_CALL');
    });

    test('toJson returns WAITING for waiting status', () {
      expect(converter.toJson(UserStatus.waiting), 'WAITING');
    });
  });

  group('UserStatusChange', () {
    test('creates status change correctly', () {
      const change = UserStatusChange(
        userId: '123',
        status: UserStatus.online,
      );

      expect(change.userId, '123');
      expect(change.status, UserStatus.online);
    });

    test('fromJson creates status change correctly', () {
      final json = {
        'userId': '123',
        'status': 'ONLINE',
      };

      final change = UserStatusChange.fromJson(json);

      expect(change.userId, '123');
      expect(change.status, UserStatus.online);
    });
  });
}
