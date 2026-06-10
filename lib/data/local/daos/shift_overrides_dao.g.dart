// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_overrides_dao.dart';

// ignore_for_file: type=lint
mixin _$ShiftOverridesDaoMixin on DatabaseAccessor<AppDatabase> {
  $ShiftOverridesTable get shiftOverrides => attachedDatabase.shiftOverrides;
  ShiftOverridesDaoManager get managers => ShiftOverridesDaoManager(this);
}

class ShiftOverridesDaoManager {
  final _$ShiftOverridesDaoMixin _db;
  ShiftOverridesDaoManager(this._db);
  $$ShiftOverridesTableTableManager get shiftOverrides =>
      $$ShiftOverridesTableTableManager(
        _db.attachedDatabase,
        _db.shiftOverrides,
      );
}
