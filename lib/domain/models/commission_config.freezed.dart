// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'commission_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CommissionConfig {

 int get ashikiriAmount; double get commissionRate;
/// Create a copy of CommissionConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CommissionConfigCopyWith<CommissionConfig> get copyWith => _$CommissionConfigCopyWithImpl<CommissionConfig>(this as CommissionConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CommissionConfig&&(identical(other.ashikiriAmount, ashikiriAmount) || other.ashikiriAmount == ashikiriAmount)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate));
}


@override
int get hashCode => Object.hash(runtimeType,ashikiriAmount,commissionRate);

@override
String toString() {
  return 'CommissionConfig(ashikiriAmount: $ashikiriAmount, commissionRate: $commissionRate)';
}


}

/// @nodoc
abstract mixin class $CommissionConfigCopyWith<$Res>  {
  factory $CommissionConfigCopyWith(CommissionConfig value, $Res Function(CommissionConfig) _then) = _$CommissionConfigCopyWithImpl;
@useResult
$Res call({
 int ashikiriAmount, double commissionRate
});




}
/// @nodoc
class _$CommissionConfigCopyWithImpl<$Res>
    implements $CommissionConfigCopyWith<$Res> {
  _$CommissionConfigCopyWithImpl(this._self, this._then);

  final CommissionConfig _self;
  final $Res Function(CommissionConfig) _then;

/// Create a copy of CommissionConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ashikiriAmount = null,Object? commissionRate = null,}) {
  return _then(_self.copyWith(
ashikiriAmount: null == ashikiriAmount ? _self.ashikiriAmount : ashikiriAmount // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [CommissionConfig].
extension CommissionConfigPatterns on CommissionConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CommissionConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CommissionConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CommissionConfig value)  $default,){
final _that = this;
switch (_that) {
case _CommissionConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CommissionConfig value)?  $default,){
final _that = this;
switch (_that) {
case _CommissionConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int ashikiriAmount,  double commissionRate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CommissionConfig() when $default != null:
return $default(_that.ashikiriAmount,_that.commissionRate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int ashikiriAmount,  double commissionRate)  $default,) {final _that = this;
switch (_that) {
case _CommissionConfig():
return $default(_that.ashikiriAmount,_that.commissionRate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int ashikiriAmount,  double commissionRate)?  $default,) {final _that = this;
switch (_that) {
case _CommissionConfig() when $default != null:
return $default(_that.ashikiriAmount,_that.commissionRate);case _:
  return null;

}
}

}

/// @nodoc


class _CommissionConfig implements CommissionConfig {
  const _CommissionConfig({required this.ashikiriAmount, required this.commissionRate});
  

@override final  int ashikiriAmount;
@override final  double commissionRate;

/// Create a copy of CommissionConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CommissionConfigCopyWith<_CommissionConfig> get copyWith => __$CommissionConfigCopyWithImpl<_CommissionConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CommissionConfig&&(identical(other.ashikiriAmount, ashikiriAmount) || other.ashikiriAmount == ashikiriAmount)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate));
}


@override
int get hashCode => Object.hash(runtimeType,ashikiriAmount,commissionRate);

@override
String toString() {
  return 'CommissionConfig(ashikiriAmount: $ashikiriAmount, commissionRate: $commissionRate)';
}


}

/// @nodoc
abstract mixin class _$CommissionConfigCopyWith<$Res> implements $CommissionConfigCopyWith<$Res> {
  factory _$CommissionConfigCopyWith(_CommissionConfig value, $Res Function(_CommissionConfig) _then) = __$CommissionConfigCopyWithImpl;
@override @useResult
$Res call({
 int ashikiriAmount, double commissionRate
});




}
/// @nodoc
class __$CommissionConfigCopyWithImpl<$Res>
    implements _$CommissionConfigCopyWith<$Res> {
  __$CommissionConfigCopyWithImpl(this._self, this._then);

  final _CommissionConfig _self;
  final $Res Function(_CommissionConfig) _then;

/// Create a copy of CommissionConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ashikiriAmount = null,Object? commissionRate = null,}) {
  return _then(_CommissionConfig(
ashikiriAmount: null == ashikiriAmount ? _self.ashikiriAmount : ashikiriAmount // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

// dart format on
