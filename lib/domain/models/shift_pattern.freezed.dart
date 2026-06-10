// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shift_pattern.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShiftPattern {

 int get id; String get name; WorkStyle get workStyle; List<ShiftType> get cycle; DateTime get startDate; DateTime get validFrom; DateTime? get validUntil; bool get isActive; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ShiftPattern
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShiftPatternCopyWith<ShiftPattern> get copyWith => _$ShiftPatternCopyWithImpl<ShiftPattern>(this as ShiftPattern, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShiftPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.workStyle, workStyle) || other.workStyle == workStyle)&&const DeepCollectionEquality().equals(other.cycle, cycle)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,workStyle,const DeepCollectionEquality().hash(cycle),startDate,validFrom,validUntil,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ShiftPattern(id: $id, name: $name, workStyle: $workStyle, cycle: $cycle, startDate: $startDate, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ShiftPatternCopyWith<$Res>  {
  factory $ShiftPatternCopyWith(ShiftPattern value, $Res Function(ShiftPattern) _then) = _$ShiftPatternCopyWithImpl;
@useResult
$Res call({
 int id, String name, WorkStyle workStyle, List<ShiftType> cycle, DateTime startDate, DateTime validFrom, DateTime? validUntil, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ShiftPatternCopyWithImpl<$Res>
    implements $ShiftPatternCopyWith<$Res> {
  _$ShiftPatternCopyWithImpl(this._self, this._then);

  final ShiftPattern _self;
  final $Res Function(ShiftPattern) _then;

/// Create a copy of ShiftPattern
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? workStyle = null,Object? cycle = null,Object? startDate = null,Object? validFrom = null,Object? validUntil = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,workStyle: null == workStyle ? _self.workStyle : workStyle // ignore: cast_nullable_to_non_nullable
as WorkStyle,cycle: null == cycle ? _self.cycle : cycle // ignore: cast_nullable_to_non_nullable
as List<ShiftType>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ShiftPattern].
extension ShiftPatternPatterns on ShiftPattern {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShiftPattern value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShiftPattern() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShiftPattern value)  $default,){
final _that = this;
switch (_that) {
case _ShiftPattern():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShiftPattern value)?  $default,){
final _that = this;
switch (_that) {
case _ShiftPattern() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  WorkStyle workStyle,  List<ShiftType> cycle,  DateTime startDate,  DateTime validFrom,  DateTime? validUntil,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShiftPattern() when $default != null:
return $default(_that.id,_that.name,_that.workStyle,_that.cycle,_that.startDate,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  WorkStyle workStyle,  List<ShiftType> cycle,  DateTime startDate,  DateTime validFrom,  DateTime? validUntil,  bool isActive,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ShiftPattern():
return $default(_that.id,_that.name,_that.workStyle,_that.cycle,_that.startDate,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  WorkStyle workStyle,  List<ShiftType> cycle,  DateTime startDate,  DateTime validFrom,  DateTime? validUntil,  bool isActive,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ShiftPattern() when $default != null:
return $default(_that.id,_that.name,_that.workStyle,_that.cycle,_that.startDate,_that.validFrom,_that.validUntil,_that.isActive,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ShiftPattern implements ShiftPattern {
  const _ShiftPattern({required this.id, required this.name, required this.workStyle, required final  List<ShiftType> cycle, required this.startDate, required this.validFrom, this.validUntil, required this.isActive, required this.createdAt, required this.updatedAt}): _cycle = cycle;
  

@override final  int id;
@override final  String name;
@override final  WorkStyle workStyle;
 final  List<ShiftType> _cycle;
@override List<ShiftType> get cycle {
  if (_cycle is EqualUnmodifiableListView) return _cycle;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cycle);
}

@override final  DateTime startDate;
@override final  DateTime validFrom;
@override final  DateTime? validUntil;
@override final  bool isActive;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ShiftPattern
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShiftPatternCopyWith<_ShiftPattern> get copyWith => __$ShiftPatternCopyWithImpl<_ShiftPattern>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShiftPattern&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.workStyle, workStyle) || other.workStyle == workStyle)&&const DeepCollectionEquality().equals(other._cycle, _cycle)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.validFrom, validFrom) || other.validFrom == validFrom)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,workStyle,const DeepCollectionEquality().hash(_cycle),startDate,validFrom,validUntil,isActive,createdAt,updatedAt);

@override
String toString() {
  return 'ShiftPattern(id: $id, name: $name, workStyle: $workStyle, cycle: $cycle, startDate: $startDate, validFrom: $validFrom, validUntil: $validUntil, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ShiftPatternCopyWith<$Res> implements $ShiftPatternCopyWith<$Res> {
  factory _$ShiftPatternCopyWith(_ShiftPattern value, $Res Function(_ShiftPattern) _then) = __$ShiftPatternCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, WorkStyle workStyle, List<ShiftType> cycle, DateTime startDate, DateTime validFrom, DateTime? validUntil, bool isActive, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ShiftPatternCopyWithImpl<$Res>
    implements _$ShiftPatternCopyWith<$Res> {
  __$ShiftPatternCopyWithImpl(this._self, this._then);

  final _ShiftPattern _self;
  final $Res Function(_ShiftPattern) _then;

/// Create a copy of ShiftPattern
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? workStyle = null,Object? cycle = null,Object? startDate = null,Object? validFrom = null,Object? validUntil = freezed,Object? isActive = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ShiftPattern(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,workStyle: null == workStyle ? _self.workStyle : workStyle // ignore: cast_nullable_to_non_nullable
as WorkStyle,cycle: null == cycle ? _self._cycle : cycle // ignore: cast_nullable_to_non_nullable
as List<ShiftType>,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,validFrom: null == validFrom ? _self.validFrom : validFrom // ignore: cast_nullable_to_non_nullable
as DateTime,validUntil: freezed == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
