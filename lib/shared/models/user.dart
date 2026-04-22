import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing a registered user
@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    required String name,
    required String email,
    String? mobileNumber,
    String? profilePicture,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
}

/// Request model for user registration.
///
/// Serializes to the backend contract: `{ name, email, mobile, password }`.
@Freezed(toJson: true)
sealed class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String name,
    required String email,
    @JsonKey(name: 'mobile') required String mobileNumber,
    required String password,
    @JsonKey(includeIfNull: false) String? profilePicture,
  }) = _RegisterRequest;

  factory RegisterRequest.fromJson(Map<String, dynamic> json) =>
      _$RegisterRequestFromJson(json);
}

/// Request model for user login
@freezed
sealed class LoginRequest with _$LoginRequest {
  const factory LoginRequest({
    required String email,
    required String password,
  }) = _LoginRequest;

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);
}

/// Request model for profile update
@freezed
sealed class UpdateProfileRequest with _$UpdateProfileRequest {
  const factory UpdateProfileRequest({
    String? name,
    String? profilePicture,
    String? mobileNumber,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}
