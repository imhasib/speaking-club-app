// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['_id'] as String,
  username: json['username'] as String,
  email: json['email'] as String,
  mobileNumber: json['mobileNumber'] as String?,
  avatar: json['profilePicture'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  '_id': instance.id,
  'username': instance.username,
  'email': instance.email,
  'mobileNumber': instance.mobileNumber,
  'profilePicture': instance.avatar,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      username: json['name'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobile'] as String,
      password: json['password'] as String,
      avatar: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.username,
      'email': instance.email,
      'mobile': instance.mobileNumber,
      'password': instance.password,
      'profilePicture': ?instance.avatar,
    };

_LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) =>
    _LoginRequest(
      email: json['email'] as String,
      password: json['password'] as String,
    );

Map<String, dynamic> _$LoginRequestToJson(_LoginRequest instance) =>
    <String, dynamic>{'email': instance.email, 'password': instance.password};

_UpdateProfileRequest _$UpdateProfileRequestFromJson(
  Map<String, dynamic> json,
) => _UpdateProfileRequest(
  username: json['username'] as String?,
  avatar: json['profilePicture'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  _UpdateProfileRequest instance,
) => <String, dynamic>{
  'username': instance.username,
  'profilePicture': instance.avatar,
  'mobileNumber': instance.mobileNumber,
};
