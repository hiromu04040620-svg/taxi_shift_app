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

### ShiftPatterns ビジネスルール

#### 期間重複の禁止

同一期間に `isActive = true` なシフトパターンは常に1つのみとする。
新規作成・更新時に Repository 層で以下の判定を行い、
重複が検知された場合は StateError をスローする。

##### 重複判定ロジック

新規/更新するパターン A の期間が、既存の isActive=true な
パターン B (自分自身を除く) の期間と1日でも重なる場合に
重複とみなす。

- validUntil が NULL の場合は「無期限」として扱う
- 同一日（境界日）も重複とみなす

##### 設計意図

「指定された日のシフトパターン」が業務ロジック上一意に
定まる必要があるため。複数の有効パターンが存在すると、
アプリの根幹的な動作が破綻する。

#### cycle JSON の構造

シフトサイクルは文字列配列として保存する。
各要素はシフト種別を表す文字列で、配列の先頭から順に
startDate からの日数分繰り返し適用される。

##### 例

```json
["workDay", "afterDuty", "dayOff"]
```

これは「勤務日 → 明け休み → 公休」の3日サイクルを意味し、 startDate が 2026-06-01 の場合:

2026-06-01: workDay
2026-06-02: afterDuty
2026-06-03: dayOff
2026-06-04: workDay
...（以下繰り返し）

##### ShiftType として有効な値
- `workDay`: 勤務日
- `afterDuty`: 明け休み（隔日勤務後の翌休み）
- `dayOff`: 公休

(将来拡張可能。追加時は DATA_MODEL.md と ShiftType enum を同時更新)

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

## ShiftType の使用範囲

ShiftType 列挙値は以下のように使い分ける。

### ShiftPattern.cycle で使用可能な値（定期サイクル用）
- workDay
- afterDuty
- dayOff

### ShiftOverride.shiftType で使用可能な値（例外用）
上記3つに加えて:
- extraWork (公出)
- optionalDayOff (任意休)
- paidLeave (有休)

Repository 層でバリデーションを実装:
ShiftPatternsRepository.create/update で
cycle に extraWork/optionalDayOff/paidLeave が含まれていたら
ArgumentError をスロー。

## ShiftOverrides ビジネスルール

### OverrideStatus enum
- confirmed: 確定状態（MVP ではこの値のみ使用）
- (将来拡張余地として enum 自体は定義するが、
  他の値は現時点では使用しない)

### 同日重複の挙動
date UNIQUE 制約により物理的に重複は作れない。
ユーザーが同日に再度オーバーライドを作成した場合、
Repository 層で既存レコードを upsert（更新）する。
エラーにはしない。

### シフト交換 (Swap) の概念
2日付のシフトを相互に変更する操作。
2レコードを同一トランザクションで作成し、
pairedOverrideId で相互参照させる。

#### createSwap のバリデーション
- dateA == dateB の場合: ArgumentError
- newTypeA == newTypeB: 許可（警告なし）
- 両日 dayOff: 許可（実業務でありうる）
- いずれかの日付に既存オーバーライドがある場合: 上書き

#### deleteSwap の挙動
ペアの両方を同一トランザクションで削除する。
削除時、片方のレコード ID を指定すれば
pairedOverrideId から相方を特定して両方削除する。

### 単発オーバーライドの削除
pairedOverrideId が NULL のレコードは単独削除可能。
pairedOverrideId が非NULL のレコードを単独削除した場合、
onDelete: KeyAction.setNull により
相方の pairedOverrideId が自動的に NULL になる。
（= 残った相方は単発オーバーライドに変化）

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

### AppSettings 初期値

アプリ初回起動時、`AppDatabase.onCreate` 内で以下の値を持つ単一レコード (id = 1) を投入する。

| カラム | 初期値 | 備考 |
|---|---|---|
| id | 1 | CHECK制約により常に1 |
| monthlyClosingDay | 15 | 月次締め日（1-31の範囲）|
| ashikiriAmount | 0 | 足切り金額。ユーザーが設定画面で入力するまでゼロ |
| commissionRate | 0.5 | 歩合率。B型賃金50%を業界標準として採用 |
| improvementStandardEnabled | true | 改善基準告示チェックの有効/無効 |
| maxMonthlyRestraintHours | 262 | 改善基準告示の月間拘束時間上限 |
| maxMonthlyShifts | 13 | 隔日勤務の月間出勤上限 |
| themeMode | 'system' | 'system' / 'light' / 'dark' のいずれか |
| isPremium | false | 課金状態 |
| customLabels | '{}' | カスタムラベルのJSON文字列。初期は空オブジェクト |

#### 設計意図
- `ashikiriAmount` を 0 にしているのは、会社・契約により金額が大きく異なるため、明示的にユーザー入力を促す意図。UI 側で「足切り金額が 0 の場合は設定画面への誘導バナーを表示」などの実装を推奨。
- `commissionRate` の初期値 0.5 は業界標準だが、A型・B型・AB型で異なるため、初回起動時のオンボーディング画面で確認・修正させるフローが望ましい。
- `improvementStandardEnabled` は法令準拠の安全側初期値として true としている。


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
