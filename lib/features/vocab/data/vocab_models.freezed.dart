// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vocab_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WordExample {

 String? get sessionLabel; String? get sessionId; String get text; int get highlightStart; int get highlightEnd; bool get isCorrect; String? get correction;
/// Create a copy of WordExample
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WordExampleCopyWith<WordExample> get copyWith => _$WordExampleCopyWithImpl<WordExample>(this as WordExample, _$identity);

  /// Serializes this WordExample to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WordExample&&(identical(other.sessionLabel, sessionLabel) || other.sessionLabel == sessionLabel)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.text, text) || other.text == text)&&(identical(other.highlightStart, highlightStart) || other.highlightStart == highlightStart)&&(identical(other.highlightEnd, highlightEnd) || other.highlightEnd == highlightEnd)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.correction, correction) || other.correction == correction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionLabel,sessionId,text,highlightStart,highlightEnd,isCorrect,correction);

@override
String toString() {
  return 'WordExample(sessionLabel: $sessionLabel, sessionId: $sessionId, text: $text, highlightStart: $highlightStart, highlightEnd: $highlightEnd, isCorrect: $isCorrect, correction: $correction)';
}


}

/// @nodoc
abstract mixin class $WordExampleCopyWith<$Res>  {
  factory $WordExampleCopyWith(WordExample value, $Res Function(WordExample) _then) = _$WordExampleCopyWithImpl;
@useResult
$Res call({
 String? sessionLabel, String? sessionId, String text, int highlightStart, int highlightEnd, bool isCorrect, String? correction
});




}
/// @nodoc
class _$WordExampleCopyWithImpl<$Res>
    implements $WordExampleCopyWith<$Res> {
  _$WordExampleCopyWithImpl(this._self, this._then);

  final WordExample _self;
  final $Res Function(WordExample) _then;

/// Create a copy of WordExample
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? sessionLabel = freezed,Object? sessionId = freezed,Object? text = null,Object? highlightStart = null,Object? highlightEnd = null,Object? isCorrect = null,Object? correction = freezed,}) {
  return _then(_self.copyWith(
sessionLabel: freezed == sessionLabel ? _self.sessionLabel : sessionLabel // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,highlightStart: null == highlightStart ? _self.highlightStart : highlightStart // ignore: cast_nullable_to_non_nullable
as int,highlightEnd: null == highlightEnd ? _self.highlightEnd : highlightEnd // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,correction: freezed == correction ? _self.correction : correction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WordExample].
extension WordExamplePatterns on WordExample {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WordExample value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WordExample() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WordExample value)  $default,){
final _that = this;
switch (_that) {
case _WordExample():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WordExample value)?  $default,){
final _that = this;
switch (_that) {
case _WordExample() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? sessionLabel,  String? sessionId,  String text,  int highlightStart,  int highlightEnd,  bool isCorrect,  String? correction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WordExample() when $default != null:
return $default(_that.sessionLabel,_that.sessionId,_that.text,_that.highlightStart,_that.highlightEnd,_that.isCorrect,_that.correction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? sessionLabel,  String? sessionId,  String text,  int highlightStart,  int highlightEnd,  bool isCorrect,  String? correction)  $default,) {final _that = this;
switch (_that) {
case _WordExample():
return $default(_that.sessionLabel,_that.sessionId,_that.text,_that.highlightStart,_that.highlightEnd,_that.isCorrect,_that.correction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? sessionLabel,  String? sessionId,  String text,  int highlightStart,  int highlightEnd,  bool isCorrect,  String? correction)?  $default,) {final _that = this;
switch (_that) {
case _WordExample() when $default != null:
return $default(_that.sessionLabel,_that.sessionId,_that.text,_that.highlightStart,_that.highlightEnd,_that.isCorrect,_that.correction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WordExample implements WordExample {
  const _WordExample({this.sessionLabel, this.sessionId, required this.text, this.highlightStart = 0, this.highlightEnd = 0, this.isCorrect = true, this.correction});
  factory _WordExample.fromJson(Map<String, dynamic> json) => _$WordExampleFromJson(json);

@override final  String? sessionLabel;
@override final  String? sessionId;
@override final  String text;
@override@JsonKey() final  int highlightStart;
@override@JsonKey() final  int highlightEnd;
@override@JsonKey() final  bool isCorrect;
@override final  String? correction;

/// Create a copy of WordExample
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WordExampleCopyWith<_WordExample> get copyWith => __$WordExampleCopyWithImpl<_WordExample>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WordExampleToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WordExample&&(identical(other.sessionLabel, sessionLabel) || other.sessionLabel == sessionLabel)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.text, text) || other.text == text)&&(identical(other.highlightStart, highlightStart) || other.highlightStart == highlightStart)&&(identical(other.highlightEnd, highlightEnd) || other.highlightEnd == highlightEnd)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&(identical(other.correction, correction) || other.correction == correction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,sessionLabel,sessionId,text,highlightStart,highlightEnd,isCorrect,correction);

@override
String toString() {
  return 'WordExample(sessionLabel: $sessionLabel, sessionId: $sessionId, text: $text, highlightStart: $highlightStart, highlightEnd: $highlightEnd, isCorrect: $isCorrect, correction: $correction)';
}


}

/// @nodoc
abstract mixin class _$WordExampleCopyWith<$Res> implements $WordExampleCopyWith<$Res> {
  factory _$WordExampleCopyWith(_WordExample value, $Res Function(_WordExample) _then) = __$WordExampleCopyWithImpl;
@override @useResult
$Res call({
 String? sessionLabel, String? sessionId, String text, int highlightStart, int highlightEnd, bool isCorrect, String? correction
});




}
/// @nodoc
class __$WordExampleCopyWithImpl<$Res>
    implements _$WordExampleCopyWith<$Res> {
  __$WordExampleCopyWithImpl(this._self, this._then);

  final _WordExample _self;
  final $Res Function(_WordExample) _then;

/// Create a copy of WordExample
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? sessionLabel = freezed,Object? sessionId = freezed,Object? text = null,Object? highlightStart = null,Object? highlightEnd = null,Object? isCorrect = null,Object? correction = freezed,}) {
  return _then(_WordExample(
sessionLabel: freezed == sessionLabel ? _self.sessionLabel : sessionLabel // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,highlightStart: null == highlightStart ? _self.highlightStart : highlightStart // ignore: cast_nullable_to_non_nullable
as int,highlightEnd: null == highlightEnd ? _self.highlightEnd : highlightEnd // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,correction: freezed == correction ? _self.correction : correction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$UserWord {

 String get word; int get count; int get usagePct; bool get isCorrect; List<WordExample> get examples;
/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserWordCopyWith<UserWord> get copyWith => _$UserWordCopyWithImpl<UserWord>(this as UserWord, _$identity);

  /// Serializes this UserWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserWord&&(identical(other.word, word) || other.word == word)&&(identical(other.count, count) || other.count == count)&&(identical(other.usagePct, usagePct) || other.usagePct == usagePct)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&const DeepCollectionEquality().equals(other.examples, examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,count,usagePct,isCorrect,const DeepCollectionEquality().hash(examples));

@override
String toString() {
  return 'UserWord(word: $word, count: $count, usagePct: $usagePct, isCorrect: $isCorrect, examples: $examples)';
}


}

/// @nodoc
abstract mixin class $UserWordCopyWith<$Res>  {
  factory $UserWordCopyWith(UserWord value, $Res Function(UserWord) _then) = _$UserWordCopyWithImpl;
@useResult
$Res call({
 String word, int count, int usagePct, bool isCorrect, List<WordExample> examples
});




}
/// @nodoc
class _$UserWordCopyWithImpl<$Res>
    implements $UserWordCopyWith<$Res> {
  _$UserWordCopyWithImpl(this._self, this._then);

  final UserWord _self;
  final $Res Function(UserWord) _then;

/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? count = null,Object? usagePct = null,Object? isCorrect = null,Object? examples = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,usagePct: null == usagePct ? _self.usagePct : usagePct // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,examples: null == examples ? _self.examples : examples // ignore: cast_nullable_to_non_nullable
as List<WordExample>,
  ));
}

}


/// Adds pattern-matching-related methods to [UserWord].
extension UserWordPatterns on UserWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserWord value)  $default,){
final _that = this;
switch (_that) {
case _UserWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserWord value)?  $default,){
final _that = this;
switch (_that) {
case _UserWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  int count,  int usagePct,  bool isCorrect,  List<WordExample> examples)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserWord() when $default != null:
return $default(_that.word,_that.count,_that.usagePct,_that.isCorrect,_that.examples);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  int count,  int usagePct,  bool isCorrect,  List<WordExample> examples)  $default,) {final _that = this;
switch (_that) {
case _UserWord():
return $default(_that.word,_that.count,_that.usagePct,_that.isCorrect,_that.examples);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  int count,  int usagePct,  bool isCorrect,  List<WordExample> examples)?  $default,) {final _that = this;
switch (_that) {
case _UserWord() when $default != null:
return $default(_that.word,_that.count,_that.usagePct,_that.isCorrect,_that.examples);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _UserWord implements UserWord {
  const _UserWord({required this.word, this.count = 0, this.usagePct = 0, this.isCorrect = true, final  List<WordExample> examples = const []}): _examples = examples;
  factory _UserWord.fromJson(Map<String, dynamic> json) => _$UserWordFromJson(json);

@override final  String word;
@override@JsonKey() final  int count;
@override@JsonKey() final  int usagePct;
@override@JsonKey() final  bool isCorrect;
 final  List<WordExample> _examples;
@override@JsonKey() List<WordExample> get examples {
  if (_examples is EqualUnmodifiableListView) return _examples;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_examples);
}


/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserWordCopyWith<_UserWord> get copyWith => __$UserWordCopyWithImpl<_UserWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserWord&&(identical(other.word, word) || other.word == word)&&(identical(other.count, count) || other.count == count)&&(identical(other.usagePct, usagePct) || other.usagePct == usagePct)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect)&&const DeepCollectionEquality().equals(other._examples, _examples));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,count,usagePct,isCorrect,const DeepCollectionEquality().hash(_examples));

@override
String toString() {
  return 'UserWord(word: $word, count: $count, usagePct: $usagePct, isCorrect: $isCorrect, examples: $examples)';
}


}

/// @nodoc
abstract mixin class _$UserWordCopyWith<$Res> implements $UserWordCopyWith<$Res> {
  factory _$UserWordCopyWith(_UserWord value, $Res Function(_UserWord) _then) = __$UserWordCopyWithImpl;
@override @useResult
$Res call({
 String word, int count, int usagePct, bool isCorrect, List<WordExample> examples
});




}
/// @nodoc
class __$UserWordCopyWithImpl<$Res>
    implements _$UserWordCopyWith<$Res> {
  __$UserWordCopyWithImpl(this._self, this._then);

  final _UserWord _self;
  final $Res Function(_UserWord) _then;

/// Create a copy of UserWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? count = null,Object? usagePct = null,Object? isCorrect = null,Object? examples = null,}) {
  return _then(_UserWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,usagePct: null == usagePct ? _self.usagePct : usagePct // ignore: cast_nullable_to_non_nullable
as int,isCorrect: null == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool,examples: null == examples ? _self._examples : examples // ignore: cast_nullable_to_non_nullable
as List<WordExample>,
  ));
}


}


/// @nodoc
mixin _$VocabStats {

 int get uniqueWords; int get correctUsagePct; int get sessions; double get totalHours; int get weeklyNewWords; String? get usageTrend;
/// Create a copy of VocabStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabStatsCopyWith<VocabStats> get copyWith => _$VocabStatsCopyWithImpl<VocabStats>(this as VocabStats, _$identity);

  /// Serializes this VocabStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabStats&&(identical(other.uniqueWords, uniqueWords) || other.uniqueWords == uniqueWords)&&(identical(other.correctUsagePct, correctUsagePct) || other.correctUsagePct == correctUsagePct)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.weeklyNewWords, weeklyNewWords) || other.weeklyNewWords == weeklyNewWords)&&(identical(other.usageTrend, usageTrend) || other.usageTrend == usageTrend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uniqueWords,correctUsagePct,sessions,totalHours,weeklyNewWords,usageTrend);

@override
String toString() {
  return 'VocabStats(uniqueWords: $uniqueWords, correctUsagePct: $correctUsagePct, sessions: $sessions, totalHours: $totalHours, weeklyNewWords: $weeklyNewWords, usageTrend: $usageTrend)';
}


}

/// @nodoc
abstract mixin class $VocabStatsCopyWith<$Res>  {
  factory $VocabStatsCopyWith(VocabStats value, $Res Function(VocabStats) _then) = _$VocabStatsCopyWithImpl;
@useResult
$Res call({
 int uniqueWords, int correctUsagePct, int sessions, double totalHours, int weeklyNewWords, String? usageTrend
});




}
/// @nodoc
class _$VocabStatsCopyWithImpl<$Res>
    implements $VocabStatsCopyWith<$Res> {
  _$VocabStatsCopyWithImpl(this._self, this._then);

  final VocabStats _self;
  final $Res Function(VocabStats) _then;

/// Create a copy of VocabStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uniqueWords = null,Object? correctUsagePct = null,Object? sessions = null,Object? totalHours = null,Object? weeklyNewWords = null,Object? usageTrend = freezed,}) {
  return _then(_self.copyWith(
uniqueWords: null == uniqueWords ? _self.uniqueWords : uniqueWords // ignore: cast_nullable_to_non_nullable
as int,correctUsagePct: null == correctUsagePct ? _self.correctUsagePct : correctUsagePct // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWords: null == weeklyNewWords ? _self.weeklyNewWords : weeklyNewWords // ignore: cast_nullable_to_non_nullable
as int,usageTrend: freezed == usageTrend ? _self.usageTrend : usageTrend // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [VocabStats].
extension VocabStatsPatterns on VocabStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabStats value)  $default,){
final _that = this;
switch (_that) {
case _VocabStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabStats value)?  $default,){
final _that = this;
switch (_that) {
case _VocabStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int uniqueWords,  int correctUsagePct,  int sessions,  double totalHours,  int weeklyNewWords,  String? usageTrend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabStats() when $default != null:
return $default(_that.uniqueWords,_that.correctUsagePct,_that.sessions,_that.totalHours,_that.weeklyNewWords,_that.usageTrend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int uniqueWords,  int correctUsagePct,  int sessions,  double totalHours,  int weeklyNewWords,  String? usageTrend)  $default,) {final _that = this;
switch (_that) {
case _VocabStats():
return $default(_that.uniqueWords,_that.correctUsagePct,_that.sessions,_that.totalHours,_that.weeklyNewWords,_that.usageTrend);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int uniqueWords,  int correctUsagePct,  int sessions,  double totalHours,  int weeklyNewWords,  String? usageTrend)?  $default,) {final _that = this;
switch (_that) {
case _VocabStats() when $default != null:
return $default(_that.uniqueWords,_that.correctUsagePct,_that.sessions,_that.totalHours,_that.weeklyNewWords,_that.usageTrend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabStats implements VocabStats {
  const _VocabStats({this.uniqueWords = 0, this.correctUsagePct = 0, this.sessions = 0, this.totalHours = 0, this.weeklyNewWords = 0, this.usageTrend});
  factory _VocabStats.fromJson(Map<String, dynamic> json) => _$VocabStatsFromJson(json);

@override@JsonKey() final  int uniqueWords;
@override@JsonKey() final  int correctUsagePct;
@override@JsonKey() final  int sessions;
@override@JsonKey() final  double totalHours;
@override@JsonKey() final  int weeklyNewWords;
@override final  String? usageTrend;

/// Create a copy of VocabStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabStatsCopyWith<_VocabStats> get copyWith => __$VocabStatsCopyWithImpl<_VocabStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabStatsToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabStats&&(identical(other.uniqueWords, uniqueWords) || other.uniqueWords == uniqueWords)&&(identical(other.correctUsagePct, correctUsagePct) || other.correctUsagePct == correctUsagePct)&&(identical(other.sessions, sessions) || other.sessions == sessions)&&(identical(other.totalHours, totalHours) || other.totalHours == totalHours)&&(identical(other.weeklyNewWords, weeklyNewWords) || other.weeklyNewWords == weeklyNewWords)&&(identical(other.usageTrend, usageTrend) || other.usageTrend == usageTrend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,uniqueWords,correctUsagePct,sessions,totalHours,weeklyNewWords,usageTrend);

@override
String toString() {
  return 'VocabStats(uniqueWords: $uniqueWords, correctUsagePct: $correctUsagePct, sessions: $sessions, totalHours: $totalHours, weeklyNewWords: $weeklyNewWords, usageTrend: $usageTrend)';
}


}

/// @nodoc
abstract mixin class _$VocabStatsCopyWith<$Res> implements $VocabStatsCopyWith<$Res> {
  factory _$VocabStatsCopyWith(_VocabStats value, $Res Function(_VocabStats) _then) = __$VocabStatsCopyWithImpl;
@override @useResult
$Res call({
 int uniqueWords, int correctUsagePct, int sessions, double totalHours, int weeklyNewWords, String? usageTrend
});




}
/// @nodoc
class __$VocabStatsCopyWithImpl<$Res>
    implements _$VocabStatsCopyWith<$Res> {
  __$VocabStatsCopyWithImpl(this._self, this._then);

  final _VocabStats _self;
  final $Res Function(_VocabStats) _then;

/// Create a copy of VocabStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uniqueWords = null,Object? correctUsagePct = null,Object? sessions = null,Object? totalHours = null,Object? weeklyNewWords = null,Object? usageTrend = freezed,}) {
  return _then(_VocabStats(
uniqueWords: null == uniqueWords ? _self.uniqueWords : uniqueWords // ignore: cast_nullable_to_non_nullable
as int,correctUsagePct: null == correctUsagePct ? _self.correctUsagePct : correctUsagePct // ignore: cast_nullable_to_non_nullable
as int,sessions: null == sessions ? _self.sessions : sessions // ignore: cast_nullable_to_non_nullable
as int,totalHours: null == totalHours ? _self.totalHours : totalHours // ignore: cast_nullable_to_non_nullable
as double,weeklyNewWords: null == weeklyNewWords ? _self.weeklyNewWords : weeklyNewWords // ignore: cast_nullable_to_non_nullable
as int,usageTrend: freezed == usageTrend ? _self.usageTrend : usageTrend // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$RarelyUsedWord {

 String get word; int get count;
/// Create a copy of RarelyUsedWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RarelyUsedWordCopyWith<RarelyUsedWord> get copyWith => _$RarelyUsedWordCopyWithImpl<RarelyUsedWord>(this as RarelyUsedWord, _$identity);

  /// Serializes this RarelyUsedWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RarelyUsedWord&&(identical(other.word, word) || other.word == word)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,count);

@override
String toString() {
  return 'RarelyUsedWord(word: $word, count: $count)';
}


}

/// @nodoc
abstract mixin class $RarelyUsedWordCopyWith<$Res>  {
  factory $RarelyUsedWordCopyWith(RarelyUsedWord value, $Res Function(RarelyUsedWord) _then) = _$RarelyUsedWordCopyWithImpl;
@useResult
$Res call({
 String word, int count
});




}
/// @nodoc
class _$RarelyUsedWordCopyWithImpl<$Res>
    implements $RarelyUsedWordCopyWith<$Res> {
  _$RarelyUsedWordCopyWithImpl(this._self, this._then);

  final RarelyUsedWord _self;
  final $Res Function(RarelyUsedWord) _then;

/// Create a copy of RarelyUsedWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? count = null,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RarelyUsedWord].
extension RarelyUsedWordPatterns on RarelyUsedWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RarelyUsedWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RarelyUsedWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RarelyUsedWord value)  $default,){
final _that = this;
switch (_that) {
case _RarelyUsedWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RarelyUsedWord value)?  $default,){
final _that = this;
switch (_that) {
case _RarelyUsedWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  int count)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RarelyUsedWord() when $default != null:
return $default(_that.word,_that.count);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  int count)  $default,) {final _that = this;
switch (_that) {
case _RarelyUsedWord():
return $default(_that.word,_that.count);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  int count)?  $default,) {final _that = this;
switch (_that) {
case _RarelyUsedWord() when $default != null:
return $default(_that.word,_that.count);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RarelyUsedWord implements RarelyUsedWord {
  const _RarelyUsedWord({required this.word, this.count = 0});
  factory _RarelyUsedWord.fromJson(Map<String, dynamic> json) => _$RarelyUsedWordFromJson(json);

@override final  String word;
@override@JsonKey() final  int count;

/// Create a copy of RarelyUsedWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RarelyUsedWordCopyWith<_RarelyUsedWord> get copyWith => __$RarelyUsedWordCopyWithImpl<_RarelyUsedWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RarelyUsedWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RarelyUsedWord&&(identical(other.word, word) || other.word == word)&&(identical(other.count, count) || other.count == count));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,count);

@override
String toString() {
  return 'RarelyUsedWord(word: $word, count: $count)';
}


}

/// @nodoc
abstract mixin class _$RarelyUsedWordCopyWith<$Res> implements $RarelyUsedWordCopyWith<$Res> {
  factory _$RarelyUsedWordCopyWith(_RarelyUsedWord value, $Res Function(_RarelyUsedWord) _then) = __$RarelyUsedWordCopyWithImpl;
@override @useResult
$Res call({
 String word, int count
});




}
/// @nodoc
class __$RarelyUsedWordCopyWithImpl<$Res>
    implements _$RarelyUsedWordCopyWith<$Res> {
  __$RarelyUsedWordCopyWithImpl(this._self, this._then);

  final _RarelyUsedWord _self;
  final $Res Function(_RarelyUsedWord) _then;

/// Create a copy of RarelyUsedWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? count = null,}) {
  return _then(_RarelyUsedWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$NeedsImprovementWord {

 String get word; int get misuses; String? get example; String? get correction;
/// Create a copy of NeedsImprovementWord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NeedsImprovementWordCopyWith<NeedsImprovementWord> get copyWith => _$NeedsImprovementWordCopyWithImpl<NeedsImprovementWord>(this as NeedsImprovementWord, _$identity);

  /// Serializes this NeedsImprovementWord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NeedsImprovementWord&&(identical(other.word, word) || other.word == word)&&(identical(other.misuses, misuses) || other.misuses == misuses)&&(identical(other.example, example) || other.example == example)&&(identical(other.correction, correction) || other.correction == correction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,misuses,example,correction);

@override
String toString() {
  return 'NeedsImprovementWord(word: $word, misuses: $misuses, example: $example, correction: $correction)';
}


}

/// @nodoc
abstract mixin class $NeedsImprovementWordCopyWith<$Res>  {
  factory $NeedsImprovementWordCopyWith(NeedsImprovementWord value, $Res Function(NeedsImprovementWord) _then) = _$NeedsImprovementWordCopyWithImpl;
@useResult
$Res call({
 String word, int misuses, String? example, String? correction
});




}
/// @nodoc
class _$NeedsImprovementWordCopyWithImpl<$Res>
    implements $NeedsImprovementWordCopyWith<$Res> {
  _$NeedsImprovementWordCopyWithImpl(this._self, this._then);

  final NeedsImprovementWord _self;
  final $Res Function(NeedsImprovementWord) _then;

/// Create a copy of NeedsImprovementWord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? word = null,Object? misuses = null,Object? example = freezed,Object? correction = freezed,}) {
  return _then(_self.copyWith(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,misuses: null == misuses ? _self.misuses : misuses // ignore: cast_nullable_to_non_nullable
as int,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,correction: freezed == correction ? _self.correction : correction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [NeedsImprovementWord].
extension NeedsImprovementWordPatterns on NeedsImprovementWord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NeedsImprovementWord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NeedsImprovementWord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NeedsImprovementWord value)  $default,){
final _that = this;
switch (_that) {
case _NeedsImprovementWord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NeedsImprovementWord value)?  $default,){
final _that = this;
switch (_that) {
case _NeedsImprovementWord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String word,  int misuses,  String? example,  String? correction)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NeedsImprovementWord() when $default != null:
return $default(_that.word,_that.misuses,_that.example,_that.correction);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String word,  int misuses,  String? example,  String? correction)  $default,) {final _that = this;
switch (_that) {
case _NeedsImprovementWord():
return $default(_that.word,_that.misuses,_that.example,_that.correction);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String word,  int misuses,  String? example,  String? correction)?  $default,) {final _that = this;
switch (_that) {
case _NeedsImprovementWord() when $default != null:
return $default(_that.word,_that.misuses,_that.example,_that.correction);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NeedsImprovementWord implements NeedsImprovementWord {
  const _NeedsImprovementWord({required this.word, this.misuses = 0, this.example, this.correction});
  factory _NeedsImprovementWord.fromJson(Map<String, dynamic> json) => _$NeedsImprovementWordFromJson(json);

@override final  String word;
@override@JsonKey() final  int misuses;
@override final  String? example;
@override final  String? correction;

/// Create a copy of NeedsImprovementWord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NeedsImprovementWordCopyWith<_NeedsImprovementWord> get copyWith => __$NeedsImprovementWordCopyWithImpl<_NeedsImprovementWord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NeedsImprovementWordToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _NeedsImprovementWord&&(identical(other.word, word) || other.word == word)&&(identical(other.misuses, misuses) || other.misuses == misuses)&&(identical(other.example, example) || other.example == example)&&(identical(other.correction, correction) || other.correction == correction));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,word,misuses,example,correction);

@override
String toString() {
  return 'NeedsImprovementWord(word: $word, misuses: $misuses, example: $example, correction: $correction)';
}


}

/// @nodoc
abstract mixin class _$NeedsImprovementWordCopyWith<$Res> implements $NeedsImprovementWordCopyWith<$Res> {
  factory _$NeedsImprovementWordCopyWith(_NeedsImprovementWord value, $Res Function(_NeedsImprovementWord) _then) = __$NeedsImprovementWordCopyWithImpl;
@override @useResult
$Res call({
 String word, int misuses, String? example, String? correction
});




}
/// @nodoc
class __$NeedsImprovementWordCopyWithImpl<$Res>
    implements _$NeedsImprovementWordCopyWith<$Res> {
  __$NeedsImprovementWordCopyWithImpl(this._self, this._then);

  final _NeedsImprovementWord _self;
  final $Res Function(_NeedsImprovementWord) _then;

/// Create a copy of NeedsImprovementWord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? word = null,Object? misuses = null,Object? example = freezed,Object? correction = freezed,}) {
  return _then(_NeedsImprovementWord(
word: null == word ? _self.word : word // ignore: cast_nullable_to_non_nullable
as String,misuses: null == misuses ? _self.misuses : misuses // ignore: cast_nullable_to_non_nullable
as int,example: freezed == example ? _self.example : example // ignore: cast_nullable_to_non_nullable
as String?,correction: freezed == correction ? _self.correction : correction // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$VocabSummary {

 VocabStats get stats; List<RarelyUsedWord> get rarelyUsed; List<NeedsImprovementWord> get needsImprovement; List<UserWord> get allWords;
/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VocabSummaryCopyWith<VocabSummary> get copyWith => _$VocabSummaryCopyWithImpl<VocabSummary>(this as VocabSummary, _$identity);

  /// Serializes this VocabSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is VocabSummary&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other.rarelyUsed, rarelyUsed)&&const DeepCollectionEquality().equals(other.needsImprovement, needsImprovement)&&const DeepCollectionEquality().equals(other.allWords, allWords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(rarelyUsed),const DeepCollectionEquality().hash(needsImprovement),const DeepCollectionEquality().hash(allWords));

@override
String toString() {
  return 'VocabSummary(stats: $stats, rarelyUsed: $rarelyUsed, needsImprovement: $needsImprovement, allWords: $allWords)';
}


}

/// @nodoc
abstract mixin class $VocabSummaryCopyWith<$Res>  {
  factory $VocabSummaryCopyWith(VocabSummary value, $Res Function(VocabSummary) _then) = _$VocabSummaryCopyWithImpl;
@useResult
$Res call({
 VocabStats stats, List<RarelyUsedWord> rarelyUsed, List<NeedsImprovementWord> needsImprovement, List<UserWord> allWords
});


$VocabStatsCopyWith<$Res> get stats;

}
/// @nodoc
class _$VocabSummaryCopyWithImpl<$Res>
    implements $VocabSummaryCopyWith<$Res> {
  _$VocabSummaryCopyWithImpl(this._self, this._then);

  final VocabSummary _self;
  final $Res Function(VocabSummary) _then;

/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stats = null,Object? rarelyUsed = null,Object? needsImprovement = null,Object? allWords = null,}) {
  return _then(_self.copyWith(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as VocabStats,rarelyUsed: null == rarelyUsed ? _self.rarelyUsed : rarelyUsed // ignore: cast_nullable_to_non_nullable
as List<RarelyUsedWord>,needsImprovement: null == needsImprovement ? _self.needsImprovement : needsImprovement // ignore: cast_nullable_to_non_nullable
as List<NeedsImprovementWord>,allWords: null == allWords ? _self.allWords : allWords // ignore: cast_nullable_to_non_nullable
as List<UserWord>,
  ));
}
/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VocabStatsCopyWith<$Res> get stats {
  
  return $VocabStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}


/// Adds pattern-matching-related methods to [VocabSummary].
extension VocabSummaryPatterns on VocabSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _VocabSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _VocabSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _VocabSummary value)  $default,){
final _that = this;
switch (_that) {
case _VocabSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _VocabSummary value)?  $default,){
final _that = this;
switch (_that) {
case _VocabSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( VocabStats stats,  List<RarelyUsedWord> rarelyUsed,  List<NeedsImprovementWord> needsImprovement,  List<UserWord> allWords)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _VocabSummary() when $default != null:
return $default(_that.stats,_that.rarelyUsed,_that.needsImprovement,_that.allWords);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( VocabStats stats,  List<RarelyUsedWord> rarelyUsed,  List<NeedsImprovementWord> needsImprovement,  List<UserWord> allWords)  $default,) {final _that = this;
switch (_that) {
case _VocabSummary():
return $default(_that.stats,_that.rarelyUsed,_that.needsImprovement,_that.allWords);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( VocabStats stats,  List<RarelyUsedWord> rarelyUsed,  List<NeedsImprovementWord> needsImprovement,  List<UserWord> allWords)?  $default,) {final _that = this;
switch (_that) {
case _VocabSummary() when $default != null:
return $default(_that.stats,_that.rarelyUsed,_that.needsImprovement,_that.allWords);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _VocabSummary implements VocabSummary {
  const _VocabSummary({required this.stats, final  List<RarelyUsedWord> rarelyUsed = const [], final  List<NeedsImprovementWord> needsImprovement = const [], final  List<UserWord> allWords = const []}): _rarelyUsed = rarelyUsed,_needsImprovement = needsImprovement,_allWords = allWords;
  factory _VocabSummary.fromJson(Map<String, dynamic> json) => _$VocabSummaryFromJson(json);

@override final  VocabStats stats;
 final  List<RarelyUsedWord> _rarelyUsed;
@override@JsonKey() List<RarelyUsedWord> get rarelyUsed {
  if (_rarelyUsed is EqualUnmodifiableListView) return _rarelyUsed;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_rarelyUsed);
}

 final  List<NeedsImprovementWord> _needsImprovement;
@override@JsonKey() List<NeedsImprovementWord> get needsImprovement {
  if (_needsImprovement is EqualUnmodifiableListView) return _needsImprovement;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needsImprovement);
}

 final  List<UserWord> _allWords;
@override@JsonKey() List<UserWord> get allWords {
  if (_allWords is EqualUnmodifiableListView) return _allWords;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allWords);
}


/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VocabSummaryCopyWith<_VocabSummary> get copyWith => __$VocabSummaryCopyWithImpl<_VocabSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VocabSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _VocabSummary&&(identical(other.stats, stats) || other.stats == stats)&&const DeepCollectionEquality().equals(other._rarelyUsed, _rarelyUsed)&&const DeepCollectionEquality().equals(other._needsImprovement, _needsImprovement)&&const DeepCollectionEquality().equals(other._allWords, _allWords));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,stats,const DeepCollectionEquality().hash(_rarelyUsed),const DeepCollectionEquality().hash(_needsImprovement),const DeepCollectionEquality().hash(_allWords));

@override
String toString() {
  return 'VocabSummary(stats: $stats, rarelyUsed: $rarelyUsed, needsImprovement: $needsImprovement, allWords: $allWords)';
}


}

/// @nodoc
abstract mixin class _$VocabSummaryCopyWith<$Res> implements $VocabSummaryCopyWith<$Res> {
  factory _$VocabSummaryCopyWith(_VocabSummary value, $Res Function(_VocabSummary) _then) = __$VocabSummaryCopyWithImpl;
@override @useResult
$Res call({
 VocabStats stats, List<RarelyUsedWord> rarelyUsed, List<NeedsImprovementWord> needsImprovement, List<UserWord> allWords
});


@override $VocabStatsCopyWith<$Res> get stats;

}
/// @nodoc
class __$VocabSummaryCopyWithImpl<$Res>
    implements _$VocabSummaryCopyWith<$Res> {
  __$VocabSummaryCopyWithImpl(this._self, this._then);

  final _VocabSummary _self;
  final $Res Function(_VocabSummary) _then;

/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stats = null,Object? rarelyUsed = null,Object? needsImprovement = null,Object? allWords = null,}) {
  return _then(_VocabSummary(
stats: null == stats ? _self.stats : stats // ignore: cast_nullable_to_non_nullable
as VocabStats,rarelyUsed: null == rarelyUsed ? _self._rarelyUsed : rarelyUsed // ignore: cast_nullable_to_non_nullable
as List<RarelyUsedWord>,needsImprovement: null == needsImprovement ? _self._needsImprovement : needsImprovement // ignore: cast_nullable_to_non_nullable
as List<NeedsImprovementWord>,allWords: null == allWords ? _self._allWords : allWords // ignore: cast_nullable_to_non_nullable
as List<UserWord>,
  ));
}

/// Create a copy of VocabSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$VocabStatsCopyWith<$Res> get stats {
  
  return $VocabStatsCopyWith<$Res>(_self.stats, (value) {
    return _then(_self.copyWith(stats: value));
  });
}
}

// dart format on
