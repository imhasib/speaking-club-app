import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_tokens.freezed.dart';
part 'auth_tokens.g.dart';

/// Authentication tokens
@freezed
sealed class AuthTokens with _$AuthTokens {
  const factory AuthTokens({
    required String accessToken,
    required String refreshToken,
  }) = _AuthTokens;

  factory AuthTokens.fromJson(Map<String, dynamic> json) =>
      _$AuthTokensFromJson(json);
}

/// Authentication response containing user and tokens
@freezed
sealed class AuthResponse with _$AuthResponse {
  const AuthResponse._();

  const factory AuthResponse({
    required String accessToken,
    required String refreshToken,
    required AuthUser user,
  }) = _AuthResponse;

  factory AuthResponse.fromJson(Map<String, dynamic> json) =>
      _$AuthResponseFromJson(json);

  /// Helper to get tokens as AuthTokens object
  AuthTokens get tokens => AuthTokens(
    accessToken: accessToken,
    refreshToken: refreshToken,
  );
}

/// User data returned in auth responses
@freezed
sealed class AuthUser with _$AuthUser {
  const factory AuthUser({
    required String id,
    required String name,
    required String email,
    @JsonKey(name: 'mobile') String? mobileNumber,
    String? profilePicture,
  }) = _AuthUser;

  factory AuthUser.fromJson(Map<String, dynamic> json) =>
      _$AuthUserFromJson(json);
}

/// Google auth request
@freezed
sealed class GoogleAuthRequest with _$GoogleAuthRequest {
  const factory GoogleAuthRequest({
    required String idToken,
  }) = _GoogleAuthRequest;

  factory GoogleAuthRequest.fromJson(Map<String, dynamic> json) =>
      _$GoogleAuthRequestFromJson(json);
}

/// Refresh token request
@freezed
sealed class RefreshTokenRequest with _$RefreshTokenRequest {
  const factory RefreshTokenRequest({
    required String refreshToken,
  }) = _RefreshTokenRequest;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenRequestFromJson(json);
}
