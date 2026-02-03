// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'online_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OnlineUser _$OnlineUserFromJson(Map<String, dynamic> json) => _OnlineUser(
  id: json['id'] as String,
  username: json['username'] as String,
  avatar: json['avatar'] as String?,
  status: const UserStatusConverter().fromJson(json['status'] as String),
);

Map<String, dynamic> _$OnlineUserToJson(_OnlineUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'avatar': instance.avatar,
      'status': const UserStatusConverter().toJson(instance.status),
    };

_UserStatusChange _$UserStatusChangeFromJson(Map<String, dynamic> json) =>
    _UserStatusChange(
      userId: json['userId'] as String,
      status: const UserStatusConverter().fromJson(json['status'] as String),
    );

Map<String, dynamic> _$UserStatusChangeToJson(_UserStatusChange instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'status': const UserStatusConverter().toJson(instance.status),
    };
