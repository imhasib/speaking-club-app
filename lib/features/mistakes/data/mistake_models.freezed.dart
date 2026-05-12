// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'mistake_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Mistake {

 String get id; MistakeCategory get category; String get wrong; String get right; String get explanation; String? get sessionLabel; String? get sessionId; DateTime get createdAt; bool get isFixed; bool get savedToVocab;
/// Create a copy of Mistake
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakeCopyWith<Mistake> get copyWith => _$MistakeCopyWithImpl<Mistake>(this as Mistake, _$identity);

  /// Serializes this Mistake to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Mistake&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.right, right) || other.right == right)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.sessionLabel, sessionLabel) || other.sessionLabel == sessionLabel)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed)&&(identical(other.savedToVocab, savedToVocab) || other.savedToVocab == savedToVocab));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,wrong,right,explanation,sessionLabel,sessionId,createdAt,isFixed,savedToVocab);

@override
String toString() {
  return 'Mistake(id: $id, category: $category, wrong: $wrong, right: $right, explanation: $explanation, sessionLabel: $sessionLabel, sessionId: $sessionId, createdAt: $createdAt, isFixed: $isFixed, savedToVocab: $savedToVocab)';
}


}

/// @nodoc
abstract mixin class $MistakeCopyWith<$Res>  {
  factory $MistakeCopyWith(Mistake value, $Res Function(Mistake) _then) = _$MistakeCopyWithImpl;
@useResult
$Res call({
 String id, MistakeCategory category, String wrong, String right, String explanation, String? sessionLabel, String? sessionId, DateTime createdAt, bool isFixed, bool savedToVocab
});




}
/// @nodoc
class _$MistakeCopyWithImpl<$Res>
    implements $MistakeCopyWith<$Res> {
  _$MistakeCopyWithImpl(this._self, this._then);

  final Mistake _self;
  final $Res Function(Mistake) _then;

/// Create a copy of Mistake
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? wrong = null,Object? right = null,Object? explanation = null,Object? sessionLabel = freezed,Object? sessionId = freezed,Object? createdAt = null,Object? isFixed = null,Object? savedToVocab = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MistakeCategory,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as String,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,sessionLabel: freezed == sessionLabel ? _self.sessionLabel : sessionLabel // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,savedToVocab: null == savedToVocab ? _self.savedToVocab : savedToVocab // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Mistake].
extension MistakePatterns on Mistake {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Mistake value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Mistake() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Mistake value)  $default,){
final _that = this;
switch (_that) {
case _Mistake():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Mistake value)?  $default,){
final _that = this;
switch (_that) {
case _Mistake() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  MistakeCategory category,  String wrong,  String right,  String explanation,  String? sessionLabel,  String? sessionId,  DateTime createdAt,  bool isFixed,  bool savedToVocab)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Mistake() when $default != null:
return $default(_that.id,_that.category,_that.wrong,_that.right,_that.explanation,_that.sessionLabel,_that.sessionId,_that.createdAt,_that.isFixed,_that.savedToVocab);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  MistakeCategory category,  String wrong,  String right,  String explanation,  String? sessionLabel,  String? sessionId,  DateTime createdAt,  bool isFixed,  bool savedToVocab)  $default,) {final _that = this;
switch (_that) {
case _Mistake():
return $default(_that.id,_that.category,_that.wrong,_that.right,_that.explanation,_that.sessionLabel,_that.sessionId,_that.createdAt,_that.isFixed,_that.savedToVocab);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  MistakeCategory category,  String wrong,  String right,  String explanation,  String? sessionLabel,  String? sessionId,  DateTime createdAt,  bool isFixed,  bool savedToVocab)?  $default,) {final _that = this;
switch (_that) {
case _Mistake() when $default != null:
return $default(_that.id,_that.category,_that.wrong,_that.right,_that.explanation,_that.sessionLabel,_that.sessionId,_that.createdAt,_that.isFixed,_that.savedToVocab);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Mistake implements Mistake {
  const _Mistake({required this.id, required this.category, required this.wrong, required this.right, required this.explanation, this.sessionLabel, this.sessionId, required this.createdAt, this.isFixed = false, this.savedToVocab = false});
  factory _Mistake.fromJson(Map<String, dynamic> json) => _$MistakeFromJson(json);

@override final  String id;
@override final  MistakeCategory category;
@override final  String wrong;
@override final  String right;
@override final  String explanation;
@override final  String? sessionLabel;
@override final  String? sessionId;
@override final  DateTime createdAt;
@override@JsonKey() final  bool isFixed;
@override@JsonKey() final  bool savedToVocab;

/// Create a copy of Mistake
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakeCopyWith<_Mistake> get copyWith => __$MistakeCopyWithImpl<_Mistake>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakeToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Mistake&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.wrong, wrong) || other.wrong == wrong)&&(identical(other.right, right) || other.right == right)&&(identical(other.explanation, explanation) || other.explanation == explanation)&&(identical(other.sessionLabel, sessionLabel) || other.sessionLabel == sessionLabel)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.isFixed, isFixed) || other.isFixed == isFixed)&&(identical(other.savedToVocab, savedToVocab) || other.savedToVocab == savedToVocab));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,category,wrong,right,explanation,sessionLabel,sessionId,createdAt,isFixed,savedToVocab);

@override
String toString() {
  return 'Mistake(id: $id, category: $category, wrong: $wrong, right: $right, explanation: $explanation, sessionLabel: $sessionLabel, sessionId: $sessionId, createdAt: $createdAt, isFixed: $isFixed, savedToVocab: $savedToVocab)';
}


}

/// @nodoc
abstract mixin class _$MistakeCopyWith<$Res> implements $MistakeCopyWith<$Res> {
  factory _$MistakeCopyWith(_Mistake value, $Res Function(_Mistake) _then) = __$MistakeCopyWithImpl;
@override @useResult
$Res call({
 String id, MistakeCategory category, String wrong, String right, String explanation, String? sessionLabel, String? sessionId, DateTime createdAt, bool isFixed, bool savedToVocab
});




}
/// @nodoc
class __$MistakeCopyWithImpl<$Res>
    implements _$MistakeCopyWith<$Res> {
  __$MistakeCopyWithImpl(this._self, this._then);

  final _Mistake _self;
  final $Res Function(_Mistake) _then;

/// Create a copy of Mistake
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? wrong = null,Object? right = null,Object? explanation = null,Object? sessionLabel = freezed,Object? sessionId = freezed,Object? createdAt = null,Object? isFixed = null,Object? savedToVocab = null,}) {
  return _then(_Mistake(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MistakeCategory,wrong: null == wrong ? _self.wrong : wrong // ignore: cast_nullable_to_non_nullable
as String,right: null == right ? _self.right : right // ignore: cast_nullable_to_non_nullable
as String,explanation: null == explanation ? _self.explanation : explanation // ignore: cast_nullable_to_non_nullable
as String,sessionLabel: freezed == sessionLabel ? _self.sessionLabel : sessionLabel // ignore: cast_nullable_to_non_nullable
as String?,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,isFixed: null == isFixed ? _self.isFixed : isFixed // ignore: cast_nullable_to_non_nullable
as bool,savedToVocab: null == savedToVocab ? _self.savedToVocab : savedToVocab // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$MistakesSummary {

 int get thisWeek; int get fixed; int? get trend;
/// Create a copy of MistakesSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MistakesSummaryCopyWith<MistakesSummary> get copyWith => _$MistakesSummaryCopyWithImpl<MistakesSummary>(this as MistakesSummary, _$identity);

  /// Serializes this MistakesSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MistakesSummary&&(identical(other.thisWeek, thisWeek) || other.thisWeek == thisWeek)&&(identical(other.fixed, fixed) || other.fixed == fixed)&&(identical(other.trend, trend) || other.trend == trend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,thisWeek,fixed,trend);

@override
String toString() {
  return 'MistakesSummary(thisWeek: $thisWeek, fixed: $fixed, trend: $trend)';
}


}

/// @nodoc
abstract mixin class $MistakesSummaryCopyWith<$Res>  {
  factory $MistakesSummaryCopyWith(MistakesSummary value, $Res Function(MistakesSummary) _then) = _$MistakesSummaryCopyWithImpl;
@useResult
$Res call({
 int thisWeek, int fixed, int? trend
});




}
/// @nodoc
class _$MistakesSummaryCopyWithImpl<$Res>
    implements $MistakesSummaryCopyWith<$Res> {
  _$MistakesSummaryCopyWithImpl(this._self, this._then);

  final MistakesSummary _self;
  final $Res Function(MistakesSummary) _then;

/// Create a copy of MistakesSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? thisWeek = null,Object? fixed = null,Object? trend = freezed,}) {
  return _then(_self.copyWith(
thisWeek: null == thisWeek ? _self.thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as int,fixed: null == fixed ? _self.fixed : fixed // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [MistakesSummary].
extension MistakesSummaryPatterns on MistakesSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MistakesSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MistakesSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MistakesSummary value)  $default,){
final _that = this;
switch (_that) {
case _MistakesSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MistakesSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MistakesSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int thisWeek,  int fixed,  int? trend)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MistakesSummary() when $default != null:
return $default(_that.thisWeek,_that.fixed,_that.trend);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int thisWeek,  int fixed,  int? trend)  $default,) {final _that = this;
switch (_that) {
case _MistakesSummary():
return $default(_that.thisWeek,_that.fixed,_that.trend);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int thisWeek,  int fixed,  int? trend)?  $default,) {final _that = this;
switch (_that) {
case _MistakesSummary() when $default != null:
return $default(_that.thisWeek,_that.fixed,_that.trend);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MistakesSummary implements MistakesSummary {
  const _MistakesSummary({this.thisWeek = 0, this.fixed = 0, this.trend});
  factory _MistakesSummary.fromJson(Map<String, dynamic> json) => _$MistakesSummaryFromJson(json);

@override@JsonKey() final  int thisWeek;
@override@JsonKey() final  int fixed;
@override final  int? trend;

/// Create a copy of MistakesSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MistakesSummaryCopyWith<_MistakesSummary> get copyWith => __$MistakesSummaryCopyWithImpl<_MistakesSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MistakesSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MistakesSummary&&(identical(other.thisWeek, thisWeek) || other.thisWeek == thisWeek)&&(identical(other.fixed, fixed) || other.fixed == fixed)&&(identical(other.trend, trend) || other.trend == trend));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,thisWeek,fixed,trend);

@override
String toString() {
  return 'MistakesSummary(thisWeek: $thisWeek, fixed: $fixed, trend: $trend)';
}


}

/// @nodoc
abstract mixin class _$MistakesSummaryCopyWith<$Res> implements $MistakesSummaryCopyWith<$Res> {
  factory _$MistakesSummaryCopyWith(_MistakesSummary value, $Res Function(_MistakesSummary) _then) = __$MistakesSummaryCopyWithImpl;
@override @useResult
$Res call({
 int thisWeek, int fixed, int? trend
});




}
/// @nodoc
class __$MistakesSummaryCopyWithImpl<$Res>
    implements _$MistakesSummaryCopyWith<$Res> {
  __$MistakesSummaryCopyWithImpl(this._self, this._then);

  final _MistakesSummary _self;
  final $Res Function(_MistakesSummary) _then;

/// Create a copy of MistakesSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? thisWeek = null,Object? fixed = null,Object? trend = freezed,}) {
  return _then(_MistakesSummary(
thisWeek: null == thisWeek ? _self.thisWeek : thisWeek // ignore: cast_nullable_to_non_nullable
as int,fixed: null == fixed ? _self.fixed : fixed // ignore: cast_nullable_to_non_nullable
as int,trend: freezed == trend ? _self.trend : trend // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
