# fastlane リリース手順

## できること

fastlane で iOS の IPA 作成と App Store Connect / TestFlight へのアップロードを自動化する。

```sh
bundle exec fastlane ios build_ipa
bundle exec fastlane ios upload_testflight
```

`upload_testflight` は `pubspec.yaml` の `version` を使って IPA を作成し、App Store Connect にアップロードする。

## 初回だけ必要な認証設定

App Store Connect の「ユーザとアクセス」>「統合」>「App Store Connect API」で API Key を作成する。
作成後、以下をローカル環境変数として設定する。

```sh
export APP_STORE_CONNECT_API_KEY_KEY_ID="Key ID"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="Issuer ID"
export APP_STORE_CONNECT_API_KEY_KEY_FILEPATH="/absolute/path/to/AuthKey_XXXXXXXXXX.p8"
```

`.p8` ファイルは一度しかダウンロードできないため、安全な場所に保管する。
`fastlane/AuthKey_*.p8` と `fastlane/app_store_connect_api_key.json` は `.gitignore` で除外している。

## アップロードだけ再実行する

すでに `build/ios/ipa/TaxiShift.ipa` がある場合は、再ビルドを省略できる。

```sh
bundle exec fastlane ios upload_testflight skip_build:true
```

## 再提出前の手動確認

- App Store Connect の Paid Apps Agreement が In Effect
- Non-Consumable IAP `remove_ads` が Cleared for Sale
- アプリバージョンに IAP `remove_ads` が紐づいている
- Support URL が `https://hiromu04040620-svg.github.io/taxi_shift_app/`
- TestFlight / App Store Connect に Build Number が前回より大きいビルドが表示されている
