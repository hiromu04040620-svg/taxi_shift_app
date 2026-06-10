# AGENTS.md

このプロジェクトで作業するAIエージェント（Antigravity）への常時指示書。

## プロジェクト概要

タクシー乗務員（個人）向けのシフト・売上管理アプリ。iOS / Android クロスプラットフォーム。
詳細は `docs/PRD.md` を参照。

## 必読ドキュメント

実装前に以下を必ず読むこと。優先度順:

1. `docs/DOMAIN_GLOSSARY.md` - タクシー業界用語の定義。**ハルシネーション防止のため最重要**
2. `docs/PRD.md` - プロダクト要件
3. `docs/SPEC.md` - 画面・機能仕様
4. `docs/DATA_MODEL.md` - データモデル、サイクル展開ロジック
5. `docs/ARCHITECTURE.md` - 技術スタック、ディレクトリ構造
6. `docs/UI_UX.md` - デザイン原則

## 技術スタック（厳守）

- **Framework**: Flutter（最新安定版）
- **State Management**: Riverpod 2.x
- **Local DB**: drift（SQLite ベース）
- **Routing**: go_router
- **Calendar UI**: table_calendar
- **Chart**: fl_chart
- **Notifications**: flutter_local_notifications
- **Ads**: google_mobile_ads（v1で導入）
- **Locale**: intl（日本語必須）

承認なしに上記以外のライブラリを追加しないこと。代替案がある場合は提案して承認を得ること。

## コーディング規約

- Dart の公式スタイルガイドに準拠（`dart format` 適用）
- Lint: `flutter_lints` 最新版＋追加で `very_good_analysis` 推奨
- コメント・ドキュメント文字列は **日本語可**。ただしAPI公開する識別子は英語
- ファイル名は `snake_case.dart`、クラス名は `PascalCase`
- 不要な `print` は残さない。ログは `logger` パッケージか `debugPrint` で
- マジックナンバーは禁止、定数化すること

## ドメイン用語（実装時）

- コード上の識別子は英語で統一（例: `Shift.type = ShiftType.workDay`）
- ただし `DOMAIN_GLOSSARY.md` の用語と対応表を `lib/core/constants/shift_types.dart` 等に明記すること
- UI 表示は日本語（「出番」「明け」など）

## ディレクトリ構造（厳守）

```
lib/
├── main.dart
├── app.dart
├── core/              # 共通基盤
│   ├── constants/
│   ├── theme/
│   ├── router/
│   └── utils/
├── data/              # データ層
│   ├── database/      # drift スキーマ・DAO
│   ├── repositories/
│   └── models/
├── domain/            # ドメイン層（純粋なビジネスロジック）
│   ├── entities/
│   ├── usecases/
│   └── services/      # サイクル展開ロジック等
├── presentation/      # UI層
│   ├── pages/
│   ├── widgets/
│   └── providers/     # Riverpod プロバイダ
└── l10n/              # 多言語対応
```

## 禁止事項

- APIキー・秘密情報のコミット禁止。`.env` は `.gitignore` に含めること
- `main` ブランチへの直接コミット禁止。feature ブランチで作業
- マイグレーション無しのスキーマ変更禁止
- テストなしでのコア機能（サイクル展開、改善基準告示判定）の実装禁止

## 開発フロー

1. タスクごとに feature ブランチを切る
2. 実装後は `dart format` と `flutter analyze` を必ず通す
3. コア機能は **ユニットテスト必須**
4. 差分は hunk 単位でユーザーがレビューする前提で、**小さなコミットを心がける**
5. コミットメッセージは Conventional Commits 準拠（`feat:`, `fix:`, `refactor:` 等）

## モデル使い分けのヒント（参考）

- 設計議論・複雑実装: Claude Sonnet 4.6 / Opus 4.6
- ルーチン修正・フォーマット・テスト生成: Gemini 3.5 Flash
- 大規模リファクタリング: Gemini 3.1 Pro

## 検証方法

- 各画面実装後、Visual Artifact としてスクリーンショットを残すこと
- カレンダー画面はサイクル展開が正しく描画されているかを目視確認
- 改善基準告示の判定ロジックはエッジケース（月またぎ、うるう年）を必ずテスト


## UI 統一のための実装ルール（厳守）

本プロジェクトは Material Design 3 で統一されたデザインを採用する。
UI のガタつき・不整合を防ぐため、以下のルールを **必ず守る** こと。

### スペーシング・サイズ・角丸の定数化

数値リテラルでの padding/margin/radius/サイズ指定は **禁止**。
必ず `lib/core/theme/` 配下の定数クラスから取得すること。

実装すべき定数クラス（Phase 1 で作成）:

```dart
// lib/core/theme/design_tokens.dart

class AppSpacing {
  AppSpacing._();
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

class AppRadius {
  AppRadius._();
  static const double sm = 4;
  static const double md = 8;
  static const double lg = 12;
  static const double xl = 16;
  static const double full = 9999;
}

class AppIconSize {
  AppIconSize._();
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
}

class AppTapTarget {
  AppTapTarget._();
  /// Material タップターゲット最小サイズ
  static const double minimum = 48;
}
```

使用例:

```dart
// ❌ ダメな例（マジックナンバー）
padding: const EdgeInsets.all(13),
borderRadius: BorderRadius.circular(7),
SizedBox(height: 20),

// ✅ OK な例（定数経由）
padding: const EdgeInsets.all(AppSpacing.md),
borderRadius: BorderRadius.circular(AppRadius.md),
SizedBox(height: AppSpacing.lg),
```

### 色指定の統一

- Material widget の色は **必ず `Theme.of(context).colorScheme.xxx` 経由** で取得すること
- シフト種別色のみ `ShiftColors` 拡張（または定数クラス）から取得
- `Color(0xFF...)` の直接指定は **禁止**（`ShiftColors` 定義箇所を除く）

```dart
// ❌ ダメな例
Container(color: const Color(0xFF1E3A8A)),
Text('hello', style: TextStyle(color: Color(0xFF000000))),

// ✅ OK な例
Container(color: Theme.of(context).colorScheme.primary),
Text('hello', style: TextStyle(color: Theme.of(context).colorScheme.onSurface)),

// ✅ OK な例（シフト種別色のみ例外）
Container(color: Theme.of(context).colorScheme.workDayBg),  // extension 経由
```

### タイポグラフィの統一

- フォントサイズ・ウェイトの直接指定は **禁止**
- 必ず `Theme.of(context).textTheme.xxx` から取得すること
- M3 タイプスケール（docs/DESIGN.md 参照）に沿う

```dart
// ❌ ダメな例
Text('タイトル', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),

// ✅ OK な例
Text('タイトル', style: Theme.of(context).textTheme.titleLarge),
```

### コンポーネント実装の方針

- M3 標準のウィジェットを最優先で使用すること
  - ボタン: `FilledButton` / `OutlinedButton` / `TextButton` / `ElevatedButton`
  - 入力: `TextField` / `TextFormField`
  - カード: `Card`
  - ダイアログ: `AlertDialog` / `Dialog`
  - シート: `BottomSheet` / `showModalBottomSheet`
  - スイッチ: `Switch`
  - チェック: `Checkbox`
  - ラジオ: `Radio` / `RadioGroup`
  - チップ: `Chip` / `FilterChip` / `InputChip`
  - ナビゲーション: `NavigationBar`（M3 BottomNav）

- 専用ライブラリを使う例外:
  - カレンダー本体: `table_calendar`
  - グラフ: `fl_chart`
  - 通知: `flutter_local_notifications`

- 上記以外で自前実装が必要な場合のみ、`lib/presentation/widgets/` に切り出す

### 業務固有ウィジェットの切り出し

シフトチップ、売上カード、サマリーカード等の業務固有ウィジェットは
必ず `lib/presentation/widgets/` に切り出して再利用すること。

同じ見た目のものをページごとに直書きしない。
**「2回以上同じパターンが出てきたら共通ウィジェット化」** が原則。

### ダークモード対応

すべてのカスタムウィジェットは、Light/Dark 両方で破綻しないことを確認すること。
- Light/Dark で別の色を持つ場合は `Theme.of(context).brightness` で切替
- 直接色指定するならカラースキームの両モード分を定義すること

### アニメーション

- `Duration` の直接指定は避け、定数化を推奨:
  - `AppDuration.short = 150ms`
  - `AppDuration.medium = 300ms`
  - `AppDuration.long = 500ms`
- 基本は Material のデフォルトカーブを使用
- 過剰なアニメーションは避ける

### 禁止リスト（再掲・厳守）

以下は即 reject 対象:

- 数値リテラルでの padding/margin/radius/フォントサイズ指定
- `Color(0xFF...)` での直接色指定（許可された例外を除く）
- `TextStyle(fontSize: ...)` でのサイズ直接指定
- 同じ UI パターンを複数ファイルに直書き
- `Container` の濫用（`DecoratedBox`, `Padding`, `SizedBox` で十分なケース）
- ハードコードされた英語文字列（UI 表示文字列は `l10n` 経由）
