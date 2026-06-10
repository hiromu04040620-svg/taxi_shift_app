# アーキテクチャ

## 設計原則

1. **Clean Architecture の3層分離**: presentation / domain / data
2. **オフラインファースト**: 全機能がローカルDBで完結
3. **テスタブル**: domain層は外部依存ゼロ、ユニットテストで網羅
4. **シンプル優先**: 個人開発として保守可能な範囲に留める

## 技術スタック

| カテゴリ | 採用 | 理由 |
|---|---|---|
| Framework | Flutter（最新stable） | iOS/Android単一コードベース |
| 言語 | Dart | Flutterの公式言語 |
| 状態管理 | Riverpod 2.x | 型安全、テスト容易、コミュニティ最大 |
| ローカルDB | drift | SQLiteベース、型安全、マイグレーション充実 |
| ルーティング | go_router | 公式推奨、ディープリンク対応 |
| カレンダーUI | table_calendar | カスタムビルダーで自由度高 |
| グラフ | fl_chart | デファクト、軽量 |
| 通知 | flutter_local_notifications | ローカル通知の定番 |
| 広告 | google_mobile_ads | AdMob公式 |
| ストレージ | shared_preferences | 軽い設定の永続化 |
| 国際化 | intl | 日付フォーマット用（日本語） |
| ログ | logger | 開発時のデバッグ用 |
| テスト | flutter_test, mocktail | 標準＋モック |

## レイヤー構成

```
┌─────────────────────────────────────┐
│  Presentation Layer                  │
│  (Pages, Widgets, Riverpod Providers)│
└──────────────┬──────────────────────┘
               │ 依存
               ▼
┌─────────────────────────────────────┐
│  Domain Layer                        │
│  (Entities, UseCases, Services)      │
│  ※ 外部依存ゼロの純粋ロジック        │
└──────────────┬──────────────────────┘
               │ 依存
               ▼
┌─────────────────────────────────────┐
│  Data Layer                          │
│  (Repositories, drift Database, DAO) │
└─────────────────────────────────────┘
```

依存方向は常に Presentation → Domain ← Data。
Domain は他層を知らない。Data 層が Domain のインターフェイス（Repository契約）を実装する形。

## ディレクトリ構造

```
lib/
├── main.dart                    # エントリポイント、ProviderScope
├── app.dart                     # MaterialApp 設定
│
├── core/                        # 横断的共通基盤
│   ├── constants/
│   │   ├── shift_types.dart     # ShiftType enum, 表示名マップ
│   │   ├── work_styles.dart     # WorkStyle enum
│   │   └── app_constants.dart   # アプリ全体の定数
│   ├── theme/
│   │   ├── app_theme.dart
│   │   └── shift_colors.dart    # シフト種別ごとの色
│   ├── router/
│   │   └── app_router.dart      # go_router設定
│   ├── utils/
│   │   ├── date_utils.dart      # 日付ヘルパー
│   │   ├── number_format.dart   # 円表示など
│   │   └── result.dart          # Result<T> 型
│   └── exceptions/
│
├── data/
│   ├── database/
│   │   ├── app_database.dart    # drift Database クラス
│   │   ├── tables/              # テーブル定義
│   │   │   ├── shift_patterns_table.dart
│   │   │   ├── shift_overrides_table.dart
│   │   │   ├── revenues_table.dart
│   │   │   ├── work_sessions_table.dart
│   │   │   └── app_settings_table.dart
│   │   ├── daos/                # DAO
│   │   └── migrations.dart
│   ├── models/                  # DBモデル ↔ ドメインEntity 変換用
│   └── repositories/            # Repository 実装
│       ├── shift_pattern_repository_impl.dart
│       ├── shift_override_repository_impl.dart
│       ├── revenue_repository_impl.dart
│       └── settings_repository_impl.dart
│
├── domain/
│   ├── entities/
│   │   ├── shift_pattern.dart
│   │   ├── shift_override.dart
│   │   ├── revenue.dart
│   │   ├── work_session.dart
│   │   └── app_settings.dart
│   ├── repositories/            # Repository インターフェイス
│   ├── services/
│   │   ├── shift_resolver.dart  # サイクル展開ロジック
│   │   ├── summary_calculator.dart
│   │   └── improvement_standard_checker.dart
│   └── usecases/                # 必要に応じて
│
├── presentation/
│   ├── pages/
│   │   ├── onboarding/
│   │   ├── calendar/
│   │   ├── day_detail/
│   │   ├── revenue_input/
│   │   ├── summary/
│   │   └── settings/
│   ├── widgets/                 # 共通ウィジェット
│   │   ├── shift_chip.dart
│   │   ├── revenue_card.dart
│   │   └── alert_banner.dart
│   └── providers/               # Riverpod プロバイダ
│       ├── database_provider.dart
│       ├── shift_pattern_provider.dart
│       ├── calendar_provider.dart
│       └── summary_provider.dart
│
└── l10n/
    └── app_ja.arb               # 日本語リソース

test/
├── unit/
│   ├── domain/
│   │   └── services/
│   │       ├── shift_resolver_test.dart       # 必須
│   │       ├── summary_calculator_test.dart
│   │       └── improvement_standard_test.dart  # 必須
│   └── data/
└── widget/
```

## 状態管理戦略（Riverpod）

### Provider の種類分け

| Provider 種類 | 用途 |
|---|---|
| `Provider` | 依存注入（Repository, DB） |
| `FutureProvider` | 1回限りの非同期取得 |
| `StreamProvider` | DBの変更購読（drift の watch） |
| `NotifierProvider` | 画面のローカル状態管理 |
| `AsyncNotifierProvider` | 非同期処理を伴う状態 |

### 主要 Provider 例

```dart
// DB
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());

// Repository
final shiftPatternRepositoryProvider = Provider<ShiftPatternRepository>((ref) {
  return ShiftPatternRepositoryImpl(ref.watch(databaseProvider));
});

// 現在アクティブなパターン
final activePatternProvider = StreamProvider<ShiftPattern?>((ref) {
  return ref.watch(shiftPatternRepositoryProvider).watchActive();
});

// 指定月のシフト一覧（サイクル展開後）
final monthShiftsProvider = FutureProvider.family<Map<DateTime, ShiftType>, DateTime>((ref, month) {
  // pattern + overrides から resolveShiftType で計算
});
```

## サイクル展開の責務分離

**Domain Layer（`shift_resolver.dart`）**:
- 純粋関数として `resolveShiftType(date, pattern, overrides) → ShiftType` を提供
- DB アクセスもFlutter依存もしない
- ユニットテスト100%カバレッジ目標

**Presentation Layer**:
- Provider が pattern と overrides を取得
- 月のシフトをまとめて計算してUIに渡す
- 結果は Map<DateTime, ShiftType> でキャッシュ

## drift の使い方

- スキーマは `tables/*.dart` で定義
- DAOは機能単位で分割
- Stream で変更を watch して Riverpod の StreamProvider に流す
- マイグレーションは `schemaVersion` を上げる時に必ず実装

```dart
@DriftDatabase(tables: [...], daos: [...])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) => m.createAll(),
    onUpgrade: (m, from, to) async {
      // バージョン間のマイグレーション
    },
  );
}
```

## ルーティング（go_router）

```dart
final router = GoRouter(
  initialLocation: '/calendar',
  routes: [
    GoRoute(path: '/onboarding', builder: ...),
    ShellRoute(  // BottomNavBar
      builder: (context, state, child) => MainScaffold(child: child),
      routes: [
        GoRoute(path: '/calendar', builder: ...),
        GoRoute(path: '/summary', builder: ...),
        GoRoute(path: '/settings', builder: ...),
      ],
    ),
    GoRoute(path: '/day/:date', builder: ...),
    GoRoute(path: '/revenue/:date', builder: ...),
    // ...
  ],
);
```

## エラーハンドリング方針

- Repository は `Result<T, Failure>` 型を返す
- `Failure` は domain層に定義された sealed class
- 上位層で UI に適したメッセージに変換

```dart
sealed class Failure {
  String get userMessage;
}
class DatabaseFailure extends Failure { ... }
class ValidationFailure extends Failure { ... }
```

## テスト方針

| 対象 | テスト種別 | 必須度 |
|---|---|---|
| `shift_resolver` | ユニット | 必須 |
| `improvement_standard_checker` | ユニット | 必須 |
| `summary_calculator` | ユニット | 必須 |
| Repository 実装 | ユニット（in-memory DB） | 推奨 |
| 主要ページ | Widget テスト | 推奨 |
| E2E | integration_test | スコープ外 |

### 重要なテストケース（shift_resolver）

- 起点日当日 → 配列[0]
- 月またぎ
- 過去日（起点日より前） → 余りの計算が負数になる場合の処理
- うるう年（2/29）
- パターン切替日の前日・当日・翌日
- Override優先確認
- 複数Overrideの中から該当日を正しく検索

## ビルド・配信

- iOS: Xcode で archive、TestFlight 経由で配信
- Android: `flutter build appbundle` → Google Play Console
- バージョニング: Semantic Versioning（1.0.0 から開始）
- `pubspec.yaml` の `version` を更新時は CHANGELOG.md も更新

## パフォーマンス考慮

- カレンダー描画: 月の全日付を一度に計算するが、Map化してキャッシュ
- DB クエリ: 月の範囲で絞り込み、全件取得しない
- グラフ: 表示月のみの集計、過去全期間の集計はオンデマンド
