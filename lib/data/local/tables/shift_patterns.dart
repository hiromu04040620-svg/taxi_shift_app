import 'package:drift/drift.dart';
import '../converters/date_only_converter.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('ShiftPattern')
class ShiftPatterns extends Table with TimestampMixin {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get workStyle => text()();
  TextColumn get cycle => text()(); // JSON
  TextColumn get startDate => text().map(const DateOnlyConverter())(); // DATE
  TextColumn get validFrom => text().map(const DateOnlyConverter())(); // DATE
  TextColumn get validUntil =>
      text().map(const DateOnlyConverter()).nullable()(); // DATE NULL
  BoolColumn get isActive => boolean()();
}
