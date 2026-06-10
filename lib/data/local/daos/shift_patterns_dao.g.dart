// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_patterns_dao.dart';

// ignore_for_file: type=lint
mixin _$ShiftPatternsDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShiftPatternsTable get shiftPatterns => attachedDatabase.shiftPatterns;
  ShiftPatternsDaoManager get managers => ShiftPatternsDaoManager(this);
}

class ShiftPatternsDaoManager {
  final _$ShiftPatternsDaoMixin _db;
  ShiftPatternsDaoManager(this._db);
  $$ShiftPatternsTableTableManager get shiftPatterns =>
      $$ShiftPatternsTableTableManager(_db.attachedDatabase, _db.shiftPatterns);
}
