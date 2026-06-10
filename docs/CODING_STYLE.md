# コーディング規約・命名規則

## ドメインモデルとDrift生成クラスの命名規則

ドメイン層（ビジネスロジック）とデータ層（DBアクセス）の分離を明確にするため、以下のルールで命名を統一します。

### ルール1: Drift 生成クラス（DB行）は単数形
- Drift のテーブル定義にて `@DataClassName` で明示的に指定します。
- 例: `Revenues` テーブル → `Revenue` クラス

### ルール2: ドメインモデルは「概念として適切な形」で命名
機械的に単数形/複数形を決めず、そのモデルが表す概念で命名します。
- `AppSettings`: アプリ設定全体の集合。複数形が自然。
- `ShiftPattern`: 1つのシフトパターン定義。単数形が自然。
- `ShiftOverride`: 1日の例外シフト。単数形が自然。
- `Revenue`: 1日の売上記録。単数形が自然。
- `WorkSession`: 1回の勤務セッション。単数形が自然。
- `Preset`: 1つのプリセット。単数形が自然。

### ルール3: Drift クラスとドメインモデルが同名になる場合の対処
`Revenue` (Drift) と `Revenue` (ドメイン) が衝突する場合などは、ドメインモデルをそのままの名称 (`Revenue`) とし、Drift クラス側をインポート時のエイリアス（`as db` 等）で区別します。

**例:**
```dart
import 'package:drift/drift.dart';
import '../local/database.dart' as db;
import '../../domain/models/revenue.dart';

class RevenueRepository {
  final db.AppDatabase _database;

  RevenueRepository(this._database);

  Future<Revenue> get(int id) async {
    // DB行は db.Revenue として扱う
    final db.Revenue row = await _database.revenuesDao.getById(id);
    return Revenue.fromDb(row);
  }
}
```
