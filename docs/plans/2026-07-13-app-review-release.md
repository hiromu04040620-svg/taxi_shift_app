# TaxiShift 1.0 App Review Release Plan

## 1. 購入ライフサイクル

**対象**

- `lib/core/services/in_app_purchase_gateway.dart`
- `lib/presentation/providers/premium_purchase_provider.dart`
- `test/presentation/providers/premium_purchase_provider_test.dart`

**手順**

1. Gateway の Fake を使い、商品取得、購入成功、復元、キャンセル、エラー、
   `completePurchase` のテストを先に追加する。
2. 購入状態モデルとアプリ全体で生存する Controller を実装する。
3. アプリ起動時に Controller を初期化し、画面遷移後も購入ストリームを購読する。

## 2. 審査員が見つけられる購入画面

**対象**

- `lib/presentation/screens/premium/premium_screen.dart`
- `lib/presentation/screens/settings/sections/premium_section.dart`
- `lib/presentation/widgets/banner_ad_widget.dart`
- `lib/presentation/router/app_router.dart`
- 対応する Widget テスト

**手順**

1. 商品価格、買い切り表示、購入、復元、再読込、状態説明を検証するテストを追加する。
2. 専用購入画面を実装する。
3. 案内枠と設定から `/premium` へ直接移動できるようにする。
4. 購入済みでは案内枠が消え、設定と購入画面に有効状態を表示する。

## 3. 主要画面のUI整理

**対象**

- Theme と Design Token
- カレンダー、日別詳細、入力シート
- 売上、勤務、法令サマリー
- 設定

**手順**

1. 既存 Widget テストに iPhone / iPad の制約と主要情報の確認を追加する。
2. 情報階層、余白、タップ領域、見出し、空状態、レスポンシブ配置を改善する。
3. 英語の状態語と古い装飾を日本語の運用表示へ統一する。
4. ライト・ダーク、狭幅・広幅で overflow がないことを確認する。

## 4. Fastlane と App Store Connect API

**対象**

- `fastlane/Fastfile`
- `fastlane/README.md`
- `scripts/app_store_connect_audit.rb`
- `docs/FASTLANE_RELEASE.md`

**手順**

1. 秘密情報を出力しない API 監査スクリプトをリポジトリへ追加する。
2. IAP、ローカリゼーション、ビルド、審査動画の状態を JSON で取得する。
3. テスト、IPA作成、アップロード、処理待ち、素材同期をレーン化する。
4. IAP が提出可能でない、動画がない、ビルドが無効な場合は提出を停止する。
5. 提出後に Submission ID と状態を再取得する。

## 5. 実機・素材・提出

1. 全静的解析とテストを実行する。
2. iPhone 実機へインストールし、Sandbox で商品取得、購入、復元を確認する。
3. iPhone / iPad の新しいストアスクリーンショットを生成する。
4. ホーム画面から主要機能と購入成功までを収録した動画を用意する。
5. 却下済み IAP の詳細を App Store Connect で再保存する。
6. Fastlane/API の事前監査を通し、build 9 以降をアップロードして審査へ提出する。
