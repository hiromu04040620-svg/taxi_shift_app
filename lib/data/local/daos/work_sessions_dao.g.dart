// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'work_sessions_dao.dart';

// ignore_for_file: type=lint
mixin _$WorkSessionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $WorkSessionsTable get workSessions => attachedDatabase.workSessions;
  WorkSessionsDaoManager get managers => WorkSessionsDaoManager(this);
}

class WorkSessionsDaoManager {
  final _$WorkSessionsDaoMixin _db;
  WorkSessionsDaoManager(this._db);
  $$WorkSessionsTableTableManager get workSessions =>
      $$WorkSessionsTableTableManager(_db.attachedDatabase, _db.workSessions);
}
