import 'package:drift/drift.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('ShiftOverride')
class ShiftOverrides extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()(); // DATE UNIQUE
  TextColumn get shiftType => text()();
  TextColumn get status => text()();
  TextColumn get reason => text().nullable()();
  IntColumn get pairedOverrideId =>
      integer().nullable().references(ShiftOverrides, #id)();
}
