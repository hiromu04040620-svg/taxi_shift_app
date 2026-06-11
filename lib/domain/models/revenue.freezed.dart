// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'revenue.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Revenue {

 int? get id; DateTime get shiftDate; int? get workSessionId; int get grossRevenue; int get taxExcludedRevenue; int get cashAmount; int get cardAmount; int get appAmount; int get ticketAmount; double get totalDistance; double get occupiedDistance; int get ridesCount; int? get fuelAmount; String? get note;
/// Create a copy of Revenue
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RevenueCopyWith<Revenue> get copyWith => _$RevenueCopyWithImpl<Revenue>(this as Revenue, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Revenue&&(identical(other.id, id) || other.id == id)&&(identical(other.shiftDate, shiftDate) || other.shiftDate == shiftDate)&&(identical(other.workSessionId, workSessionId) || other.workSessionId == workSessionId)&&(identical(other.grossRevenue, grossRevenue) || other.grossRevenue == grossRevenue)&&(identical(other.taxExcludedRevenue, taxExcludedRevenue) || other.taxExcludedRevenue == taxExcludedRevenue)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.cardAmount, cardAmount) || other.cardAmount == cardAmount)&&(identical(other.appAmount, appAmount) || other.appAmount == appAmount)&&(identical(other.ticketAmount, ticketAmount) || other.ticketAmount == ticketAmount)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.occupiedDistance, occupiedDistance) || other.occupiedDistance == occupiedDistance)&&(identical(other.ridesCount, ridesCount) || other.ridesCount == ridesCount)&&(identical(other.fuelAmount, fuelAmount) || other.fuelAmount == fuelAmount)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,shiftDate,workSessionId,grossRevenue,taxExcludedRevenue,cashAmount,cardAmount,appAmount,ticketAmount,totalDistance,occupiedDistance,ridesCount,fuelAmount,note);

@override
String toString() {
  return 'Revenue(id: $id, shiftDate: $shiftDate, workSessionId: $workSessionId, grossRevenue: $grossRevenue, taxExcludedRevenue: $taxExcludedRevenue, cashAmount: $cashAmount, cardAmount: $cardAmount, appAmount: $appAmount, ticketAmount: $ticketAmount, totalDistance: $totalDistance, occupiedDistance: $occupiedDistance, ridesCount: $ridesCount, fuelAmount: $fuelAmount, note: $note)';
}


}

/// @nodoc
abstract mixin class $RevenueCopyWith<$Res>  {
  factory $RevenueCopyWith(Revenue value, $Res Function(Revenue) _then) = _$RevenueCopyWithImpl;
@useResult
$Res call({
 int? id, DateTime shiftDate, int? workSessionId, int grossRevenue, int taxExcludedRevenue, int cashAmount, int cardAmount, int appAmount, int ticketAmount, double totalDistance, double occupiedDistance, int ridesCount, int? fuelAmount, String? note
});




}
/// @nodoc
class _$RevenueCopyWithImpl<$Res>
    implements $RevenueCopyWith<$Res> {
  _$RevenueCopyWithImpl(this._self, this._then);

  final Revenue _self;
  final $Res Function(Revenue) _then;

/// Create a copy of Revenue
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? shiftDate = null,Object? workSessionId = freezed,Object? grossRevenue = null,Object? taxExcludedRevenue = null,Object? cashAmount = null,Object? cardAmount = null,Object? appAmount = null,Object? ticketAmount = null,Object? totalDistance = null,Object? occupiedDistance = null,Object? ridesCount = null,Object? fuelAmount = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,shiftDate: null == shiftDate ? _self.shiftDate : shiftDate // ignore: cast_nullable_to_non_nullable
as DateTime,workSessionId: freezed == workSessionId ? _self.workSessionId : workSessionId // ignore: cast_nullable_to_non_nullable
as int?,grossRevenue: null == grossRevenue ? _self.grossRevenue : grossRevenue // ignore: cast_nullable_to_non_nullable
as int,taxExcludedRevenue: null == taxExcludedRevenue ? _self.taxExcludedRevenue : taxExcludedRevenue // ignore: cast_nullable_to_non_nullable
as int,cashAmount: null == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as int,cardAmount: null == cardAmount ? _self.cardAmount : cardAmount // ignore: cast_nullable_to_non_nullable
as int,appAmount: null == appAmount ? _self.appAmount : appAmount // ignore: cast_nullable_to_non_nullable
as int,ticketAmount: null == ticketAmount ? _self.ticketAmount : ticketAmount // ignore: cast_nullable_to_non_nullable
as int,totalDistance: null == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double,occupiedDistance: null == occupiedDistance ? _self.occupiedDistance : occupiedDistance // ignore: cast_nullable_to_non_nullable
as double,ridesCount: null == ridesCount ? _self.ridesCount : ridesCount // ignore: cast_nullable_to_non_nullable
as int,fuelAmount: freezed == fuelAmount ? _self.fuelAmount : fuelAmount // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Revenue].
extension RevenuePatterns on Revenue {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Revenue value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Revenue() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Revenue value)  $default,){
final _that = this;
switch (_that) {
case _Revenue():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Revenue value)?  $default,){
final _that = this;
switch (_that) {
case _Revenue() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? id,  DateTime shiftDate,  int? workSessionId,  int grossRevenue,  int taxExcludedRevenue,  int cashAmount,  int cardAmount,  int appAmount,  int ticketAmount,  double totalDistance,  double occupiedDistance,  int ridesCount,  int? fuelAmount,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Revenue() when $default != null:
return $default(_that.id,_that.shiftDate,_that.workSessionId,_that.grossRevenue,_that.taxExcludedRevenue,_that.cashAmount,_that.cardAmount,_that.appAmount,_that.ticketAmount,_that.totalDistance,_that.occupiedDistance,_that.ridesCount,_that.fuelAmount,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? id,  DateTime shiftDate,  int? workSessionId,  int grossRevenue,  int taxExcludedRevenue,  int cashAmount,  int cardAmount,  int appAmount,  int ticketAmount,  double totalDistance,  double occupiedDistance,  int ridesCount,  int? fuelAmount,  String? note)  $default,) {final _that = this;
switch (_that) {
case _Revenue():
return $default(_that.id,_that.shiftDate,_that.workSessionId,_that.grossRevenue,_that.taxExcludedRevenue,_that.cashAmount,_that.cardAmount,_that.appAmount,_that.ticketAmount,_that.totalDistance,_that.occupiedDistance,_that.ridesCount,_that.fuelAmount,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? id,  DateTime shiftDate,  int? workSessionId,  int grossRevenue,  int taxExcludedRevenue,  int cashAmount,  int cardAmount,  int appAmount,  int ticketAmount,  double totalDistance,  double occupiedDistance,  int ridesCount,  int? fuelAmount,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _Revenue() when $default != null:
return $default(_that.id,_that.shiftDate,_that.workSessionId,_that.grossRevenue,_that.taxExcludedRevenue,_that.cashAmount,_that.cardAmount,_that.appAmount,_that.ticketAmount,_that.totalDistance,_that.occupiedDistance,_that.ridesCount,_that.fuelAmount,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _Revenue extends Revenue {
  const _Revenue({this.id, required this.shiftDate, this.workSessionId, required this.grossRevenue, required this.taxExcludedRevenue, required this.cashAmount, required this.cardAmount, required this.appAmount, required this.ticketAmount, required this.totalDistance, required this.occupiedDistance, required this.ridesCount, this.fuelAmount, this.note}): super._();
  

@override final  int? id;
@override final  DateTime shiftDate;
@override final  int? workSessionId;
@override final  int grossRevenue;
@override final  int taxExcludedRevenue;
@override final  int cashAmount;
@override final  int cardAmount;
@override final  int appAmount;
@override final  int ticketAmount;
@override final  double totalDistance;
@override final  double occupiedDistance;
@override final  int ridesCount;
@override final  int? fuelAmount;
@override final  String? note;

/// Create a copy of Revenue
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RevenueCopyWith<_Revenue> get copyWith => __$RevenueCopyWithImpl<_Revenue>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Revenue&&(identical(other.id, id) || other.id == id)&&(identical(other.shiftDate, shiftDate) || other.shiftDate == shiftDate)&&(identical(other.workSessionId, workSessionId) || other.workSessionId == workSessionId)&&(identical(other.grossRevenue, grossRevenue) || other.grossRevenue == grossRevenue)&&(identical(other.taxExcludedRevenue, taxExcludedRevenue) || other.taxExcludedRevenue == taxExcludedRevenue)&&(identical(other.cashAmount, cashAmount) || other.cashAmount == cashAmount)&&(identical(other.cardAmount, cardAmount) || other.cardAmount == cardAmount)&&(identical(other.appAmount, appAmount) || other.appAmount == appAmount)&&(identical(other.ticketAmount, ticketAmount) || other.ticketAmount == ticketAmount)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.occupiedDistance, occupiedDistance) || other.occupiedDistance == occupiedDistance)&&(identical(other.ridesCount, ridesCount) || other.ridesCount == ridesCount)&&(identical(other.fuelAmount, fuelAmount) || other.fuelAmount == fuelAmount)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,id,shiftDate,workSessionId,grossRevenue,taxExcludedRevenue,cashAmount,cardAmount,appAmount,ticketAmount,totalDistance,occupiedDistance,ridesCount,fuelAmount,note);

@override
String toString() {
  return 'Revenue(id: $id, shiftDate: $shiftDate, workSessionId: $workSessionId, grossRevenue: $grossRevenue, taxExcludedRevenue: $taxExcludedRevenue, cashAmount: $cashAmount, cardAmount: $cardAmount, appAmount: $appAmount, ticketAmount: $ticketAmount, totalDistance: $totalDistance, occupiedDistance: $occupiedDistance, ridesCount: $ridesCount, fuelAmount: $fuelAmount, note: $note)';
}


}

/// @nodoc
abstract mixin class _$RevenueCopyWith<$Res> implements $RevenueCopyWith<$Res> {
  factory _$RevenueCopyWith(_Revenue value, $Res Function(_Revenue) _then) = __$RevenueCopyWithImpl;
@override @useResult
$Res call({
 int? id, DateTime shiftDate, int? workSessionId, int grossRevenue, int taxExcludedRevenue, int cashAmount, int cardAmount, int appAmount, int ticketAmount, double totalDistance, double occupiedDistance, int ridesCount, int? fuelAmount, String? note
});




}
/// @nodoc
class __$RevenueCopyWithImpl<$Res>
    implements _$RevenueCopyWith<$Res> {
  __$RevenueCopyWithImpl(this._self, this._then);

  final _Revenue _self;
  final $Res Function(_Revenue) _then;

/// Create a copy of Revenue
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? shiftDate = null,Object? workSessionId = freezed,Object? grossRevenue = null,Object? taxExcludedRevenue = null,Object? cashAmount = null,Object? cardAmount = null,Object? appAmount = null,Object? ticketAmount = null,Object? totalDistance = null,Object? occupiedDistance = null,Object? ridesCount = null,Object? fuelAmount = freezed,Object? note = freezed,}) {
  return _then(_Revenue(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,shiftDate: null == shiftDate ? _self.shiftDate : shiftDate // ignore: cast_nullable_to_non_nullable
as DateTime,workSessionId: freezed == workSessionId ? _self.workSessionId : workSessionId // ignore: cast_nullable_to_non_nullable
as int?,grossRevenue: null == grossRevenue ? _self.grossRevenue : grossRevenue // ignore: cast_nullable_to_non_nullable
as int,taxExcludedRevenue: null == taxExcludedRevenue ? _self.taxExcludedRevenue : taxExcludedRevenue // ignore: cast_nullable_to_non_nullable
as int,cashAmount: null == cashAmount ? _self.cashAmount : cashAmount // ignore: cast_nullable_to_non_nullable
as int,cardAmount: null == cardAmount ? _self.cardAmount : cardAmount // ignore: cast_nullable_to_non_nullable
as int,appAmount: null == appAmount ? _self.appAmount : appAmount // ignore: cast_nullable_to_non_nullable
as int,ticketAmount: null == ticketAmount ? _self.ticketAmount : ticketAmount // ignore: cast_nullable_to_non_nullable
as int,totalDistance: null == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double,occupiedDistance: null == occupiedDistance ? _self.occupiedDistance : occupiedDistance // ignore: cast_nullable_to_non_nullable
as double,ridesCount: null == ridesCount ? _self.ridesCount : ridesCount // ignore: cast_nullable_to_non_nullable
as int,fuelAmount: freezed == fuelAmount ? _self.fuelAmount : fuelAmount // ignore: cast_nullable_to_non_nullable
as int?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
