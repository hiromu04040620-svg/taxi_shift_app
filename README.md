# taxi_shift_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## 開発フロー

### コミット前の自動チェック

このプロジェクトでは husky による pre-commit フックで以下を自動実行します:

- `references/` 配下への誤コミット防止
- `dart format` のチェック
- `flutter analyze`
- ドメイン層のユニットテスト

チェックが失敗するとコミットが中断されます。

### コミットメッセージ規約

Conventional Commits を採用しています。形式:

```
<type>(<scope>): <subject>
```

有効な type: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`

例:
- `feat(calendar): add month navigation`
- `fix(revenue): correct cash sum calculation`
- `docs: update PRD`

### Hunk による差分レビュー

`git diff` / `git show` は Hunk で表示されるよう設定済みです。
エイリアスも利用可能:

```
git review        # 現在の作業ツリーの差分を Hunk で開く
git review-last   # 直近のコミットを Hunk で開く
```

### UI 統一ルール

UI のガタつきを防ぐため、AGENTS.md に記載された規約に従います:

- スペーシング・サイズは `AppSpacing`, `AppRadius`, `AppIconSize` 経由
- 色は `Theme.of(context).colorScheme` 経由
- タイポグラフィは `Theme.of(context).textTheme` 経由
- 数値リテラル・直接色指定は禁止

詳細は `AGENTS.md` の「UI 統一のための実装ルール」セクションを参照。
