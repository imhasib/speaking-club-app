// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_User _$UserFromJson(Map<String, dynamic> json) => _User(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  mobileNumber: json['mobileNumber'] as String?,
  profilePicture: json['profilePicture'] as String?,
  createdAt: DateTime.parse(json['createdAt'] as String),
  updatedAt: DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$UserToJson(_User instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'mobileNumber': instance.mobileNumber,
  'profilePicture': instance.profilePicture,
  'createdAt': instance.createdAt.toIso8601String(),
  'updatedAt': instance.updatedAt.toIso8601String(),
};

_RegisterRequest _$RegisterRequestFromJson(Map<String, dynamic> json) =>
    _RegisterRequest(
      name: json['name'] as String,
      email: json['email'] as String,
      mobileNumber: json['mobile'] as String,
      password: json['password'] as String,
      profilePicture: json['profilePicture'] as String?,
    );

Map<String, dynamic> _$RegisterRequestToJson(_RegisterRequest instance) =>
    <String, dynamic>{
      'name': instance.name,
      'email': instance.email,
      'mobile': instance.mobileNumber,
      'password': instance.password,
      'profilePicture': ?instance.profilePicture,
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
  name: json['name'] as String?,
  profilePicture: json['profilePicture'] as String?,
  mobileNumber: json['mobileNumber'] as String?,
);

Map<String, dynamic> _$UpdateProfileRequestToJson(
  _UpdateProfileRequest instance,
) => <String, dynamic>{
  'name': instance.name,
  'profilePicture': instance.profilePicture,
  'mobileNumber': instance.mobileNumber,
};
