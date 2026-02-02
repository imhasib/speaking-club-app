// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Call {

 String get id; List<CallParticipant> get participants; CallParticipant get initiatedBy; DateTime get startedAt; DateTime? get endedAt; CallStatus get status; int? get duration; CallType get type;
/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallCopyWith<Call> get copyWith => _$CallCopyWithImpl<Call>(this as Call, _$identity);

  /// Serializes this Call to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Call&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.participants, participants)&&(identical(other.initiatedBy, initiatedBy) || other.initiatedBy == initiatedBy)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(participants),initiatedBy,startedAt,endedAt,status,duration,type);

@override
String toString() {
  return 'Call(id: $id, participants: $participants, initiatedBy: $initiatedBy, startedAt: $startedAt, endedAt: $endedAt, status: $status, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class $CallCopyWith<$Res>  {
  factory $CallCopyWith(Call value, $Res Function(Call) _then) = _$CallCopyWithImpl;
@useResult
$Res call({
 String id, List<CallParticipant> participants, CallParticipant initiatedBy, DateTime startedAt, DateTime? endedAt, CallStatus status, int? duration, CallType type
});


$CallParticipantCopyWith<$Res> get initiatedBy;

}
/// @nodoc
class _$CallCopyWithImpl<$Res>
    implements $CallCopyWith<$Res> {
  _$CallCopyWithImpl(this._self, this._then);

  final Call _self;
  final $Res Function(Call) _then;

/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? participants = null,Object? initiatedBy = null,Object? startedAt = null,Object? endedAt = freezed,Object? status = null,Object? duration = freezed,Object? type = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self.participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallParticipant>,initiatedBy: null == initiatedBy ? _self.initiatedBy : initiatedBy // ignore: cast_nullable_to_non_nullable
as CallParticipant,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallStatus,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallType,
  ));
}
/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res> get initiatedBy {
  
  return $CallParticipantCopyWith<$Res>(_self.initiatedBy, (value) {
    return _then(_self.copyWith(initiatedBy: value));
  });
}
}


/// Adds pattern-matching-related methods to [Call].
extension CallPatterns on Call {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Call value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Call() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Call value)  $default,){
final _that = this;
switch (_that) {
case _Call():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Call value)?  $default,){
final _that = this;
switch (_that) {
case _Call() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration,  CallType type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Call() when $default != null:
return $default(_that.id,_that.participants,_that.initiatedBy,_that.startedAt,_that.endedAt,_that.status,_that.duration,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration,  CallType type)  $default,) {final _that = this;
switch (_that) {
case _Call():
return $default(_that.id,_that.participants,_that.initiatedBy,_that.startedAt,_that.endedAt,_that.status,_that.duration,_that.type);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration,  CallType type)?  $default,) {final _that = this;
switch (_that) {
case _Call() when $default != null:
return $default(_that.id,_that.participants,_that.initiatedBy,_that.startedAt,_that.endedAt,_that.status,_that.duration,_that.type);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Call extends Call {
  const _Call({required this.id, required final  List<CallParticipant> participants, required this.initiatedBy, required this.startedAt, this.endedAt, required this.status, this.duration, this.type = CallType.random}): _participants = participants,super._();
  factory _Call.fromJson(Map<String, dynamic> json) => _$CallFromJson(json);

@override final  String id;
 final  List<CallParticipant> _participants;
@override List<CallParticipant> get participants {
  if (_participants is EqualUnmodifiableListView) return _participants;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_participants);
}

@override final  CallParticipant initiatedBy;
@override final  DateTime startedAt;
@override final  DateTime? endedAt;
@override final  CallStatus status;
@override final  int? duration;
@override@JsonKey() final  CallType type;

/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallCopyWith<_Call> get copyWith => __$CallCopyWithImpl<_Call>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Call&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._participants, _participants)&&(identical(other.initiatedBy, initiatedBy) || other.initiatedBy == initiatedBy)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.type, type) || other.type == type));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_participants),initiatedBy,startedAt,endedAt,status,duration,type);

@override
String toString() {
  return 'Call(id: $id, participants: $participants, initiatedBy: $initiatedBy, startedAt: $startedAt, endedAt: $endedAt, status: $status, duration: $duration, type: $type)';
}


}

/// @nodoc
abstract mixin class _$CallCopyWith<$Res> implements $CallCopyWith<$Res> {
  factory _$CallCopyWith(_Call value, $Res Function(_Call) _then) = __$CallCopyWithImpl;
@override @useResult
$Res call({
 String id, List<CallParticipant> participants, CallParticipant initiatedBy, DateTime startedAt, DateTime? endedAt, CallStatus status, int? duration, CallType type
});


@override $CallParticipantCopyWith<$Res> get initiatedBy;

}
/// @nodoc
class __$CallCopyWithImpl<$Res>
    implements _$CallCopyWith<$Res> {
  __$CallCopyWithImpl(this._self, this._then);

  final _Call _self;
  final $Res Function(_Call) _then;

/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? participants = null,Object? initiatedBy = null,Object? startedAt = null,Object? endedAt = freezed,Object? status = null,Object? duration = freezed,Object? type = null,}) {
  return _then(_Call(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,participants: null == participants ? _self._participants : participants // ignore: cast_nullable_to_non_nullable
as List<CallParticipant>,initiatedBy: null == initiatedBy ? _self.initiatedBy : initiatedBy // ignore: cast_nullable_to_non_nullable
as CallParticipant,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: freezed == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CallStatus,duration: freezed == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as int?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as CallType,
  ));
}

/// Create a copy of Call
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<$Res> get initiatedBy {
  
  return $CallParticipantCopyWith<$Res>(_self.initiatedBy, (value) {
    return _then(_self.copyWith(initiatedBy: value));
  });
}
}


/// @nodoc
mixin _$CallParticipant {

 String get id; String get username; String? get avatar;
/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<CallParticipant> get copyWith => _$CallParticipantCopyWithImpl<CallParticipant>(this as CallParticipant, _$identity);

  /// Serializes this CallParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'CallParticipant(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $CallParticipantCopyWith<$Res>  {
  factory $CallParticipantCopyWith(CallParticipant value, $Res Function(CallParticipant) _then) = _$CallParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String username, String? avatar
});




}
/// @nodoc
class _$CallParticipantCopyWithImpl<$Res>
    implements $CallParticipantCopyWith<$Res> {
  _$CallParticipantCopyWithImpl(this._self, this._then);

  final CallParticipant _self;
  final $Res Function(CallParticipant) _then;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallParticipant].
extension CallParticipantPatterns on CallParticipant {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallParticipant value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallParticipant value)  $default,){
final _that = this;
switch (_that) {
case _CallParticipant():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallParticipant value)?  $default,){
final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String? avatar)  $default,) {final _that = this;
switch (_that) {
case _CallParticipant():
return $default(_that.id,_that.username,_that.avatar);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String? avatar)?  $default,) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallParticipant implements CallParticipant {
  const _CallParticipant({required this.id, required this.username, this.avatar});
  factory _CallParticipant.fromJson(Map<String, dynamic> json) => _$CallParticipantFromJson(json);

@override final  String id;
@override final  String username;
@override final  String? avatar;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallParticipantCopyWith<_CallParticipant> get copyWith => __$CallParticipantCopyWithImpl<_CallParticipant>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallParticipantToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'CallParticipant(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$CallParticipantCopyWith<$Res> implements $CallParticipantCopyWith<$Res> {
  factory _$CallParticipantCopyWith(_CallParticipant value, $Res Function(_CallParticipant) _then) = __$CallParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String? avatar
});




}
/// @nodoc
class __$CallParticipantCopyWithImpl<$Res>
    implements _$CallParticipantCopyWith<$Res> {
  __$CallParticipantCopyWithImpl(this._self, this._then);

  final _CallParticipant _self;
  final $Res Function(_CallParticipant) _then;

/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = freezed,}) {
  return _then(_CallParticipant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$MatchmakingResult {

 String get callId; String get dbCallId; String get peerId; PeerInfo get peerInfo; bool get initiator;
/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchmakingResultCopyWith<MatchmakingResult> get copyWith => _$MatchmakingResultCopyWithImpl<MatchmakingResult>(this as MatchmakingResult, _$identity);

  /// Serializes this MatchmakingResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchmakingResult&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.peerId, peerId) || other.peerId == peerId)&&(identical(other.peerInfo, peerInfo) || other.peerInfo == peerInfo)&&(identical(other.initiator, initiator) || other.initiator == initiator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,peerId,peerInfo,initiator);

@override
String toString() {
  return 'MatchmakingResult(callId: $callId, dbCallId: $dbCallId, peerId: $peerId, peerInfo: $peerInfo, initiator: $initiator)';
}


}

/// @nodoc
abstract mixin class $MatchmakingResultCopyWith<$Res>  {
  factory $MatchmakingResultCopyWith(MatchmakingResult value, $Res Function(MatchmakingResult) _then) = _$MatchmakingResultCopyWithImpl;
@useResult
$Res call({
 String callId, String dbCallId, String peerId, PeerInfo peerInfo, bool initiator
});


$PeerInfoCopyWith<$Res> get peerInfo;

}
/// @nodoc
class _$MatchmakingResultCopyWithImpl<$Res>
    implements $MatchmakingResultCopyWith<$Res> {
  _$MatchmakingResultCopyWithImpl(this._self, this._then);

  final MatchmakingResult _self;
  final $Res Function(MatchmakingResult) _then;

/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? dbCallId = null,Object? peerId = null,Object? peerInfo = null,Object? initiator = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: null == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String,peerId: null == peerId ? _self.peerId : peerId // ignore: cast_nullable_to_non_nullable
as String,peerInfo: null == peerInfo ? _self.peerInfo : peerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,initiator: null == initiator ? _self.initiator : initiator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get peerInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.peerInfo, (value) {
    return _then(_self.copyWith(peerInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [MatchmakingResult].
extension MatchmakingResultPatterns on MatchmakingResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchmakingResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchmakingResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchmakingResult value)  $default,){
final _that = this;
switch (_that) {
case _MatchmakingResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchmakingResult value)?  $default,){
final _that = this;
switch (_that) {
case _MatchmakingResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String dbCallId,  String peerId,  PeerInfo peerInfo,  bool initiator)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchmakingResult() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.peerId,_that.peerInfo,_that.initiator);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String dbCallId,  String peerId,  PeerInfo peerInfo,  bool initiator)  $default,) {final _that = this;
switch (_that) {
case _MatchmakingResult():
return $default(_that.callId,_that.dbCallId,_that.peerId,_that.peerInfo,_that.initiator);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String dbCallId,  String peerId,  PeerInfo peerInfo,  bool initiator)?  $default,) {final _that = this;
switch (_that) {
case _MatchmakingResult() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.peerId,_that.peerInfo,_that.initiator);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchmakingResult implements MatchmakingResult {
  const _MatchmakingResult({required this.callId, required this.dbCallId, required this.peerId, required this.peerInfo, required this.initiator});
  factory _MatchmakingResult.fromJson(Map<String, dynamic> json) => _$MatchmakingResultFromJson(json);

@override final  String callId;
@override final  String dbCallId;
@override final  String peerId;
@override final  PeerInfo peerInfo;
@override final  bool initiator;

/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchmakingResultCopyWith<_MatchmakingResult> get copyWith => __$MatchmakingResultCopyWithImpl<_MatchmakingResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchmakingResultToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchmakingResult&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.peerId, peerId) || other.peerId == peerId)&&(identical(other.peerInfo, peerInfo) || other.peerInfo == peerInfo)&&(identical(other.initiator, initiator) || other.initiator == initiator));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,peerId,peerInfo,initiator);

@override
String toString() {
  return 'MatchmakingResult(callId: $callId, dbCallId: $dbCallId, peerId: $peerId, peerInfo: $peerInfo, initiator: $initiator)';
}


}

/// @nodoc
abstract mixin class _$MatchmakingResultCopyWith<$Res> implements $MatchmakingResultCopyWith<$Res> {
  factory _$MatchmakingResultCopyWith(_MatchmakingResult value, $Res Function(_MatchmakingResult) _then) = __$MatchmakingResultCopyWithImpl;
@override @useResult
$Res call({
 String callId, String dbCallId, String peerId, PeerInfo peerInfo, bool initiator
});


@override $PeerInfoCopyWith<$Res> get peerInfo;

}
/// @nodoc
class __$MatchmakingResultCopyWithImpl<$Res>
    implements _$MatchmakingResultCopyWith<$Res> {
  __$MatchmakingResultCopyWithImpl(this._self, this._then);

  final _MatchmakingResult _self;
  final $Res Function(_MatchmakingResult) _then;

/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? dbCallId = null,Object? peerId = null,Object? peerInfo = null,Object? initiator = null,}) {
  return _then(_MatchmakingResult(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: null == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String,peerId: null == peerId ? _self.peerId : peerId // ignore: cast_nullable_to_non_nullable
as String,peerInfo: null == peerInfo ? _self.peerInfo : peerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,initiator: null == initiator ? _self.initiator : initiator // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of MatchmakingResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get peerInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.peerInfo, (value) {
    return _then(_self.copyWith(peerInfo: value));
  });
}
}


/// @nodoc
mixin _$PeerInfo {

 String get id; String get username; String? get avatar;
/// Create a copy of PeerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<PeerInfo> get copyWith => _$PeerInfoCopyWithImpl<PeerInfo>(this as PeerInfo, _$identity);

  /// Serializes this PeerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'PeerInfo(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class $PeerInfoCopyWith<$Res>  {
  factory $PeerInfoCopyWith(PeerInfo value, $Res Function(PeerInfo) _then) = _$PeerInfoCopyWithImpl;
@useResult
$Res call({
 String id, String username, String? avatar
});




}
/// @nodoc
class _$PeerInfoCopyWithImpl<$Res>
    implements $PeerInfoCopyWith<$Res> {
  _$PeerInfoCopyWithImpl(this._self, this._then);

  final PeerInfo _self;
  final $Res Function(PeerInfo) _then;

/// Create a copy of PeerInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? username = null,Object? avatar = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PeerInfo].
extension PeerInfoPatterns on PeerInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PeerInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PeerInfo value)  $default,){
final _that = this;
switch (_that) {
case _PeerInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PeerInfo value)?  $default,){
final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String username,  String? avatar)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String username,  String? avatar)  $default,) {final _that = this;
switch (_that) {
case _PeerInfo():
return $default(_that.id,_that.username,_that.avatar);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String username,  String? avatar)?  $default,) {final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
return $default(_that.id,_that.username,_that.avatar);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PeerInfo implements PeerInfo {
  const _PeerInfo({required this.id, required this.username, this.avatar});
  factory _PeerInfo.fromJson(Map<String, dynamic> json) => _$PeerInfoFromJson(json);

@override final  String id;
@override final  String username;
@override final  String? avatar;

/// Create a copy of PeerInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PeerInfoCopyWith<_PeerInfo> get copyWith => __$PeerInfoCopyWithImpl<_PeerInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PeerInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.username, username) || other.username == username)&&(identical(other.avatar, avatar) || other.avatar == avatar));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,username,avatar);

@override
String toString() {
  return 'PeerInfo(id: $id, username: $username, avatar: $avatar)';
}


}

/// @nodoc
abstract mixin class _$PeerInfoCopyWith<$Res> implements $PeerInfoCopyWith<$Res> {
  factory _$PeerInfoCopyWith(_PeerInfo value, $Res Function(_PeerInfo) _then) = __$PeerInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String username, String? avatar
});




}
/// @nodoc
class __$PeerInfoCopyWithImpl<$Res>
    implements _$PeerInfoCopyWith<$Res> {
  __$PeerInfoCopyWithImpl(this._self, this._then);

  final _PeerInfo _self;
  final $Res Function(_PeerInfo) _then;

/// Create a copy of PeerInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? username = null,Object? avatar = freezed,}) {
  return _then(_PeerInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,username: null == username ? _self.username : username // ignore: cast_nullable_to_non_nullable
as String,avatar: freezed == avatar ? _self.avatar : avatar // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$IncomingCall {

 String get callId; String get callerId; PeerInfo get callerInfo;
/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingCallCopyWith<IncomingCall> get copyWith => _$IncomingCallCopyWithImpl<IncomingCall>(this as IncomingCall, _$identity);

  /// Serializes this IncomingCall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerId, callerId) || other.callerId == callerId)&&(identical(other.callerInfo, callerInfo) || other.callerInfo == callerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,callerId,callerInfo);

@override
String toString() {
  return 'IncomingCall(callId: $callId, callerId: $callerId, callerInfo: $callerInfo)';
}


}

/// @nodoc
abstract mixin class $IncomingCallCopyWith<$Res>  {
  factory $IncomingCallCopyWith(IncomingCall value, $Res Function(IncomingCall) _then) = _$IncomingCallCopyWithImpl;
@useResult
$Res call({
 String callId, String callerId, PeerInfo callerInfo
});


$PeerInfoCopyWith<$Res> get callerInfo;

}
/// @nodoc
class _$IncomingCallCopyWithImpl<$Res>
    implements $IncomingCallCopyWith<$Res> {
  _$IncomingCallCopyWithImpl(this._self, this._then);

  final IncomingCall _self;
  final $Res Function(IncomingCall) _then;

/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? callerId = null,Object? callerInfo = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
as String,callerInfo: null == callerInfo ? _self.callerInfo : callerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,
  ));
}
/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get callerInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.callerInfo, (value) {
    return _then(_self.copyWith(callerInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [IncomingCall].
extension IncomingCallPatterns on IncomingCall {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IncomingCall value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IncomingCall value)  $default,){
final _that = this;
switch (_that) {
case _IncomingCall():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IncomingCall value)?  $default,){
final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String callerId,  PeerInfo callerInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
return $default(_that.callId,_that.callerId,_that.callerInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String callerId,  PeerInfo callerInfo)  $default,) {final _that = this;
switch (_that) {
case _IncomingCall():
return $default(_that.callId,_that.callerId,_that.callerInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String callerId,  PeerInfo callerInfo)?  $default,) {final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
return $default(_that.callId,_that.callerId,_that.callerInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomingCall implements IncomingCall {
  const _IncomingCall({required this.callId, required this.callerId, required this.callerInfo});
  factory _IncomingCall.fromJson(Map<String, dynamic> json) => _$IncomingCallFromJson(json);

@override final  String callId;
@override final  String callerId;
@override final  PeerInfo callerInfo;

/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IncomingCallCopyWith<_IncomingCall> get copyWith => __$IncomingCallCopyWithImpl<_IncomingCall>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IncomingCallToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.callerId, callerId) || other.callerId == callerId)&&(identical(other.callerInfo, callerInfo) || other.callerInfo == callerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,callerId,callerInfo);

@override
String toString() {
  return 'IncomingCall(callId: $callId, callerId: $callerId, callerInfo: $callerInfo)';
}


}

/// @nodoc
abstract mixin class _$IncomingCallCopyWith<$Res> implements $IncomingCallCopyWith<$Res> {
  factory _$IncomingCallCopyWith(_IncomingCall value, $Res Function(_IncomingCall) _then) = __$IncomingCallCopyWithImpl;
@override @useResult
$Res call({
 String callId, String callerId, PeerInfo callerInfo
});


@override $PeerInfoCopyWith<$Res> get callerInfo;

}
/// @nodoc
class __$IncomingCallCopyWithImpl<$Res>
    implements _$IncomingCallCopyWith<$Res> {
  __$IncomingCallCopyWithImpl(this._self, this._then);

  final _IncomingCall _self;
  final $Res Function(_IncomingCall) _then;

/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? callerId = null,Object? callerInfo = null,}) {
  return _then(_IncomingCall(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
as String,callerInfo: null == callerInfo ? _self.callerInfo : callerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,
  ));
}

/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get callerInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.callerInfo, (value) {
    return _then(_self.copyWith(callerInfo: value));
  });
}
}

// dart format on
