import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// User model representing a registered user
@freezed
sealed class User with _$User {
  const factory User({
    @JsonKey(name: '_id') required String id,
    required String username,
    required String email,
    String? mobileNumber,
    @JsonKey(name: 'profilePicture') String? avatar,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) {
    // Tolerate both API shapes: { _id, username, ... } and { id, name, ... }
    final normalized = Map<String, dynamic>.from(json);
    if (normalized['_id'] == null && normalized['id'] != null) {
      normalized['_id'] = normalized['id'];
    }
    if (normalized['username'] == null && normalized['name'] != null) {
      normalized['username'] = normalized['name'];
    }
    return _$UserFromJson(normalized);
  }
}

/// Request model for user registration
@Freezed(toJson: true)
sealed class RegisterRequest with _$RegisterRequest {
  const factory RegisterRequest({
    required String username,
    required String email,
    required String mobileNumber,
    required String password,
    @JsonKey(name: 'profilePicture', includeIfNull: false)
    String? avatar,
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
    String? username,
    @JsonKey(name: 'profilePicture') String? avatar,
    String? mobileNumber,
  }) = _UpdateProfileRequest;

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateProfileRequestFromJson(json);
}
