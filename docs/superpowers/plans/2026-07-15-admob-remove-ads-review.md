# AdMob広告・広告非表示IAP 審査対応 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** AppleのSandbox審査で広告表示、`remove_ads`購入、広告消去、復元を再現でき、公開版では本番AdMob広告を表示するBuild 11をApp Reviewへ提出する。

**Architecture:** 広告環境判定、UMP/ATT同意、バナー読み込みを独立したサービスとRiverpod状態に分離する。Sandbox/TestFlight/App Reviewはレシート環境からGoogle公式テスト広告へ自動切替し、App Store公開版だけ既存の本番広告ユニットを使う。既存の`AppSettings.isPremium`と`in_app_purchase`を広告可否の唯一の権利情報として維持する。

**Tech Stack:** Flutter 3.44.0、Dart 3.12.0、Riverpod、`google_mobile_ads: ^9.0.0`、`app_tracking_transparency: ^2.0.7`、`in_app_purchase: ^3.3.0`、Swift、App Store Connect API、Fastlane

## Global Constraints

- iOS App Store初回提出と`remove_ads`の非消費型IAPを同じ審査へ含める。
- カレンダー画面とサマリー画面だけにanchored adaptive bannerを表示する。
- プレミアム購入済みの場合は広告ロードを開始せず、広告枠も残さない。
- Debug、ローカルRelease、Sandbox、TestFlight、App ReviewではGoogle公式テスト広告IDを使う。
- 通常のApp StoreレシートでのみiOS本番バナー広告IDを使う。
- Android本番広告はこの提出では無効にし、未設定IDでクラッシュさせない。
- UMPの`canRequestAds()`が真になる前に広告を要求しない。
- 数値、色、文字スタイルは既存のデザイントークンとMaterial 3テーマを使う。
- 新しい動作は必ず失敗するテストを先に確認してから実装する。
- `fastlane/README.md`など既存の無関係な差分をコミットへ含めない。

---

### Task 1: 広告依存関係と実行環境判定

**Files:**
- Create: `lib/core/config/ad_config.dart`
- Create: `lib/core/services/ad_environment_gateway.dart`
- Create: `test/core/config/ad_config_test.dart`
- Create: `test/core/services/ad_environment_gateway_test.dart`
- Modify: `ios/Runner/AppDelegate.swift`
- Modify: `pubspec.yaml`
- Modify: `pubspec.lock`

**Interfaces:**
- Produces: `enum AdStoreEnvironment { sandbox, production, unsupported }`
- Produces: `abstract interface class AdEnvironmentGateway { Future<AdStoreEnvironment> current(); }`
- Produces: `AdConfig.bannerAdUnitId({required TargetPlatform platform, required bool isDebug, required AdStoreEnvironment environment}) -> String?`

- [ ] **Step 1: 広告ID選択の失敗テストを書く**

```dart
test('iOS SandboxはGoogle公式テストIDを返す', () {
  expect(
    AdConfig.bannerAdUnitId(
      platform: TargetPlatform.iOS,
      isDebug: false,
      environment: AdStoreEnvironment.sandbox,
    ),
    'ca-app-pub-3940256099942544/2934735716',
  );
});

test('iOS本番レシートだけTaxiShift本番IDを返す', () {
  expect(
    AdConfig.bannerAdUnitId(
      platform: TargetPlatform.iOS,
      isDebug: false,
      environment: AdStoreEnvironment.production,
    ),
    'ca-app-pub-8811650450958094/5035306031',
  );
});

test('Android releaseは広告IDを返さない', () {
  expect(
    AdConfig.bannerAdUnitId(
      platform: TargetPlatform.android,
      isDebug: false,
      environment: AdStoreEnvironment.unsupported,
    ),
    isNull,
  );
});
```

- [ ] **Step 2: テストを実行し、`AdConfig`未定義で失敗することを確認する**

Run: `flutter test test/core/config/ad_config_test.dart`

Expected: FAIL with missing `AdConfig` / `AdStoreEnvironment`.

- [ ] **Step 3: 最小の広告設定とMethodChannel gatewayを実装する**

```dart
enum AdStoreEnvironment { sandbox, production, unsupported }

class AdConfig {
  AdConfig._();

  static const _iosTestBanner =
      'ca-app-pub-3940256099942544/2934735716';
  static const _iosProductionBanner =
      'ca-app-pub-8811650450958094/5035306031';

  static String? bannerAdUnitId({
    required TargetPlatform platform,
    required bool isDebug,
    required AdStoreEnvironment environment,
  }) {
    if (platform != TargetPlatform.iOS) return null;
    if (isDebug || environment == AdStoreEnvironment.sandbox) {
      return _iosTestBanner;
    }
    return environment == AdStoreEnvironment.production
        ? _iosProductionBanner
        : null;
  }
}
```

`MethodChannelAdEnvironmentGateway`は`com.sasame.takushiftokun/ad_environment`の`getEnvironment`を呼び、`sandbox`、`production`以外は`unsupported`へ変換する。Swift側はDebugビルド、レシートなし、`sandboxReceipt`を`sandbox`、通常レシートを`production`として返す。

- [ ] **Step 4: 依存関係を追加して取得する**

```yaml
google_mobile_ads: ^9.0.0
app_tracking_transparency: ^2.0.7
```

Run: `flutter pub get`

Expected: both packages resolve and plugin registrants regenerate without errors.

- [ ] **Step 5: 対象テストを通す**

Run: `flutter test test/core/config/ad_config_test.dart test/core/services/ad_environment_gateway_test.dart`

Expected: PASS.

- [ ] **Step 6: コミットする**

```bash
git add pubspec.yaml pubspec.lock lib/core/config/ad_config.dart lib/core/services/ad_environment_gateway.dart ios/Runner/AppDelegate.swift test/core/config/ad_config_test.dart test/core/services/ad_environment_gateway_test.dart
git commit -m "feat: restore review-safe AdMob environment"
```

### Task 2: UMP・ATT・Mobile Ads初期化

**Files:**
- Create: `lib/core/services/ad_consent_gateway.dart`
- Create: `lib/presentation/providers/ad_runtime_provider.dart`
- Create: `test/presentation/providers/ad_runtime_provider_test.dart`
- Modify: `lib/app.dart`

**Interfaces:**
- Produces: `AdConsentResult(canRequestAds, privacyOptionsRequired, diagnosticCode)`
- Produces: `AdRuntimeState(status, adUnitId, privacyOptionsRequired, diagnosticCode)`
- Produces: `AdRuntimeController.initialize()` and `showPrivacyOptions()`
- Consumes: `AdEnvironmentGateway.current()` and `AdConfig.bannerAdUnitId(...)`

- [ ] **Step 1: 同意完了前に広告を有効化しない失敗テストを書く**

```dart
test('UMPが広告を許可した時だけreadyになる', () async {
  consent.result = const AdConsentResult(
    canRequestAds: true,
    privacyOptionsRequired: true,
  );
  final container = adRuntimeContainer(consent: consent);
  await waitForAdRuntime(container, AdRuntimeStatus.ready);
  final state = container.read(adRuntimeControllerProvider);
  expect(state.adUnitId, isNotNull);
  expect(state.privacyOptionsRequired, true);
});

test('UMPが広告を許可しない時は広告IDを公開しない', () async {
  consent.result = const AdConsentResult(canRequestAds: false);
  final container = adRuntimeContainer(consent: consent);
  await waitForAdRuntime(container, AdRuntimeStatus.unavailable);
  expect(container.read(adRuntimeControllerProvider).adUnitId, isNull);
});
```

- [ ] **Step 2: テストを実行し、provider未定義で失敗することを確認する**

Run: `flutter test test/presentation/providers/ad_runtime_provider_test.dart`

Expected: FAIL with missing runtime types.

- [ ] **Step 3: UMP callback APIをFutureへ包むgatewayを実装する**

`PluginAdConsentGateway.gatherConsent()`は次をこの順で行う。

```dart
ConsentInformation.instance.requestConsentInfoUpdate(
  ConsentRequestParameters(),
  onSuccess,
  onFailure,
);
ConsentForm.loadAndShowConsentFormIfRequired(onDismissed);
final canRequestAds = await ConsentInformation.instance.canRequestAds();
final privacyStatus = await ConsentInformation.instance
    .getPrivacyOptionsRequirementStatus();
```

iOSでATTが未決定ならUMPフォーム終了後に`AppTrackingTransparency.requestTrackingAuthorization()`を呼ぶ。ATT拒否は広告利用不可とは扱わず、UMPの`canRequestAds`を最終判断とする。広告要求可能な場合だけ`MobileAds.instance.initialize()`を1回呼ぶ。

- [ ] **Step 4: Riverpod controllerとアプリ起動監視を実装する**

`TaxiShiftApp.build`で`ref.watch(adRuntimeControllerProvider)`を監視し、controllerの`build()`から一度だけ非同期初期化する。エラー時はアプリを落とさず`unavailable`へ遷移し、診断コードを保持する。

- [ ] **Step 5: providerテストを通す**

Run: `flutter test test/presentation/providers/ad_runtime_provider_test.dart`

Expected: PASS for ready, unavailable, consent failure, duplicate initialization prevention, privacy form.

- [ ] **Step 6: コミットする**

```bash
git add lib/core/services/ad_consent_gateway.dart lib/presentation/providers/ad_runtime_provider.dart lib/app.dart test/presentation/providers/ad_runtime_provider_test.dart
git commit -m "feat: gate ads behind privacy consent"
```

### Task 3: 実AdMobバナーとプレミアム連動

**Files:**
- Create: `lib/core/services/banner_ad_loader.dart`
- Create: `test/core/services/banner_ad_loader_test.dart`
- Modify: `lib/presentation/widgets/banner_ad_widget.dart`
- Modify: `lib/presentation/providers/ads_provider.dart`
- Modify: `lib/presentation/screens/calendar/calendar_screen.dart`
- Modify: `lib/presentation/screens/summary/summary_screen.dart`
- Modify: `test/presentation/providers/ads_provider_test.dart`
- Modify: `test/presentation/widgets/banner_ad_widget_test.dart`

**Interfaces:**
- Produces: `LoadedBannerAd(size, view, dispose)`
- Produces: `BannerAdLoader.load({required double width, required String adUnitId})`
- Consumes: `AdRuntimeState.adUnitId` and `AppSettings.isPremium`

- [ ] **Step 1: 無料・同意済みだけ広告を表示する失敗テストを書く**

```dart
test('無料かつ広告runtime readyの場合だけ広告を有効化する', () {
  final container = ProviderContainer(overrides: [
    appSettingsProvider.overrideWithValue(const AsyncData(freeSettings)),
    adRuntimeControllerProvider.overrideWith(
      () => FakeReadyAdRuntimeController(),
    ),
  ]);
  expect(container.read(adsEnabledProvider), true);
});

test('プレミアムユーザーはruntime readyでも広告を無効化する', () {
  // isPremium: true
  expect(container.read(adsEnabledProvider), false);
});
```

`BannerAdWidget`のテストはFake loaderが返した`Key('fake-ad-view')`が表示され、dispose時にFakeの`dispose`が1回呼ばれること、失敗時は`SizedBox.shrink`になることを確認する。

- [ ] **Step 2: 対象テストが現在の自社案内表示のため失敗することを確認する**

Run: `flutter test test/presentation/providers/ads_provider_test.dart test/presentation/widgets/banner_ad_widget_test.dart`

Expected: FAIL because the widget has no AdMob loader/runtime gating.

- [ ] **Step 3: anchored adaptive banner loaderを実装する**

```dart
final size = await AdSize.getLargeAnchoredAdaptiveBannerAdSize(
  width.truncate(),
);
final banner = BannerAd(
  adUnitId: adUnitId,
  size: size,
  request: const AdRequest(),
  listener: BannerAdListener(
    onAdLoaded: completeLoaded,
    onAdFailedToLoad: completeFailedAndDispose,
  ),
);
await banner.load();
```

`BannerAdWidget`はロード完了後だけ`AdWidget`を安定した`SizedBox`へ入れ、失敗・未準備では`SizedBox.shrink()`を返す。広告をタップしてプレミアム画面へ遷移させる旧自社案内は削除する。

- [ ] **Step 4: カレンダーとサマリーへ実広告を配線する**

両画面の`bottomNavigationBar`は`adsEnabledProvider`が真の時だけ`BannerAdWidget(adUnitId: runtime.adUnitId!)`を生成する。購入成功で`isPremium`が更新された直後にwidgetが破棄され、広告と余白が消える。

- [ ] **Step 5: 広告関連テストを通す**

Run: `flutter test test/core/services/banner_ad_loader_test.dart test/presentation/providers/ads_provider_test.dart test/presentation/widgets/banner_ad_widget_test.dart`

Expected: PASS.

- [ ] **Step 6: コミットする**

```bash
git add lib/core/services/banner_ad_loader.dart lib/presentation/widgets/banner_ad_widget.dart lib/presentation/providers/ads_provider.dart lib/presentation/screens/calendar/calendar_screen.dart lib/presentation/screens/summary/summary_screen.dart test/core/services/banner_ad_loader_test.dart test/presentation/providers/ads_provider_test.dart test/presentation/widgets/banner_ad_widget_test.dart
git commit -m "feat: display adaptive AdMob banners"
```

### Task 4: 購入エラー診断と広告プライバシーUI

**Files:**
- Modify: `lib/presentation/providers/premium_purchase_provider.dart`
- Modify: `lib/presentation/screens/premium/premium_screen.dart`
- Modify: `lib/presentation/screens/settings/settings_screen.dart`
- Create: `lib/presentation/screens/settings/sections/ad_privacy_section.dart`
- Modify: `test/presentation/providers/premium_purchase_provider_test.dart`
- Modify: `test/presentation/screens/premium/premium_screen_test.dart`
- Create: `test/presentation/screens/settings/sections/ad_privacy_section_test.dart`

**Interfaces:**
- Extends: `PremiumPurchaseState.errorCode`
- Consumes: `AdRuntimeController.showPrivacyOptions()`

- [ ] **Step 1: StoreKitエラーコード保持の失敗テストを書く**

```dart
test('購入エラーは利用者向け文言と診断コードを保持する', () async {
  final details = purchaseDetails(status: PurchaseStatus.error)
    ..error = IAPError(
      source: 'app_store',
      code: 'storekit_unknown',
      message: 'SKErrorDomain',
      details: {'domain': 'SKErrorDomain', 'code': 0},
    );
  gateway.purchaseController.add([details]);
  await waitForStatus(container, PremiumPurchaseStatus.ready);
  final state = container.read(premiumPurchaseControllerProvider);
  expect(state.message, '購入を完了できませんでした。もう一度お試しください。');
  expect(state.errorCode, contains('storekit_unknown'));
});
```

- [ ] **Step 2: テストが`errorCode`未定義で失敗することを確認する**

Run: `flutter test test/presentation/providers/premium_purchase_provider_test.dart`

Expected: FAIL with missing `errorCode`.

- [ ] **Step 3: 技術エラーを直接表示しない診断状態を実装する**

`PurchaseStatus.error`ではIAPErrorを`debugPrint`へ構造化して出し、状態には日本語メッセージと`source/code`だけを保持する。購入画面は本文の下に`エラーコード: app_store/storekit_unknown`を小さく表示し、再購入と再読み込みを可能にする。

- [ ] **Step 4: プライバシー設定入口を実装する**

`AdPrivacySection`は`privacyOptionsRequired == true`の時だけ「広告のプライバシー設定」を表示し、タップで`showPrivacyOptions()`を呼ぶ。プレミアム購入済みでも過去の同意を変更できるよう表示条件はUMP状態だけにする。

- [ ] **Step 5: UIとproviderテストを通す**

Run: `flutter test test/presentation/providers/premium_purchase_provider_test.dart test/presentation/screens/premium/premium_screen_test.dart test/presentation/screens/settings/sections/ad_privacy_section_test.dart`

Expected: PASS.

- [ ] **Step 6: コミットする**

```bash
git add lib/presentation/providers/premium_purchase_provider.dart lib/presentation/screens/premium/premium_screen.dart lib/presentation/screens/settings/settings_screen.dart lib/presentation/screens/settings/sections/ad_privacy_section.dart test/presentation/providers/premium_purchase_provider_test.dart test/presentation/screens/premium/premium_screen_test.dart test/presentation/screens/settings/sections/ad_privacy_section_test.dart
git commit -m "fix: expose actionable purchase diagnostics"
```

### Task 5: iOS広告・プライバシー・審査メタデータ

**Files:**
- Modify: `ios/Runner/Info.plist`
- Modify: `ios/Runner/PrivacyInfo.xcprivacy` only if the built privacy report shows app-owned declarations are missing
- Modify: `docs/PRIVACY_POLICY.md`
- Modify: `docs/index.md`
- Modify: `docs/RELEASE_CHECKLIST.md`
- Modify: `fastlane/review_notes.txt`
- Modify: `pubspec.yaml`

**Interfaces:**
- Configures: `GADApplicationIdentifier = ca-app-pub-8811650450958094~4636980087`
- Configures: `NSUserTrackingUsageDescription`
- Configures: current Google SKAdNetwork identifiers
- Produces: Build number `11`

- [ ] **Step 1: plist構成を検査する失敗チェックを追加する**

Run before edits:

```bash
plutil -extract GADApplicationIdentifier raw ios/Runner/Info.plist
plutil -extract NSUserTrackingUsageDescription raw ios/Runner/Info.plist
```

Expected: both commands fail because keys are absent.

- [ ] **Step 2: iOS設定を追加する**

`Info.plist`へAdMobアプリID、具体的な日本語ATT目的文、Google公式の最新SKAdNetwork ID一覧を追加し、既存の`ITSAppUsesNonExemptEncryption=false`を維持する。`plutil -lint`と重複ID検査を通す。

- [ ] **Step 3: プライバシーポリシーと審査文言を実装どおり更新する**

公開ポリシーにはAdMob、広告目的の識別子・広告データ・利用状況、UMP/ATT、広告非表示購入、問い合わせ方法を記載する。審査メモにはBuild 11、広告表示場所、ATT表示、Sandbox広告、`remove_ads`購入・復元手順を明記し、添付前に「動画添付済み」とは書かない。

- [ ] **Step 4: build番号を11へ上げる**

```yaml
version: 1.0.0+11
```

- [ ] **Step 5: メタデータ差分を検査する**

Run: `plutil -lint ios/Runner/Info.plist ios/Runner/PrivacyInfo.xcprivacy && git diff --check`

Expected: PASS.

- [ ] **Step 6: コミットする**

```bash
git add ios/Runner/Info.plist ios/Runner/PrivacyInfo.xcprivacy docs/PRIVACY_POLICY.md docs/index.md docs/RELEASE_CHECKLIST.md fastlane/review_notes.txt pubspec.yaml
git commit -m "chore: prepare AdMob review build 11"
```

### Task 6: 自動テスト・App Store事前検査・Releaseビルド

**Files:**
- Modify only files required by concrete test/analyzer/preflight findings
- Output: `build/ios/archive/Runner.xcarchive`
- Output: `build/ios/ipa/TaxiShift.ipa`

- [ ] **Step 1: 生成コードと書式を更新する**

Run: `dart run build_runner build --delete-conflicting-outputs && dart format lib test`

Expected: generated Riverpod code matches sources; formatter exits 0.

- [ ] **Step 2: 全自動検証を実行する**

Run: `flutter analyze && flutter test && bundle exec ruby -Itest test/scripts/app_store_connect_audit_test.rb`

Expected: zero analyzer issues and all tests PASS.

- [ ] **Step 3: App Store preflightを実行する**

Run: `greenlight preflight .`

Expected: zero `CRITICAL`; every `WARN` is either fixed or documented with concrete evidence.

- [ ] **Step 4: iOS Release archiveとIPAを作る**

Run: `tool/build_ios_release.sh 11`

Expected: signed archive and `build/ios/ipa/TaxiShift.ipa` produced successfully.

- [ ] **Step 5: IPA内容を検査する**

確認項目:

- Bundle ID `com.sasame.takushiftokun`
- Version `1.0.0 (11)`
- App Store配布プロビジョニング
- `GADApplicationIdentifier`
- ATT目的文
- `ITSAppUsesNonExemptEncryption=false`
- `GoogleMobileAds`、`UserMessagingPlatform`、`in_app_purchase_storekit`が埋め込まれている
- Debugシンボルやテスト用秘密情報が含まれていない

- [ ] **Step 6: 検証修正を対応する機能コミットへ含める**

Task 1からTask 5の実装に起因する検証エラーは、その機能の対象ファイルだけを明示的に`git add`し、`fix: resolve App Store preflight findings`でコミットする。検証修正がなければこのステップではコミットを作らない。`git add .`とワイルドカードは使わず、既存の無関係な差分を含めない。

### Task 7: 実機Sandbox検証と審査動画

**Files:**
- Output: `fastlane/review_assets/taxishift-build11-sandbox-purchase.mov`

- [ ] **Step 1: Build 11を実機へインストールする**

Run: `xcrun devicectl device install app --device CA8743A9-7B69-5E14-B24D-E6281BDD2D25 build/ios/iphoneos/Runner.app`

Expected: install succeeds on the paired iPhone 16 Pro Max.

- [ ] **Step 2: 実機ログを接続して広告とIAPを診断する**

Run: `xcrun devicectl device process launch --device CA8743A9-7B69-5E14-B24D-E6281BDD2D25 --terminate-existing --console com.sasame.takushiftokun`

確認項目:

- Sandbox環境がGoogle公式テスト広告IDを選ぶ。
- UMPとATTが正しい順で完了する。
- カレンダーとサマリーにテストバナーが表示される。
- 商品`remove_ads`と価格が読み込まれる。
- 購入失敗時は`source/code/details`をログで特定できる。

- [ ] **Step 3: StoreKitエラーを根拠に修正する**

現在のStoreKit 1固定は、Build 11ログで確認したエラーコードに応じてのみ変更する。StoreKit 1起因なら`configureInAppPurchasePlatform()`の固定を削除して公式既定のStoreKit 2へ戻し、購入・復元テスト、Releaseビルド、実機検証を再実行する。アカウント・契約・商品状態起因ならコードを変更せずApp Store Connect設定を修正する。

- [ ] **Step 4: Sandbox購入と復元を成功させる**

無料状態で広告表示、`remove_ads`購入、広告即時消去、アプリ再起動後も非表示、Sandbox購入履歴クリア後の再購入、再インストール後の復元を確認する。

- [ ] **Step 5: Apple指定の画面録画を作る**

ホーム画面から開始し、TaxiShift起動、カレンダー、売上入力、サマリー、広告表示、購入画面、Sandbox購入成功、広告消去、復元を1本の動画に収める。個人通知や他アプリ情報は映さない。

### Task 8: AdMob・App Store Connect更新と再提出

**Files:**
- Modify: App Store Connect metadata through API/UI
- Upload: `build/ios/ipa/TaxiShift.ipa`
- Upload: `fastlane/review_assets/taxishift-build11-sandbox-purchase.mov`

- [ ] **Step 1: AdMobのプライバシーメッセージを設定する**

AdMobの「プライバシーとメッセージ」で欧州規制メッセージとiOS ATT向け説明を公開し、TaxiShiftアプリIDへ適用する。パブリッシャーのファーストパーティID設定もプライバシー申告と一致させる。

- [ ] **Step 2: Build 11をアップロードする**

Run:

```bash
APP_STORE_CONNECT_API_KEY_KEY_ID=CRVY464U3R \
APP_STORE_CONNECT_API_KEY_ISSUER_ID=f5b2b91d-79f1-45cc-8c15-daca84d7a5b6 \
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH="$PWD/fastlane/AuthKey_CRVY464U3R.p8" \
bundle exec fastlane ios upload_testflight skip_build:true
```

Expected: Build 11 uploads and reaches `VALID`.

- [ ] **Step 3: App Privacyを実装へ合わせる**

Google Mobile Ads SDKの現行データ開示に基づき、端末ID、広告データ、製品操作、粗い位置情報、診断等の収集目的、ユーザーへの関連付け、追跡利用をApp Store Connectへ正確に設定する。ATTを実装した場所を審査メモへ明記する。

- [ ] **Step 4: Build 11、IAP、動画、審査メモを提出へまとめる**

App Storeバージョン1.0でBuild 11を選び、`remove_ads`が`WAITING_FOR_REVIEW`で同じ提出に含まれることを確認する。審査動画をApp Review添付へアップロードし、アップロード完了状態を確認してからメモの「動画添付済み」を有効にする。

- [ ] **Step 5: 再提出前監査を通す**

Run:

```bash
ASC_FIRST_IAP_ASSOCIATED=true \
ASC_KEY_ID=CRVY464U3R \
ASC_ISSUER_ID=f5b2b91d-79f1-45cc-8c15-daca84d7a5b6 \
ASC_KEY_PATH="$PWD/fastlane/AuthKey_CRVY464U3R.p8" \
bundle exec ruby scripts/app_store_connect_audit.rb --gate
```

Expected: `Submission gate: PASS` after the gate recognizes both `READY_TO_SUBMIT` and already-submitted `WAITING_FOR_REVIEW` states.

- [ ] **Step 6: App Reviewへ提出する**

提出前にBuild 11、IAP、動画、App Privacy、審査メモを画面上でも再確認し、「App Reviewに提出」を実行する。

- [ ] **Step 7: APIで最終状態を確認する**

Expected:

- App version 1.0: `WAITING_FOR_REVIEW`または`IN_REVIEW`
- Build 11: `VALID`
- `remove_ads`: `WAITING_FOR_REVIEW`または`IN_REVIEW`
- Japanese IAP localization: `WAITING_FOR_REVIEW`または`IN_REVIEW`
- Review attachment: uploaded and `COMPLETE`
