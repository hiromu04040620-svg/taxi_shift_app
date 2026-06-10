# 参照リポジトリ一覧

本フォルダ配下は外部リポジトリの **固定スナップショット** である。
**エージェントによる編集・更新は禁止**。必要に応じて手動で再取得すること。

| ディレクトリ | 元リポジトリ | 取得日時 | コミットハッシュ |
|---|---|---|---|
| material-tokens/ | https://github.com/material-foundation/material-tokens | 2022-05-19 07:17:58 -0700 | 4da7518146b2e9fd6ce7d84670ffd48b4fc1cded |
| material-color-utilities/ | https://github.com/material-foundation/material-color-utilities | 2026-04-16 13:57:59 -0700 | 6fd88eb3e95ba1d457842e2a2bf847d06b3a018a |
| flutter_material_3_demo/ | https://github.com/chayanforyou/flutter_material_3_demo | 2025-10-06 14:41:59 +0600 | e364c60c53fa52bcfe7e10f6c124bd8bec6dfe59 |
| flutter-samples/ | https://github.com/flutter/samples | 2026-06-04 06:44:01 +0000 | 8df115f2a75ee3e2e1cb60e13201b52a66a6bcfe |

## 更新手順（必要時のみ手動で）

1. 該当フォルダを丸ごと削除
2. 再 clone（プロジェクトの初期化プロンプト参照）
3. 本ファイルの取得日とコミットハッシュを更新
4. UI への影響を手動レビュー

## 注意

本ファイル以外のフォルダ配下は `.gitignore` で除外されている。
本ファイル（REFERENCES.md）のみが Git 管理対象。
