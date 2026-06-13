# リリースチェックリスト

## 1. 現在の実装を確定

- [ ] `feature/paywall-release-prep` の差分をレビュー
- [ ] `flutter analyze` が通ることを確認
- [ ] `flutter test` が通ることを確認
- [ ] 実機で記録入力、ペイウォール、広告枠、シフト変更を確認
- [ ] 小さなコミットに分けて保存

## 2. プライバシーポリシー公開

- [ ] `docs/PRIVACY_POLICY.md` の問い合わせ先を確定
- [ ] GitHub Pages 等で公開
- [ ] 公開 URL を控える
- [ ] 設定画面の「プライバシーポリシー」導線に URL を接続
- [ ] App Store Connect の App Privacy に URL を登録

## 3. App Privacy 申告

- [ ] アプリ本体の入力データは端末内保存で、開発者サーバー送信なしとして整理
- [ ] Google Mobile Ads SDK が扱うデータを確認
- [ ] 広告識別子、端末情報、利用状況など、AdMob 由来のデータを申告
- [ ] ATT の表示文言が実態と合っていることを確認

## 4. 広告非表示 IAP

- [ ] App Store Connect で Non-Consumable 商品を作成
- [ ] Product ID を確定
- [ ] `in_app_purchase` 導入を承認
- [ ] 購入、復元、失敗、キャンセルの処理を実装
- [ ] 購入成功時に `isPremium=true` へ更新
- [ ] StoreKit / Sandbox で購入・復元を実機確認

## 5. App Store Connect 登録

- [ ] Bundle ID とアプリ名を確定
- [ ] カテゴリを確定
- [ ] 年齢制限を回答
- [ ] 価格を設定
- [ ] サポート URL を準備
- [ ] プライバシーポリシー URL を登録
- [ ] スクリーンショットを作成
- [ ] 説明文、キーワード、プロモーション文を作成

## 6. TestFlight

- [ ] Release ビルド番号を更新
- [ ] iOS 実機で Release 起動確認
- [ ] Xcode Archive を作成
- [ ] App Store Connect へアップロード
- [ ] TestFlight 内部テスターへ配布
- [ ] クラッシュ、広告、IAP、データ永続化を確認

## 7. 初回審査前

- [ ] テスト広告 ID から本番広告 ID への切り替えを確認
- [ ] ATT 許可前後の広告表示を確認
- [ ] 課金なしでも主要機能が使えることを確認
- [ ] ペイウォールが操作を過度に妨げないことを確認
- [ ] 審査メモに広告非表示 IAP の説明を記載
