// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'work_session.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WorkSession {

 int? get id; DateTime get shiftDate; DateTime get startDateTime; DateTime get endDateTime; int get restMinutes; String? get note;
/// Create a copy of WorkSession
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorkSessionCopyWith<WorkSession> get copyWith => _$WorkSessionCopyWithImpl<WorkSession>(this as WorkSession, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorkSession&&(identical(other.id, id) || other.id == id)&&(identical(other.shiftDate, shiftDate) || other.shiftDate == shiftDate)&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.restMinutes, restMinutes) || other.restMinutes == restMinutes)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,shiftDate,startDateTime,endDateTime,restMinutes,note);

@override
String toString() {
  return 'WorkSession(id: $id, shiftDate: $shiftDate, startDateTime: $startDateTime, endDateTime: $endDateTime, restMinutes: $restMinutes, note: $note)';
}


}

/// @nodoc
abstract mixin class $WorkSessionCopyWith<$Res>  {
  factory $WorkSessionCopyWith(WorkSession value, $Res Function(WorkSession) _then) = _$WorkSessionCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime shiftDate, DateTime startDateTime, DateTime endDateTime, int restMinutes, String? note
});




}
/// @nodoc
class _$WorkSessionCopyWithImpl<$Res>
    implements $WorkSessionCopyWith<$Res> {
  _$WorkSessionCopyWithImpl(this._self, this._then);

  final WorkSession _self;
  final $Res Function(WorkSession) _then;

/// Create a copy of WorkSession
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? shiftDate = null,Object? startDateTime = null,Object? endDateTime = null,Object? restMinutes = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,shiftDate: null == shiftDate ? _self.shiftDate : shiftDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDateTime: null == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,endDateTime: null == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,restMinutes: null == restMinutes ? _self.restMinutes : restMinutes // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WorkSession].
extension WorkSessionPatterns on WorkSession {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorkSession value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorkSession() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorkSession value)  $default,){
final _that = this;
switch (_that) {
case _WorkSession():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorkSession value)?  $default,){
final _that = this;
switch (_that) {
case _WorkSession() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime shiftDate,  DateTime startDateTime,  DateTime endDateTime,  int restMinutes,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorkSession() when $default != null:
return $default(_that.id,_that.shiftDate,_that.startDateTime,_that.endDateTime,_that.restMinutes,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime shiftDate,  DateTime startDateTime,  DateTime endDateTime,  int restMinutes,  String? note)  $default,) {final _that = this;
switch (_that) {
case _WorkSession():
return $default(_that.id,_that.shiftDate,_that.startDateTime,_that.endDateTime,_that.restMinutes,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime shiftDate,  DateTime startDateTime,  DateTime endDateTime,  int restMinutes,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _WorkSession() when $default != null:
return $default(_that.id,_that.shiftDate,_that.startDateTime,_that.endDateTime,_that.restMinutes,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _WorkSession extends WorkSession {
  const _WorkSession({this.id, required this.shiftDate, required this.startDateTime, required this.endDateTime, required this.restMinutes, this.note}): super._();
  

@override final  int? id;
@override final  DateTime shiftDate;
@override final  DateTime startDateTime;
@override final  DateTime endDateTime;
@override final  int restMinutes;
@override final  String? note;

/// Create a copy of WorkSession
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorkSessionCopyWith<_WorkSession> get copyWith => __$WorkSessionCopyWithImpl<_WorkSession>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorkSession&&(identical(other.id, id) || other.id == id)&&(identical(other.shiftDate, shiftDate) || other.shiftDate == shiftDate)&&(identical(other.startDateTime, startDateTime) || other.startDateTime == startDateTime)&&(identical(other.endDateTime, endDateTime) || other.endDateTime == endDateTime)&&(identical(other.restMinutes, restMinutes) || other.restMinutes == restMinutes)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,shiftDate,startDateTime,endDateTime,restMinutes,note);

@override
String toString() {
  return 'WorkSession(id: $id, shiftDate: $shiftDate, startDateTime: $startDateTime, endDateTime: $endDateTime, restMinutes: $restMinutes, note: $note)';
}


}

/// @nodoc
abstract mixin class _$WorkSessionCopyWith<$Res> implements $WorkSessionCopyWith<$Res> {
  factory _$WorkSessionCopyWith(_WorkSession value, $Res Function(_WorkSession) _then) = __$WorkSessionCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime shiftDate, DateTime startDateTime, DateTime endDateTime, int restMinutes, String? note
});




}
/// @nodoc
class __$WorkSessionCopyWithImpl<$Res>
    implements _$WorkSessionCopyWith<$Res> {
  __$WorkSessionCopyWithImpl(this._self, this._then);

  final _WorkSession _self;
  final $Res Function(_WorkSession) _then;

/// Create a copy of WorkSession
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? shiftDate = null,Object? startDateTime = null,Object? endDateTime = null,Object? restMinutes = null,Object? note = freezed,}) {
  return _then(_WorkSession(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,shiftDate: null == shiftDate ? _self.shiftDate : shiftDate // ignore: cast_nullable_to_non_nullable
as DateTime,startDateTime: null == startDateTime ? _self.startDateTime : startDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,endDateTime: null == endDateTime ? _self.endDateTime : endDateTime // ignore: cast_nullable_to_non_nullable
as DateTime,restMinutes: null == restMinutes ? _self.restMinutes : restMinutes // ignore: cast_nullable_to_non_nullable
as int,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
