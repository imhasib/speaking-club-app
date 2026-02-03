// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'presence_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PresenceState {

 SocketConnectionState get connectionState; UserStatus get userStatus; List<OnlineUser> get onlineUsers; bool get isLoading; String? get error;
/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PresenceStateCopyWith<PresenceState> get copyWith => _$PresenceStateCopyWithImpl<PresenceState>(this as PresenceState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PresenceState&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&const DeepCollectionEquality().equals(other.onlineUsers, onlineUsers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,connectionState,userStatus,const DeepCollectionEquality().hash(onlineUsers),isLoading,error);

@override
String toString() {
  return 'PresenceState(connectionState: $connectionState, userStatus: $userStatus, onlineUsers: $onlineUsers, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class $PresenceStateCopyWith<$Res>  {
  factory $PresenceStateCopyWith(PresenceState value, $Res Function(PresenceState) _then) = _$PresenceStateCopyWithImpl;
@useResult
$Res call({
 SocketConnectionState connectionState, UserStatus userStatus, List<OnlineUser> onlineUsers, bool isLoading, String? error
});




}
/// @nodoc
class _$PresenceStateCopyWithImpl<$Res>
    implements $PresenceStateCopyWith<$Res> {
  _$PresenceStateCopyWithImpl(this._self, this._then);

  final PresenceState _self;
  final $Res Function(PresenceState) _then;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? connectionState = null,Object? userStatus = null,Object? onlineUsers = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as SocketConnectionState,userStatus: null == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as UserStatus,onlineUsers: null == onlineUsers ? _self.onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as List<OnlineUser>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PresenceState].
extension PresenceStatePatterns on PresenceState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PresenceState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PresenceState value)  $default,){
final _that = this;
switch (_that) {
case _PresenceState():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PresenceState value)?  $default,){
final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SocketConnectionState connectionState,  UserStatus userStatus,  List<OnlineUser> onlineUsers,  bool isLoading,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that.connectionState,_that.userStatus,_that.onlineUsers,_that.isLoading,_that.error);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SocketConnectionState connectionState,  UserStatus userStatus,  List<OnlineUser> onlineUsers,  bool isLoading,  String? error)  $default,) {final _that = this;
switch (_that) {
case _PresenceState():
return $default(_that.connectionState,_that.userStatus,_that.onlineUsers,_that.isLoading,_that.error);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SocketConnectionState connectionState,  UserStatus userStatus,  List<OnlineUser> onlineUsers,  bool isLoading,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _PresenceState() when $default != null:
return $default(_that.connectionState,_that.userStatus,_that.onlineUsers,_that.isLoading,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _PresenceState extends PresenceState {
  const _PresenceState({this.connectionState = SocketConnectionState.disconnected, this.userStatus = UserStatus.offline, final  List<OnlineUser> onlineUsers = const [], this.isLoading = false, this.error}): _onlineUsers = onlineUsers,super._();
  

@override@JsonKey() final  SocketConnectionState connectionState;
@override@JsonKey() final  UserStatus userStatus;
 final  List<OnlineUser> _onlineUsers;
@override@JsonKey() List<OnlineUser> get onlineUsers {
  if (_onlineUsers is EqualUnmodifiableListView) return _onlineUsers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_onlineUsers);
}

@override@JsonKey() final  bool isLoading;
@override final  String? error;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PresenceStateCopyWith<_PresenceState> get copyWith => __$PresenceStateCopyWithImpl<_PresenceState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PresenceState&&(identical(other.connectionState, connectionState) || other.connectionState == connectionState)&&(identical(other.userStatus, userStatus) || other.userStatus == userStatus)&&const DeepCollectionEquality().equals(other._onlineUsers, _onlineUsers)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,connectionState,userStatus,const DeepCollectionEquality().hash(_onlineUsers),isLoading,error);

@override
String toString() {
  return 'PresenceState(connectionState: $connectionState, userStatus: $userStatus, onlineUsers: $onlineUsers, isLoading: $isLoading, error: $error)';
}


}

/// @nodoc
abstract mixin class _$PresenceStateCopyWith<$Res> implements $PresenceStateCopyWith<$Res> {
  factory _$PresenceStateCopyWith(_PresenceState value, $Res Function(_PresenceState) _then) = __$PresenceStateCopyWithImpl;
@override @useResult
$Res call({
 SocketConnectionState connectionState, UserStatus userStatus, List<OnlineUser> onlineUsers, bool isLoading, String? error
});




}
/// @nodoc
class __$PresenceStateCopyWithImpl<$Res>
    implements _$PresenceStateCopyWith<$Res> {
  __$PresenceStateCopyWithImpl(this._self, this._then);

  final _PresenceState _self;
  final $Res Function(_PresenceState) _then;

/// Create a copy of PresenceState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? connectionState = null,Object? userStatus = null,Object? onlineUsers = null,Object? isLoading = null,Object? error = freezed,}) {
  return _then(_PresenceState(
connectionState: null == connectionState ? _self.connectionState : connectionState // ignore: cast_nullable_to_non_nullable
as SocketConnectionState,userStatus: null == userStatus ? _self.userStatus : userStatus // ignore: cast_nullable_to_non_nullable
as UserStatus,onlineUsers: null == onlineUsers ? _self._onlineUsers : onlineUsers // ignore: cast_nullable_to_non_nullable
as List<OnlineUser>,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
