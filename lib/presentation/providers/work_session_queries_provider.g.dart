// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_session_queries_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(workSessionForDate)
final workSessionForDateProvider = WorkSessionForDateFamily._();

final class WorkSessionForDateProvider
    extends
        $FunctionalProvider<
          AsyncValue<WorkSession?>,
          WorkSession?,
          FutureOr<WorkSession?>
        >
    with $FutureModifier<WorkSession?>, $FutureProvider<WorkSession?> {
  WorkSessionForDateProvider._({
    required WorkSessionForDateFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'workSessionForDateProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workSessionForDateHash();

  @override
  String toString() {
    return r'workSessionForDateProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WorkSession?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WorkSession?> create(Ref ref) {
    final argument = this.argument as DateTime;
    return workSessionForDate(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkSessionForDateProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workSessionForDateHash() =>
    r'7001de17b5b158858940b43da249c3b119cbef5d';

final class WorkSessionForDateFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WorkSession?>, DateTime> {
  WorkSessionForDateFamily._()
    : super(
        retry: null,
        name: r'workSessionForDateProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkSessionForDateProvider call(DateTime date) =>
      WorkSessionForDateProvider._(argument: date, from: this);

  @override
  String toString() => r'workSessionForDateProvider';
}

@ProviderFor(workSessionsInMonth)
final workSessionsInMonthProvider = WorkSessionsInMonthFamily._();

final class WorkSessionsInMonthProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<WorkSession>>,
          List<WorkSession>,
          FutureOr<List<WorkSession>>
        >
    with
        $FutureModifier<List<WorkSession>>,
        $FutureProvider<List<WorkSession>> {
  WorkSessionsInMonthProvider._({
    required WorkSessionsInMonthFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'workSessionsInMonthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$workSessionsInMonthHash();

  @override
  String toString() {
    return r'workSessionsInMonthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<WorkSession>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<WorkSession>> create(Ref ref) {
    final argument = this.argument as ({int month, int year});
    return workSessionsInMonth(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkSessionsInMonthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$workSessionsInMonthHash() =>
    r'dbb668d1fa324bc778896e4842799c08cc35951f';

final class WorkSessionsInMonthFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<WorkSession>>,
          ({int month, int year})
        > {
  WorkSessionsInMonthFamily._()
    : super(
        retry: null,
        name: r'workSessionsInMonthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  WorkSessionsInMonthProvider call(({int month, int year}) monthArg) =>
      WorkSessionsInMonthProvider._(argument: monthArg, from: this);

  @override
  String toString() => r'workSessionsInMonthProvider';
}
