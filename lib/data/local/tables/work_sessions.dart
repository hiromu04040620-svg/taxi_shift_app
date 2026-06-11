import 'package:drift/drift.dart';
import '../converters/date_only_converter.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('WorkSession')
class WorkSessions extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date =>
      text().map(const DateOnlyConverter()).unique()(); // YYYY-MM-DD
  DateTimeColumn get startTime => dateTime()();
  DateTimeColumn get endTime => dateTime()();
  IntColumn get breakMinutes => integer()();
  TextColumn get note => text().nullable()();
}
