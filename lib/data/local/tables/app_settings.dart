import 'package:drift/drift.dart';
import 'mixins/timestamp_mixin.dart';

@DataClassName('AppSetting')
class AppSettings extends Table with TimestampMixin {
  IntColumn get id => integer().withDefault(const Constant(1))(); // 常に1
  IntColumn get monthlyClosingDay =>
      integer().withDefault(const Constant(15))();
  IntColumn get ashikiriAmount => integer()();
  RealColumn get commissionRate => real()();
  BoolColumn get improvementStandardEnabled => boolean()();
  IntColumn get maxMonthlyRestraintHours =>
      integer().withDefault(const Constant(262))();
  IntColumn get maxMonthlyShifts => integer().withDefault(const Constant(13))();
  TextColumn get themeMode => text()();
  BoolColumn get isPremium => boolean()();
  TextColumn get customLabels => text()(); // JSON

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['CHECK (id = 1)'];
}
