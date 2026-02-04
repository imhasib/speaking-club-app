// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'matchmaking_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MatchmakingState {

 MatchmakingPhase get phase; DateTime? get joinedAt; int get waitingSeconds; String? get error;
/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchmakingStateCopyWith<MatchmakingState> get copyWith => _$MatchmakingStateCopyWithImpl<MatchmakingState>(this as MatchmakingState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchmakingState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.waitingSeconds, waitingSeconds) || other.waitingSeconds == waitingSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,phase,joinedAt,waitingSeconds,error);

@override
String toString() {
  return 'MatchmakingState(phase: $phase, joinedAt: $joinedAt, waitingSeconds: $waitingSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class $MatchmakingStateCopyWith<$Res>  {
  factory $MatchmakingStateCopyWith(MatchmakingState value, $Res Function(MatchmakingState) _then) = _$MatchmakingStateCopyWithImpl;
@useResult
$Res call({
 MatchmakingPhase phase, DateTime? joinedAt, int waitingSeconds, String? error
});




}
/// @nodoc
class _$MatchmakingStateCopyWithImpl<$Res>
    implements $MatchmakingStateCopyWith<$Res> {
  _$MatchmakingStateCopyWithImpl(this._self, this._then);

  final MatchmakingState _self;
  final $Res Function(MatchmakingState) _then;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? joinedAt = freezed,Object? waitingSeconds = null,Object? error = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as MatchmakingPhase,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waitingSeconds: null == waitingSeconds ? _self.waitingSeconds : waitingSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MatchmakingState].
extension MatchmakingStatePatterns on MatchmakingState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchmakingState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchmakingState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchmakingState value)  $default,){
final _that = this;
switch (_that) {
case _MatchmakingState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchmakingState value)?  $default,){
final _that = this;
switch (_that) {
case _MatchmakingState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MatchmakingPhase phase,  DateTime? joinedAt,  int waitingSeconds,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchmakingState() when $default != null:
return $default(_that.phase,_that.joinedAt,_that.waitingSeconds,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MatchmakingPhase phase,  DateTime? joinedAt,  int waitingSeconds,  String? error)  $default,) {final _that = this;
switch (_that) {
case _MatchmakingState():
return $default(_that.phase,_that.joinedAt,_that.waitingSeconds,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MatchmakingPhase phase,  DateTime? joinedAt,  int waitingSeconds,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _MatchmakingState() when $default != null:
return $default(_that.phase,_that.joinedAt,_that.waitingSeconds,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _MatchmakingState extends MatchmakingState {
  const _MatchmakingState({this.phase = MatchmakingPhase.idle, this.joinedAt, this.waitingSeconds = 0, this.error}): super._();
  

@override@JsonKey() final  MatchmakingPhase phase;
@override final  DateTime? joinedAt;
@override@JsonKey() final  int waitingSeconds;
@override final  String? error;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchmakingStateCopyWith<_MatchmakingState> get copyWith => __$MatchmakingStateCopyWithImpl<_MatchmakingState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchmakingState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.joinedAt, joinedAt) || other.joinedAt == joinedAt)&&(identical(other.waitingSeconds, waitingSeconds) || other.waitingSeconds == waitingSeconds)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,phase,joinedAt,waitingSeconds,error);

@override
String toString() {
  return 'MatchmakingState(phase: $phase, joinedAt: $joinedAt, waitingSeconds: $waitingSeconds, error: $error)';
}


}

/// @nodoc
abstract mixin class _$MatchmakingStateCopyWith<$Res> implements $MatchmakingStateCopyWith<$Res> {
  factory _$MatchmakingStateCopyWith(_MatchmakingState value, $Res Function(_MatchmakingState) _then) = __$MatchmakingStateCopyWithImpl;
@override @useResult
$Res call({
 MatchmakingPhase phase, DateTime? joinedAt, int waitingSeconds, String? error
});




}
/// @nodoc
class __$MatchmakingStateCopyWithImpl<$Res>
    implements _$MatchmakingStateCopyWith<$Res> {
  __$MatchmakingStateCopyWithImpl(this._self, this._then);

  final _MatchmakingState _self;
  final $Res Function(_MatchmakingState) _then;

/// Create a copy of MatchmakingState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? joinedAt = freezed,Object? waitingSeconds = null,Object? error = freezed,}) {
  return _then(_MatchmakingState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as MatchmakingPhase,joinedAt: freezed == joinedAt ? _self.joinedAt : joinedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,waitingSeconds: null == waitingSeconds ? _self.waitingSeconds : waitingSeconds // ignore: cast_nullable_to_non_nullable
as int,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
