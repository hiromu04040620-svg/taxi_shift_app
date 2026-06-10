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
