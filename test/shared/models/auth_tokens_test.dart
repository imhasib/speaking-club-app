import 'package:flutter_test/flutter_test.dart';
import 'package:Speaking_club/shared/models/auth_tokens.dart';

void main() {
  group('AuthTokens', () {
    test('creates auth tokens correctly', () {
      const tokens = AuthTokens(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
      );

      expect(tokens.accessToken, 'access-token-123');
      expect(tokens.refreshToken, 'refresh-token-456');
    });

    test('fromJson creates tokens correctly', () {
      final json = {
        'accessToken': 'access-token-123',
        'refreshToken': 'refresh-token-456',
      };

      final tokens = AuthTokens.fromJson(json);

      expect(tokens.accessToken, 'access-token-123');
      expect(tokens.refreshToken, 'refresh-token-456');
    });

    test('toJson converts tokens correctly', () {
      const tokens = AuthTokens(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
      );

      final json = tokens.toJson();

      expect(json['accessToken'], 'access-token-123');
      expect(json['refreshToken'], 'refresh-token-456');
    });
  });

  group('AuthResponse', () {
    test('creates auth response correctly', () {
      const response = AuthResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        user: AuthUser(
          id: 'user-123',
          name: 'testuser',
          email: 'test@example.com',
        ),
      );

      expect(response.accessToken, 'access-token-123');
      expect(response.refreshToken, 'refresh-token-456');
      expect(response.user.name, 'testuser');
    });

    test('tokens getter returns AuthTokens', () {
      const response = AuthResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        user: AuthUser(
          id: 'user-123',
          name: 'testuser',
          email: 'test@example.com',
        ),
      );

      final tokens = response.tokens;
      expect(tokens.accessToken, 'access-token-123');
      expect(tokens.refreshToken, 'refresh-token-456');
    });

    test('fromJson creates auth response correctly', () {
      final json = {
        'accessToken': 'access-token-123',
        'refreshToken': 'refresh-token-456',
        'user': {
          '_id': 'user-123',
          'name': 'testuser',
          'email': 'test@example.com',
        },
      };

      final response = AuthResponse.fromJson(json);

      expect(response.accessToken, 'access-token-123');
      expect(response.user.id, 'user-123');
    });

    test('toJson converts auth response correctly', () {
      const response = AuthResponse(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
        user: AuthUser(
          id: 'user-123',
          name: 'testuser',
          email: 'test@example.com',
        ),
      );

      final json = response.toJson();

      expect(json['accessToken'], 'access-token-123');
      // Note: freezed without explicitToJson returns the object, not a Map
      expect((json['user'] as AuthUser).id, 'user-123');
    });
  });

  group('AuthUser', () {
    test('creates auth user correctly', () {
      const authUser = AuthUser(
        id: 'user-123',
        name: 'testuser',
        email: 'test@example.com',
      );

      expect(authUser.id, 'user-123');
      expect(authUser.name, 'testuser');
      expect(authUser.email, 'test@example.com');
    });

    test('creates auth user with optional fields', () {
      const authUser = AuthUser(
        id: 'user-123',
        name: 'testuser',
        email: 'test@example.com',
        mobileNumber: '+1234567890',
        profilePicture: 'https://example.com/pic.jpg',
      );

      expect(authUser.mobileNumber, '+1234567890');
      expect(authUser.profilePicture, 'https://example.com/pic.jpg');
    });

    test('fromJson creates auth user correctly', () {
      final json = {
        '_id': 'user-123',
        'name': 'testuser',
        'email': 'test@example.com',
        'mobileNumber': '+1234567890',
      };

      final authUser = AuthUser.fromJson(json);

      expect(authUser.id, 'user-123');
      expect(authUser.name, 'testuser');
      expect(authUser.mobileNumber, '+1234567890');
    });

    test('toJson converts auth user correctly', () {
      const authUser = AuthUser(
        id: 'user-123',
        name: 'testuser',
        email: 'test@example.com',
      );

      final json = authUser.toJson();

      expect(json['_id'], 'user-123');
      expect(json['name'], 'testuser');
    });

    test('copyWith updates fields correctly', () {
      const authUser = AuthUser(
        id: 'user-123',
        name: 'testuser',
        email: 'test@example.com',
      );

      final updatedUser = authUser.copyWith(name: 'newname');

      expect(updatedUser.id, 'user-123');
      expect(updatedUser.name, 'newname');
    });
  });

  group('GoogleAuthRequest', () {
    test('creates google auth request correctly', () {
      const request = GoogleAuthRequest(idToken: 'google-id-token-123');

      expect(request.idToken, 'google-id-token-123');
    });

    test('toJson converts request correctly', () {
      const request = GoogleAuthRequest(idToken: 'google-id-token-123');

      final json = request.toJson();

      expect(json['idToken'], 'google-id-token-123');
    });

    test('fromJson creates request correctly', () {
      final json = {'idToken': 'google-id-token-123'};

      final request = GoogleAuthRequest.fromJson(json);

      expect(request.idToken, 'google-id-token-123');
    });
  });

  group('RefreshTokenRequest', () {
    test('creates refresh token request correctly', () {
      const request = RefreshTokenRequest(refreshToken: 'refresh-token-123');

      expect(request.refreshToken, 'refresh-token-123');
    });

    test('toJson converts request correctly', () {
      const request = RefreshTokenRequest(refreshToken: 'refresh-token-123');

      final json = request.toJson();

      expect(json['refreshToken'], 'refresh-token-123');
    });

    test('fromJson creates request correctly', () {
      final json = {'refreshToken': 'refresh-token-123'};

      final request = RefreshTokenRequest.fromJson(json);

      expect(request.refreshToken, 'refresh-token-123');
    });
  });
}
