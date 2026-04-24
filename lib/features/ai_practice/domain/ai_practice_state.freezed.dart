// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ai_practice_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AiPracticeState {

 AiPracticePhase get phase;// Session info
 String? get sessionId; AiSessionMode get mode; AiPersona get persona; String? get topic; String? get scenario;// Connection states
 OpenAIConnectionState get openAIConnectionState; SpeechState get speechState; TtsState get ttsState;// Conversation
 List<AiMessage> get messages; String get currentUserText; String get currentAiText; Speaker get currentSpeaker;// Session timing
 DateTime? get sessionStartTime; int get sessionDurationSeconds; int get remainingDailySeconds;// 5 min default
// Corrections collected during session
 List<Correction> get corrections;// Stats (calculated on end)
 int get wordsSpoken;// Audio controls
 bool get isMuted; bool get isSpeakerOn;// TTS availability (false when TTS init failed)
 bool get ttsAvailable;// Error
 String? get error;// Whether the current error is a persistent STT failure (show manual retry)
 bool get sttPersistentError;
/// Create a copy of AiPracticeState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AiPracticeStateCopyWith<AiPracticeState> get copyWith => _$AiPracticeStateCopyWithImpl<AiPracticeState>(this as AiPracticeState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AiPracticeState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.openAIConnectionState, openAIConnectionState) || other.openAIConnectionState == openAIConnectionState)&&(identical(other.speechState, speechState) || other.speechState == speechState)&&(identical(other.ttsState, ttsState) || other.ttsState == ttsState)&&const DeepCollectionEquality().equals(other.messages, messages)&&(identical(other.currentUserText, currentUserText) || other.currentUserText == currentUserText)&&(identical(other.currentAiText, currentAiText) || other.currentAiText == currentAiText)&&(identical(other.currentSpeaker, currentSpeaker) || other.currentSpeaker == currentSpeaker)&&(identical(other.sessionStartTime, sessionStartTime) || other.sessionStartTime == sessionStartTime)&&(identical(other.sessionDurationSeconds, sessionDurationSeconds) || other.sessionDurationSeconds == sessionDurationSeconds)&&(identical(other.remainingDailySeconds, remainingDailySeconds) || other.remainingDailySeconds == remainingDailySeconds)&&const DeepCollectionEquality().equals(other.corrections, corrections)&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn)&&(identical(other.ttsAvailable, ttsAvailable) || other.ttsAvailable == ttsAvailable)&&(identical(other.error, error) || other.error == error)&&(identical(other.sttPersistentError, sttPersistentError) || other.sttPersistentError == sttPersistentError));
}


@override
int get hashCode => Object.hashAll([runtimeType,phase,sessionId,mode,persona,topic,scenario,openAIConnectionState,speechState,ttsState,const DeepCollectionEquality().hash(messages),currentUserText,currentAiText,currentSpeaker,sessionStartTime,sessionDurationSeconds,remainingDailySeconds,const DeepCollectionEquality().hash(corrections),wordsSpoken,isMuted,isSpeakerOn,ttsAvailable,error,sttPersistentError]);

@override
String toString() {
  return 'AiPracticeState(phase: $phase, sessionId: $sessionId, mode: $mode, persona: $persona, topic: $topic, scenario: $scenario, openAIConnectionState: $openAIConnectionState, speechState: $speechState, ttsState: $ttsState, messages: $messages, currentUserText: $currentUserText, currentAiText: $currentAiText, currentSpeaker: $currentSpeaker, sessionStartTime: $sessionStartTime, sessionDurationSeconds: $sessionDurationSeconds, remainingDailySeconds: $remainingDailySeconds, corrections: $corrections, wordsSpoken: $wordsSpoken, isMuted: $isMuted, isSpeakerOn: $isSpeakerOn, ttsAvailable: $ttsAvailable, error: $error, sttPersistentError: $sttPersistentError)';
}


}

/// @nodoc
abstract mixin class $AiPracticeStateCopyWith<$Res>  {
  factory $AiPracticeStateCopyWith(AiPracticeState value, $Res Function(AiPracticeState) _then) = _$AiPracticeStateCopyWithImpl;
@useResult
$Res call({
 AiPracticePhase phase, String? sessionId, AiSessionMode mode, AiPersona persona, String? topic, String? scenario, OpenAIConnectionState openAIConnectionState, SpeechState speechState, TtsState ttsState, List<AiMessage> messages, String currentUserText, String currentAiText, Speaker currentSpeaker, DateTime? sessionStartTime, int sessionDurationSeconds, int remainingDailySeconds, List<Correction> corrections, int wordsSpoken, bool isMuted, bool isSpeakerOn, bool ttsAvailable, String? error, bool sttPersistentError
});




}
/// @nodoc
class _$AiPracticeStateCopyWithImpl<$Res>
    implements $AiPracticeStateCopyWith<$Res> {
  _$AiPracticeStateCopyWithImpl(this._self, this._then);

  final AiPracticeState _self;
  final $Res Function(AiPracticeState) _then;

/// Create a copy of AiPracticeState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? sessionId = freezed,Object? mode = null,Object? persona = null,Object? topic = freezed,Object? scenario = freezed,Object? openAIConnectionState = null,Object? speechState = null,Object? ttsState = null,Object? messages = null,Object? currentUserText = null,Object? currentAiText = null,Object? currentSpeaker = null,Object? sessionStartTime = freezed,Object? sessionDurationSeconds = null,Object? remainingDailySeconds = null,Object? corrections = null,Object? wordsSpoken = null,Object? isMuted = null,Object? isSpeakerOn = null,Object? ttsAvailable = null,Object? error = freezed,Object? sttPersistentError = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as AiPracticePhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiSessionMode,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AiPersona,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,scenario: freezed == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String?,openAIConnectionState: null == openAIConnectionState ? _self.openAIConnectionState : openAIConnectionState // ignore: cast_nullable_to_non_nullable
as OpenAIConnectionState,speechState: null == speechState ? _self.speechState : speechState // ignore: cast_nullable_to_non_nullable
as SpeechState,ttsState: null == ttsState ? _self.ttsState : ttsState // ignore: cast_nullable_to_non_nullable
as TtsState,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,currentUserText: null == currentUserText ? _self.currentUserText : currentUserText // ignore: cast_nullable_to_non_nullable
as String,currentAiText: null == currentAiText ? _self.currentAiText : currentAiText // ignore: cast_nullable_to_non_nullable
as String,currentSpeaker: null == currentSpeaker ? _self.currentSpeaker : currentSpeaker // ignore: cast_nullable_to_non_nullable
as Speaker,sessionStartTime: freezed == sessionStartTime ? _self.sessionStartTime : sessionStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,sessionDurationSeconds: null == sessionDurationSeconds ? _self.sessionDurationSeconds : sessionDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingDailySeconds: null == remainingDailySeconds ? _self.remainingDailySeconds : remainingDailySeconds // ignore: cast_nullable_to_non_nullable
as int,corrections: null == corrections ? _self.corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<Correction>,wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,ttsAvailable: null == ttsAvailable ? _self.ttsAvailable : ttsAvailable // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,sttPersistentError: null == sttPersistentError ? _self.sttPersistentError : sttPersistentError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AiPracticeState].
extension AiPracticeStatePatterns on AiPracticeState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AiPracticeState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AiPracticeState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AiPracticeState value)  $default,){
final _that = this;
switch (_that) {
case _AiPracticeState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AiPracticeState value)?  $default,){
final _that = this;
switch (_that) {
case _AiPracticeState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AiPracticePhase phase,  String? sessionId,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  OpenAIConnectionState openAIConnectionState,  SpeechState speechState,  TtsState ttsState,  List<AiMessage> messages,  String currentUserText,  String currentAiText,  Speaker currentSpeaker,  DateTime? sessionStartTime,  int sessionDurationSeconds,  int remainingDailySeconds,  List<Correction> corrections,  int wordsSpoken,  bool isMuted,  bool isSpeakerOn,  bool ttsAvailable,  String? error,  bool sttPersistentError)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AiPracticeState() when $default != null:
return $default(_that.phase,_that.sessionId,_that.mode,_that.persona,_that.topic,_that.scenario,_that.openAIConnectionState,_that.speechState,_that.ttsState,_that.messages,_that.currentUserText,_that.currentAiText,_that.currentSpeaker,_that.sessionStartTime,_that.sessionDurationSeconds,_that.remainingDailySeconds,_that.corrections,_that.wordsSpoken,_that.isMuted,_that.isSpeakerOn,_that.ttsAvailable,_that.error,_that.sttPersistentError);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AiPracticePhase phase,  String? sessionId,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  OpenAIConnectionState openAIConnectionState,  SpeechState speechState,  TtsState ttsState,  List<AiMessage> messages,  String currentUserText,  String currentAiText,  Speaker currentSpeaker,  DateTime? sessionStartTime,  int sessionDurationSeconds,  int remainingDailySeconds,  List<Correction> corrections,  int wordsSpoken,  bool isMuted,  bool isSpeakerOn,  bool ttsAvailable,  String? error,  bool sttPersistentError)  $default,) {final _that = this;
switch (_that) {
case _AiPracticeState():
return $default(_that.phase,_that.sessionId,_that.mode,_that.persona,_that.topic,_that.scenario,_that.openAIConnectionState,_that.speechState,_that.ttsState,_that.messages,_that.currentUserText,_that.currentAiText,_that.currentSpeaker,_that.sessionStartTime,_that.sessionDurationSeconds,_that.remainingDailySeconds,_that.corrections,_that.wordsSpoken,_that.isMuted,_that.isSpeakerOn,_that.ttsAvailable,_that.error,_that.sttPersistentError);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AiPracticePhase phase,  String? sessionId,  AiSessionMode mode,  AiPersona persona,  String? topic,  String? scenario,  OpenAIConnectionState openAIConnectionState,  SpeechState speechState,  TtsState ttsState,  List<AiMessage> messages,  String currentUserText,  String currentAiText,  Speaker currentSpeaker,  DateTime? sessionStartTime,  int sessionDurationSeconds,  int remainingDailySeconds,  List<Correction> corrections,  int wordsSpoken,  bool isMuted,  bool isSpeakerOn,  bool ttsAvailable,  String? error,  bool sttPersistentError)?  $default,) {final _that = this;
switch (_that) {
case _AiPracticeState() when $default != null:
return $default(_that.phase,_that.sessionId,_that.mode,_that.persona,_that.topic,_that.scenario,_that.openAIConnectionState,_that.speechState,_that.ttsState,_that.messages,_that.currentUserText,_that.currentAiText,_that.currentSpeaker,_that.sessionStartTime,_that.sessionDurationSeconds,_that.remainingDailySeconds,_that.corrections,_that.wordsSpoken,_that.isMuted,_that.isSpeakerOn,_that.ttsAvailable,_that.error,_that.sttPersistentError);case _:
  return null;

}
}

}

/// @nodoc


class _AiPracticeState extends AiPracticeState {
  const _AiPracticeState({this.phase = AiPracticePhase.idle, this.sessionId, this.mode = AiSessionMode.freeChat, this.persona = AiPersona.emma, this.topic, this.scenario, this.openAIConnectionState = OpenAIConnectionState.disconnected, this.speechState = SpeechState.idle, this.ttsState = TtsState.idle, final  List<AiMessage> messages = const [], this.currentUserText = '', this.currentAiText = '', this.currentSpeaker = Speaker.none, this.sessionStartTime, this.sessionDurationSeconds = 0, this.remainingDailySeconds = 300, final  List<Correction> corrections = const [], this.wordsSpoken = 0, this.isMuted = false, this.isSpeakerOn = true, this.ttsAvailable = true, this.error, this.sttPersistentError = false}): _messages = messages,_corrections = corrections,super._();
  

@override@JsonKey() final  AiPracticePhase phase;
// Session info
@override final  String? sessionId;
@override@JsonKey() final  AiSessionMode mode;
@override@JsonKey() final  AiPersona persona;
@override final  String? topic;
@override final  String? scenario;
// Connection states
@override@JsonKey() final  OpenAIConnectionState openAIConnectionState;
@override@JsonKey() final  SpeechState speechState;
@override@JsonKey() final  TtsState ttsState;
// Conversation
 final  List<AiMessage> _messages;
// Conversation
@override@JsonKey() List<AiMessage> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

@override@JsonKey() final  String currentUserText;
@override@JsonKey() final  String currentAiText;
@override@JsonKey() final  Speaker currentSpeaker;
// Session timing
@override final  DateTime? sessionStartTime;
@override@JsonKey() final  int sessionDurationSeconds;
@override@JsonKey() final  int remainingDailySeconds;
// 5 min default
// Corrections collected during session
 final  List<Correction> _corrections;
// 5 min default
// Corrections collected during session
@override@JsonKey() List<Correction> get corrections {
  if (_corrections is EqualUnmodifiableListView) return _corrections;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_corrections);
}

// Stats (calculated on end)
@override@JsonKey() final  int wordsSpoken;
// Audio controls
@override@JsonKey() final  bool isMuted;
@override@JsonKey() final  bool isSpeakerOn;
// TTS availability (false when TTS init failed)
@override@JsonKey() final  bool ttsAvailable;
// Error
@override final  String? error;
// Whether the current error is a persistent STT failure (show manual retry)
@override@JsonKey() final  bool sttPersistentError;

/// Create a copy of AiPracticeState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AiPracticeStateCopyWith<_AiPracticeState> get copyWith => __$AiPracticeStateCopyWithImpl<_AiPracticeState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AiPracticeState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.persona, persona) || other.persona == persona)&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.scenario, scenario) || other.scenario == scenario)&&(identical(other.openAIConnectionState, openAIConnectionState) || other.openAIConnectionState == openAIConnectionState)&&(identical(other.speechState, speechState) || other.speechState == speechState)&&(identical(other.ttsState, ttsState) || other.ttsState == ttsState)&&const DeepCollectionEquality().equals(other._messages, _messages)&&(identical(other.currentUserText, currentUserText) || other.currentUserText == currentUserText)&&(identical(other.currentAiText, currentAiText) || other.currentAiText == currentAiText)&&(identical(other.currentSpeaker, currentSpeaker) || other.currentSpeaker == currentSpeaker)&&(identical(other.sessionStartTime, sessionStartTime) || other.sessionStartTime == sessionStartTime)&&(identical(other.sessionDurationSeconds, sessionDurationSeconds) || other.sessionDurationSeconds == sessionDurationSeconds)&&(identical(other.remainingDailySeconds, remainingDailySeconds) || other.remainingDailySeconds == remainingDailySeconds)&&const DeepCollectionEquality().equals(other._corrections, _corrections)&&(identical(other.wordsSpoken, wordsSpoken) || other.wordsSpoken == wordsSpoken)&&(identical(other.isMuted, isMuted) || other.isMuted == isMuted)&&(identical(other.isSpeakerOn, isSpeakerOn) || other.isSpeakerOn == isSpeakerOn)&&(identical(other.ttsAvailable, ttsAvailable) || other.ttsAvailable == ttsAvailable)&&(identical(other.error, error) || other.error == error)&&(identical(other.sttPersistentError, sttPersistentError) || other.sttPersistentError == sttPersistentError));
}


@override
int get hashCode => Object.hashAll([runtimeType,phase,sessionId,mode,persona,topic,scenario,openAIConnectionState,speechState,ttsState,const DeepCollectionEquality().hash(_messages),currentUserText,currentAiText,currentSpeaker,sessionStartTime,sessionDurationSeconds,remainingDailySeconds,const DeepCollectionEquality().hash(_corrections),wordsSpoken,isMuted,isSpeakerOn,ttsAvailable,error,sttPersistentError]);

@override
String toString() {
  return 'AiPracticeState(phase: $phase, sessionId: $sessionId, mode: $mode, persona: $persona, topic: $topic, scenario: $scenario, openAIConnectionState: $openAIConnectionState, speechState: $speechState, ttsState: $ttsState, messages: $messages, currentUserText: $currentUserText, currentAiText: $currentAiText, currentSpeaker: $currentSpeaker, sessionStartTime: $sessionStartTime, sessionDurationSeconds: $sessionDurationSeconds, remainingDailySeconds: $remainingDailySeconds, corrections: $corrections, wordsSpoken: $wordsSpoken, isMuted: $isMuted, isSpeakerOn: $isSpeakerOn, ttsAvailable: $ttsAvailable, error: $error, sttPersistentError: $sttPersistentError)';
}


}

/// @nodoc
abstract mixin class _$AiPracticeStateCopyWith<$Res> implements $AiPracticeStateCopyWith<$Res> {
  factory _$AiPracticeStateCopyWith(_AiPracticeState value, $Res Function(_AiPracticeState) _then) = __$AiPracticeStateCopyWithImpl;
@override @useResult
$Res call({
 AiPracticePhase phase, String? sessionId, AiSessionMode mode, AiPersona persona, String? topic, String? scenario, OpenAIConnectionState openAIConnectionState, SpeechState speechState, TtsState ttsState, List<AiMessage> messages, String currentUserText, String currentAiText, Speaker currentSpeaker, DateTime? sessionStartTime, int sessionDurationSeconds, int remainingDailySeconds, List<Correction> corrections, int wordsSpoken, bool isMuted, bool isSpeakerOn, bool ttsAvailable, String? error, bool sttPersistentError
});




}
/// @nodoc
class __$AiPracticeStateCopyWithImpl<$Res>
    implements _$AiPracticeStateCopyWith<$Res> {
  __$AiPracticeStateCopyWithImpl(this._self, this._then);

  final _AiPracticeState _self;
  final $Res Function(_AiPracticeState) _then;

/// Create a copy of AiPracticeState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? sessionId = freezed,Object? mode = null,Object? persona = null,Object? topic = freezed,Object? scenario = freezed,Object? openAIConnectionState = null,Object? speechState = null,Object? ttsState = null,Object? messages = null,Object? currentUserText = null,Object? currentAiText = null,Object? currentSpeaker = null,Object? sessionStartTime = freezed,Object? sessionDurationSeconds = null,Object? remainingDailySeconds = null,Object? corrections = null,Object? wordsSpoken = null,Object? isMuted = null,Object? isSpeakerOn = null,Object? ttsAvailable = null,Object? error = freezed,Object? sttPersistentError = null,}) {
  return _then(_AiPracticeState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as AiPracticePhase,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as AiSessionMode,persona: null == persona ? _self.persona : persona // ignore: cast_nullable_to_non_nullable
as AiPersona,topic: freezed == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String?,scenario: freezed == scenario ? _self.scenario : scenario // ignore: cast_nullable_to_non_nullable
as String?,openAIConnectionState: null == openAIConnectionState ? _self.openAIConnectionState : openAIConnectionState // ignore: cast_nullable_to_non_nullable
as OpenAIConnectionState,speechState: null == speechState ? _self.speechState : speechState // ignore: cast_nullable_to_non_nullable
as SpeechState,ttsState: null == ttsState ? _self.ttsState : ttsState // ignore: cast_nullable_to_non_nullable
as TtsState,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<AiMessage>,currentUserText: null == currentUserText ? _self.currentUserText : currentUserText // ignore: cast_nullable_to_non_nullable
as String,currentAiText: null == currentAiText ? _self.currentAiText : currentAiText // ignore: cast_nullable_to_non_nullable
as String,currentSpeaker: null == currentSpeaker ? _self.currentSpeaker : currentSpeaker // ignore: cast_nullable_to_non_nullable
as Speaker,sessionStartTime: freezed == sessionStartTime ? _self.sessionStartTime : sessionStartTime // ignore: cast_nullable_to_non_nullable
as DateTime?,sessionDurationSeconds: null == sessionDurationSeconds ? _self.sessionDurationSeconds : sessionDurationSeconds // ignore: cast_nullable_to_non_nullable
as int,remainingDailySeconds: null == remainingDailySeconds ? _self.remainingDailySeconds : remainingDailySeconds // ignore: cast_nullable_to_non_nullable
as int,corrections: null == corrections ? _self._corrections : corrections // ignore: cast_nullable_to_non_nullable
as List<Correction>,wordsSpoken: null == wordsSpoken ? _self.wordsSpoken : wordsSpoken // ignore: cast_nullable_to_non_nullable
as int,isMuted: null == isMuted ? _self.isMuted : isMuted // ignore: cast_nullable_to_non_nullable
as bool,isSpeakerOn: null == isSpeakerOn ? _self.isSpeakerOn : isSpeakerOn // ignore: cast_nullable_to_non_nullable
as bool,ttsAvailable: null == ttsAvailable ? _self.ttsAvailable : ttsAvailable // ignore: cast_nullable_to_non_nullable
as bool,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,sttPersistentError: null == sttPersistentError ? _self.sttPersistentError : sttPersistentError // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc
mixin _$ModeSelectionState {

 bool get isLoading; List<TopicCategory> get topicCategories; List<Scenario> get scenarios; AiUsageInfo? get usageInfo; String? get error;
/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModeSelectionStateCopyWith<ModeSelectionState> get copyWith => _$ModeSelectionStateCopyWithImpl<ModeSelectionState>(this as ModeSelectionState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModeSelectionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other.topicCategories, topicCategories)&&const DeepCollectionEquality().equals(other.scenarios, scenarios)&&(identical(other.usageInfo, usageInfo) || other.usageInfo == usageInfo)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(topicCategories),const DeepCollectionEquality().hash(scenarios),usageInfo,error);

@override
String toString() {
  return 'ModeSelectionState(isLoading: $isLoading, topicCategories: $topicCategories, scenarios: $scenarios, usageInfo: $usageInfo, error: $error)';
}


}

/// @nodoc
abstract mixin class $ModeSelectionStateCopyWith<$Res>  {
  factory $ModeSelectionStateCopyWith(ModeSelectionState value, $Res Function(ModeSelectionState) _then) = _$ModeSelectionStateCopyWithImpl;
@useResult
$Res call({
 bool isLoading, List<TopicCategory> topicCategories, List<Scenario> scenarios, AiUsageInfo? usageInfo, String? error
});


$AiUsageInfoCopyWith<$Res>? get usageInfo;

}
/// @nodoc
class _$ModeSelectionStateCopyWithImpl<$Res>
    implements $ModeSelectionStateCopyWith<$Res> {
  _$ModeSelectionStateCopyWithImpl(this._self, this._then);

  final ModeSelectionState _self;
  final $Res Function(ModeSelectionState) _then;

/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isLoading = null,Object? topicCategories = null,Object? scenarios = null,Object? usageInfo = freezed,Object? error = freezed,}) {
  return _then(_self.copyWith(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,topicCategories: null == topicCategories ? _self.topicCategories : topicCategories // ignore: cast_nullable_to_non_nullable
as List<TopicCategory>,scenarios: null == scenarios ? _self.scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<Scenario>,usageInfo: freezed == usageInfo ? _self.usageInfo : usageInfo // ignore: cast_nullable_to_non_nullable
as AiUsageInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageInfoCopyWith<$Res>? get usageInfo {
    if (_self.usageInfo == null) {
    return null;
  }

  return $AiUsageInfoCopyWith<$Res>(_self.usageInfo!, (value) {
    return _then(_self.copyWith(usageInfo: value));
  });
}
}


/// Adds pattern-matching-related methods to [ModeSelectionState].
extension ModeSelectionStatePatterns on ModeSelectionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModeSelectionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModeSelectionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModeSelectionState value)  $default,){
final _that = this;
switch (_that) {
case _ModeSelectionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModeSelectionState value)?  $default,){
final _that = this;
switch (_that) {
case _ModeSelectionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isLoading,  List<TopicCategory> topicCategories,  List<Scenario> scenarios,  AiUsageInfo? usageInfo,  String? error)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModeSelectionState() when $default != null:
return $default(_that.isLoading,_that.topicCategories,_that.scenarios,_that.usageInfo,_that.error);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isLoading,  List<TopicCategory> topicCategories,  List<Scenario> scenarios,  AiUsageInfo? usageInfo,  String? error)  $default,) {final _that = this;
switch (_that) {
case _ModeSelectionState():
return $default(_that.isLoading,_that.topicCategories,_that.scenarios,_that.usageInfo,_that.error);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isLoading,  List<TopicCategory> topicCategories,  List<Scenario> scenarios,  AiUsageInfo? usageInfo,  String? error)?  $default,) {final _that = this;
switch (_that) {
case _ModeSelectionState() when $default != null:
return $default(_that.isLoading,_that.topicCategories,_that.scenarios,_that.usageInfo,_that.error);case _:
  return null;

}
}

}

/// @nodoc


class _ModeSelectionState implements ModeSelectionState {
  const _ModeSelectionState({this.isLoading = false, final  List<TopicCategory> topicCategories = const [], final  List<Scenario> scenarios = const [], this.usageInfo, this.error}): _topicCategories = topicCategories,_scenarios = scenarios;
  

@override@JsonKey() final  bool isLoading;
 final  List<TopicCategory> _topicCategories;
@override@JsonKey() List<TopicCategory> get topicCategories {
  if (_topicCategories is EqualUnmodifiableListView) return _topicCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_topicCategories);
}

 final  List<Scenario> _scenarios;
@override@JsonKey() List<Scenario> get scenarios {
  if (_scenarios is EqualUnmodifiableListView) return _scenarios;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_scenarios);
}

@override final  AiUsageInfo? usageInfo;
@override final  String? error;

/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModeSelectionStateCopyWith<_ModeSelectionState> get copyWith => __$ModeSelectionStateCopyWithImpl<_ModeSelectionState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModeSelectionState&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._topicCategories, _topicCategories)&&const DeepCollectionEquality().equals(other._scenarios, _scenarios)&&(identical(other.usageInfo, usageInfo) || other.usageInfo == usageInfo)&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,isLoading,const DeepCollectionEquality().hash(_topicCategories),const DeepCollectionEquality().hash(_scenarios),usageInfo,error);

@override
String toString() {
  return 'ModeSelectionState(isLoading: $isLoading, topicCategories: $topicCategories, scenarios: $scenarios, usageInfo: $usageInfo, error: $error)';
}


}

/// @nodoc
abstract mixin class _$ModeSelectionStateCopyWith<$Res> implements $ModeSelectionStateCopyWith<$Res> {
  factory _$ModeSelectionStateCopyWith(_ModeSelectionState value, $Res Function(_ModeSelectionState) _then) = __$ModeSelectionStateCopyWithImpl;
@override @useResult
$Res call({
 bool isLoading, List<TopicCategory> topicCategories, List<Scenario> scenarios, AiUsageInfo? usageInfo, String? error
});


@override $AiUsageInfoCopyWith<$Res>? get usageInfo;

}
/// @nodoc
class __$ModeSelectionStateCopyWithImpl<$Res>
    implements _$ModeSelectionStateCopyWith<$Res> {
  __$ModeSelectionStateCopyWithImpl(this._self, this._then);

  final _ModeSelectionState _self;
  final $Res Function(_ModeSelectionState) _then;

/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isLoading = null,Object? topicCategories = null,Object? scenarios = null,Object? usageInfo = freezed,Object? error = freezed,}) {
  return _then(_ModeSelectionState(
isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,topicCategories: null == topicCategories ? _self._topicCategories : topicCategories // ignore: cast_nullable_to_non_nullable
as List<TopicCategory>,scenarios: null == scenarios ? _self._scenarios : scenarios // ignore: cast_nullable_to_non_nullable
as List<Scenario>,usageInfo: freezed == usageInfo ? _self.usageInfo : usageInfo // ignore: cast_nullable_to_non_nullable
as AiUsageInfo?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of ModeSelectionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AiUsageInfoCopyWith<$Res>? get usageInfo {
    if (_self.usageInfo == null) {
    return null;
  }

  return $AiUsageInfoCopyWith<$Res>(_self.usageInfo!, (value) {
    return _then(_self.copyWith(usageInfo: value));
  });
}
}

// dart format on
