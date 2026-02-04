import 'package:freezed_annotation/freezed_annotation.dart';

part 'online_user.freezed.dart';
part 'online_user.g.dart';

/// Custom converter for UserStatus that handles case-insensitive values
class UserStatusConverter implements JsonConverter<UserStatus, String> {
  const UserStatusConverter();

  @override
  UserStatus fromJson(String json) {
    switch (json.toUpperCase()) {
      case 'ONLINE':
        return UserStatus.online;
      case 'WAITING':
        return UserStatus.waiting;
      case 'IN_CALL':
      case 'CALLING':
      case 'RINGING':
        return UserStatus.inCall;
      case 'OFFLINE':
        return UserStatus.offline;
      default:
        // Default to online for unknown statuses to prevent accidental removal
        return UserStatus.online;
    }
  }

  @override
  String toJson(UserStatus object) {
    switch (object) {
      case UserStatus.online:
        return 'ONLINE';
      case UserStatus.waiting:
        return 'WAITING';
      case UserStatus.inCall:
        return 'IN_CALL';
      case UserStatus.offline:
        return 'OFFLINE';
    }
  }
}

/// User status enum
enum UserStatus {
  online,
  waiting,
  inCall,
  offline;

  bool get isAvailable => this == UserStatus.online;
  bool get isWaiting => this == UserStatus.waiting;
  bool get isInCall => this == UserStatus.inCall;
  bool get isOffline => this == UserStatus.offline;
}

/// Online user model for presence tracking
@freezed
sealed class OnlineUser with _$OnlineUser {
  const factory OnlineUser({
    required String id,
    required String username,
    String? avatar,
    @UserStatusConverter() required UserStatus status,
  }) = _OnlineUser;

  factory OnlineUser.fromJson(Map<String, dynamic> json) =>
      _$OnlineUserFromJson(json);
}

/// User status change event
@freezed
sealed class UserStatusChange with _$UserStatusChange {
  const factory UserStatusChange({
    required String userId,
    @UserStatusConverter() required UserStatus status,
  }) = _UserStatusChange;

  factory UserStatusChange.fromJson(Map<String, dynamic> json) =>
      _$UserStatusChangeFromJson(json);
}
