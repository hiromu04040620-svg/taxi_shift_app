import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/app_settings.dart' as tbl;

part 'app_settings_dao.g.dart';

@DriftAccessor(tables: [tbl.AppSettings])
class AppSettingsDao extends DatabaseAccessor<AppDatabase>
    with _$AppSettingsDaoMixin {
  AppSettingsDao(super.db);

  /// 必ず1行目 (id=1) を返す
  Future<AppSetting> getSettings() {
    return (select(appSettings)..where((t) => t.id.equals(1))).getSingle();
  }

  /// リアクティブ取得
  Stream<AppSetting> watchSettings() {
    return (select(appSettings)..where((t) => t.id.equals(1))).watchSingle();
  }

  /// Settingsの更新
  Future<void> updateSettings(AppSettingsCompanion companion) {
    return (update(appSettings)..where((t) => t.id.equals(1))).write(companion);
  }
}
