// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'revenues_dao.dart';

// ignore_for_file: type=lint
mixin _$RevenuesDaoMixin on DatabaseAccessor<AppDatabase> {
  $RevenuesTable get revenues => attachedDatabase.revenues;
  RevenuesDaoManager get managers => RevenuesDaoManager(this);
}

class RevenuesDaoManager {
  final _$RevenuesDaoMixin _db;
  RevenuesDaoManager(this._db);
  $$RevenuesTableTableManager get revenues =>
      $$RevenuesTableTableManager(_db.attachedDatabase, _db.revenues);
}
