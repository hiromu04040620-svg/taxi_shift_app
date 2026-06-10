import 'package:drift/drift.dart';
import '../converters/date_only_converter.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('ShiftOverride')
class ShiftOverrides extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date =>
      text().map(const DateOnlyConverter()).unique()(); // YYYY-MM-DD
  TextColumn get shiftType => text()();
  TextColumn get status => text()();
  TextColumn get reason => text().nullable()();
  IntColumn get pairedOverrideId => integer().nullable().references(
    ShiftOverrides,
    #id,
    onDelete: KeyAction.setNull,
  )();
}
