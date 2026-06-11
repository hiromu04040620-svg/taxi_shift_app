// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'improvement_warnings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(monthlyWarnings)
final monthlyWarningsProvider = MonthlyWarningsFamily._();

final class MonthlyWarningsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ImprovementWarning>>,
          List<ImprovementWarning>,
          FutureOr<List<ImprovementWarning>>
        >
    with
        $FutureModifier<List<ImprovementWarning>>,
        $FutureProvider<List<ImprovementWarning>> {
  MonthlyWarningsProvider._({
    required MonthlyWarningsFamily super.from,
    required ({int month, int year}) super.argument,
  }) : super(
         retry: null,
         name: r'monthlyWarningsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$monthlyWarningsHash();

  @override
  String toString() {
    return r'monthlyWarningsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ImprovementWarning>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ImprovementWarning>> create(Ref ref) {
    final argument = this.argument as ({int month, int year});
    return monthlyWarnings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MonthlyWarningsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$monthlyWarningsHash() => r'16f3090bcd83da6d4a57ce07d754d41502c90d7a';

final class MonthlyWarningsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ImprovementWarning>>,
          ({int month, int year})
        > {
  MonthlyWarningsFamily._()
    : super(
        retry: null,
        name: r'monthlyWarningsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MonthlyWarningsProvider call(({int month, int year}) monthArg) =>
      MonthlyWarningsProvider._(argument: monthArg, from: this);

  @override
  String toString() => r'monthlyWarningsProvider';
}

@ProviderFor(sessionWarnings)
final sessionWarningsProvider = SessionWarningsFamily._();

final class SessionWarningsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ImprovementWarning>>,
          List<ImprovementWarning>,
          FutureOr<List<ImprovementWarning>>
        >
    with
        $FutureModifier<List<ImprovementWarning>>,
        $FutureProvider<List<ImprovementWarning>> {
  SessionWarningsProvider._({
    required SessionWarningsFamily super.from,
    required DateTime super.argument,
  }) : super(
         retry: null,
         name: r'sessionWarningsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$sessionWarningsHash();

  @override
  String toString() {
    return r'sessionWarningsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ImprovementWarning>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ImprovementWarning>> create(Ref ref) {
    final argument = this.argument as DateTime;
    return sessionWarnings(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SessionWarningsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$sessionWarningsHash() => r'9e36c4a61b989902e0a66762730c7f4f902a8009';

final class SessionWarningsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<ImprovementWarning>>,
          DateTime
        > {
  SessionWarningsFamily._()
    : super(
        retry: null,
        name: r'sessionWarningsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SessionWarningsProvider call(DateTime date) =>
      SessionWarningsProvider._(argument: date, from: this);

  @override
  String toString() => r'sessionWarningsProvider';
}
