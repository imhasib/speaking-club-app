import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/models/user.dart';

void main() {
  group('User', () {
    test('creates user with required fields', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.mobileNumber, isNull);
      expect(user.avatar, isNull);
    });

    test('creates user with all fields', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        mobileNumber: '+1234567890',
        avatar: 'https://example.com/avatar.jpg',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(user.mobileNumber, '+1234567890');
      expect(user.avatar, 'https://example.com/avatar.jpg');
    });

    test('fromJson creates user correctly', () {
      final json = {
        '_id': '123',
        'username': 'testuser',
        'email': 'test@example.com',
        'mobileNumber': '+1234567890',
        'avatar': 'https://example.com/avatar.jpg',
        'createdAt': '2024-01-01T00:00:00.000Z',
        'updatedAt': '2024-01-01T00:00:00.000Z',
      };

      final user = User.fromJson(json);

      expect(user.id, '123');
      expect(user.username, 'testuser');
      expect(user.email, 'test@example.com');
      expect(user.mobileNumber, '+1234567890');
    });

    test('toJson converts user correctly', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        mobileNumber: '+1234567890',
        createdAt: DateTime.utc(2024, 1, 1),
        updatedAt: DateTime.utc(2024, 1, 1),
      );

      final json = user.toJson();

      expect(json['_id'], '123');
      expect(json['username'], 'testuser');
      expect(json['email'], 'test@example.com');
      expect(json['mobileNumber'], '+1234567890');
    });

    test('copyWith creates new user with updated fields', () {
      final user = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final updatedUser = user.copyWith(username: 'newusername');

      expect(updatedUser.id, '123');
      expect(updatedUser.username, 'newusername');
      expect(updatedUser.email, 'test@example.com');
    });

    test('equality works correctly', () {
      final user1 = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      final user2 = User(
        id: '123',
        username: 'testuser',
        email: 'test@example.com',
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      );

      expect(user1, equals(user2));
    });
  });

  group('RegisterRequest', () {
    test('creates register request correctly', () {
      final request = RegisterRequest(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        mobileNumber: '+1234567890',
      );

      expect(request.username, 'newuser');
      expect(request.email, 'new@example.com');
      expect(request.password, 'password123');
      expect(request.mobileNumber, '+1234567890');
    });

    test('toJson converts register request correctly', () {
      final request = RegisterRequest(
        username: 'newuser',
        email: 'new@example.com',
        password: 'password123',
        mobileNumber: '+1234567890',
      );

      final json = request.toJson();

      expect(json['name'], 'newuser');
      expect(json['email'], 'new@example.com');
      expect(json['password'], 'password123');
      expect(json['mobile'], '+1234567890');
    });
  });

  group('LoginRequest', () {
    test('creates login request correctly', () {
      final request = LoginRequest(
        email: 'test@example.com',
        password: 'password123',
      );

      expect(request.email, 'test@example.com');
      expect(request.password, 'password123');
    });

    test('toJson converts login request correctly', () {
      final request = LoginRequest(
        email: 'test@example.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['email'], 'test@example.com');
      expect(json['password'], 'password123');
    });
  });

  group('UpdateProfileRequest', () {
    test('creates update request with username', () {
      final request = UpdateProfileRequest(username: 'newname');

      expect(request.username, 'newname');
      expect(request.mobileNumber, isNull);
    });

    test('toJson includes only non-null fields', () {
      final request = UpdateProfileRequest(username: 'newname');

      final json = request.toJson();

      expect(json['username'], 'newname');
    });
  });
}
