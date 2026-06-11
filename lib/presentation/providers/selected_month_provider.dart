import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'selected_month_provider.g.dart';

@Riverpod(keepAlive: true)
class SelectedMonth extends _$SelectedMonth {
  @override
  ({int year, int month}) build() {
    final now = DateTime.now();
    return (year: now.year, month: now.month);
  }

  void set(({int year, int month}) value) => state = value;
}
