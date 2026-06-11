// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenue_queries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(revenueForDate)
final revenueForDateProvider = RevenueForDateFamily._();

final class RevenueForDateProvider
    extends
        $FunctionalProvider<AsyncValue<Revenue?>, Revenue?, FutureOr<Revenue?>>
    with $FutureModifier<Revenue?>, $FutureProvider<Revenue?> {
  RevenueForDateProvider._({
    required RevenueForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'revenueForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$revenueForDateHash();

  @override
  String toString() {
    return r'revenueForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Revenue?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Revenue?> create(Ref ref) {
    final argument = this.argument as DateTime;
    return revenueForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenueForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$revenueForDateHash() => r'12489f4c7dd204bd5f4f7ce628e9ae4b453af05a';

final class RevenueForDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Revenue?>, DateTime> {
  RevenueForDateFamily._()
    : super(
        retry: null,
        name: r'revenueForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RevenueForDateProvider call(DateTime date) =>
      RevenueForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'revenueForDateProvider';
}

@ProviderFor(revenuesInMonth)
final revenuesInMonthProvider = RevenuesInMonthFamily._();

final class RevenuesInMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Revenue>>,
          List<Revenue>,
          FutureOr<List<Revenue>>
        >
    with $FutureModifier<List<Revenue>>, $FutureProvider<List<Revenue>> {
  RevenuesInMonthProvider._({
    required RevenuesInMonthFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'revenuesInMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$revenuesInMonthHash();

  @override
  String toString() {
    return r'revenuesInMonthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Revenue>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Revenue>> create(Ref ref) {
    final argument = this.argument as ({int month, int year});
    return revenuesInMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RevenuesInMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$revenuesInMonthHash() => r'a303c049f6943464f6717d7b733d1ea0af6aac5b';

final class RevenuesInMonthFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Revenue>>,
          ({int month, int year})
        > {
  RevenuesInMonthFamily._()
    : super(
        retry: null,
        name: r'revenuesInMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  RevenuesInMonthProvider call(({int month, int year}) monthArg) =>
      RevenuesInMonthProvider._(argument: monthArg, from: this);

  @override
  String toString() => r'revenuesInMonthProvider';
}

@ProviderFor(monthlySummary)
final monthlySummaryProvider = MonthlySummaryFamily._();

final class MonthlySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<MonthlySummary>,
          MonthlySummary,
          FutureOr<MonthlySummary>
        >
    with $FutureModifier<MonthlySummary>, $FutureProvider<MonthlySummary> {
  MonthlySummaryProvider._({
    required MonthlySummaryFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'monthlySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlySummaryHash();

  @override
  String toString() {
    return r'monthlySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MonthlySummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MonthlySummary> create(Ref ref) {
    final argument = this.argument as ({int month, int year});
    return monthlySummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlySummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlySummaryHash() => r'bc9e2816f12cf6aef0a95378d8a8c437a5b751ca';

final class MonthlySummaryFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<MonthlySummary>,
          ({int month, int year})
        > {
  MonthlySummaryFamily._()
    : super(
        retry: null,
        name: r'monthlySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlySummaryProvider call(({int month, int year}) monthArg) =>
      MonthlySummaryProvider._(argument: monthArg, from: this);

  @override
  String toString() => r'monthlySummaryProvider';
}
