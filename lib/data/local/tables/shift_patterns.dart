import 'package:drift/drift.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('ShiftPattern')
class ShiftPatterns extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get workStyle => text()();
  TextColumn get cycle => text()(); // JSON
  DateTimeColumn get startDate => dateTime()(); // DATE
  DateTimeColumn get validFrom => dateTime()(); // DATE
  DateTimeColumn get validUntil => dateTime().nullable()(); // DATE NULL
  BoolColumn get isActive => boolean()();
}
