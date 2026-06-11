// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commission_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommissionResult {

 int get baseRevenue; int get excessRevenue; int get commissionAmount; bool get isAboveAshikiri;
/// Create a copy of CommissionResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommissionResultCopyWith<CommissionResult> get copyWith => _$CommissionResultCopyWithImpl<CommissionResult>(this as CommissionResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommissionResult&&(identical(other.baseRevenue, baseRevenue) || other.baseRevenue == baseRevenue)&&(identical(other.excessRevenue, excessRevenue) || other.excessRevenue == excessRevenue)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.isAboveAshikiri, isAboveAshikiri) || other.isAboveAshikiri == isAboveAshikiri));
}


@override
int get hashCode => Object.hash(runtimeType,baseRevenue,excessRevenue,commissionAmount,isAboveAshikiri);

@override
String toString() {
  return 'CommissionResult(baseRevenue: $baseRevenue, excessRevenue: $excessRevenue, commissionAmount: $commissionAmount, isAboveAshikiri: $isAboveAshikiri)';
}


}

/// @nodoc
abstract mixin class $CommissionResultCopyWith<$Res>  {
  factory $CommissionResultCopyWith(CommissionResult value, $Res Function(CommissionResult) _then) = _$CommissionResultCopyWithImpl;
@useResult
$Res call({
 int baseRevenue, int excessRevenue, int commissionAmount, bool isAboveAshikiri
});




}
/// @nodoc
class _$CommissionResultCopyWithImpl<$Res>
    implements $CommissionResultCopyWith<$Res> {
  _$CommissionResultCopyWithImpl(this._self, this._then);

  final CommissionResult _self;
  final $Res Function(CommissionResult) _then;

/// Create a copy of CommissionResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? baseRevenue = null,Object? excessRevenue = null,Object? commissionAmount = null,Object? isAboveAshikiri = null,}) {
  return _then(_self.copyWith(
baseRevenue: null == baseRevenue ? _self.baseRevenue : baseRevenue // ignore: cast_nullable_to_non_nullable
as int,excessRevenue: null == excessRevenue ? _self.excessRevenue : excessRevenue // ignore: cast_nullable_to_non_nullable
as int,commissionAmount: null == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as int,isAboveAshikiri: null == isAboveAshikiri ? _self.isAboveAshikiri : isAboveAshikiri // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [CommissionResult].
extension CommissionResultPatterns on CommissionResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommissionResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommissionResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommissionResult value)  $default,){
final _that = this;
switch (_that) {
case _CommissionResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommissionResult value)?  $default,){
final _that = this;
switch (_that) {
case _CommissionResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int baseRevenue,  int excessRevenue,  int commissionAmount,  bool isAboveAshikiri)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommissionResult() when $default != null:
return $default(_that.baseRevenue,_that.excessRevenue,_that.commissionAmount,_that.isAboveAshikiri);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int baseRevenue,  int excessRevenue,  int commissionAmount,  bool isAboveAshikiri)  $default,) {final _that = this;
switch (_that) {
case _CommissionResult():
return $default(_that.baseRevenue,_that.excessRevenue,_that.commissionAmount,_that.isAboveAshikiri);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int baseRevenue,  int excessRevenue,  int commissionAmount,  bool isAboveAshikiri)?  $default,) {final _that = this;
switch (_that) {
case _CommissionResult() when $default != null:
return $default(_that.baseRevenue,_that.excessRevenue,_that.commissionAmount,_that.isAboveAshikiri);case _:
  return null;

}
}

}

/// @nodoc


class _CommissionResult implements CommissionResult {
  const _CommissionResult({required this.baseRevenue, required this.excessRevenue, required this.commissionAmount, required this.isAboveAshikiri});
  

@override final  int baseRevenue;
@override final  int excessRevenue;
@override final  int commissionAmount;
@override final  bool isAboveAshikiri;

/// Create a copy of CommissionResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommissionResultCopyWith<_CommissionResult> get copyWith => __$CommissionResultCopyWithImpl<_CommissionResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommissionResult&&(identical(other.baseRevenue, baseRevenue) || other.baseRevenue == baseRevenue)&&(identical(other.excessRevenue, excessRevenue) || other.excessRevenue == excessRevenue)&&(identical(other.commissionAmount, commissionAmount) || other.commissionAmount == commissionAmount)&&(identical(other.isAboveAshikiri, isAboveAshikiri) || other.isAboveAshikiri == isAboveAshikiri));
}


@override
int get hashCode => Object.hash(runtimeType,baseRevenue,excessRevenue,commissionAmount,isAboveAshikiri);

@override
String toString() {
  return 'CommissionResult(baseRevenue: $baseRevenue, excessRevenue: $excessRevenue, commissionAmount: $commissionAmount, isAboveAshikiri: $isAboveAshikiri)';
}


}

/// @nodoc
abstract mixin class _$CommissionResultCopyWith<$Res> implements $CommissionResultCopyWith<$Res> {
  factory _$CommissionResultCopyWith(_CommissionResult value, $Res Function(_CommissionResult) _then) = __$CommissionResultCopyWithImpl;
@override @useResult
$Res call({
 int baseRevenue, int excessRevenue, int commissionAmount, bool isAboveAshikiri
});




}
/// @nodoc
class __$CommissionResultCopyWithImpl<$Res>
    implements _$CommissionResultCopyWith<$Res> {
  __$CommissionResultCopyWithImpl(this._self, this._then);

  final _CommissionResult _self;
  final $Res Function(_CommissionResult) _then;

/// Create a copy of CommissionResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? baseRevenue = null,Object? excessRevenue = null,Object? commissionAmount = null,Object? isAboveAshikiri = null,}) {
  return _then(_CommissionResult(
baseRevenue: null == baseRevenue ? _self.baseRevenue : baseRevenue // ignore: cast_nullable_to_non_nullable
as int,excessRevenue: null == excessRevenue ? _self.excessRevenue : excessRevenue // ignore: cast_nullable_to_non_nullable
as int,commissionAmount: null == commissionAmount ? _self.commissionAmount : commissionAmount // ignore: cast_nullable_to_non_nullable
as int,isAboveAshikiri: null == isAboveAshikiri ? _self.isAboveAshikiri : isAboveAshikiri // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
