// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'selected_month_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedMonth)
final selectedMonthProvider = SelectedMonthProvider._();

final class SelectedMonthProvider
    extends $NotifierProvider<SelectedMonth, ({int month, int year})> {
  SelectedMonthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedMonthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedMonthHash();

  @$internal
  @override
  SelectedMonth create() => SelectedMonth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int month, int year}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int month, int year})>(value),
    );
  }
}

String _$selectedMonthHash() => r'eced6468c8407321d8a568ac20c8aa73eacf9560';

abstract class _$SelectedMonth extends $Notifier<({int month, int year})> {
  ({int month, int year}) build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<({int month, int year}), ({int month, int year})>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<({int month, int year}), ({int month, int year})>,
              ({int month, int year}),
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
