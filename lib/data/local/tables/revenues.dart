import 'package:drift/drift.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('Revenue')
class Revenues extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get date => dateTime().unique()(); // DATE UNIQUE
  IntColumn get grossRevenue => integer()();
  IntColumn get taxExcludedRevenue => integer()();
  IntColumn get cashAmount => integer()();
  IntColumn get cashlessAmount => integer()();
  IntColumn get otherAmount => integer()();
  RealColumn get totalDistance => real()();
  RealColumn get occupiedDistance => real()();
  IntColumn get ridesCount => integer()();
  IntColumn get fuelAmount => integer().nullable()();
  TextColumn get photoPath => text().nullable()();
  TextColumn get note => text().nullable()();
}
