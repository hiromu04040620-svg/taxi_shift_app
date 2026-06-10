import 'package:drift/drift.dart';

@DataClassName('Preset')
class Presets extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get workStyle => text()();
  TextColumn get cycle => text()(); // JSON
}
