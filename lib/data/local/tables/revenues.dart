import 'package:drift/drift.dart';
import '../converters/date_only_converter.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('Revenue')
class Revenues extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get date =>
      text().map(const DateOnlyConverter()).unique()(); // YYYY-MM-DD
  IntColumn get workSessionId => integer().nullable()();
  IntColumn get grossRevenue => integer()();
  IntColumn get taxExcludedRevenue => integer()();
  IntColumn get cashAmount => integer()();
  IntColumn get cardAmount => integer()();
  IntColumn get appAmount => integer()();
  IntColumn get ticketAmount => integer()();
  RealColumn get totalDistance => real()();
  RealColumn get occupiedDistance => real()();
  IntColumn get ridesCount => integer()();
  IntColumn get fuelAmount => integer().nullable()();
  TextColumn get note => text().nullable()();
}
