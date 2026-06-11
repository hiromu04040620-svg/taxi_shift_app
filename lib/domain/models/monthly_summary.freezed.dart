// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'monthly_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$MonthlySummary {

 int get totalGrossRevenue; int get totalTaxExcludedRevenue; double get averageRevenuePerShift; int get totalShiftsCount; int get totalRidesCount; double get totalDistance; double get totalOccupiedDistance; double get overallOccupancyRate; Map<String, int> get paymentBreakdown;
/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MonthlySummaryCopyWith<MonthlySummary> get copyWith => _$MonthlySummaryCopyWithImpl<MonthlySummary>(this as MonthlySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MonthlySummary&&(identical(other.totalGrossRevenue, totalGrossRevenue) || other.totalGrossRevenue == totalGrossRevenue)&&(identical(other.totalTaxExcludedRevenue, totalTaxExcludedRevenue) || other.totalTaxExcludedRevenue == totalTaxExcludedRevenue)&&(identical(other.averageRevenuePerShift, averageRevenuePerShift) || other.averageRevenuePerShift == averageRevenuePerShift)&&(identical(other.totalShiftsCount, totalShiftsCount) || other.totalShiftsCount == totalShiftsCount)&&(identical(other.totalRidesCount, totalRidesCount) || other.totalRidesCount == totalRidesCount)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.totalOccupiedDistance, totalOccupiedDistance) || other.totalOccupiedDistance == totalOccupiedDistance)&&(identical(other.overallOccupancyRate, overallOccupancyRate) || other.overallOccupancyRate == overallOccupancyRate)&&const DeepCollectionEquality().equals(other.paymentBreakdown, paymentBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,totalGrossRevenue,totalTaxExcludedRevenue,averageRevenuePerShift,totalShiftsCount,totalRidesCount,totalDistance,totalOccupiedDistance,overallOccupancyRate,const DeepCollectionEquality().hash(paymentBreakdown));

@override
String toString() {
  return 'MonthlySummary(totalGrossRevenue: $totalGrossRevenue, totalTaxExcludedRevenue: $totalTaxExcludedRevenue, averageRevenuePerShift: $averageRevenuePerShift, totalShiftsCount: $totalShiftsCount, totalRidesCount: $totalRidesCount, totalDistance: $totalDistance, totalOccupiedDistance: $totalOccupiedDistance, overallOccupancyRate: $overallOccupancyRate, paymentBreakdown: $paymentBreakdown)';
}


}

/// @nodoc
abstract mixin class $MonthlySummaryCopyWith<$Res>  {
  factory $MonthlySummaryCopyWith(MonthlySummary value, $Res Function(MonthlySummary) _then) = _$MonthlySummaryCopyWithImpl;
@useResult
$Res call({
 int totalGrossRevenue, int totalTaxExcludedRevenue, double averageRevenuePerShift, int totalShiftsCount, int totalRidesCount, double totalDistance, double totalOccupiedDistance, double overallOccupancyRate, Map<String, int> paymentBreakdown
});




}
/// @nodoc
class _$MonthlySummaryCopyWithImpl<$Res>
    implements $MonthlySummaryCopyWith<$Res> {
  _$MonthlySummaryCopyWithImpl(this._self, this._then);

  final MonthlySummary _self;
  final $Res Function(MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? totalGrossRevenue = null,Object? totalTaxExcludedRevenue = null,Object? averageRevenuePerShift = null,Object? totalShiftsCount = null,Object? totalRidesCount = null,Object? totalDistance = null,Object? totalOccupiedDistance = null,Object? overallOccupancyRate = null,Object? paymentBreakdown = null,}) {
  return _then(_self.copyWith(
totalGrossRevenue: null == totalGrossRevenue ? _self.totalGrossRevenue : totalGrossRevenue // ignore: cast_nullable_to_non_nullable
as int,totalTaxExcludedRevenue: null == totalTaxExcludedRevenue ? _self.totalTaxExcludedRevenue : totalTaxExcludedRevenue // ignore: cast_nullable_to_non_nullable
as int,averageRevenuePerShift: null == averageRevenuePerShift ? _self.averageRevenuePerShift : averageRevenuePerShift // ignore: cast_nullable_to_non_nullable
as double,totalShiftsCount: null == totalShiftsCount ? _self.totalShiftsCount : totalShiftsCount // ignore: cast_nullable_to_non_nullable
as int,totalRidesCount: null == totalRidesCount ? _self.totalRidesCount : totalRidesCount // ignore: cast_nullable_to_non_nullable
as int,totalDistance: null == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double,totalOccupiedDistance: null == totalOccupiedDistance ? _self.totalOccupiedDistance : totalOccupiedDistance // ignore: cast_nullable_to_non_nullable
as double,overallOccupancyRate: null == overallOccupancyRate ? _self.overallOccupancyRate : overallOccupancyRate // ignore: cast_nullable_to_non_nullable
as double,paymentBreakdown: null == paymentBreakdown ? _self.paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

}


/// Adds pattern-matching-related methods to [MonthlySummary].
extension MonthlySummaryPatterns on MonthlySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MonthlySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MonthlySummary value)  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MonthlySummary value)?  $default,){
final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int totalGrossRevenue,  int totalTaxExcludedRevenue,  double averageRevenuePerShift,  int totalShiftsCount,  int totalRidesCount,  double totalDistance,  double totalOccupiedDistance,  double overallOccupancyRate,  Map<String, int> paymentBreakdown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.totalGrossRevenue,_that.totalTaxExcludedRevenue,_that.averageRevenuePerShift,_that.totalShiftsCount,_that.totalRidesCount,_that.totalDistance,_that.totalOccupiedDistance,_that.overallOccupancyRate,_that.paymentBreakdown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int totalGrossRevenue,  int totalTaxExcludedRevenue,  double averageRevenuePerShift,  int totalShiftsCount,  int totalRidesCount,  double totalDistance,  double totalOccupiedDistance,  double overallOccupancyRate,  Map<String, int> paymentBreakdown)  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary():
return $default(_that.totalGrossRevenue,_that.totalTaxExcludedRevenue,_that.averageRevenuePerShift,_that.totalShiftsCount,_that.totalRidesCount,_that.totalDistance,_that.totalOccupiedDistance,_that.overallOccupancyRate,_that.paymentBreakdown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int totalGrossRevenue,  int totalTaxExcludedRevenue,  double averageRevenuePerShift,  int totalShiftsCount,  int totalRidesCount,  double totalDistance,  double totalOccupiedDistance,  double overallOccupancyRate,  Map<String, int> paymentBreakdown)?  $default,) {final _that = this;
switch (_that) {
case _MonthlySummary() when $default != null:
return $default(_that.totalGrossRevenue,_that.totalTaxExcludedRevenue,_that.averageRevenuePerShift,_that.totalShiftsCount,_that.totalRidesCount,_that.totalDistance,_that.totalOccupiedDistance,_that.overallOccupancyRate,_that.paymentBreakdown);case _:
  return null;

}
}

}

/// @nodoc


class _MonthlySummary implements MonthlySummary {
  const _MonthlySummary({required this.totalGrossRevenue, required this.totalTaxExcludedRevenue, required this.averageRevenuePerShift, required this.totalShiftsCount, required this.totalRidesCount, required this.totalDistance, required this.totalOccupiedDistance, required this.overallOccupancyRate, required final  Map<String, int> paymentBreakdown}): _paymentBreakdown = paymentBreakdown;
  

@override final  int totalGrossRevenue;
@override final  int totalTaxExcludedRevenue;
@override final  double averageRevenuePerShift;
@override final  int totalShiftsCount;
@override final  int totalRidesCount;
@override final  double totalDistance;
@override final  double totalOccupiedDistance;
@override final  double overallOccupancyRate;
 final  Map<String, int> _paymentBreakdown;
@override Map<String, int> get paymentBreakdown {
  if (_paymentBreakdown is EqualUnmodifiableMapView) return _paymentBreakdown;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_paymentBreakdown);
}


/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MonthlySummaryCopyWith<_MonthlySummary> get copyWith => __$MonthlySummaryCopyWithImpl<_MonthlySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MonthlySummary&&(identical(other.totalGrossRevenue, totalGrossRevenue) || other.totalGrossRevenue == totalGrossRevenue)&&(identical(other.totalTaxExcludedRevenue, totalTaxExcludedRevenue) || other.totalTaxExcludedRevenue == totalTaxExcludedRevenue)&&(identical(other.averageRevenuePerShift, averageRevenuePerShift) || other.averageRevenuePerShift == averageRevenuePerShift)&&(identical(other.totalShiftsCount, totalShiftsCount) || other.totalShiftsCount == totalShiftsCount)&&(identical(other.totalRidesCount, totalRidesCount) || other.totalRidesCount == totalRidesCount)&&(identical(other.totalDistance, totalDistance) || other.totalDistance == totalDistance)&&(identical(other.totalOccupiedDistance, totalOccupiedDistance) || other.totalOccupiedDistance == totalOccupiedDistance)&&(identical(other.overallOccupancyRate, overallOccupancyRate) || other.overallOccupancyRate == overallOccupancyRate)&&const DeepCollectionEquality().equals(other._paymentBreakdown, _paymentBreakdown));
}


@override
int get hashCode => Object.hash(runtimeType,totalGrossRevenue,totalTaxExcludedRevenue,averageRevenuePerShift,totalShiftsCount,totalRidesCount,totalDistance,totalOccupiedDistance,overallOccupancyRate,const DeepCollectionEquality().hash(_paymentBreakdown));

@override
String toString() {
  return 'MonthlySummary(totalGrossRevenue: $totalGrossRevenue, totalTaxExcludedRevenue: $totalTaxExcludedRevenue, averageRevenuePerShift: $averageRevenuePerShift, totalShiftsCount: $totalShiftsCount, totalRidesCount: $totalRidesCount, totalDistance: $totalDistance, totalOccupiedDistance: $totalOccupiedDistance, overallOccupancyRate: $overallOccupancyRate, paymentBreakdown: $paymentBreakdown)';
}


}

/// @nodoc
abstract mixin class _$MonthlySummaryCopyWith<$Res> implements $MonthlySummaryCopyWith<$Res> {
  factory _$MonthlySummaryCopyWith(_MonthlySummary value, $Res Function(_MonthlySummary) _then) = __$MonthlySummaryCopyWithImpl;
@override @useResult
$Res call({
 int totalGrossRevenue, int totalTaxExcludedRevenue, double averageRevenuePerShift, int totalShiftsCount, int totalRidesCount, double totalDistance, double totalOccupiedDistance, double overallOccupancyRate, Map<String, int> paymentBreakdown
});




}
/// @nodoc
class __$MonthlySummaryCopyWithImpl<$Res>
    implements _$MonthlySummaryCopyWith<$Res> {
  __$MonthlySummaryCopyWithImpl(this._self, this._then);

  final _MonthlySummary _self;
  final $Res Function(_MonthlySummary) _then;

/// Create a copy of MonthlySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? totalGrossRevenue = null,Object? totalTaxExcludedRevenue = null,Object? averageRevenuePerShift = null,Object? totalShiftsCount = null,Object? totalRidesCount = null,Object? totalDistance = null,Object? totalOccupiedDistance = null,Object? overallOccupancyRate = null,Object? paymentBreakdown = null,}) {
  return _then(_MonthlySummary(
totalGrossRevenue: null == totalGrossRevenue ? _self.totalGrossRevenue : totalGrossRevenue // ignore: cast_nullable_to_non_nullable
as int,totalTaxExcludedRevenue: null == totalTaxExcludedRevenue ? _self.totalTaxExcludedRevenue : totalTaxExcludedRevenue // ignore: cast_nullable_to_non_nullable
as int,averageRevenuePerShift: null == averageRevenuePerShift ? _self.averageRevenuePerShift : averageRevenuePerShift // ignore: cast_nullable_to_non_nullable
as double,totalShiftsCount: null == totalShiftsCount ? _self.totalShiftsCount : totalShiftsCount // ignore: cast_nullable_to_non_nullable
as int,totalRidesCount: null == totalRidesCount ? _self.totalRidesCount : totalRidesCount // ignore: cast_nullable_to_non_nullable
as int,totalDistance: null == totalDistance ? _self.totalDistance : totalDistance // ignore: cast_nullable_to_non_nullable
as double,totalOccupiedDistance: null == totalOccupiedDistance ? _self.totalOccupiedDistance : totalOccupiedDistance // ignore: cast_nullable_to_non_nullable
as double,overallOccupancyRate: null == overallOccupancyRate ? _self.overallOccupancyRate : overallOccupancyRate // ignore: cast_nullable_to_non_nullable
as double,paymentBreakdown: null == paymentBreakdown ? _self._paymentBreakdown : paymentBreakdown // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}


}

// dart format on
