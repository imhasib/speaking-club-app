// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'online_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnlineUser {

 String get id; String get name; String? get profilePicture;@UserStatusConverter() UserStatus get status;
/// Create a copy of OnlineUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnlineUserCopyWith<OnlineUser> get copyWith => _$OnlineUserCopyWithImpl<OnlineUser>(this as OnlineUser, _$identity);

  /// Serializes this OnlineUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnlineUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture,status);

@override
String toString() {
  return 'OnlineUser(id: $id, name: $name, profilePicture: $profilePicture, status: $status)';
}


}

/// @nodoc
abstract mixin class $OnlineUserCopyWith<$Res>  {
  factory $OnlineUserCopyWith(OnlineUser value, $Res Function(OnlineUser) _then) = _$OnlineUserCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? profilePicture,@UserStatusConverter() UserStatus status
});




}
/// @nodoc
class _$OnlineUserCopyWithImpl<$Res>
    implements $OnlineUserCopyWith<$Res> {
  _$OnlineUserCopyWithImpl(this._self, this._then);

  final OnlineUser _self;
  final $Res Function(OnlineUser) _then;

/// Create a copy of OnlineUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [OnlineUser].
extension OnlineUserPatterns on OnlineUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnlineUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnlineUser() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnlineUser value)  $default,){
final _that = this;
switch (_that) {
case _OnlineUser():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnlineUser value)?  $default,){
final _that = this;
switch (_that) {
case _OnlineUser() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture, @UserStatusConverter()  UserStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnlineUser() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture, @UserStatusConverter()  UserStatus status)  $default,) {final _that = this;
switch (_that) {
case _OnlineUser():
return $default(_that.id,_that.name,_that.profilePicture,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? profilePicture, @UserStatusConverter()  UserStatus status)?  $default,) {final _that = this;
switch (_that) {
case _OnlineUser() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnlineUser implements OnlineUser {
  const _OnlineUser({required this.id, required this.name, this.profilePicture, @UserStatusConverter() required this.status});
  factory _OnlineUser.fromJson(Map<String, dynamic> json) => _$OnlineUserFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? profilePicture;
@override@UserStatusConverter() final  UserStatus status;

/// Create a copy of OnlineUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnlineUserCopyWith<_OnlineUser> get copyWith => __$OnlineUserCopyWithImpl<_OnlineUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnlineUserToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnlineUser&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture,status);

@override
String toString() {
  return 'OnlineUser(id: $id, name: $name, profilePicture: $profilePicture, status: $status)';
}


}

/// @nodoc
abstract mixin class _$OnlineUserCopyWith<$Res> implements $OnlineUserCopyWith<$Res> {
  factory _$OnlineUserCopyWith(_OnlineUser value, $Res Function(_OnlineUser) _then) = __$OnlineUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? profilePicture,@UserStatusConverter() UserStatus status
});




}
/// @nodoc
class __$OnlineUserCopyWithImpl<$Res>
    implements _$OnlineUserCopyWith<$Res> {
  __$OnlineUserCopyWithImpl(this._self, this._then);

  final _OnlineUser _self;
  final $Res Function(_OnlineUser) _then;

/// Create a copy of OnlineUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,Object? status = null,}) {
  return _then(_OnlineUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,
  ));
}


}


/// @nodoc
mixin _$UserStatusChange {

 String get userId;@UserStatusConverter() UserStatus get status;
/// Create a copy of UserStatusChange
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserStatusChangeCopyWith<UserStatusChange> get copyWith => _$UserStatusChangeCopyWithImpl<UserStatusChange>(this as UserStatusChange, _$identity);

  /// Serializes this UserStatusChange to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserStatusChange&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,status);

@override
String toString() {
  return 'UserStatusChange(userId: $userId, status: $status)';
}


}

/// @nodoc
abstract mixin class $UserStatusChangeCopyWith<$Res>  {
  factory $UserStatusChangeCopyWith(UserStatusChange value, $Res Function(UserStatusChange) _then) = _$UserStatusChangeCopyWithImpl;
@useResult
$Res call({
 String userId,@UserStatusConverter() UserStatus status
});




}
/// @nodoc
class _$UserStatusChangeCopyWithImpl<$Res>
    implements $UserStatusChangeCopyWith<$Res> {
  _$UserStatusChangeCopyWithImpl(this._self, this._then);

  final UserStatusChange _self;
  final $Res Function(UserStatusChange) _then;

/// Create a copy of UserStatusChange
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? status = null,}) {
  return _then(_self.copyWith(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [UserStatusChange].
extension UserStatusChangePatterns on UserStatusChange {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserStatusChange value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserStatusChange() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserStatusChange value)  $default,){
final _that = this;
switch (_that) {
case _UserStatusChange():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserStatusChange value)?  $default,){
final _that = this;
switch (_that) {
case _UserStatusChange() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String userId, @UserStatusConverter()  UserStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserStatusChange() when $default != null:
return $default(_that.userId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String userId, @UserStatusConverter()  UserStatus status)  $default,) {final _that = this;
switch (_that) {
case _UserStatusChange():
return $default(_that.userId,_that.status);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String userId, @UserStatusConverter()  UserStatus status)?  $default,) {final _that = this;
switch (_that) {
case _UserStatusChange() when $default != null:
return $default(_that.userId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserStatusChange implements UserStatusChange {
  const _UserStatusChange({required this.userId, @UserStatusConverter() required this.status});
  factory _UserStatusChange.fromJson(Map<String, dynamic> json) => _$UserStatusChangeFromJson(json);

@override final  String userId;
@override@UserStatusConverter() final  UserStatus status;

/// Create a copy of UserStatusChange
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserStatusChangeCopyWith<_UserStatusChange> get copyWith => __$UserStatusChangeCopyWithImpl<_UserStatusChange>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserStatusChangeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserStatusChange&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,userId,status);

@override
String toString() {
  return 'UserStatusChange(userId: $userId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$UserStatusChangeCopyWith<$Res> implements $UserStatusChangeCopyWith<$Res> {
  factory _$UserStatusChangeCopyWith(_UserStatusChange value, $Res Function(_UserStatusChange) _then) = __$UserStatusChangeCopyWithImpl;
@override @useResult
$Res call({
 String userId,@UserStatusConverter() UserStatus status
});




}
/// @nodoc
class __$UserStatusChangeCopyWithImpl<$Res>
    implements _$UserStatusChangeCopyWith<$Res> {
  __$UserStatusChangeCopyWithImpl(this._self, this._then);

  final _UserStatusChange _self;
  final $Res Function(_UserStatusChange) _then;

/// Create a copy of UserStatusChange
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? status = null,}) {
  return _then(_UserStatusChange(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as UserStatus,
  ));
}


}

// dart format on
