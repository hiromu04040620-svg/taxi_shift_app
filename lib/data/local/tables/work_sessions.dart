import 'package:drift/drift.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('WorkSession')
class WorkSessions extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()(); // DATE UNIQUE
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get breakMinutes => integer()();
}
