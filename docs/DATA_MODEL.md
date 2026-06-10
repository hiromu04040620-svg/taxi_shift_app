# データモデル

ローカルDB（drift / SQLite）のスキーマと、サイクル展開ロジックを定義する。

## エンティティ一覧

```
ShiftPattern        サイクル定義（班・ライン）
ShiftOverride       例外（特定日の種別上書き）
Revenue             出番ごとの売上記録
WorkSession         勤務時間記録（拘束時間計算用）
AppSettings         アプリ全体の設定（シングルトン）
Preset              サイクルプリセット（読み取り専用、初期データ）
```

## スキーマ詳細

### ShiftPattern

サイクルパターンの定義。複数のパターンを履歴管理する（班替えに対応）。

| カラム | 型 | 説明 |
|---|---|---|
| id | INTEGER PK | |
| name | TEXT | パターン名（例: "A班", "メイン"） |
| workStyle | TEXT | `alternateDay` / `dayShift` / `nightShift` |
| cycle | TEXT (JSON) | シフト種別の配列（例: `["workDay","afterDuty","dayOff"]`） |
| startDate | DATE | 起点日 |
| validFrom | DATE | このパターンの適用開始日 |
| validUntil | DATE NULL | 終了日。NULL なら現在適用中 |
| isActive | BOOLEAN | 現在使用中かどうか |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

### ShiftOverride

サイクルから計算される予定を、特定日だけ上書きするレコード。

| カラム | 型 | 説明 |
|---|---|---|
| id | INTEGER PK | |
| date | TEXT UNIQUE | 対象日 (YYYY-MM-DD) |
| shiftType | TEXT | `workDay` / `afterDuty` / `dayOff` / `extraWork` / `optionalDayOff` / `paidLeave` |
| status | TEXT | `confirmed`（確定） / `requested`（希望中） |
| reason | TEXT NULL | 変更理由メモ |
| pairedOverrideId | INTEGER NULL | 出番変更時のペアレコードID |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

### Revenue

出番ごとの売上記録。1出番＝1レコード。

| カラム | 型 | 説明 |
|---|---|---|
| id | INTEGER PK | |
| date | TEXT UNIQUE | 出番日（出庫日基準）(YYYY-MM-DD) |
| grossRevenue | INTEGER | 総営収（円） |
| taxExcludedRevenue | INTEGER | 税抜営収（円） |
| cashAmount | INTEGER | 現金売上 |
| cashlessAmount | INTEGER | キャッシュレス売上（カード/IC/QR合算） |
| otherAmount | INTEGER | その他（チケット等） |
| totalDistance | REAL | 総走行距離（km） |
| occupiedDistance | REAL | 実車距離（km） |
| ridesCount | INTEGER | 乗車回数 |
| fuelAmount | INTEGER NULL | 燃料補給額 |
| photoPath | TEXT NULL | 添付写真のパス |
| note | TEXT NULL | メモ |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

派生値: `occupancyRate = occupiedDistance / totalDistance`

### WorkSession

勤務時間。改善基準告示の判定に使う。

| カラム | 型 | 説明 |
|---|---|---|
| id | INTEGER PK | |
| date | TEXT UNIQUE | 出番日（出庫日基準）(YYYY-MM-DD) |
| startTime | DATETIME | 出庫（拘束開始） |
| endTime | DATETIME | 帰庫（拘束終了） |
| breakMinutes | INTEGER | 休憩合計（分） |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

派生値:
- `restraintMinutes = endTime - startTime`（拘束時間）
- `actualWorkMinutes = restraintMinutes - breakMinutes`（実労働時間）

### AppSettings

シングルトンレコード（id=1固定）。

| カラム | 型 | 説明 |
|---|---|---|
| id | INTEGER PK | 常に1 |
| monthlyClosingDay | INTEGER | 月締め日（1-31）、デフォルト15 |
| ashikiriAmount | INTEGER | 足切り額 |
| commissionRate | REAL | 歩率（0.0〜1.0） |
| improvementStandardEnabled | BOOLEAN | 告示アラートON/OFF |
| maxMonthlyRestraintHours | INTEGER | 月間拘束時間上限（デフォルト262） |
| maxMonthlyShifts | INTEGER | 月の出番上限（デフォルト13） |
| themeMode | TEXT | `system` / `light` / `dark` |
| isPremium | BOOLEAN | プレミアム購入済みフラグ |
| customLabels | TEXT (JSON) | 表示名カスタマイズ |
| createdAt | DATETIME | |
| updatedAt | DATETIME | |

### Preset

サイクルプリセット（初期データとしてシード）。
- isBuiltin: bool, NOT NULL, default false（組み込みプリセットを示すフラグ。trueの場合UIで編集・削除不可）

| id | name | workStyle | cycle | isBuiltin |
|---|---|---|---|---|
| 1 | 隔日 2出番2休（標準） | alternateDay | `[workDay, afterDuty, workDay, afterDuty, dayOff, dayOff, dayOff]` | true |
| 2 | 隔日 ダブ公サイクル | alternateDay | `[workDay, afterDuty, workDay, afterDuty, workDay, afterDuty, dayOff, dayOff, dayOff]` |
| 3 | 隔日 12出番標準 | alternateDay | `[workDay, afterDuty, workDay, afterDuty, workDay, afterDuty, dayOff]` |
| 4 | 日勤週休2日 | dayShift | `[workDay, workDay, workDay, workDay, workDay, dayOff, dayOff]` |
| 5 | 夜勤週休2日 | nightShift | `[workDay, workDay, workDay, workDay, workDay, dayOff, dayOff]` |

## サイクル展開ロジック

特定日付のシフト種別を求める純粋関数。**DBに毎日のレコードを持たない**ことが本設計の肝。

```dart
ShiftType resolveShiftType(DateTime targetDate, ShiftPattern pattern, List<ShiftOverride> overrides) {
  // 1. Override があれば最優先
  final override = overrides.firstWhereOrNull((o) => isSameDate(o.date, targetDate));
  if (override != null) return override.shiftType;

  // 2. パターン適用期間外は null（または別パターンを検索）
  if (targetDate.isBefore(pattern.validFrom)) return ShiftType.unknown;
  if (pattern.validUntil != null && targetDate.isAfter(pattern.validUntil!)) {
    return ShiftType.unknown;
  }

  // 3. 起点日からの差分日数を周期で割った余りで配列引き
  final diffDays = daysBetween(pattern.startDate, targetDate);
  final cycleLength = pattern.cycle.length;
  final index = diffDays % cycleLength;
  return pattern.cycle[index >= 0 ? index : index + cycleLength];
}
```

### 月またぎ・班変更時の処理

複数の `ShiftPattern` が時系列で存在する場合、対象日に `validFrom <= date <= validUntil` を満たすパターンを使用する。
パターン切替日に注意。日跨ぎ（隔日勤務は2暦日にまたがる）は出庫日を基準とする。

## サマリー計算ロジック

月次サマリーは「月締め日」を基準に集計する。

```
集計対象期間: (monthlyClosingDay前日 + 1日) ～ monthlyClosingDay
例: 月締め15日 → 前月16日 ～ 当月15日
```

派生指標:
- 出番数: `Revenue` レコード数 ＋ 予定の出番（未来分）
- 総営収: `SUM(grossRevenue)`
- 平均営収: `総営収 / 出番数`
- 実車率: `SUM(occupiedDistance) / SUM(totalDistance)`
- 歩合給試算: `MAX(0, taxExcludedRevenue - ashikiri) * commissionRate` の合計

## 改善基準告示の判定ロジック

```
月の拘束時間合計 = SUM(WorkSession.restraintMinutes / 60)
判定:
  - 達成率 = 合計 / maxMonthlyRestraintHours
  - 達成率 >= 0.9 で「警告」、>= 1.0 で「超過」表示

連続休息判定:
  - 各出番の endTime と 次出番の startTime の差を計算
  - 20時間未満なら違反フラグ

月の出番数:
  - 集計期間内の出番数（実績＋予定）
  - maxMonthlyShifts 超過で警告
```

## マイグレーション方針

- `drift` の Migration を使用
- スキーマ変更時は必ずマイグレーションを書く
- 開発初期はリセット可だが、ストア配信後は必ず後方互換を保つ

## インデックス設計

- `ShiftOverride.date` UNIQUE INDEX
- `Revenue.date` UNIQUE INDEX
- `WorkSession.date` UNIQUE INDEX
- `ShiftPattern (validFrom, validUntil)` 複合INDEX
