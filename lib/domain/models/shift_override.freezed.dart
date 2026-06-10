// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_override.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShiftOverride {

 int get id; DateTime get date; ShiftType get shiftType; OverrideStatus get status; String? get reason; int? get pairedOverrideId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ShiftOverride
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftOverrideCopyWith<ShiftOverride> get copyWith => _$ShiftOverrideCopyWithImpl<ShiftOverride>(this as ShiftOverride, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftOverride&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.shiftType, shiftType) || other.shiftType == shiftType)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.pairedOverrideId, pairedOverrideId) || other.pairedOverrideId == pairedOverrideId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,shiftType,status,reason,pairedOverrideId,createdAt,updatedAt);

@override
String toString() {
  return 'ShiftOverride(id: $id, date: $date, shiftType: $shiftType, status: $status, reason: $reason, pairedOverrideId: $pairedOverrideId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShiftOverrideCopyWith<$Res>  {
  factory $ShiftOverrideCopyWith(ShiftOverride value, $Res Function(ShiftOverride) _then) = _$ShiftOverrideCopyWithImpl;
@useResult
$Res call({
 int id, DateTime date, ShiftType shiftType, OverrideStatus status, String? reason, int? pairedOverrideId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ShiftOverrideCopyWithImpl<$Res>
    implements $ShiftOverrideCopyWith<$Res> {
  _$ShiftOverrideCopyWithImpl(this._self, this._then);

  final ShiftOverride _self;
  final $Res Function(ShiftOverride) _then;

/// Create a copy of ShiftOverride
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? shiftType = null,Object? status = null,Object? reason = freezed,Object? pairedOverrideId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,shiftType: null == shiftType ? _self.shiftType : shiftType // ignore: cast_nullable_to_non_nullable
as ShiftType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OverrideStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pairedOverrideId: freezed == pairedOverrideId ? _self.pairedOverrideId : pairedOverrideId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftOverride].
extension ShiftOverridePatterns on ShiftOverride {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftOverride value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftOverride() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftOverride value)  $default,){
final _that = this;
switch (_that) {
case _ShiftOverride():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftOverride value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftOverride() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  DateTime date,  ShiftType shiftType,  OverrideStatus status,  String? reason,  int? pairedOverrideId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftOverride() when $default != null:
return $default(_that.id,_that.date,_that.shiftType,_that.status,_that.reason,_that.pairedOverrideId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  DateTime date,  ShiftType shiftType,  OverrideStatus status,  String? reason,  int? pairedOverrideId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShiftOverride():
return $default(_that.id,_that.date,_that.shiftType,_that.status,_that.reason,_that.pairedOverrideId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  DateTime date,  ShiftType shiftType,  OverrideStatus status,  String? reason,  int? pairedOverrideId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShiftOverride() when $default != null:
return $default(_that.id,_that.date,_that.shiftType,_that.status,_that.reason,_that.pairedOverrideId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ShiftOverride implements ShiftOverride {
  const _ShiftOverride({required this.id, required this.date, required this.shiftType, this.status = OverrideStatus.confirmed, this.reason, this.pairedOverrideId, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  DateTime date;
@override final  ShiftType shiftType;
@override@JsonKey() final  OverrideStatus status;
@override final  String? reason;
@override final  int? pairedOverrideId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ShiftOverride
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftOverrideCopyWith<_ShiftOverride> get copyWith => __$ShiftOverrideCopyWithImpl<_ShiftOverride>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftOverride&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.shiftType, shiftType) || other.shiftType == shiftType)&&(identical(other.status, status) || other.status == status)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.pairedOverrideId, pairedOverrideId) || other.pairedOverrideId == pairedOverrideId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,date,shiftType,status,reason,pairedOverrideId,createdAt,updatedAt);

@override
String toString() {
  return 'ShiftOverride(id: $id, date: $date, shiftType: $shiftType, status: $status, reason: $reason, pairedOverrideId: $pairedOverrideId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShiftOverrideCopyWith<$Res> implements $ShiftOverrideCopyWith<$Res> {
  factory _$ShiftOverrideCopyWith(_ShiftOverride value, $Res Function(_ShiftOverride) _then) = __$ShiftOverrideCopyWithImpl;
@override @useResult
$Res call({
 int id, DateTime date, ShiftType shiftType, OverrideStatus status, String? reason, int? pairedOverrideId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ShiftOverrideCopyWithImpl<$Res>
    implements _$ShiftOverrideCopyWith<$Res> {
  __$ShiftOverrideCopyWithImpl(this._self, this._then);

  final _ShiftOverride _self;
  final $Res Function(_ShiftOverride) _then;

/// Create a copy of ShiftOverride
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? shiftType = null,Object? status = null,Object? reason = freezed,Object? pairedOverrideId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ShiftOverride(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as DateTime,shiftType: null == shiftType ? _self.shiftType : shiftType // ignore: cast_nullable_to_non_nullable
as ShiftType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as OverrideStatus,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,pairedOverrideId: freezed == pairedOverrideId ? _self.pairedOverrideId : pairedOverrideId // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
