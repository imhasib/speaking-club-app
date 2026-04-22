// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AiSession {

 String get id; String get odId; DateTime get startedAt; DateTime get endedAt; int get durationSeconds; AiSessionMode get mode; AiPersona get persona; String? get topic; String? get scenario; List<AiMessage> get messages; List<Correction> get corrections; SessionStats get stats;
/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiSessionCopyWith<AiSession> get copyWith => _$AiSessionCopyWithImpl<AiSession>(this as AiSession, _$identity);

  /// Serializes this AiSession to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odId, odId) || other.odId == odId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&const DeepCollectionEquality().equals(other.messages, messages)&&const DeepCollectionEquality().equals(other.corrections, corrections)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odId,startedAt,endedAt,durationSeconds,mode,persona,topic,scenario,const DeepCollectionEquality().hash(messages),const DeepCollectionEquality().hash(corrections),stats);

@override
String toString() {
  return 'AiSession(id: $id, odId: $odId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, mode: $mode, persona: $persona, topic: $topic, scenario: $scenario, messages: $messages, corrections: $corrections, stats: $stats)';
}


}

/// @nodoc
abstract mixin class $AiSessionCopyWith<$Res>  {
  factory $AiSessionCopyWith(AiSession value, $Res Function(AiSession) _then) = _$AiSessionCopyWithImpl;
@useResult
$Res call({
 String id, String odId, DateTime startedAt, DateTime endedAt, int durationSeconds, AiSessionMode mode, AiPersona persona, String? topic, String? scenario, List<AiMessage> messages, List<Correction> corrections, SessionStats stats
});


$SessionStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$AiSessionCopyWithImpl<$Res>
    implements $AiSessionCopyWith<$Res> {
  _$AiSessionCopyWithImpl(this._self, this._then);

  final AiSession _self;
  final $Res Function(AiSession) _then;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? odId = null,Object? startedAt = null,Object? endedAt = null,Object? durationSeconds = null,Object? mode = null,Object? persona = null,Object? topic = freezed,Object? scenario = freezed,Object? messages = null,Object? corrections = null,Object? stats = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odId: null == odId ? _self.odId : odId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiSessionMode,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AiPersona,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,scenario: freezed == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,corrections: null == corrections ? _self.corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<Correction>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as SessionStats,
  ));
}
/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionStatsCopyWith<$Res> get stats {
  
  return $SessionStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [AiSession].
extension AiSessionPatterns on AiSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiSession value)  $default,){
final _that = this;
switch (_that) {
case _AiSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiSession value)?  $default,){
final _that = this;
switch (_that) {
case _AiSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String odId,  DateTime startedAt,  DateTime endedAt,  int durationSeconds,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  List<AiMessage> messages,  List<Correction> corrections,  SessionStats stats)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiSession() when $default != null:
return $default(_that.id,_that.odId,_that.startedAt,_that.endedAt,_that.durationSeconds,_that.mode,_that.persona,_that.topic,_that.scenario,_that.messages,_that.corrections,_that.stats);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String odId,  DateTime startedAt,  DateTime endedAt,  int durationSeconds,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  List<AiMessage> messages,  List<Correction> corrections,  SessionStats stats)  $default,) {final _that = this;
switch (_that) {
case _AiSession():
return $default(_that.id,_that.odId,_that.startedAt,_that.endedAt,_that.durationSeconds,_that.mode,_that.persona,_that.topic,_that.scenario,_that.messages,_that.corrections,_that.stats);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String odId,  DateTime startedAt,  DateTime endedAt,  int durationSeconds,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  List<AiMessage> messages,  List<Correction> corrections,  SessionStats stats)?  $default,) {final _that = this;
switch (_that) {
case _AiSession() when $default != null:
return $default(_that.id,_that.odId,_that.startedAt,_that.endedAt,_that.durationSeconds,_that.mode,_that.persona,_that.topic,_that.scenario,_that.messages,_that.corrections,_that.stats);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiSession extends AiSession {
  const _AiSession({required this.id, required this.odId, required this.startedAt, required this.endedAt, required this.durationSeconds, required this.mode, this.persona = AiPersona.emma, this.topic, this.scenario, required final  List<AiMessage> messages, required final  List<Correction> corrections, required this.stats}): _messages = messages,_corrections = corrections,super._();
  factory _AiSession.fromJson(Map<String, dynamic> json) => _$AiSessionFromJson(json);

@override final  String id;
@override final  String odId;
@override final  DateTime startedAt;
@override final  DateTime endedAt;
@override final  int durationSeconds;
@override final  AiSessionMode mode;
@override@JsonKey() final  AiPersona persona;
@override final  String? topic;
@override final  String? scenario;
 final  List<AiMessage> _messages;
@override List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  List<Correction> _corrections;
@override List<Correction> get corrections {
  if (_corrections is EqualUnmodifiableListView) return _corrections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_corrections);
}

@override final  SessionStats stats;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiSessionCopyWith<_AiSession> get copyWith => __$AiSessionCopyWithImpl<_AiSession>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiSessionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiSession&&(identical(other.id, id) || other.id == id)&&(identical(other.odId, odId) || other.odId == odId)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.endedAt, endedAt) || other.endedAt == endedAt)&&(identical(other.durationSeconds, durationSeconds) || other.durationSeconds == durationSeconds)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&const DeepCollectionEquality().equals(other._messages, _messages)&&const DeepCollectionEquality().equals(other._corrections, _corrections)&&(identical(other.stats, stats) || other.stats == stats));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,odId,startedAt,endedAt,durationSeconds,mode,persona,topic,scenario,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_corrections),stats);

@override
String toString() {
  return 'AiSession(id: $id, odId: $odId, startedAt: $startedAt, endedAt: $endedAt, durationSeconds: $durationSeconds, mode: $mode, persona: $persona, topic: $topic, scenario: $scenario, messages: $messages, corrections: $corrections, stats: $stats)';
}


}

/// @nodoc
abstract mixin class _$AiSessionCopyWith<$Res> implements $AiSessionCopyWith<$Res> {
  factory _$AiSessionCopyWith(_AiSession value, $Res Function(_AiSession) _then) = __$AiSessionCopyWithImpl;
@override @useResult
$Res call({
 String id, String odId, DateTime startedAt, DateTime endedAt, int durationSeconds, AiSessionMode mode, AiPersona persona, String? topic, String? scenario, List<AiMessage> messages, List<Correction> corrections, SessionStats stats
});


@override $SessionStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$AiSessionCopyWithImpl<$Res>
    implements _$AiSessionCopyWith<$Res> {
  __$AiSessionCopyWithImpl(this._self, this._then);

  final _AiSession _self;
  final $Res Function(_AiSession) _then;

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? odId = null,Object? startedAt = null,Object? endedAt = null,Object? durationSeconds = null,Object? mode = null,Object? persona = null,Object? topic = freezed,Object? scenario = freezed,Object? messages = null,Object? corrections = null,Object? stats = null,}) {
  return _then(_AiSession(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,odId: null == odId ? _self.odId : odId // ignore: cast_nullable_to_non_nullable
as String,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime,endedAt: null == endedAt ? _self.endedAt : endedAt // ignore: cast_nullable_to_non_nullable
as DateTime,durationSeconds: null == durationSeconds ? _self.durationSeconds : durationSeconds // ignore: cast_nullable_to_non_nullable
as int,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiSessionMode,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AiPersona,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,scenario: freezed == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String?,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,corrections: null == corrections ? _self._corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<Correction>,stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as SessionStats,
  ));
}

/// Create a copy of AiSession
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SessionStatsCopyWith<$Res> get stats {
  
  return $SessionStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// @nodoc
mixin _$AiMessage {

 String get role;// 'user' or 'assistant'
 String get content; DateTime get timestamp;
/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiMessageCopyWith<AiMessage> get copyWith => _$AiMessageCopyWithImpl<AiMessage>(this as AiMessage, _$identity);

  /// Serializes this AiMessage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content,timestamp);

@override
String toString() {
  return 'AiMessage(role: $role, content: $content, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class $AiMessageCopyWith<$Res>  {
  factory $AiMessageCopyWith(AiMessage value, $Res Function(AiMessage) _then) = _$AiMessageCopyWithImpl;
@useResult
$Res call({
 String role, String content, DateTime timestamp
});




}
/// @nodoc
class _$AiMessageCopyWithImpl<$Res>
    implements $AiMessageCopyWith<$Res> {
  _$AiMessageCopyWithImpl(this._self, this._then);

  final AiMessage _self;
  final $Res Function(AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = null,Object? content = null,Object? timestamp = null,}) {
  return _then(_self.copyWith(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiMessage].
extension AiMessagePatterns on AiMessage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiMessage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiMessage value)  $default,){
final _that = this;
switch (_that) {
case _AiMessage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiMessage value)?  $default,){
final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String role,  String content,  DateTime timestamp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.role,_that.content,_that.timestamp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String role,  String content,  DateTime timestamp)  $default,) {final _that = this;
switch (_that) {
case _AiMessage():
return $default(_that.role,_that.content,_that.timestamp);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String role,  String content,  DateTime timestamp)?  $default,) {final _that = this;
switch (_that) {
case _AiMessage() when $default != null:
return $default(_that.role,_that.content,_that.timestamp);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiMessage implements AiMessage {
  const _AiMessage({required this.role, required this.content, required this.timestamp});
  factory _AiMessage.fromJson(Map<String, dynamic> json) => _$AiMessageFromJson(json);

@override final  String role;
// 'user' or 'assistant'
@override final  String content;
@override final  DateTime timestamp;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiMessageCopyWith<_AiMessage> get copyWith => __$AiMessageCopyWithImpl<_AiMessage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiMessageToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiMessage&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content)&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,role,content,timestamp);

@override
String toString() {
  return 'AiMessage(role: $role, content: $content, timestamp: $timestamp)';
}


}

/// @nodoc
abstract mixin class _$AiMessageCopyWith<$Res> implements $AiMessageCopyWith<$Res> {
  factory _$AiMessageCopyWith(_AiMessage value, $Res Function(_AiMessage) _then) = __$AiMessageCopyWithImpl;
@override @useResult
$Res call({
 String role, String content, DateTime timestamp
});




}
/// @nodoc
class __$AiMessageCopyWithImpl<$Res>
    implements _$AiMessageCopyWith<$Res> {
  __$AiMessageCopyWithImpl(this._self, this._then);

  final _AiMessage _self;
  final $Res Function(_AiMessage) _then;

/// Create a copy of AiMessage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = null,Object? content = null,Object? timestamp = null,}) {
  return _then(_AiMessage(
role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$Correction {

 String get original; String get corrected; String get explanation;
/// Create a copy of Correction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CorrectionCopyWith<Correction> get copyWith => _$CorrectionCopyWithImpl<Correction>(this as Correction, _$identity);

  /// Serializes this Correction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Correction&&(identical(other.original, original) || other.original == original)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,corrected,explanation);

@override
String toString() {
  return 'Correction(original: $original, corrected: $corrected, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class $CorrectionCopyWith<$Res>  {
  factory $CorrectionCopyWith(Correction value, $Res Function(Correction) _then) = _$CorrectionCopyWithImpl;
@useResult
$Res call({
 String original, String corrected, String explanation
});




}
/// @nodoc
class _$CorrectionCopyWithImpl<$Res>
    implements $CorrectionCopyWith<$Res> {
  _$CorrectionCopyWithImpl(this._self, this._then);

  final Correction _self;
  final $Res Function(Correction) _then;

/// Create a copy of Correction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? original = null,Object? corrected = null,Object? explanation = null,}) {
  return _then(_self.copyWith(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Correction].
extension CorrectionPatterns on Correction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Correction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Correction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Correction value)  $default,){
final _that = this;
switch (_that) {
case _Correction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Correction value)?  $default,){
final _that = this;
switch (_that) {
case _Correction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String original,  String corrected,  String explanation)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Correction() when $default != null:
return $default(_that.original,_that.corrected,_that.explanation);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String original,  String corrected,  String explanation)  $default,) {final _that = this;
switch (_that) {
case _Correction():
return $default(_that.original,_that.corrected,_that.explanation);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String original,  String corrected,  String explanation)?  $default,) {final _that = this;
switch (_that) {
case _Correction() when $default != null:
return $default(_that.original,_that.corrected,_that.explanation);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Correction implements Correction {
  const _Correction({required this.original, required this.corrected, required this.explanation});
  factory _Correction.fromJson(Map<String, dynamic> json) => _$CorrectionFromJson(json);

@override final  String original;
@override final  String corrected;
@override final  String explanation;

/// Create a copy of Correction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CorrectionCopyWith<_Correction> get copyWith => __$CorrectionCopyWithImpl<_Correction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CorrectionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Correction&&(identical(other.original, original) || other.original == original)&&(identical(other.corrected, corrected) || other.corrected == corrected)&&(identical(other.explanation, explanation) || other.explanation == explanation));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,original,corrected,explanation);

@override
String toString() {
  return 'Correction(original: $original, corrected: $corrected, explanation: $explanation)';
}


}

/// @nodoc
abstract mixin class _$CorrectionCopyWith<$Res> implements $CorrectionCopyWith<$Res> {
  factory _$CorrectionCopyWith(_Correction value, $Res Function(_Correction) _then) = __$CorrectionCopyWithImpl;
@override @useResult
$Res call({
 String original, String corrected, String explanation
});




}
/// @nodoc
class __$CorrectionCopyWithImpl<$Res>
    implements _$CorrectionCopyWith<$Res> {
  __$CorrectionCopyWithImpl(this._self, this._then);

  final _Correction _self;
  final $Res Function(_Correction) _then;

/// Create a copy of Correction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? original = null,Object? corrected = null,Object? explanation = null,}) {
  return _then(_Correction(
original: null == original ? _self.original : original // ignore: cast_nullable_to_non_nullable
as String,corrected: null == corrected ? _self.corrected : corrected // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$SessionStats {

 int get wordsSpoken; int get averageSentenceLength; int get speakingTimePercent; List<String> get vocabularyUsed;
/// Create a copy of SessionStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStatsCopyWith<SessionStats> get copyWith => _$SessionStatsCopyWithImpl<SessionStats>(this as SessionStats, _$identity);

  /// Serializes this SessionStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionStats&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.averageSentenceLength, averageSentenceLength) || other.averageSentenceLength == averageSentenceLength)&&(identical(other.speakingTimePercent, speakingTimePercent) || other.speakingTimePercent == speakingTimePercent)&&const DeepCollectionEquality().equals(other.vocabularyUsed, vocabularyUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wordsSpoken,averageSentenceLength,speakingTimePercent,const DeepCollectionEquality().hash(vocabularyUsed));

@override
String toString() {
  return 'SessionStats(wordsSpoken: $wordsSpoken, averageSentenceLength: $averageSentenceLength, speakingTimePercent: $speakingTimePercent, vocabularyUsed: $vocabularyUsed)';
}


}

/// @nodoc
abstract mixin class $SessionStatsCopyWith<$Res>  {
  factory $SessionStatsCopyWith(SessionStats value, $Res Function(SessionStats) _then) = _$SessionStatsCopyWithImpl;
@useResult
$Res call({
 int wordsSpoken, int averageSentenceLength, int speakingTimePercent, List<String> vocabularyUsed
});




}
/// @nodoc
class _$SessionStatsCopyWithImpl<$Res>
    implements $SessionStatsCopyWith<$Res> {
  _$SessionStatsCopyWithImpl(this._self, this._then);

  final SessionStats _self;
  final $Res Function(SessionStats) _then;

/// Create a copy of SessionStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wordsSpoken = null,Object? averageSentenceLength = null,Object? speakingTimePercent = null,Object? vocabularyUsed = null,}) {
  return _then(_self.copyWith(
wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,averageSentenceLength: null == averageSentenceLength ? _self.averageSentenceLength : averageSentenceLength // ignore: cast_nullable_to_non_nullable
as int,speakingTimePercent: null == speakingTimePercent ? _self.speakingTimePercent : speakingTimePercent // ignore: cast_nullable_to_non_nullable
as int,vocabularyUsed: null == vocabularyUsed ? _self.vocabularyUsed : vocabularyUsed // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [SessionStats].
extension SessionStatsPatterns on SessionStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionStats value)  $default,){
final _that = this;
switch (_that) {
case _SessionStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionStats value)?  $default,){
final _that = this;
switch (_that) {
case _SessionStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int wordsSpoken,  int averageSentenceLength,  int speakingTimePercent,  List<String> vocabularyUsed)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionStats() when $default != null:
return $default(_that.wordsSpoken,_that.averageSentenceLength,_that.speakingTimePercent,_that.vocabularyUsed);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int wordsSpoken,  int averageSentenceLength,  int speakingTimePercent,  List<String> vocabularyUsed)  $default,) {final _that = this;
switch (_that) {
case _SessionStats():
return $default(_that.wordsSpoken,_that.averageSentenceLength,_that.speakingTimePercent,_that.vocabularyUsed);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int wordsSpoken,  int averageSentenceLength,  int speakingTimePercent,  List<String> vocabularyUsed)?  $default,) {final _that = this;
switch (_that) {
case _SessionStats() when $default != null:
return $default(_that.wordsSpoken,_that.averageSentenceLength,_that.speakingTimePercent,_that.vocabularyUsed);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SessionStats implements SessionStats {
  const _SessionStats({this.wordsSpoken = 0, this.averageSentenceLength = 0, this.speakingTimePercent = 0, final  List<String> vocabularyUsed = const []}): _vocabularyUsed = vocabularyUsed;
  factory _SessionStats.fromJson(Map<String, dynamic> json) => _$SessionStatsFromJson(json);

@override@JsonKey() final  int wordsSpoken;
@override@JsonKey() final  int averageSentenceLength;
@override@JsonKey() final  int speakingTimePercent;
 final  List<String> _vocabularyUsed;
@override@JsonKey() List<String> get vocabularyUsed {
  if (_vocabularyUsed is EqualUnmodifiableListView) return _vocabularyUsed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_vocabularyUsed);
}


/// Create a copy of SessionStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStatsCopyWith<_SessionStats> get copyWith => __$SessionStatsCopyWithImpl<_SessionStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SessionStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionStats&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.averageSentenceLength, averageSentenceLength) || other.averageSentenceLength == averageSentenceLength)&&(identical(other.speakingTimePercent, speakingTimePercent) || other.speakingTimePercent == speakingTimePercent)&&const DeepCollectionEquality().equals(other._vocabularyUsed, _vocabularyUsed));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,wordsSpoken,averageSentenceLength,speakingTimePercent,const DeepCollectionEquality().hash(_vocabularyUsed));

@override
String toString() {
  return 'SessionStats(wordsSpoken: $wordsSpoken, averageSentenceLength: $averageSentenceLength, speakingTimePercent: $speakingTimePercent, vocabularyUsed: $vocabularyUsed)';
}


}

/// @nodoc
abstract mixin class _$SessionStatsCopyWith<$Res> implements $SessionStatsCopyWith<$Res> {
  factory _$SessionStatsCopyWith(_SessionStats value, $Res Function(_SessionStats) _then) = __$SessionStatsCopyWithImpl;
@override @useResult
$Res call({
 int wordsSpoken, int averageSentenceLength, int speakingTimePercent, List<String> vocabularyUsed
});




}
/// @nodoc
class __$SessionStatsCopyWithImpl<$Res>
    implements _$SessionStatsCopyWith<$Res> {
  __$SessionStatsCopyWithImpl(this._self, this._then);

  final _SessionStats _self;
  final $Res Function(_SessionStats) _then;

/// Create a copy of SessionStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wordsSpoken = null,Object? averageSentenceLength = null,Object? speakingTimePercent = null,Object? vocabularyUsed = null,}) {
  return _then(_SessionStats(
wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,averageSentenceLength: null == averageSentenceLength ? _self.averageSentenceLength : averageSentenceLength // ignore: cast_nullable_to_non_nullable
as int,speakingTimePercent: null == speakingTimePercent ? _self.speakingTimePercent : speakingTimePercent // ignore: cast_nullable_to_non_nullable
as int,vocabularyUsed: null == vocabularyUsed ? _self._vocabularyUsed : vocabularyUsed // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$EphemeralKeyResponse {

 String get ephemeralKey; DateTime get expiresAt; String get sessionId; int get remainingSeconds;
/// Create a copy of EphemeralKeyResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$EphemeralKeyResponseCopyWith<EphemeralKeyResponse> get copyWith => _$EphemeralKeyResponseCopyWithImpl<EphemeralKeyResponse>(this as EphemeralKeyResponse, _$identity);

  /// Serializes this EphemeralKeyResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is EphemeralKeyResponse&&(identical(other.ephemeralKey, ephemeralKey) || other.ephemeralKey == ephemeralKey)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ephemeralKey,expiresAt,sessionId,remainingSeconds);

@override
String toString() {
  return 'EphemeralKeyResponse(ephemeralKey: $ephemeralKey, expiresAt: $expiresAt, sessionId: $sessionId, remainingSeconds: $remainingSeconds)';
}


}

/// @nodoc
abstract mixin class $EphemeralKeyResponseCopyWith<$Res>  {
  factory $EphemeralKeyResponseCopyWith(EphemeralKeyResponse value, $Res Function(EphemeralKeyResponse) _then) = _$EphemeralKeyResponseCopyWithImpl;
@useResult
$Res call({
 String ephemeralKey, DateTime expiresAt, String sessionId, int remainingSeconds
});




}
/// @nodoc
class _$EphemeralKeyResponseCopyWithImpl<$Res>
    implements $EphemeralKeyResponseCopyWith<$Res> {
  _$EphemeralKeyResponseCopyWithImpl(this._self, this._then);

  final EphemeralKeyResponse _self;
  final $Res Function(EphemeralKeyResponse) _then;

/// Create a copy of EphemeralKeyResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ephemeralKey = null,Object? expiresAt = null,Object? sessionId = null,Object? remainingSeconds = null,}) {
  return _then(_self.copyWith(
ephemeralKey: null == ephemeralKey ? _self.ephemeralKey : ephemeralKey // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [EphemeralKeyResponse].
extension EphemeralKeyResponsePatterns on EphemeralKeyResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _EphemeralKeyResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _EphemeralKeyResponse() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _EphemeralKeyResponse value)  $default,){
final _that = this;
switch (_that) {
case _EphemeralKeyResponse():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _EphemeralKeyResponse value)?  $default,){
final _that = this;
switch (_that) {
case _EphemeralKeyResponse() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String ephemeralKey,  DateTime expiresAt,  String sessionId,  int remainingSeconds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _EphemeralKeyResponse() when $default != null:
return $default(_that.ephemeralKey,_that.expiresAt,_that.sessionId,_that.remainingSeconds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String ephemeralKey,  DateTime expiresAt,  String sessionId,  int remainingSeconds)  $default,) {final _that = this;
switch (_that) {
case _EphemeralKeyResponse():
return $default(_that.ephemeralKey,_that.expiresAt,_that.sessionId,_that.remainingSeconds);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String ephemeralKey,  DateTime expiresAt,  String sessionId,  int remainingSeconds)?  $default,) {final _that = this;
switch (_that) {
case _EphemeralKeyResponse() when $default != null:
return $default(_that.ephemeralKey,_that.expiresAt,_that.sessionId,_that.remainingSeconds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _EphemeralKeyResponse implements EphemeralKeyResponse {
  const _EphemeralKeyResponse({required this.ephemeralKey, required this.expiresAt, required this.sessionId, required this.remainingSeconds});
  factory _EphemeralKeyResponse.fromJson(Map<String, dynamic> json) => _$EphemeralKeyResponseFromJson(json);

@override final  String ephemeralKey;
@override final  DateTime expiresAt;
@override final  String sessionId;
@override final  int remainingSeconds;

/// Create a copy of EphemeralKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$EphemeralKeyResponseCopyWith<_EphemeralKeyResponse> get copyWith => __$EphemeralKeyResponseCopyWithImpl<_EphemeralKeyResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$EphemeralKeyResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _EphemeralKeyResponse&&(identical(other.ephemeralKey, ephemeralKey) || other.ephemeralKey == ephemeralKey)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,ephemeralKey,expiresAt,sessionId,remainingSeconds);

@override
String toString() {
  return 'EphemeralKeyResponse(ephemeralKey: $ephemeralKey, expiresAt: $expiresAt, sessionId: $sessionId, remainingSeconds: $remainingSeconds)';
}


}

/// @nodoc
abstract mixin class _$EphemeralKeyResponseCopyWith<$Res> implements $EphemeralKeyResponseCopyWith<$Res> {
  factory _$EphemeralKeyResponseCopyWith(_EphemeralKeyResponse value, $Res Function(_EphemeralKeyResponse) _then) = __$EphemeralKeyResponseCopyWithImpl;
@override @useResult
$Res call({
 String ephemeralKey, DateTime expiresAt, String sessionId, int remainingSeconds
});




}
/// @nodoc
class __$EphemeralKeyResponseCopyWithImpl<$Res>
    implements _$EphemeralKeyResponseCopyWith<$Res> {
  __$EphemeralKeyResponseCopyWithImpl(this._self, this._then);

  final _EphemeralKeyResponse _self;
  final $Res Function(_EphemeralKeyResponse) _then;

/// Create a copy of EphemeralKeyResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ephemeralKey = null,Object? expiresAt = null,Object? sessionId = null,Object? remainingSeconds = null,}) {
  return _then(_EphemeralKeyResponse(
ephemeralKey: null == ephemeralKey ? _self.ephemeralKey : ephemeralKey // ignore: cast_nullable_to_non_nullable
as String,expiresAt: null == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as DateTime,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AiUsageInfo {

 int get usedSeconds; int get remainingSeconds;@JsonKey(name: 'limitSeconds') int get dailyLimitSeconds; DateTime get resetsAt;
/// Create a copy of AiUsageInfo
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiUsageInfoCopyWith<AiUsageInfo> get copyWith => _$AiUsageInfoCopyWithImpl<AiUsageInfo>(this as AiUsageInfo, _$identity);

  /// Serializes this AiUsageInfo to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiUsageInfo&&(identical(other.usedSeconds, usedSeconds) || other.usedSeconds == usedSeconds)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.dailyLimitSeconds, dailyLimitSeconds) || other.dailyLimitSeconds == dailyLimitSeconds)&&(identical(other.resetsAt, resetsAt) || other.resetsAt == resetsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usedSeconds,remainingSeconds,dailyLimitSeconds,resetsAt);

@override
String toString() {
  return 'AiUsageInfo(usedSeconds: $usedSeconds, remainingSeconds: $remainingSeconds, dailyLimitSeconds: $dailyLimitSeconds, resetsAt: $resetsAt)';
}


}

/// @nodoc
abstract mixin class $AiUsageInfoCopyWith<$Res>  {
  factory $AiUsageInfoCopyWith(AiUsageInfo value, $Res Function(AiUsageInfo) _then) = _$AiUsageInfoCopyWithImpl;
@useResult
$Res call({
 int usedSeconds, int remainingSeconds,@JsonKey(name: 'limitSeconds') int dailyLimitSeconds, DateTime resetsAt
});




}
/// @nodoc
class _$AiUsageInfoCopyWithImpl<$Res>
    implements $AiUsageInfoCopyWith<$Res> {
  _$AiUsageInfoCopyWithImpl(this._self, this._then);

  final AiUsageInfo _self;
  final $Res Function(AiUsageInfo) _then;

/// Create a copy of AiUsageInfo
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? usedSeconds = null,Object? remainingSeconds = null,Object? dailyLimitSeconds = null,Object? resetsAt = null,}) {
  return _then(_self.copyWith(
usedSeconds: null == usedSeconds ? _self.usedSeconds : usedSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,dailyLimitSeconds: null == dailyLimitSeconds ? _self.dailyLimitSeconds : dailyLimitSeconds // ignore: cast_nullable_to_non_nullable
as int,resetsAt: null == resetsAt ? _self.resetsAt : resetsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AiUsageInfo].
extension AiUsageInfoPatterns on AiUsageInfo {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiUsageInfo value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiUsageInfo() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiUsageInfo value)  $default,){
final _that = this;
switch (_that) {
case _AiUsageInfo():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiUsageInfo value)?  $default,){
final _that = this;
switch (_that) {
case _AiUsageInfo() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int usedSeconds,  int remainingSeconds, @JsonKey(name: 'limitSeconds')  int dailyLimitSeconds,  DateTime resetsAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiUsageInfo() when $default != null:
return $default(_that.usedSeconds,_that.remainingSeconds,_that.dailyLimitSeconds,_that.resetsAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int usedSeconds,  int remainingSeconds, @JsonKey(name: 'limitSeconds')  int dailyLimitSeconds,  DateTime resetsAt)  $default,) {final _that = this;
switch (_that) {
case _AiUsageInfo():
return $default(_that.usedSeconds,_that.remainingSeconds,_that.dailyLimitSeconds,_that.resetsAt);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int usedSeconds,  int remainingSeconds, @JsonKey(name: 'limitSeconds')  int dailyLimitSeconds,  DateTime resetsAt)?  $default,) {final _that = this;
switch (_that) {
case _AiUsageInfo() when $default != null:
return $default(_that.usedSeconds,_that.remainingSeconds,_that.dailyLimitSeconds,_that.resetsAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AiUsageInfo extends AiUsageInfo {
  const _AiUsageInfo({required this.usedSeconds, required this.remainingSeconds, @JsonKey(name: 'limitSeconds') required this.dailyLimitSeconds, required this.resetsAt}): super._();
  factory _AiUsageInfo.fromJson(Map<String, dynamic> json) => _$AiUsageInfoFromJson(json);

@override final  int usedSeconds;
@override final  int remainingSeconds;
@override@JsonKey(name: 'limitSeconds') final  int dailyLimitSeconds;
@override final  DateTime resetsAt;

/// Create a copy of AiUsageInfo
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiUsageInfoCopyWith<_AiUsageInfo> get copyWith => __$AiUsageInfoCopyWithImpl<_AiUsageInfo>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AiUsageInfoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiUsageInfo&&(identical(other.usedSeconds, usedSeconds) || other.usedSeconds == usedSeconds)&&(identical(other.remainingSeconds, remainingSeconds) || other.remainingSeconds == remainingSeconds)&&(identical(other.dailyLimitSeconds, dailyLimitSeconds) || other.dailyLimitSeconds == dailyLimitSeconds)&&(identical(other.resetsAt, resetsAt) || other.resetsAt == resetsAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,usedSeconds,remainingSeconds,dailyLimitSeconds,resetsAt);

@override
String toString() {
  return 'AiUsageInfo(usedSeconds: $usedSeconds, remainingSeconds: $remainingSeconds, dailyLimitSeconds: $dailyLimitSeconds, resetsAt: $resetsAt)';
}


}

/// @nodoc
abstract mixin class _$AiUsageInfoCopyWith<$Res> implements $AiUsageInfoCopyWith<$Res> {
  factory _$AiUsageInfoCopyWith(_AiUsageInfo value, $Res Function(_AiUsageInfo) _then) = __$AiUsageInfoCopyWithImpl;
@override @useResult
$Res call({
 int usedSeconds, int remainingSeconds,@JsonKey(name: 'limitSeconds') int dailyLimitSeconds, DateTime resetsAt
});




}
/// @nodoc
class __$AiUsageInfoCopyWithImpl<$Res>
    implements _$AiUsageInfoCopyWith<$Res> {
  __$AiUsageInfoCopyWithImpl(this._self, this._then);

  final _AiUsageInfo _self;
  final $Res Function(_AiUsageInfo) _then;

/// Create a copy of AiUsageInfo
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? usedSeconds = null,Object? remainingSeconds = null,Object? dailyLimitSeconds = null,Object? resetsAt = null,}) {
  return _then(_AiUsageInfo(
usedSeconds: null == usedSeconds ? _self.usedSeconds : usedSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingSeconds: null == remainingSeconds ? _self.remainingSeconds : remainingSeconds // ignore: cast_nullable_to_non_nullable
as int,dailyLimitSeconds: null == dailyLimitSeconds ? _self.dailyLimitSeconds : dailyLimitSeconds // ignore: cast_nullable_to_non_nullable
as int,resetsAt: null == resetsAt ? _self.resetsAt : resetsAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TopicCategory {

 String get id; String get name; String get icon; List<Topic> get topics;
/// Create a copy of TopicCategory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCategoryCopyWith<TopicCategory> get copyWith => _$TopicCategoryCopyWithImpl<TopicCategory>(this as TopicCategory, _$identity);

  /// Serializes this TopicCategory to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TopicCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other.topics, topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,const DeepCollectionEquality().hash(topics));

@override
String toString() {
  return 'TopicCategory(id: $id, name: $name, icon: $icon, topics: $topics)';
}


}

/// @nodoc
abstract mixin class $TopicCategoryCopyWith<$Res>  {
  factory $TopicCategoryCopyWith(TopicCategory value, $Res Function(TopicCategory) _then) = _$TopicCategoryCopyWithImpl;
@useResult
$Res call({
 String id, String name, String icon, List<Topic> topics
});




}
/// @nodoc
class _$TopicCategoryCopyWithImpl<$Res>
    implements $TopicCategoryCopyWith<$Res> {
  _$TopicCategoryCopyWithImpl(this._self, this._then);

  final TopicCategory _self;
  final $Res Function(TopicCategory) _then;

/// Create a copy of TopicCategory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? topics = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self.topics : topics // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}

}


/// Adds pattern-matching-related methods to [TopicCategory].
extension TopicCategoryPatterns on TopicCategory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TopicCategory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TopicCategory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TopicCategory value)  $default,){
final _that = this;
switch (_that) {
case _TopicCategory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TopicCategory value)?  $default,){
final _that = this;
switch (_that) {
case _TopicCategory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String icon,  List<Topic> topics)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TopicCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.topics);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String icon,  List<Topic> topics)  $default,) {final _that = this;
switch (_that) {
case _TopicCategory():
return $default(_that.id,_that.name,_that.icon,_that.topics);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String icon,  List<Topic> topics)?  $default,) {final _that = this;
switch (_that) {
case _TopicCategory() when $default != null:
return $default(_that.id,_that.name,_that.icon,_that.topics);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TopicCategory implements TopicCategory {
  const _TopicCategory({required this.id, required this.name, required this.icon, required final  List<Topic> topics}): _topics = topics;
  factory _TopicCategory.fromJson(Map<String, dynamic> json) => _$TopicCategoryFromJson(json);

@override final  String id;
@override final  String name;
@override final  String icon;
 final  List<Topic> _topics;
@override List<Topic> get topics {
  if (_topics is EqualUnmodifiableListView) return _topics;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topics);
}


/// Create a copy of TopicCategory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCategoryCopyWith<_TopicCategory> get copyWith => __$TopicCategoryCopyWithImpl<_TopicCategory>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicCategoryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TopicCategory&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.icon, icon) || other.icon == icon)&&const DeepCollectionEquality().equals(other._topics, _topics));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,icon,const DeepCollectionEquality().hash(_topics));

@override
String toString() {
  return 'TopicCategory(id: $id, name: $name, icon: $icon, topics: $topics)';
}


}

/// @nodoc
abstract mixin class _$TopicCategoryCopyWith<$Res> implements $TopicCategoryCopyWith<$Res> {
  factory _$TopicCategoryCopyWith(_TopicCategory value, $Res Function(_TopicCategory) _then) = __$TopicCategoryCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String icon, List<Topic> topics
});




}
/// @nodoc
class __$TopicCategoryCopyWithImpl<$Res>
    implements _$TopicCategoryCopyWith<$Res> {
  __$TopicCategoryCopyWithImpl(this._self, this._then);

  final _TopicCategory _self;
  final $Res Function(_TopicCategory) _then;

/// Create a copy of TopicCategory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? icon = null,Object? topics = null,}) {
  return _then(_TopicCategory(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,topics: null == topics ? _self._topics : topics // ignore: cast_nullable_to_non_nullable
as List<Topic>,
  ));
}


}


/// @nodoc
mixin _$Topic {

 String get id; String get name; String? get description;
/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TopicCopyWith<Topic> get copyWith => _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description);

@override
String toString() {
  return 'Topic(id: $id, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res>  {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) = _$TopicCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description
});




}
/// @nodoc
class _$TopicCopyWithImpl<$Res>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Topic].
extension TopicPatterns on Topic {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Topic value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Topic value)  $default,){
final _that = this;
switch (_that) {
case _Topic():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Topic value)?  $default,){
final _that = this;
switch (_that) {
case _Topic() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _Topic():
return $default(_that.id,_that.name,_that.description);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _Topic() when $default != null:
return $default(_that.id,_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Topic implements Topic {
  const _Topic({required this.id, required this.name, this.description});
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TopicCopyWith<_Topic> get copyWith => __$TopicCopyWithImpl<_Topic>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TopicToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Topic&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description);

@override
String toString() {
  return 'Topic(id: $id, name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) = __$TopicCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description
});




}
/// @nodoc
class __$TopicCopyWithImpl<$Res>
    implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

/// Create a copy of Topic
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,}) {
  return _then(_Topic(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Scenario {

 String get id; String get name; String get aiRole; String get userRole; String get description; String? get instructions;
/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScenarioCopyWith<Scenario> get copyWith => _$ScenarioCopyWithImpl<Scenario>(this as Scenario, _$identity);

  /// Serializes this Scenario to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Scenario&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.aiRole, aiRole) || other.aiRole == aiRole)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,aiRole,userRole,description,instructions);

@override
String toString() {
  return 'Scenario(id: $id, name: $name, aiRole: $aiRole, userRole: $userRole, description: $description, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class $ScenarioCopyWith<$Res>  {
  factory $ScenarioCopyWith(Scenario value, $Res Function(Scenario) _then) = _$ScenarioCopyWithImpl;
@useResult
$Res call({
 String id, String name, String aiRole, String userRole, String description, String? instructions
});




}
/// @nodoc
class _$ScenarioCopyWithImpl<$Res>
    implements $ScenarioCopyWith<$Res> {
  _$ScenarioCopyWithImpl(this._self, this._then);

  final Scenario _self;
  final $Res Function(Scenario) _then;

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? aiRole = null,Object? userRole = null,Object? description = null,Object? instructions = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aiRole: null == aiRole ? _self.aiRole : aiRole // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Scenario].
extension ScenarioPatterns on Scenario {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Scenario value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Scenario() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Scenario value)  $default,){
final _that = this;
switch (_that) {
case _Scenario():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Scenario value)?  $default,){
final _that = this;
switch (_that) {
case _Scenario() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String aiRole,  String userRole,  String description,  String? instructions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Scenario() when $default != null:
return $default(_that.id,_that.name,_that.aiRole,_that.userRole,_that.description,_that.instructions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String aiRole,  String userRole,  String description,  String? instructions)  $default,) {final _that = this;
switch (_that) {
case _Scenario():
return $default(_that.id,_that.name,_that.aiRole,_that.userRole,_that.description,_that.instructions);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String aiRole,  String userRole,  String description,  String? instructions)?  $default,) {final _that = this;
switch (_that) {
case _Scenario() when $default != null:
return $default(_that.id,_that.name,_that.aiRole,_that.userRole,_that.description,_that.instructions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Scenario implements Scenario {
  const _Scenario({required this.id, required this.name, required this.aiRole, required this.userRole, required this.description, this.instructions});
  factory _Scenario.fromJson(Map<String, dynamic> json) => _$ScenarioFromJson(json);

@override final  String id;
@override final  String name;
@override final  String aiRole;
@override final  String userRole;
@override final  String description;
@override final  String? instructions;

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ScenarioCopyWith<_Scenario> get copyWith => __$ScenarioCopyWithImpl<_Scenario>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ScenarioToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Scenario&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.aiRole, aiRole) || other.aiRole == aiRole)&&(identical(other.userRole, userRole) || other.userRole == userRole)&&(identical(other.description, description) || other.description == description)&&(identical(other.instructions, instructions) || other.instructions == instructions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,aiRole,userRole,description,instructions);

@override
String toString() {
  return 'Scenario(id: $id, name: $name, aiRole: $aiRole, userRole: $userRole, description: $description, instructions: $instructions)';
}


}

/// @nodoc
abstract mixin class _$ScenarioCopyWith<$Res> implements $ScenarioCopyWith<$Res> {
  factory _$ScenarioCopyWith(_Scenario value, $Res Function(_Scenario) _then) = __$ScenarioCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String aiRole, String userRole, String description, String? instructions
});




}
/// @nodoc
class __$ScenarioCopyWithImpl<$Res>
    implements _$ScenarioCopyWith<$Res> {
  __$ScenarioCopyWithImpl(this._self, this._then);

  final _Scenario _self;
  final $Res Function(_Scenario) _then;

/// Create a copy of Scenario
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? aiRole = null,Object? userRole = null,Object? description = null,Object? instructions = freezed,}) {
  return _then(_Scenario(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,aiRole: null == aiRole ? _self.aiRole : aiRole // ignore: cast_nullable_to_non_nullable
as String,userRole: null == userRole ? _self.userRole : userRole // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,instructions: freezed == instructions ? _self.instructions : instructions // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
