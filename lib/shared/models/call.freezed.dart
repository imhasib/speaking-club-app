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

 String get id; List<CallParticipant> get participants; CallParticipant get initiatedBy; DateTime get startedAt; DateTime? get endedAt; CallStatus get status; int? get duration;@JsonKey(name: 'callType') CallType get type;
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
 String id, List<CallParticipant> participants, CallParticipant initiatedBy, DateTime startedAt, DateTime? endedAt, CallStatus status, int? duration,@JsonKey(name: 'callType') CallType type
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration, @JsonKey(name: 'callType')  CallType type)?  $default,{required TResult orElse(),}) {final _that = this;
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration, @JsonKey(name: 'callType')  CallType type)  $default,) {final _that = this;
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<CallParticipant> participants,  CallParticipant initiatedBy,  DateTime startedAt,  DateTime? endedAt,  CallStatus status,  int? duration, @JsonKey(name: 'callType')  CallType type)?  $default,) {final _that = this;
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
  const _Call({required this.id, required final  List<CallParticipant> participants, required this.initiatedBy, required this.startedAt, this.endedAt, required this.status, this.duration, @JsonKey(name: 'callType') this.type = CallType.random}): _participants = participants,super._();
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
@override@JsonKey(name: 'callType') final  CallType type;

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
 String id, List<CallParticipant> participants, CallParticipant initiatedBy, DateTime startedAt, DateTime? endedAt, CallStatus status, int? duration,@JsonKey(name: 'callType') CallType type
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

 String get id; String get name; String? get profilePicture;
/// Create a copy of CallParticipant
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallParticipantCopyWith<CallParticipant> get copyWith => _$CallParticipantCopyWithImpl<CallParticipant>(this as CallParticipant, _$identity);

  /// Serializes this CallParticipant to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture);

@override
String toString() {
  return 'CallParticipant(id: $id, name: $name, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class $CallParticipantCopyWith<$Res>  {
  factory $CallParticipantCopyWith(CallParticipant value, $Res Function(CallParticipant) _then) = _$CallParticipantCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? profilePicture
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture)  $default,) {final _that = this;
switch (_that) {
case _CallParticipant():
return $default(_that.id,_that.name,_that.profilePicture);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? profilePicture)?  $default,) {final _that = this;
switch (_that) {
case _CallParticipant() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallParticipant implements CallParticipant {
  const _CallParticipant({required this.id, required this.name, this.profilePicture});
  factory _CallParticipant.fromJson(Map<String, dynamic> json) => _$CallParticipantFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? profilePicture;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallParticipant&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture);

@override
String toString() {
  return 'CallParticipant(id: $id, name: $name, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class _$CallParticipantCopyWith<$Res> implements $CallParticipantCopyWith<$Res> {
  factory _$CallParticipantCopyWith(_CallParticipant value, $Res Function(_CallParticipant) _then) = __$CallParticipantCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? profilePicture
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,}) {
  return _then(_CallParticipant(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
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
  const _MatchmakingResult({required this.callId, required this.dbCallId, required this.peerId, required this.peerInfo, this.initiator = false});
  factory _MatchmakingResult.fromJson(Map<String, dynamic> json) => _$MatchmakingResultFromJson(json);

@override final  String callId;
@override final  String dbCallId;
@override final  String peerId;
@override final  PeerInfo peerInfo;
@override@JsonKey() final  bool initiator;

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

 String get id; String get name; String? get profilePicture;
/// Create a copy of PeerInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<PeerInfo> get copyWith => _$PeerInfoCopyWithImpl<PeerInfo>(this as PeerInfo, _$identity);

  /// Serializes this PeerInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PeerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture);

@override
String toString() {
  return 'PeerInfo(id: $id, name: $name, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class $PeerInfoCopyWith<$Res>  {
  factory $PeerInfoCopyWith(PeerInfo value, $Res Function(PeerInfo) _then) = _$PeerInfoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? profilePicture
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? profilePicture)  $default,) {final _that = this;
switch (_that) {
case _PeerInfo():
return $default(_that.id,_that.name,_that.profilePicture);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? profilePicture)?  $default,) {final _that = this;
switch (_that) {
case _PeerInfo() when $default != null:
return $default(_that.id,_that.name,_that.profilePicture);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PeerInfo implements PeerInfo {
  const _PeerInfo({required this.id, required this.name, this.profilePicture});
  factory _PeerInfo.fromJson(Map<String, dynamic> json) => _$PeerInfoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? profilePicture;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PeerInfo&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profilePicture, profilePicture) || other.profilePicture == profilePicture));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,profilePicture);

@override
String toString() {
  return 'PeerInfo(id: $id, name: $name, profilePicture: $profilePicture)';
}


}

/// @nodoc
abstract mixin class _$PeerInfoCopyWith<$Res> implements $PeerInfoCopyWith<$Res> {
  factory _$PeerInfoCopyWith(_PeerInfo value, $Res Function(_PeerInfo) _then) = __$PeerInfoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? profilePicture
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profilePicture = freezed,}) {
  return _then(_PeerInfo(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profilePicture: freezed == profilePicture ? _self.profilePicture : profilePicture // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$IncomingCall {

 String get callId; String? get dbCallId; String get callerId; PeerInfo get callerInfo;
/// Create a copy of IncomingCall
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IncomingCallCopyWith<IncomingCall> get copyWith => _$IncomingCallCopyWithImpl<IncomingCall>(this as IncomingCall, _$identity);

  /// Serializes this IncomingCall to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IncomingCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.callerId, callerId) || other.callerId == callerId)&&(identical(other.callerInfo, callerInfo) || other.callerInfo == callerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,callerId,callerInfo);

@override
String toString() {
  return 'IncomingCall(callId: $callId, dbCallId: $dbCallId, callerId: $callerId, callerInfo: $callerInfo)';
}


}

/// @nodoc
abstract mixin class $IncomingCallCopyWith<$Res>  {
  factory $IncomingCallCopyWith(IncomingCall value, $Res Function(IncomingCall) _then) = _$IncomingCallCopyWithImpl;
@useResult
$Res call({
 String callId, String? dbCallId, String callerId, PeerInfo callerInfo
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
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? dbCallId = freezed,Object? callerId = null,Object? callerInfo = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: freezed == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String?,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String? dbCallId,  String callerId,  PeerInfo callerInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.callerId,_that.callerInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String? dbCallId,  String callerId,  PeerInfo callerInfo)  $default,) {final _that = this;
switch (_that) {
case _IncomingCall():
return $default(_that.callId,_that.dbCallId,_that.callerId,_that.callerInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String? dbCallId,  String callerId,  PeerInfo callerInfo)?  $default,) {final _that = this;
switch (_that) {
case _IncomingCall() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.callerId,_that.callerInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IncomingCall implements IncomingCall {
  const _IncomingCall({required this.callId, this.dbCallId, required this.callerId, required this.callerInfo});
  factory _IncomingCall.fromJson(Map<String, dynamic> json) => _$IncomingCallFromJson(json);

@override final  String callId;
@override final  String? dbCallId;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IncomingCall&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.callerId, callerId) || other.callerId == callerId)&&(identical(other.callerInfo, callerInfo) || other.callerInfo == callerInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,callerId,callerInfo);

@override
String toString() {
  return 'IncomingCall(callId: $callId, dbCallId: $dbCallId, callerId: $callerId, callerInfo: $callerInfo)';
}


}

/// @nodoc
abstract mixin class _$IncomingCallCopyWith<$Res> implements $IncomingCallCopyWith<$Res> {
  factory _$IncomingCallCopyWith(_IncomingCall value, $Res Function(_IncomingCall) _then) = __$IncomingCallCopyWithImpl;
@override @useResult
$Res call({
 String callId, String? dbCallId, String callerId, PeerInfo callerInfo
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
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? dbCallId = freezed,Object? callerId = null,Object? callerInfo = null,}) {
  return _then(_IncomingCall(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: freezed == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String?,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
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


/// @nodoc
mixin _$CallAccepted {

 String get callId; String get dbCallId; PeerInfo get recipientInfo;
/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallAcceptedCopyWith<CallAccepted> get copyWith => _$CallAcceptedCopyWithImpl<CallAccepted>(this as CallAccepted, _$identity);

  /// Serializes this CallAccepted to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallAccepted&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.recipientInfo, recipientInfo) || other.recipientInfo == recipientInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,recipientInfo);

@override
String toString() {
  return 'CallAccepted(callId: $callId, dbCallId: $dbCallId, recipientInfo: $recipientInfo)';
}


}

/// @nodoc
abstract mixin class $CallAcceptedCopyWith<$Res>  {
  factory $CallAcceptedCopyWith(CallAccepted value, $Res Function(CallAccepted) _then) = _$CallAcceptedCopyWithImpl;
@useResult
$Res call({
 String callId, String dbCallId, PeerInfo recipientInfo
});


$PeerInfoCopyWith<$Res> get recipientInfo;

}
/// @nodoc
class _$CallAcceptedCopyWithImpl<$Res>
    implements $CallAcceptedCopyWith<$Res> {
  _$CallAcceptedCopyWithImpl(this._self, this._then);

  final CallAccepted _self;
  final $Res Function(CallAccepted) _then;

/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? dbCallId = null,Object? recipientInfo = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: null == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String,recipientInfo: null == recipientInfo ? _self.recipientInfo : recipientInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,
  ));
}
/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get recipientInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.recipientInfo, (value) {
    return _then(_self.copyWith(recipientInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallAccepted].
extension CallAcceptedPatterns on CallAccepted {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallAccepted value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallAccepted() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallAccepted value)  $default,){
final _that = this;
switch (_that) {
case _CallAccepted():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallAccepted value)?  $default,){
final _that = this;
switch (_that) {
case _CallAccepted() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String dbCallId,  PeerInfo recipientInfo)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallAccepted() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.recipientInfo);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String dbCallId,  PeerInfo recipientInfo)  $default,) {final _that = this;
switch (_that) {
case _CallAccepted():
return $default(_that.callId,_that.dbCallId,_that.recipientInfo);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String dbCallId,  PeerInfo recipientInfo)?  $default,) {final _that = this;
switch (_that) {
case _CallAccepted() when $default != null:
return $default(_that.callId,_that.dbCallId,_that.recipientInfo);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallAccepted implements CallAccepted {
  const _CallAccepted({required this.callId, required this.dbCallId, required this.recipientInfo});
  factory _CallAccepted.fromJson(Map<String, dynamic> json) => _$CallAcceptedFromJson(json);

@override final  String callId;
@override final  String dbCallId;
@override final  PeerInfo recipientInfo;

/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallAcceptedCopyWith<_CallAccepted> get copyWith => __$CallAcceptedCopyWithImpl<_CallAccepted>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallAcceptedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallAccepted&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.recipientInfo, recipientInfo) || other.recipientInfo == recipientInfo));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,dbCallId,recipientInfo);

@override
String toString() {
  return 'CallAccepted(callId: $callId, dbCallId: $dbCallId, recipientInfo: $recipientInfo)';
}


}

/// @nodoc
abstract mixin class _$CallAcceptedCopyWith<$Res> implements $CallAcceptedCopyWith<$Res> {
  factory _$CallAcceptedCopyWith(_CallAccepted value, $Res Function(_CallAccepted) _then) = __$CallAcceptedCopyWithImpl;
@override @useResult
$Res call({
 String callId, String dbCallId, PeerInfo recipientInfo
});


@override $PeerInfoCopyWith<$Res> get recipientInfo;

}
/// @nodoc
class __$CallAcceptedCopyWithImpl<$Res>
    implements _$CallAcceptedCopyWith<$Res> {
  __$CallAcceptedCopyWithImpl(this._self, this._then);

  final _CallAccepted _self;
  final $Res Function(_CallAccepted) _then;

/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? dbCallId = null,Object? recipientInfo = null,}) {
  return _then(_CallAccepted(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,dbCallId: null == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String,recipientInfo: null == recipientInfo ? _self.recipientInfo : recipientInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo,
  ));
}

/// Create a copy of CallAccepted
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res> get recipientInfo {
  
  return $PeerInfoCopyWith<$Res>(_self.recipientInfo, (value) {
    return _then(_self.copyWith(recipientInfo: value));
  });
}
}


/// @nodoc
mixin _$CallRejected {

 String get callId; String get reason;
/// Create a copy of CallRejected
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallRejectedCopyWith<CallRejected> get copyWith => _$CallRejectedCopyWithImpl<CallRejected>(this as CallRejected, _$identity);

  /// Serializes this CallRejected to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallRejected&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,reason);

@override
String toString() {
  return 'CallRejected(callId: $callId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CallRejectedCopyWith<$Res>  {
  factory $CallRejectedCopyWith(CallRejected value, $Res Function(CallRejected) _then) = _$CallRejectedCopyWithImpl;
@useResult
$Res call({
 String callId, String reason
});




}
/// @nodoc
class _$CallRejectedCopyWithImpl<$Res>
    implements $CallRejectedCopyWith<$Res> {
  _$CallRejectedCopyWithImpl(this._self, this._then);

  final CallRejected _self;
  final $Res Function(CallRejected) _then;

/// Create a copy of CallRejected
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? reason = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallRejected].
extension CallRejectedPatterns on CallRejected {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallRejected value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallRejected() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallRejected value)  $default,){
final _that = this;
switch (_that) {
case _CallRejected():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallRejected value)?  $default,){
final _that = this;
switch (_that) {
case _CallRejected() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallRejected() when $default != null:
return $default(_that.callId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String reason)  $default,) {final _that = this;
switch (_that) {
case _CallRejected():
return $default(_that.callId,_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _CallRejected() when $default != null:
return $default(_that.callId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallRejected implements CallRejected {
  const _CallRejected({required this.callId, required this.reason});
  factory _CallRejected.fromJson(Map<String, dynamic> json) => _$CallRejectedFromJson(json);

@override final  String callId;
@override final  String reason;

/// Create a copy of CallRejected
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallRejectedCopyWith<_CallRejected> get copyWith => __$CallRejectedCopyWithImpl<_CallRejected>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallRejectedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallRejected&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,reason);

@override
String toString() {
  return 'CallRejected(callId: $callId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CallRejectedCopyWith<$Res> implements $CallRejectedCopyWith<$Res> {
  factory _$CallRejectedCopyWith(_CallRejected value, $Res Function(_CallRejected) _then) = __$CallRejectedCopyWithImpl;
@override @useResult
$Res call({
 String callId, String reason
});




}
/// @nodoc
class __$CallRejectedCopyWithImpl<$Res>
    implements _$CallRejectedCopyWith<$Res> {
  __$CallRejectedCopyWithImpl(this._self, this._then);

  final _CallRejected _self;
  final $Res Function(_CallRejected) _then;

/// Create a copy of CallRejected
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? reason = null,}) {
  return _then(_CallRejected(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CallCancelled {

 String get callId; String get reason;
/// Create a copy of CallCancelled
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallCancelledCopyWith<CallCancelled> get copyWith => _$CallCancelledCopyWithImpl<CallCancelled>(this as CallCancelled, _$identity);

  /// Serializes this CallCancelled to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallCancelled&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,reason);

@override
String toString() {
  return 'CallCancelled(callId: $callId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CallCancelledCopyWith<$Res>  {
  factory $CallCancelledCopyWith(CallCancelled value, $Res Function(CallCancelled) _then) = _$CallCancelledCopyWithImpl;
@useResult
$Res call({
 String callId, String reason
});




}
/// @nodoc
class _$CallCancelledCopyWithImpl<$Res>
    implements $CallCancelledCopyWith<$Res> {
  _$CallCancelledCopyWithImpl(this._self, this._then);

  final CallCancelled _self;
  final $Res Function(CallCancelled) _then;

/// Create a copy of CallCancelled
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? callId = null,Object? reason = null,}) {
  return _then(_self.copyWith(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallCancelled].
extension CallCancelledPatterns on CallCancelled {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallCancelled value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallCancelled() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallCancelled value)  $default,){
final _that = this;
switch (_that) {
case _CallCancelled():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallCancelled value)?  $default,){
final _that = this;
switch (_that) {
case _CallCancelled() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String callId,  String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallCancelled() when $default != null:
return $default(_that.callId,_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String callId,  String reason)  $default,) {final _that = this;
switch (_that) {
case _CallCancelled():
return $default(_that.callId,_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String callId,  String reason)?  $default,) {final _that = this;
switch (_that) {
case _CallCancelled() when $default != null:
return $default(_that.callId,_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallCancelled implements CallCancelled {
  const _CallCancelled({required this.callId, required this.reason});
  factory _CallCancelled.fromJson(Map<String, dynamic> json) => _$CallCancelledFromJson(json);

@override final  String callId;
@override final  String reason;

/// Create a copy of CallCancelled
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallCancelledCopyWith<_CallCancelled> get copyWith => __$CallCancelledCopyWithImpl<_CallCancelled>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallCancelledToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallCancelled&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,callId,reason);

@override
String toString() {
  return 'CallCancelled(callId: $callId, reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CallCancelledCopyWith<$Res> implements $CallCancelledCopyWith<$Res> {
  factory _$CallCancelledCopyWith(_CallCancelled value, $Res Function(_CallCancelled) _then) = __$CallCancelledCopyWithImpl;
@override @useResult
$Res call({
 String callId, String reason
});




}
/// @nodoc
class __$CallCancelledCopyWithImpl<$Res>
    implements _$CallCancelledCopyWith<$Res> {
  __$CallCancelledCopyWithImpl(this._self, this._then);

  final _CallCancelled _self;
  final $Res Function(_CallCancelled) _then;

/// Create a copy of CallCancelled
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? callId = null,Object? reason = null,}) {
  return _then(_CallCancelled(
callId: null == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$CallEnded {

 String get reason;
/// Create a copy of CallEnded
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallEndedCopyWith<CallEnded> get copyWith => _$CallEndedCopyWithImpl<CallEnded>(this as CallEnded, _$identity);

  /// Serializes this CallEnded to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallEnded&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CallEnded(reason: $reason)';
}


}

/// @nodoc
abstract mixin class $CallEndedCopyWith<$Res>  {
  factory $CallEndedCopyWith(CallEnded value, $Res Function(CallEnded) _then) = _$CallEndedCopyWithImpl;
@useResult
$Res call({
 String reason
});




}
/// @nodoc
class _$CallEndedCopyWithImpl<$Res>
    implements $CallEndedCopyWith<$Res> {
  _$CallEndedCopyWithImpl(this._self, this._then);

  final CallEnded _self;
  final $Res Function(CallEnded) _then;

/// Create a copy of CallEnded
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? reason = null,}) {
  return _then(_self.copyWith(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [CallEnded].
extension CallEndedPatterns on CallEnded {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallEnded value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallEnded() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallEnded value)  $default,){
final _that = this;
switch (_that) {
case _CallEnded():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallEnded value)?  $default,){
final _that = this;
switch (_that) {
case _CallEnded() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String reason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallEnded() when $default != null:
return $default(_that.reason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String reason)  $default,) {final _that = this;
switch (_that) {
case _CallEnded():
return $default(_that.reason);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String reason)?  $default,) {final _that = this;
switch (_that) {
case _CallEnded() when $default != null:
return $default(_that.reason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CallEnded implements CallEnded {
  const _CallEnded({required this.reason});
  factory _CallEnded.fromJson(Map<String, dynamic> json) => _$CallEndedFromJson(json);

@override final  String reason;

/// Create a copy of CallEnded
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallEndedCopyWith<_CallEnded> get copyWith => __$CallEndedCopyWithImpl<_CallEnded>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CallEndedToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallEnded&&(identical(other.reason, reason) || other.reason == reason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,reason);

@override
String toString() {
  return 'CallEnded(reason: $reason)';
}


}

/// @nodoc
abstract mixin class _$CallEndedCopyWith<$Res> implements $CallEndedCopyWith<$Res> {
  factory _$CallEndedCopyWith(_CallEnded value, $Res Function(_CallEnded) _then) = __$CallEndedCopyWithImpl;
@override @useResult
$Res call({
 String reason
});




}
/// @nodoc
class __$CallEndedCopyWithImpl<$Res>
    implements _$CallEndedCopyWith<$Res> {
  __$CallEndedCopyWithImpl(this._self, this._then);

  final _CallEnded _self;
  final $Res Function(_CallEnded) _then;

/// Create a copy of CallEnded
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? reason = null,}) {
  return _then(_CallEnded(
reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RTCSessionDesc {

 String get type;// 'offer' or 'answer'
 String get sdp;
/// Create a copy of RTCSessionDesc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RTCSessionDescCopyWith<RTCSessionDesc> get copyWith => _$RTCSessionDescCopyWithImpl<RTCSessionDesc>(this as RTCSessionDesc, _$identity);

  /// Serializes this RTCSessionDesc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RTCSessionDesc&&(identical(other.type, type) || other.type == type)&&(identical(other.sdp, sdp) || other.sdp == sdp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sdp);

@override
String toString() {
  return 'RTCSessionDesc(type: $type, sdp: $sdp)';
}


}

/// @nodoc
abstract mixin class $RTCSessionDescCopyWith<$Res>  {
  factory $RTCSessionDescCopyWith(RTCSessionDesc value, $Res Function(RTCSessionDesc) _then) = _$RTCSessionDescCopyWithImpl;
@useResult
$Res call({
 String type, String sdp
});




}
/// @nodoc
class _$RTCSessionDescCopyWithImpl<$Res>
    implements $RTCSessionDescCopyWith<$Res> {
  _$RTCSessionDescCopyWithImpl(this._self, this._then);

  final RTCSessionDesc _self;
  final $Res Function(RTCSessionDesc) _then;

/// Create a copy of RTCSessionDesc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? sdp = null,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sdp: null == sdp ? _self.sdp : sdp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [RTCSessionDesc].
extension RTCSessionDescPatterns on RTCSessionDesc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RTCSessionDesc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RTCSessionDesc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RTCSessionDesc value)  $default,){
final _that = this;
switch (_that) {
case _RTCSessionDesc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RTCSessionDesc value)?  $default,){
final _that = this;
switch (_that) {
case _RTCSessionDesc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String sdp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RTCSessionDesc() when $default != null:
return $default(_that.type,_that.sdp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String sdp)  $default,) {final _that = this;
switch (_that) {
case _RTCSessionDesc():
return $default(_that.type,_that.sdp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String sdp)?  $default,) {final _that = this;
switch (_that) {
case _RTCSessionDesc() when $default != null:
return $default(_that.type,_that.sdp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RTCSessionDesc implements RTCSessionDesc {
  const _RTCSessionDesc({required this.type, required this.sdp});
  factory _RTCSessionDesc.fromJson(Map<String, dynamic> json) => _$RTCSessionDescFromJson(json);

@override final  String type;
// 'offer' or 'answer'
@override final  String sdp;

/// Create a copy of RTCSessionDesc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RTCSessionDescCopyWith<_RTCSessionDesc> get copyWith => __$RTCSessionDescCopyWithImpl<_RTCSessionDesc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RTCSessionDescToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RTCSessionDesc&&(identical(other.type, type) || other.type == type)&&(identical(other.sdp, sdp) || other.sdp == sdp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,sdp);

@override
String toString() {
  return 'RTCSessionDesc(type: $type, sdp: $sdp)';
}


}

/// @nodoc
abstract mixin class _$RTCSessionDescCopyWith<$Res> implements $RTCSessionDescCopyWith<$Res> {
  factory _$RTCSessionDescCopyWith(_RTCSessionDesc value, $Res Function(_RTCSessionDesc) _then) = __$RTCSessionDescCopyWithImpl;
@override @useResult
$Res call({
 String type, String sdp
});




}
/// @nodoc
class __$RTCSessionDescCopyWithImpl<$Res>
    implements _$RTCSessionDescCopyWith<$Res> {
  __$RTCSessionDescCopyWithImpl(this._self, this._then);

  final _RTCSessionDesc _self;
  final $Res Function(_RTCSessionDesc) _then;

/// Create a copy of RTCSessionDesc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? sdp = null,}) {
  return _then(_RTCSessionDesc(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,sdp: null == sdp ? _self.sdp : sdp // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$RTCOfferSignal {

 String get from; RTCSessionDesc get offer;
/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RTCOfferSignalCopyWith<RTCOfferSignal> get copyWith => _$RTCOfferSignalCopyWithImpl<RTCOfferSignal>(this as RTCOfferSignal, _$identity);

  /// Serializes this RTCOfferSignal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RTCOfferSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.offer, offer) || other.offer == offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,offer);

@override
String toString() {
  return 'RTCOfferSignal(from: $from, offer: $offer)';
}


}

/// @nodoc
abstract mixin class $RTCOfferSignalCopyWith<$Res>  {
  factory $RTCOfferSignalCopyWith(RTCOfferSignal value, $Res Function(RTCOfferSignal) _then) = _$RTCOfferSignalCopyWithImpl;
@useResult
$Res call({
 String from, RTCSessionDesc offer
});


$RTCSessionDescCopyWith<$Res> get offer;

}
/// @nodoc
class _$RTCOfferSignalCopyWithImpl<$Res>
    implements $RTCOfferSignalCopyWith<$Res> {
  _$RTCOfferSignalCopyWithImpl(this._self, this._then);

  final RTCOfferSignal _self;
  final $Res Function(RTCOfferSignal) _then;

/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? offer = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as RTCSessionDesc,
  ));
}
/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RTCSessionDescCopyWith<$Res> get offer {
  
  return $RTCSessionDescCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}


/// Adds pattern-matching-related methods to [RTCOfferSignal].
extension RTCOfferSignalPatterns on RTCOfferSignal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RTCOfferSignal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RTCOfferSignal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RTCOfferSignal value)  $default,){
final _that = this;
switch (_that) {
case _RTCOfferSignal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RTCOfferSignal value)?  $default,){
final _that = this;
switch (_that) {
case _RTCOfferSignal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  RTCSessionDesc offer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RTCOfferSignal() when $default != null:
return $default(_that.from,_that.offer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  RTCSessionDesc offer)  $default,) {final _that = this;
switch (_that) {
case _RTCOfferSignal():
return $default(_that.from,_that.offer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  RTCSessionDesc offer)?  $default,) {final _that = this;
switch (_that) {
case _RTCOfferSignal() when $default != null:
return $default(_that.from,_that.offer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RTCOfferSignal implements RTCOfferSignal {
  const _RTCOfferSignal({required this.from, required this.offer});
  factory _RTCOfferSignal.fromJson(Map<String, dynamic> json) => _$RTCOfferSignalFromJson(json);

@override final  String from;
@override final  RTCSessionDesc offer;

/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RTCOfferSignalCopyWith<_RTCOfferSignal> get copyWith => __$RTCOfferSignalCopyWithImpl<_RTCOfferSignal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RTCOfferSignalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RTCOfferSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.offer, offer) || other.offer == offer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,offer);

@override
String toString() {
  return 'RTCOfferSignal(from: $from, offer: $offer)';
}


}

/// @nodoc
abstract mixin class _$RTCOfferSignalCopyWith<$Res> implements $RTCOfferSignalCopyWith<$Res> {
  factory _$RTCOfferSignalCopyWith(_RTCOfferSignal value, $Res Function(_RTCOfferSignal) _then) = __$RTCOfferSignalCopyWithImpl;
@override @useResult
$Res call({
 String from, RTCSessionDesc offer
});


@override $RTCSessionDescCopyWith<$Res> get offer;

}
/// @nodoc
class __$RTCOfferSignalCopyWithImpl<$Res>
    implements _$RTCOfferSignalCopyWith<$Res> {
  __$RTCOfferSignalCopyWithImpl(this._self, this._then);

  final _RTCOfferSignal _self;
  final $Res Function(_RTCOfferSignal) _then;

/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? offer = null,}) {
  return _then(_RTCOfferSignal(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,offer: null == offer ? _self.offer : offer // ignore: cast_nullable_to_non_nullable
as RTCSessionDesc,
  ));
}

/// Create a copy of RTCOfferSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RTCSessionDescCopyWith<$Res> get offer {
  
  return $RTCSessionDescCopyWith<$Res>(_self.offer, (value) {
    return _then(_self.copyWith(offer: value));
  });
}
}


/// @nodoc
mixin _$RTCAnswerSignal {

 String get from; RTCSessionDesc get answer;
/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RTCAnswerSignalCopyWith<RTCAnswerSignal> get copyWith => _$RTCAnswerSignalCopyWithImpl<RTCAnswerSignal>(this as RTCAnswerSignal, _$identity);

  /// Serializes this RTCAnswerSignal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RTCAnswerSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,answer);

@override
String toString() {
  return 'RTCAnswerSignal(from: $from, answer: $answer)';
}


}

/// @nodoc
abstract mixin class $RTCAnswerSignalCopyWith<$Res>  {
  factory $RTCAnswerSignalCopyWith(RTCAnswerSignal value, $Res Function(RTCAnswerSignal) _then) = _$RTCAnswerSignalCopyWithImpl;
@useResult
$Res call({
 String from, RTCSessionDesc answer
});


$RTCSessionDescCopyWith<$Res> get answer;

}
/// @nodoc
class _$RTCAnswerSignalCopyWithImpl<$Res>
    implements $RTCAnswerSignalCopyWith<$Res> {
  _$RTCAnswerSignalCopyWithImpl(this._self, this._then);

  final RTCAnswerSignal _self;
  final $Res Function(RTCAnswerSignal) _then;

/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? answer = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as RTCSessionDesc,
  ));
}
/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RTCSessionDescCopyWith<$Res> get answer {
  
  return $RTCSessionDescCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}


/// Adds pattern-matching-related methods to [RTCAnswerSignal].
extension RTCAnswerSignalPatterns on RTCAnswerSignal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RTCAnswerSignal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RTCAnswerSignal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RTCAnswerSignal value)  $default,){
final _that = this;
switch (_that) {
case _RTCAnswerSignal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RTCAnswerSignal value)?  $default,){
final _that = this;
switch (_that) {
case _RTCAnswerSignal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  RTCSessionDesc answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RTCAnswerSignal() when $default != null:
return $default(_that.from,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  RTCSessionDesc answer)  $default,) {final _that = this;
switch (_that) {
case _RTCAnswerSignal():
return $default(_that.from,_that.answer);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  RTCSessionDesc answer)?  $default,) {final _that = this;
switch (_that) {
case _RTCAnswerSignal() when $default != null:
return $default(_that.from,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RTCAnswerSignal implements RTCAnswerSignal {
  const _RTCAnswerSignal({required this.from, required this.answer});
  factory _RTCAnswerSignal.fromJson(Map<String, dynamic> json) => _$RTCAnswerSignalFromJson(json);

@override final  String from;
@override final  RTCSessionDesc answer;

/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RTCAnswerSignalCopyWith<_RTCAnswerSignal> get copyWith => __$RTCAnswerSignalCopyWithImpl<_RTCAnswerSignal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RTCAnswerSignalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RTCAnswerSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,answer);

@override
String toString() {
  return 'RTCAnswerSignal(from: $from, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$RTCAnswerSignalCopyWith<$Res> implements $RTCAnswerSignalCopyWith<$Res> {
  factory _$RTCAnswerSignalCopyWith(_RTCAnswerSignal value, $Res Function(_RTCAnswerSignal) _then) = __$RTCAnswerSignalCopyWithImpl;
@override @useResult
$Res call({
 String from, RTCSessionDesc answer
});


@override $RTCSessionDescCopyWith<$Res> get answer;

}
/// @nodoc
class __$RTCAnswerSignalCopyWithImpl<$Res>
    implements _$RTCAnswerSignalCopyWith<$Res> {
  __$RTCAnswerSignalCopyWithImpl(this._self, this._then);

  final _RTCAnswerSignal _self;
  final $Res Function(_RTCAnswerSignal) _then;

/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? answer = null,}) {
  return _then(_RTCAnswerSignal(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as RTCSessionDesc,
  ));
}

/// Create a copy of RTCAnswerSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RTCSessionDescCopyWith<$Res> get answer {
  
  return $RTCSessionDescCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}


/// @nodoc
mixin _$IceCandidateData {

 String get candidate; String? get sdpMid; int? get sdpMLineIndex;
/// Create a copy of IceCandidateData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IceCandidateDataCopyWith<IceCandidateData> get copyWith => _$IceCandidateDataCopyWithImpl<IceCandidateData>(this as IceCandidateData, _$identity);

  /// Serializes this IceCandidateData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is IceCandidateData&&(identical(other.candidate, candidate) || other.candidate == candidate)&&(identical(other.sdpMid, sdpMid) || other.sdpMid == sdpMid)&&(identical(other.sdpMLineIndex, sdpMLineIndex) || other.sdpMLineIndex == sdpMLineIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,candidate,sdpMid,sdpMLineIndex);

@override
String toString() {
  return 'IceCandidateData(candidate: $candidate, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex)';
}


}

/// @nodoc
abstract mixin class $IceCandidateDataCopyWith<$Res>  {
  factory $IceCandidateDataCopyWith(IceCandidateData value, $Res Function(IceCandidateData) _then) = _$IceCandidateDataCopyWithImpl;
@useResult
$Res call({
 String candidate, String? sdpMid, int? sdpMLineIndex
});




}
/// @nodoc
class _$IceCandidateDataCopyWithImpl<$Res>
    implements $IceCandidateDataCopyWith<$Res> {
  _$IceCandidateDataCopyWithImpl(this._self, this._then);

  final IceCandidateData _self;
  final $Res Function(IceCandidateData) _then;

/// Create a copy of IceCandidateData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? candidate = null,Object? sdpMid = freezed,Object? sdpMLineIndex = freezed,}) {
  return _then(_self.copyWith(
candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as String,sdpMid: freezed == sdpMid ? _self.sdpMid : sdpMid // ignore: cast_nullable_to_non_nullable
as String?,sdpMLineIndex: freezed == sdpMLineIndex ? _self.sdpMLineIndex : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [IceCandidateData].
extension IceCandidateDataPatterns on IceCandidateData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _IceCandidateData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _IceCandidateData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _IceCandidateData value)  $default,){
final _that = this;
switch (_that) {
case _IceCandidateData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _IceCandidateData value)?  $default,){
final _that = this;
switch (_that) {
case _IceCandidateData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String candidate,  String? sdpMid,  int? sdpMLineIndex)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _IceCandidateData() when $default != null:
return $default(_that.candidate,_that.sdpMid,_that.sdpMLineIndex);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String candidate,  String? sdpMid,  int? sdpMLineIndex)  $default,) {final _that = this;
switch (_that) {
case _IceCandidateData():
return $default(_that.candidate,_that.sdpMid,_that.sdpMLineIndex);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String candidate,  String? sdpMid,  int? sdpMLineIndex)?  $default,) {final _that = this;
switch (_that) {
case _IceCandidateData() when $default != null:
return $default(_that.candidate,_that.sdpMid,_that.sdpMLineIndex);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _IceCandidateData implements IceCandidateData {
  const _IceCandidateData({required this.candidate, this.sdpMid, this.sdpMLineIndex});
  factory _IceCandidateData.fromJson(Map<String, dynamic> json) => _$IceCandidateDataFromJson(json);

@override final  String candidate;
@override final  String? sdpMid;
@override final  int? sdpMLineIndex;

/// Create a copy of IceCandidateData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IceCandidateDataCopyWith<_IceCandidateData> get copyWith => __$IceCandidateDataCopyWithImpl<_IceCandidateData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IceCandidateDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _IceCandidateData&&(identical(other.candidate, candidate) || other.candidate == candidate)&&(identical(other.sdpMid, sdpMid) || other.sdpMid == sdpMid)&&(identical(other.sdpMLineIndex, sdpMLineIndex) || other.sdpMLineIndex == sdpMLineIndex));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,candidate,sdpMid,sdpMLineIndex);

@override
String toString() {
  return 'IceCandidateData(candidate: $candidate, sdpMid: $sdpMid, sdpMLineIndex: $sdpMLineIndex)';
}


}

/// @nodoc
abstract mixin class _$IceCandidateDataCopyWith<$Res> implements $IceCandidateDataCopyWith<$Res> {
  factory _$IceCandidateDataCopyWith(_IceCandidateData value, $Res Function(_IceCandidateData) _then) = __$IceCandidateDataCopyWithImpl;
@override @useResult
$Res call({
 String candidate, String? sdpMid, int? sdpMLineIndex
});




}
/// @nodoc
class __$IceCandidateDataCopyWithImpl<$Res>
    implements _$IceCandidateDataCopyWith<$Res> {
  __$IceCandidateDataCopyWithImpl(this._self, this._then);

  final _IceCandidateData _self;
  final $Res Function(_IceCandidateData) _then;

/// Create a copy of IceCandidateData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? candidate = null,Object? sdpMid = freezed,Object? sdpMLineIndex = freezed,}) {
  return _then(_IceCandidateData(
candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as String,sdpMid: freezed == sdpMid ? _self.sdpMid : sdpMid // ignore: cast_nullable_to_non_nullable
as String?,sdpMLineIndex: freezed == sdpMLineIndex ? _self.sdpMLineIndex : sdpMLineIndex // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$RTCIceSignal {

 String get from; IceCandidateData get candidate;
/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RTCIceSignalCopyWith<RTCIceSignal> get copyWith => _$RTCIceSignalCopyWithImpl<RTCIceSignal>(this as RTCIceSignal, _$identity);

  /// Serializes this RTCIceSignal to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RTCIceSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.candidate, candidate) || other.candidate == candidate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,candidate);

@override
String toString() {
  return 'RTCIceSignal(from: $from, candidate: $candidate)';
}


}

/// @nodoc
abstract mixin class $RTCIceSignalCopyWith<$Res>  {
  factory $RTCIceSignalCopyWith(RTCIceSignal value, $Res Function(RTCIceSignal) _then) = _$RTCIceSignalCopyWithImpl;
@useResult
$Res call({
 String from, IceCandidateData candidate
});


$IceCandidateDataCopyWith<$Res> get candidate;

}
/// @nodoc
class _$RTCIceSignalCopyWithImpl<$Res>
    implements $RTCIceSignalCopyWith<$Res> {
  _$RTCIceSignalCopyWithImpl(this._self, this._then);

  final RTCIceSignal _self;
  final $Res Function(RTCIceSignal) _then;

/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? from = null,Object? candidate = null,}) {
  return _then(_self.copyWith(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as IceCandidateData,
  ));
}
/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IceCandidateDataCopyWith<$Res> get candidate {
  
  return $IceCandidateDataCopyWith<$Res>(_self.candidate, (value) {
    return _then(_self.copyWith(candidate: value));
  });
}
}


/// Adds pattern-matching-related methods to [RTCIceSignal].
extension RTCIceSignalPatterns on RTCIceSignal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RTCIceSignal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RTCIceSignal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RTCIceSignal value)  $default,){
final _that = this;
switch (_that) {
case _RTCIceSignal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RTCIceSignal value)?  $default,){
final _that = this;
switch (_that) {
case _RTCIceSignal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String from,  IceCandidateData candidate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RTCIceSignal() when $default != null:
return $default(_that.from,_that.candidate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String from,  IceCandidateData candidate)  $default,) {final _that = this;
switch (_that) {
case _RTCIceSignal():
return $default(_that.from,_that.candidate);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String from,  IceCandidateData candidate)?  $default,) {final _that = this;
switch (_that) {
case _RTCIceSignal() when $default != null:
return $default(_that.from,_that.candidate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RTCIceSignal implements RTCIceSignal {
  const _RTCIceSignal({required this.from, required this.candidate});
  factory _RTCIceSignal.fromJson(Map<String, dynamic> json) => _$RTCIceSignalFromJson(json);

@override final  String from;
@override final  IceCandidateData candidate;

/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RTCIceSignalCopyWith<_RTCIceSignal> get copyWith => __$RTCIceSignalCopyWithImpl<_RTCIceSignal>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RTCIceSignalToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RTCIceSignal&&(identical(other.from, from) || other.from == from)&&(identical(other.candidate, candidate) || other.candidate == candidate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,from,candidate);

@override
String toString() {
  return 'RTCIceSignal(from: $from, candidate: $candidate)';
}


}

/// @nodoc
abstract mixin class _$RTCIceSignalCopyWith<$Res> implements $RTCIceSignalCopyWith<$Res> {
  factory _$RTCIceSignalCopyWith(_RTCIceSignal value, $Res Function(_RTCIceSignal) _then) = __$RTCIceSignalCopyWithImpl;
@override @useResult
$Res call({
 String from, IceCandidateData candidate
});


@override $IceCandidateDataCopyWith<$Res> get candidate;

}
/// @nodoc
class __$RTCIceSignalCopyWithImpl<$Res>
    implements _$RTCIceSignalCopyWith<$Res> {
  __$RTCIceSignalCopyWithImpl(this._self, this._then);

  final _RTCIceSignal _self;
  final $Res Function(_RTCIceSignal) _then;

/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? from = null,Object? candidate = null,}) {
  return _then(_RTCIceSignal(
from: null == from ? _self.from : from // ignore: cast_nullable_to_non_nullable
as String,candidate: null == candidate ? _self.candidate : candidate // ignore: cast_nullable_to_non_nullable
as IceCandidateData,
  ));
}

/// Create a copy of RTCIceSignal
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$IceCandidateDataCopyWith<$Res> get candidate {
  
  return $IceCandidateDataCopyWith<$Res>(_self.candidate, (value) {
    return _then(_self.copyWith(candidate: value));
  });
}
}

// dart format on
