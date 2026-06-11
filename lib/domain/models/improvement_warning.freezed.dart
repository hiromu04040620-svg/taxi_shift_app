// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'improvement_warning.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ImprovementWarning {

 WarningLevel get level; String get code; String get message; DateTime? get targetDate;
/// Create a copy of ImprovementWarning
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ImprovementWarningCopyWith<ImprovementWarning> get copyWith => _$ImprovementWarningCopyWithImpl<ImprovementWarning>(this as ImprovementWarning, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ImprovementWarning&&(identical(other.level, level) || other.level == level)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}


@override
int get hashCode => Object.hash(runtimeType,level,code,message,targetDate);

@override
String toString() {
  return 'ImprovementWarning(level: $level, code: $code, message: $message, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class $ImprovementWarningCopyWith<$Res>  {
  factory $ImprovementWarningCopyWith(ImprovementWarning value, $Res Function(ImprovementWarning) _then) = _$ImprovementWarningCopyWithImpl;
@useResult
$Res call({
 WarningLevel level, String code, String message, DateTime? targetDate
});




}
/// @nodoc
class _$ImprovementWarningCopyWithImpl<$Res>
    implements $ImprovementWarningCopyWith<$Res> {
  _$ImprovementWarningCopyWithImpl(this._self, this._then);

  final ImprovementWarning _self;
  final $Res Function(ImprovementWarning) _then;

/// Create a copy of ImprovementWarning
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? level = null,Object? code = null,Object? message = null,Object? targetDate = freezed,}) {
  return _then(_self.copyWith(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as WarningLevel,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ImprovementWarning].
extension ImprovementWarningPatterns on ImprovementWarning {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ImprovementWarning value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ImprovementWarning() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ImprovementWarning value)  $default,){
final _that = this;
switch (_that) {
case _ImprovementWarning():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ImprovementWarning value)?  $default,){
final _that = this;
switch (_that) {
case _ImprovementWarning() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( WarningLevel level,  String code,  String message,  DateTime? targetDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ImprovementWarning() when $default != null:
return $default(_that.level,_that.code,_that.message,_that.targetDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( WarningLevel level,  String code,  String message,  DateTime? targetDate)  $default,) {final _that = this;
switch (_that) {
case _ImprovementWarning():
return $default(_that.level,_that.code,_that.message,_that.targetDate);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( WarningLevel level,  String code,  String message,  DateTime? targetDate)?  $default,) {final _that = this;
switch (_that) {
case _ImprovementWarning() when $default != null:
return $default(_that.level,_that.code,_that.message,_that.targetDate);case _:
  return null;

}
}

}

/// @nodoc


class _ImprovementWarning implements ImprovementWarning {
  const _ImprovementWarning({required this.level, required this.code, required this.message, this.targetDate});
  

@override final  WarningLevel level;
@override final  String code;
@override final  String message;
@override final  DateTime? targetDate;

/// Create a copy of ImprovementWarning
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ImprovementWarningCopyWith<_ImprovementWarning> get copyWith => __$ImprovementWarningCopyWithImpl<_ImprovementWarning>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ImprovementWarning&&(identical(other.level, level) || other.level == level)&&(identical(other.code, code) || other.code == code)&&(identical(other.message, message) || other.message == message)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate));
}


@override
int get hashCode => Object.hash(runtimeType,level,code,message,targetDate);

@override
String toString() {
  return 'ImprovementWarning(level: $level, code: $code, message: $message, targetDate: $targetDate)';
}


}

/// @nodoc
abstract mixin class _$ImprovementWarningCopyWith<$Res> implements $ImprovementWarningCopyWith<$Res> {
  factory _$ImprovementWarningCopyWith(_ImprovementWarning value, $Res Function(_ImprovementWarning) _then) = __$ImprovementWarningCopyWithImpl;
@override @useResult
$Res call({
 WarningLevel level, String code, String message, DateTime? targetDate
});




}
/// @nodoc
class __$ImprovementWarningCopyWithImpl<$Res>
    implements _$ImprovementWarningCopyWith<$Res> {
  __$ImprovementWarningCopyWithImpl(this._self, this._then);

  final _ImprovementWarning _self;
  final $Res Function(_ImprovementWarning) _then;

/// Create a copy of ImprovementWarning
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? level = null,Object? code = null,Object? message = null,Object? targetDate = freezed,}) {
  return _then(_ImprovementWarning(
level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as WarningLevel,code: null == code ? _self.code : code // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,targetDate: freezed == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
