import 'package:freezed_annotation/freezed_annotation.dart';

part 'online_user.freezed.dart';
part 'online_user.g.dart';

/// User status enum
enum UserStatus {
  @JsonValue('online')
  online,
  @JsonValue('waiting')
  waiting,
  @JsonValue('in_call')
  inCall,
  @JsonValue('offline')
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
    required UserStatus status,
  }) = _OnlineUser;

  factory OnlineUser.fromJson(Map<String, dynamic> json) =>
      _$OnlineUserFromJson(json);
}

/// User status change event
@freezed
sealed class UserStatusChange with _$UserStatusChange {
  const factory UserStatusChange({
    required String userId,
    required UserStatus status,
  }) = _UserStatusChange;

  factory UserStatusChange.fromJson(Map<String, dynamic> json) =>
      _$UserStatusChangeFromJson(json);
}
