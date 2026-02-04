// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallState {

 CallPhase get phase; String? get callId; String? get dbCallId; PeerInfo? get peerInfo; bool get isInitiator; CallType get callType; WebRTCConnectionState get rtcState;// Media state
 bool get isAudioMuted; bool get isVideoEnabled; bool get isSpeakerOn; bool get isFrontCamera;// Call timing
 DateTime? get callStartTime; int get callDurationSeconds;// Error handling
 String? get error;
/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallStateCopyWith<CallState> get copyWith => _$CallStateCopyWithImpl<CallState>(this as CallState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.peerInfo, peerInfo) || other.peerInfo == peerInfo)&&(identical(other.isInitiator, isInitiator) || other.isInitiator == isInitiator)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.rtcState, rtcState) || other.rtcState == rtcState)&&(identical(other.isAudioMuted, isAudioMuted) || other.isAudioMuted == isAudioMuted)&&(identical(other.isVideoEnabled, isVideoEnabled) || other.isVideoEnabled == isVideoEnabled)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn)&&(identical(other.isFrontCamera, isFrontCamera) || other.isFrontCamera == isFrontCamera)&&(identical(other.callStartTime, callStartTime) || other.callStartTime == callStartTime)&&(identical(other.callDurationSeconds, callDurationSeconds) || other.callDurationSeconds == callDurationSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,phase,callId,dbCallId,peerInfo,isInitiator,callType,rtcState,isAudioMuted,isVideoEnabled,isSpeakerOn,isFrontCamera,callStartTime,callDurationSeconds,error);

@override
String toString() {
  return 'CallState(phase: $phase, callId: $callId, dbCallId: $dbCallId, peerInfo: $peerInfo, isInitiator: $isInitiator, callType: $callType, rtcState: $rtcState, isAudioMuted: $isAudioMuted, isVideoEnabled: $isVideoEnabled, isSpeakerOn: $isSpeakerOn, isFrontCamera: $isFrontCamera, callStartTime: $callStartTime, callDurationSeconds: $callDurationSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class $CallStateCopyWith<$Res>  {
  factory $CallStateCopyWith(CallState value, $Res Function(CallState) _then) = _$CallStateCopyWithImpl;
@useResult
$Res call({
 CallPhase phase, String? callId, String? dbCallId, PeerInfo? peerInfo, bool isInitiator, CallType callType, WebRTCConnectionState rtcState, bool isAudioMuted, bool isVideoEnabled, bool isSpeakerOn, bool isFrontCamera, DateTime? callStartTime, int callDurationSeconds, String? error
});


$PeerInfoCopyWith<$Res>? get peerInfo;

}
/// @nodoc
class _$CallStateCopyWithImpl<$Res>
    implements $CallStateCopyWith<$Res> {
  _$CallStateCopyWithImpl(this._self, this._then);

  final CallState _self;
  final $Res Function(CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? callId = freezed,Object? dbCallId = freezed,Object? peerInfo = freezed,Object? isInitiator = null,Object? callType = null,Object? rtcState = null,Object? isAudioMuted = null,Object? isVideoEnabled = null,Object? isSpeakerOn = null,Object? isFrontCamera = null,Object? callStartTime = freezed,Object? callDurationSeconds = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as CallPhase,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,dbCallId: freezed == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String?,peerInfo: freezed == peerInfo ? _self.peerInfo : peerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo?,isInitiator: null == isInitiator ? _self.isInitiator : isInitiator // ignore: cast_nullable_to_non_nullable
as bool,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as CallType,rtcState: null == rtcState ? _self.rtcState : rtcState // ignore: cast_nullable_to_non_nullable
as WebRTCConnectionState,isAudioMuted: null == isAudioMuted ? _self.isAudioMuted : isAudioMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoEnabled: null == isVideoEnabled ? _self.isVideoEnabled : isVideoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,isFrontCamera: null == isFrontCamera ? _self.isFrontCamera : isFrontCamera // ignore: cast_nullable_to_non_nullable
as bool,callStartTime: freezed == callStartTime ? _self.callStartTime : callStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,callDurationSeconds: null == callDurationSeconds ? _self.callDurationSeconds : callDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res>? get peerInfo {
    if (_self.peerInfo == null) {
    return null;
  }

  return $PeerInfoCopyWith<$Res>(_self.peerInfo!, (value) {
    return _then(_self.copyWith(peerInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [CallState].
extension CallStatePatterns on CallState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallState value)  $default,){
final _that = this;
switch (_that) {
case _CallState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallState value)?  $default,){
final _that = this;
switch (_that) {
case _CallState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CallPhase phase,  String? callId,  String? dbCallId,  PeerInfo? peerInfo,  bool isInitiator,  CallType callType,  WebRTCConnectionState rtcState,  bool isAudioMuted,  bool isVideoEnabled,  bool isSpeakerOn,  bool isFrontCamera,  DateTime? callStartTime,  int callDurationSeconds,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallState() when $default != null:
return $default(_that.phase,_that.callId,_that.dbCallId,_that.peerInfo,_that.isInitiator,_that.callType,_that.rtcState,_that.isAudioMuted,_that.isVideoEnabled,_that.isSpeakerOn,_that.isFrontCamera,_that.callStartTime,_that.callDurationSeconds,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CallPhase phase,  String? callId,  String? dbCallId,  PeerInfo? peerInfo,  bool isInitiator,  CallType callType,  WebRTCConnectionState rtcState,  bool isAudioMuted,  bool isVideoEnabled,  bool isSpeakerOn,  bool isFrontCamera,  DateTime? callStartTime,  int callDurationSeconds,  String? error)  $default,) {final _that = this;
switch (_that) {
case _CallState():
return $default(_that.phase,_that.callId,_that.dbCallId,_that.peerInfo,_that.isInitiator,_that.callType,_that.rtcState,_that.isAudioMuted,_that.isVideoEnabled,_that.isSpeakerOn,_that.isFrontCamera,_that.callStartTime,_that.callDurationSeconds,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CallPhase phase,  String? callId,  String? dbCallId,  PeerInfo? peerInfo,  bool isInitiator,  CallType callType,  WebRTCConnectionState rtcState,  bool isAudioMuted,  bool isVideoEnabled,  bool isSpeakerOn,  bool isFrontCamera,  DateTime? callStartTime,  int callDurationSeconds,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _CallState() when $default != null:
return $default(_that.phase,_that.callId,_that.dbCallId,_that.peerInfo,_that.isInitiator,_that.callType,_that.rtcState,_that.isAudioMuted,_that.isVideoEnabled,_that.isSpeakerOn,_that.isFrontCamera,_that.callStartTime,_that.callDurationSeconds,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _CallState extends CallState {
  const _CallState({this.phase = CallPhase.idle, this.callId, this.dbCallId, this.peerInfo, this.isInitiator = false, this.callType = CallType.random, this.rtcState = WebRTCConnectionState.idle, this.isAudioMuted = false, this.isVideoEnabled = true, this.isSpeakerOn = false, this.isFrontCamera = true, this.callStartTime, this.callDurationSeconds = 0, this.error}): super._();
  

@override@JsonKey() final  CallPhase phase;
@override final  String? callId;
@override final  String? dbCallId;
@override final  PeerInfo? peerInfo;
@override@JsonKey() final  bool isInitiator;
@override@JsonKey() final  CallType callType;
@override@JsonKey() final  WebRTCConnectionState rtcState;
// Media state
@override@JsonKey() final  bool isAudioMuted;
@override@JsonKey() final  bool isVideoEnabled;
@override@JsonKey() final  bool isSpeakerOn;
@override@JsonKey() final  bool isFrontCamera;
// Call timing
@override final  DateTime? callStartTime;
@override@JsonKey() final  int callDurationSeconds;
// Error handling
@override final  String? error;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallStateCopyWith<_CallState> get copyWith => __$CallStateCopyWithImpl<_CallState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.callId, callId) || other.callId == callId)&&(identical(other.dbCallId, dbCallId) || other.dbCallId == dbCallId)&&(identical(other.peerInfo, peerInfo) || other.peerInfo == peerInfo)&&(identical(other.isInitiator, isInitiator) || other.isInitiator == isInitiator)&&(identical(other.callType, callType) || other.callType == callType)&&(identical(other.rtcState, rtcState) || other.rtcState == rtcState)&&(identical(other.isAudioMuted, isAudioMuted) || other.isAudioMuted == isAudioMuted)&&(identical(other.isVideoEnabled, isVideoEnabled) || other.isVideoEnabled == isVideoEnabled)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn)&&(identical(other.isFrontCamera, isFrontCamera) || other.isFrontCamera == isFrontCamera)&&(identical(other.callStartTime, callStartTime) || other.callStartTime == callStartTime)&&(identical(other.callDurationSeconds, callDurationSeconds) || other.callDurationSeconds == callDurationSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,phase,callId,dbCallId,peerInfo,isInitiator,callType,rtcState,isAudioMuted,isVideoEnabled,isSpeakerOn,isFrontCamera,callStartTime,callDurationSeconds,error);

@override
String toString() {
  return 'CallState(phase: $phase, callId: $callId, dbCallId: $dbCallId, peerInfo: $peerInfo, isInitiator: $isInitiator, callType: $callType, rtcState: $rtcState, isAudioMuted: $isAudioMuted, isVideoEnabled: $isVideoEnabled, isSpeakerOn: $isSpeakerOn, isFrontCamera: $isFrontCamera, callStartTime: $callStartTime, callDurationSeconds: $callDurationSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$CallStateCopyWith<$Res> implements $CallStateCopyWith<$Res> {
  factory _$CallStateCopyWith(_CallState value, $Res Function(_CallState) _then) = __$CallStateCopyWithImpl;
@override @useResult
$Res call({
 CallPhase phase, String? callId, String? dbCallId, PeerInfo? peerInfo, bool isInitiator, CallType callType, WebRTCConnectionState rtcState, bool isAudioMuted, bool isVideoEnabled, bool isSpeakerOn, bool isFrontCamera, DateTime? callStartTime, int callDurationSeconds, String? error
});


@override $PeerInfoCopyWith<$Res>? get peerInfo;

}
/// @nodoc
class __$CallStateCopyWithImpl<$Res>
    implements _$CallStateCopyWith<$Res> {
  __$CallStateCopyWithImpl(this._self, this._then);

  final _CallState _self;
  final $Res Function(_CallState) _then;

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? callId = freezed,Object? dbCallId = freezed,Object? peerInfo = freezed,Object? isInitiator = null,Object? callType = null,Object? rtcState = null,Object? isAudioMuted = null,Object? isVideoEnabled = null,Object? isSpeakerOn = null,Object? isFrontCamera = null,Object? callStartTime = freezed,Object? callDurationSeconds = null,Object? error = freezed,}) {
  return _then(_CallState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as CallPhase,callId: freezed == callId ? _self.callId : callId // ignore: cast_nullable_to_non_nullable
as String?,dbCallId: freezed == dbCallId ? _self.dbCallId : dbCallId // ignore: cast_nullable_to_non_nullable
as String?,peerInfo: freezed == peerInfo ? _self.peerInfo : peerInfo // ignore: cast_nullable_to_non_nullable
as PeerInfo?,isInitiator: null == isInitiator ? _self.isInitiator : isInitiator // ignore: cast_nullable_to_non_nullable
as bool,callType: null == callType ? _self.callType : callType // ignore: cast_nullable_to_non_nullable
as CallType,rtcState: null == rtcState ? _self.rtcState : rtcState // ignore: cast_nullable_to_non_nullable
as WebRTCConnectionState,isAudioMuted: null == isAudioMuted ? _self.isAudioMuted : isAudioMuted // ignore: cast_nullable_to_non_nullable
as bool,isVideoEnabled: null == isVideoEnabled ? _self.isVideoEnabled : isVideoEnabled // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,isFrontCamera: null == isFrontCamera ? _self.isFrontCamera : isFrontCamera // ignore: cast_nullable_to_non_nullable
as bool,callStartTime: freezed == callStartTime ? _self.callStartTime : callStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,callDurationSeconds: null == callDurationSeconds ? _self.callDurationSeconds : callDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of CallState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PeerInfoCopyWith<$Res>? get peerInfo {
    if (_self.peerInfo == null) {
    return null;
  }

  return $PeerInfoCopyWith<$Res>(_self.peerInfo!, (value) {
    return _then(_self.copyWith(peerInfo: value));
  });
}
}

// dart format on
