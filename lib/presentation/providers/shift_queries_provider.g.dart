// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_queries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(activeShiftPattern)
final activeShiftPatternProvider = ActiveShiftPatternProvider._();

final class ActiveShiftPatternProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShiftPattern?>,
          ShiftPattern?,
          FutureOr<ShiftPattern?>
        >
    with $FutureModifier<ShiftPattern?>, $FutureProvider<ShiftPattern?> {
  ActiveShiftPatternProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeShiftPatternProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeShiftPatternHash();

  @$internal
  @override
  $FutureProviderElement<ShiftPattern?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ShiftPattern?> create(Ref ref) {
    return activeShiftPattern(ref);
  }
}

String _$activeShiftPatternHash() =>
    r'f3007769794728bee48ba22165f4813a532c25fa';

@ProviderFor(shiftTypeForDate)
final shiftTypeForDateProvider = ShiftTypeForDateFamily._();

final class ShiftTypeForDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<ShiftType?>,
          ShiftType?,
          FutureOr<ShiftType?>
        >
    with $FutureModifier<ShiftType?>, $FutureProvider<ShiftType?> {
  ShiftTypeForDateProvider._({
    required ShiftTypeForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'shiftTypeForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shiftTypeForDateHash();

  @override
  String toString() {
    return r'shiftTypeForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ShiftType?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ShiftType?> create(Ref ref) {
    final argument = this.argument as DateTime;
    return shiftTypeForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShiftTypeForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shiftTypeForDateHash() => r'9a2a3837b7e6e4684eafbbc8c20989b5259b0b85';

final class ShiftTypeForDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ShiftType?>, DateTime> {
  ShiftTypeForDateFamily._()
    : super(
        retry: null,
        name: r'shiftTypeForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShiftTypeForDateProvider call(DateTime date) =>
      ShiftTypeForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'shiftTypeForDateProvider';
}

@ProviderFor(shiftsInMonth)
final shiftsInMonthProvider = ShiftsInMonthFamily._();

final class ShiftsInMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<DateTime, ShiftType>>,
          Map<DateTime, ShiftType>,
          FutureOr<Map<DateTime, ShiftType>>
        >
    with
        $FutureModifier<Map<DateTime, ShiftType>>,
        $FutureProvider<Map<DateTime, ShiftType>> {
  ShiftsInMonthProvider._({
    required ShiftsInMonthFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'shiftsInMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$shiftsInMonthHash();

  @override
  String toString() {
    return r'shiftsInMonthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<DateTime, ShiftType>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<DateTime, ShiftType>> create(Ref ref) {
    final argument = this.argument as ({int month, int year});
    return shiftsInMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ShiftsInMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$shiftsInMonthHash() => r'50f02cdd4d516e6e966006bab727abf9c1451088';

final class ShiftsInMonthFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<DateTime, ShiftType>>,
          ({int month, int year})
        > {
  ShiftsInMonthFamily._()
    : super(
        retry: null,
        name: r'shiftsInMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ShiftsInMonthProvider call(({int month, int year}) monthArg) =>
      ShiftsInMonthProvider._(argument: monthArg, from: this);

  @override
  String toString() => r'shiftsInMonthProvider';
}
