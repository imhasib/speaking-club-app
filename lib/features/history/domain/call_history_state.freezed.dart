// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'call_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CallHistoryState {

 List<Call> get calls; int get currentPage; int get totalPages; int get totalCalls; bool get isLoading; bool get isLoadingMore; bool get hasError; String? get errorMessage;
/// Create a copy of CallHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CallHistoryStateCopyWith<CallHistoryState> get copyWith => _$CallHistoryStateCopyWithImpl<CallHistoryState>(this as CallHistoryState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CallHistoryState&&const DeepCollectionEquality().equals(other.calls, calls)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalCalls, totalCalls) || other.totalCalls == totalCalls)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(calls),currentPage,totalPages,totalCalls,isLoading,isLoadingMore,hasError,errorMessage);

@override
String toString() {
  return 'CallHistoryState(calls: $calls, currentPage: $currentPage, totalPages: $totalPages, totalCalls: $totalCalls, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $CallHistoryStateCopyWith<$Res>  {
  factory $CallHistoryStateCopyWith(CallHistoryState value, $Res Function(CallHistoryState) _then) = _$CallHistoryStateCopyWithImpl;
@useResult
$Res call({
 List<Call> calls, int currentPage, int totalPages, int totalCalls, bool isLoading, bool isLoadingMore, bool hasError, String? errorMessage
});




}
/// @nodoc
class _$CallHistoryStateCopyWithImpl<$Res>
    implements $CallHistoryStateCopyWith<$Res> {
  _$CallHistoryStateCopyWithImpl(this._self, this._then);

  final CallHistoryState _self;
  final $Res Function(CallHistoryState) _then;

/// Create a copy of CallHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? calls = null,Object? currentPage = null,Object? totalPages = null,Object? totalCalls = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasError = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
calls: null == calls ? _self.calls : calls // ignore: cast_nullable_to_non_nullable
as List<Call>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalCalls: null == totalCalls ? _self.totalCalls : totalCalls // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [CallHistoryState].
extension CallHistoryStatePatterns on CallHistoryState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CallHistoryState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CallHistoryState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CallHistoryState value)  $default,){
final _that = this;
switch (_that) {
case _CallHistoryState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CallHistoryState value)?  $default,){
final _that = this;
switch (_that) {
case _CallHistoryState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Call> calls,  int currentPage,  int totalPages,  int totalCalls,  bool isLoading,  bool isLoadingMore,  bool hasError,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CallHistoryState() when $default != null:
return $default(_that.calls,_that.currentPage,_that.totalPages,_that.totalCalls,_that.isLoading,_that.isLoadingMore,_that.hasError,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Call> calls,  int currentPage,  int totalPages,  int totalCalls,  bool isLoading,  bool isLoadingMore,  bool hasError,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _CallHistoryState():
return $default(_that.calls,_that.currentPage,_that.totalPages,_that.totalCalls,_that.isLoading,_that.isLoadingMore,_that.hasError,_that.errorMessage);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Call> calls,  int currentPage,  int totalPages,  int totalCalls,  bool isLoading,  bool isLoadingMore,  bool hasError,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _CallHistoryState() when $default != null:
return $default(_that.calls,_that.currentPage,_that.totalPages,_that.totalCalls,_that.isLoading,_that.isLoadingMore,_that.hasError,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _CallHistoryState extends CallHistoryState {
  const _CallHistoryState({final  List<Call> calls = const [], this.currentPage = 1, this.totalPages = 0, this.totalCalls = 0, this.isLoading = false, this.isLoadingMore = false, this.hasError = false, this.errorMessage}): _calls = calls,super._();
  

 final  List<Call> _calls;
@override@JsonKey() List<Call> get calls {
  if (_calls is EqualUnmodifiableListView) return _calls;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_calls);
}

@override@JsonKey() final  int currentPage;
@override@JsonKey() final  int totalPages;
@override@JsonKey() final  int totalCalls;
@override@JsonKey() final  bool isLoading;
@override@JsonKey() final  bool isLoadingMore;
@override@JsonKey() final  bool hasError;
@override final  String? errorMessage;

/// Create a copy of CallHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CallHistoryStateCopyWith<_CallHistoryState> get copyWith => __$CallHistoryStateCopyWithImpl<_CallHistoryState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CallHistoryState&&const DeepCollectionEquality().equals(other._calls, _calls)&&(identical(other.currentPage, currentPage) || other.currentPage == currentPage)&&(identical(other.totalPages, totalPages) || other.totalPages == totalPages)&&(identical(other.totalCalls, totalCalls) || other.totalCalls == totalCalls)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&(identical(other.isLoadingMore, isLoadingMore) || other.isLoadingMore == isLoadingMore)&&(identical(other.hasError, hasError) || other.hasError == hasError)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_calls),currentPage,totalPages,totalCalls,isLoading,isLoadingMore,hasError,errorMessage);

@override
String toString() {
  return 'CallHistoryState(calls: $calls, currentPage: $currentPage, totalPages: $totalPages, totalCalls: $totalCalls, isLoading: $isLoading, isLoadingMore: $isLoadingMore, hasError: $hasError, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$CallHistoryStateCopyWith<$Res> implements $CallHistoryStateCopyWith<$Res> {
  factory _$CallHistoryStateCopyWith(_CallHistoryState value, $Res Function(_CallHistoryState) _then) = __$CallHistoryStateCopyWithImpl;
@override @useResult
$Res call({
 List<Call> calls, int currentPage, int totalPages, int totalCalls, bool isLoading, bool isLoadingMore, bool hasError, String? errorMessage
});




}
/// @nodoc
class __$CallHistoryStateCopyWithImpl<$Res>
    implements _$CallHistoryStateCopyWith<$Res> {
  __$CallHistoryStateCopyWithImpl(this._self, this._then);

  final _CallHistoryState _self;
  final $Res Function(_CallHistoryState) _then;

/// Create a copy of CallHistoryState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? calls = null,Object? currentPage = null,Object? totalPages = null,Object? totalCalls = null,Object? isLoading = null,Object? isLoadingMore = null,Object? hasError = null,Object? errorMessage = freezed,}) {
  return _then(_CallHistoryState(
calls: null == calls ? _self._calls : calls // ignore: cast_nullable_to_non_nullable
as List<Call>,currentPage: null == currentPage ? _self.currentPage : currentPage // ignore: cast_nullable_to_non_nullable
as int,totalPages: null == totalPages ? _self.totalPages : totalPages // ignore: cast_nullable_to_non_nullable
as int,totalCalls: null == totalCalls ? _self.totalCalls : totalCalls // ignore: cast_nullable_to_non_nullable
as int,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,isLoadingMore: null == isLoadingMore ? _self.isLoadingMore : isLoadingMore // ignore: cast_nullable_to_non_nullable
as bool,hasError: null == hasError ? _self.hasError : hasError // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
