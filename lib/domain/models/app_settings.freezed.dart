// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AppSettings {

 int get monthlyClosingDay; int get ashikiriAmount; double get commissionRate; bool get improvementStandardEnabled; int get maxMonthlyRestraintHours; int get maxMonthlyShifts; ThemeMode get themeMode; bool get isPremium; Map<String, String> get customLabels;
/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsCopyWith<AppSettings> get copyWith => _$AppSettingsCopyWithImpl<AppSettings>(this as AppSettings, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettings&&(identical(other.monthlyClosingDay, monthlyClosingDay) || other.monthlyClosingDay == monthlyClosingDay)&&(identical(other.ashikiriAmount, ashikiriAmount) || other.ashikiriAmount == ashikiriAmount)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.improvementStandardEnabled, improvementStandardEnabled) || other.improvementStandardEnabled == improvementStandardEnabled)&&(identical(other.maxMonthlyRestraintHours, maxMonthlyRestraintHours) || other.maxMonthlyRestraintHours == maxMonthlyRestraintHours)&&(identical(other.maxMonthlyShifts, maxMonthlyShifts) || other.maxMonthlyShifts == maxMonthlyShifts)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other.customLabels, customLabels));
}


@override
int get hashCode => Object.hash(runtimeType,monthlyClosingDay,ashikiriAmount,commissionRate,improvementStandardEnabled,maxMonthlyRestraintHours,maxMonthlyShifts,themeMode,isPremium,const DeepCollectionEquality().hash(customLabels));

@override
String toString() {
  return 'AppSettings(monthlyClosingDay: $monthlyClosingDay, ashikiriAmount: $ashikiriAmount, commissionRate: $commissionRate, improvementStandardEnabled: $improvementStandardEnabled, maxMonthlyRestraintHours: $maxMonthlyRestraintHours, maxMonthlyShifts: $maxMonthlyShifts, themeMode: $themeMode, isPremium: $isPremium, customLabels: $customLabels)';
}


}

/// @nodoc
abstract mixin class $AppSettingsCopyWith<$Res>  {
  factory $AppSettingsCopyWith(AppSettings value, $Res Function(AppSettings) _then) = _$AppSettingsCopyWithImpl;
@useResult
$Res call({
 int monthlyClosingDay, int ashikiriAmount, double commissionRate, bool improvementStandardEnabled, int maxMonthlyRestraintHours, int maxMonthlyShifts, ThemeMode themeMode, bool isPremium, Map<String, String> customLabels
});




}
/// @nodoc
class _$AppSettingsCopyWithImpl<$Res>
    implements $AppSettingsCopyWith<$Res> {
  _$AppSettingsCopyWithImpl(this._self, this._then);

  final AppSettings _self;
  final $Res Function(AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? monthlyClosingDay = null,Object? ashikiriAmount = null,Object? commissionRate = null,Object? improvementStandardEnabled = null,Object? maxMonthlyRestraintHours = null,Object? maxMonthlyShifts = null,Object? themeMode = null,Object? isPremium = null,Object? customLabels = null,}) {
  return _then(_self.copyWith(
monthlyClosingDay: null == monthlyClosingDay ? _self.monthlyClosingDay : monthlyClosingDay // ignore: cast_nullable_to_non_nullable
as int,ashikiriAmount: null == ashikiriAmount ? _self.ashikiriAmount : ashikiriAmount // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,improvementStandardEnabled: null == improvementStandardEnabled ? _self.improvementStandardEnabled : improvementStandardEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxMonthlyRestraintHours: null == maxMonthlyRestraintHours ? _self.maxMonthlyRestraintHours : maxMonthlyRestraintHours // ignore: cast_nullable_to_non_nullable
as int,maxMonthlyShifts: null == maxMonthlyShifts ? _self.maxMonthlyShifts : maxMonthlyShifts // ignore: cast_nullable_to_non_nullable
as int,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,customLabels: null == customLabels ? _self.customLabels : customLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettings].
extension AppSettingsPatterns on AppSettings {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettings value)  $default,){
final _that = this;
switch (_that) {
case _AppSettings():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettings value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int monthlyClosingDay,  int ashikiriAmount,  double commissionRate,  bool improvementStandardEnabled,  int maxMonthlyRestraintHours,  int maxMonthlyShifts,  ThemeMode themeMode,  bool isPremium,  Map<String, String> customLabels)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.monthlyClosingDay,_that.ashikiriAmount,_that.commissionRate,_that.improvementStandardEnabled,_that.maxMonthlyRestraintHours,_that.maxMonthlyShifts,_that.themeMode,_that.isPremium,_that.customLabels);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int monthlyClosingDay,  int ashikiriAmount,  double commissionRate,  bool improvementStandardEnabled,  int maxMonthlyRestraintHours,  int maxMonthlyShifts,  ThemeMode themeMode,  bool isPremium,  Map<String, String> customLabels)  $default,) {final _that = this;
switch (_that) {
case _AppSettings():
return $default(_that.monthlyClosingDay,_that.ashikiriAmount,_that.commissionRate,_that.improvementStandardEnabled,_that.maxMonthlyRestraintHours,_that.maxMonthlyShifts,_that.themeMode,_that.isPremium,_that.customLabels);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int monthlyClosingDay,  int ashikiriAmount,  double commissionRate,  bool improvementStandardEnabled,  int maxMonthlyRestraintHours,  int maxMonthlyShifts,  ThemeMode themeMode,  bool isPremium,  Map<String, String> customLabels)?  $default,) {final _that = this;
switch (_that) {
case _AppSettings() when $default != null:
return $default(_that.monthlyClosingDay,_that.ashikiriAmount,_that.commissionRate,_that.improvementStandardEnabled,_that.maxMonthlyRestraintHours,_that.maxMonthlyShifts,_that.themeMode,_that.isPremium,_that.customLabels);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettings implements AppSettings {
  const _AppSettings({required this.monthlyClosingDay, required this.ashikiriAmount, required this.commissionRate, required this.improvementStandardEnabled, required this.maxMonthlyRestraintHours, required this.maxMonthlyShifts, required this.themeMode, required this.isPremium, required final  Map<String, String> customLabels}): _customLabels = customLabels;
  

@override final  int monthlyClosingDay;
@override final  int ashikiriAmount;
@override final  double commissionRate;
@override final  bool improvementStandardEnabled;
@override final  int maxMonthlyRestraintHours;
@override final  int maxMonthlyShifts;
@override final  ThemeMode themeMode;
@override final  bool isPremium;
 final  Map<String, String> _customLabels;
@override Map<String, String> get customLabels {
  if (_customLabels is EqualUnmodifiableMapView) return _customLabels;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_customLabels);
}


/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsCopyWith<_AppSettings> get copyWith => __$AppSettingsCopyWithImpl<_AppSettings>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettings&&(identical(other.monthlyClosingDay, monthlyClosingDay) || other.monthlyClosingDay == monthlyClosingDay)&&(identical(other.ashikiriAmount, ashikiriAmount) || other.ashikiriAmount == ashikiriAmount)&&(identical(other.commissionRate, commissionRate) || other.commissionRate == commissionRate)&&(identical(other.improvementStandardEnabled, improvementStandardEnabled) || other.improvementStandardEnabled == improvementStandardEnabled)&&(identical(other.maxMonthlyRestraintHours, maxMonthlyRestraintHours) || other.maxMonthlyRestraintHours == maxMonthlyRestraintHours)&&(identical(other.maxMonthlyShifts, maxMonthlyShifts) || other.maxMonthlyShifts == maxMonthlyShifts)&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.isPremium, isPremium) || other.isPremium == isPremium)&&const DeepCollectionEquality().equals(other._customLabels, _customLabels));
}


@override
int get hashCode => Object.hash(runtimeType,monthlyClosingDay,ashikiriAmount,commissionRate,improvementStandardEnabled,maxMonthlyRestraintHours,maxMonthlyShifts,themeMode,isPremium,const DeepCollectionEquality().hash(_customLabels));

@override
String toString() {
  return 'AppSettings(monthlyClosingDay: $monthlyClosingDay, ashikiriAmount: $ashikiriAmount, commissionRate: $commissionRate, improvementStandardEnabled: $improvementStandardEnabled, maxMonthlyRestraintHours: $maxMonthlyRestraintHours, maxMonthlyShifts: $maxMonthlyShifts, themeMode: $themeMode, isPremium: $isPremium, customLabels: $customLabels)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsCopyWith<$Res> implements $AppSettingsCopyWith<$Res> {
  factory _$AppSettingsCopyWith(_AppSettings value, $Res Function(_AppSettings) _then) = __$AppSettingsCopyWithImpl;
@override @useResult
$Res call({
 int monthlyClosingDay, int ashikiriAmount, double commissionRate, bool improvementStandardEnabled, int maxMonthlyRestraintHours, int maxMonthlyShifts, ThemeMode themeMode, bool isPremium, Map<String, String> customLabels
});




}
/// @nodoc
class __$AppSettingsCopyWithImpl<$Res>
    implements _$AppSettingsCopyWith<$Res> {
  __$AppSettingsCopyWithImpl(this._self, this._then);

  final _AppSettings _self;
  final $Res Function(_AppSettings) _then;

/// Create a copy of AppSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? monthlyClosingDay = null,Object? ashikiriAmount = null,Object? commissionRate = null,Object? improvementStandardEnabled = null,Object? maxMonthlyRestraintHours = null,Object? maxMonthlyShifts = null,Object? themeMode = null,Object? isPremium = null,Object? customLabels = null,}) {
  return _then(_AppSettings(
monthlyClosingDay: null == monthlyClosingDay ? _self.monthlyClosingDay : monthlyClosingDay // ignore: cast_nullable_to_non_nullable
as int,ashikiriAmount: null == ashikiriAmount ? _self.ashikiriAmount : ashikiriAmount // ignore: cast_nullable_to_non_nullable
as int,commissionRate: null == commissionRate ? _self.commissionRate : commissionRate // ignore: cast_nullable_to_non_nullable
as double,improvementStandardEnabled: null == improvementStandardEnabled ? _self.improvementStandardEnabled : improvementStandardEnabled // ignore: cast_nullable_to_non_nullable
as bool,maxMonthlyRestraintHours: null == maxMonthlyRestraintHours ? _self.maxMonthlyRestraintHours : maxMonthlyRestraintHours // ignore: cast_nullable_to_non_nullable
as int,maxMonthlyShifts: null == maxMonthlyShifts ? _self.maxMonthlyShifts : maxMonthlyShifts // ignore: cast_nullable_to_non_nullable
as int,themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,isPremium: null == isPremium ? _self.isPremium : isPremium // ignore: cast_nullable_to_non_nullable
as bool,customLabels: null == customLabels ? _self._customLabels : customLabels // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}

// dart format on
