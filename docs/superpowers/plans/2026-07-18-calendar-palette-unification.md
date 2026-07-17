# Calendar Palette Unification Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** カレンダーの勤務区分色を淡い緑・グレー中心の配色へ統一し、購入・広告非表示の既存動作を維持した最終ビルドをApp Reviewへ提出する。

**Architecture:** 既存の `ColorScheme` 拡張 `ShiftColors` を唯一の配色ソースとして維持し、getterのインターフェースを変えずにLight/Darkの値だけを置き換える。`ShiftTypeDisplay`を介する既存のカレンダーセル、凡例、選択日バッジ、オンボーディングプレビューへ自動反映させ、色の正確性とWCAG AAコントラストを単体テストで固定する。

**Tech Stack:** Flutter、Dart、Material 3、flutter_test、Fastlane、App Store Connect API

## Global Constraints

- 新しいパッケージを追加しない。
- 勤務区分の直接色指定は `lib/core/theme/shift_colors.dart` だけに置く。
- Light/Darkの12組は承認済み設計 `docs/superpowers/specs/2026-07-18-calendar-palette-unification-design.md` の値と一致させる。
- 通常文字の背景・前景コントラスト比を4.5以上にする。
- `ShiftColors`のgetter名と `ShiftTypeDisplay` の公開APIを変更しない。
- シフト計算、保存データ、広告、IAP、購入復元、プレミアム永続化のロジックを変更しない。
- `dart format`、`flutter analyze`、全Flutterテスト、App Store Connect監査を成功させる。
- 最終ビルドと実機Sandbox購入録画を同じApp Review提出へ含める。

---

## File Map

- Create `test/core/theme/shift_colors_test.dart`: Light/Darkの設計値とコントラスト比を固定する。
- Modify `lib/core/theme/shift_colors.dart`: 勤務区分の共通配色ソースを承認済みパレットへ更新する。
- Modify `docs/DOMAIN_GLOSSARY.md`: 推奨表示色を実装と一致させる。
- Modify `fastlane/review_notes.txt`: 特定ビルド番号への依存をなくし、最終ビルドにも正しい審査手順を維持する。
- Modify `pubspec.yaml`: FastlaneがApp Store Connect上の最大値より大きいビルド番号へ更新する。
- Produce `/tmp/taxishift-calendar-palette/*.png`: iPhone/iPadのLight/Dark視覚確認資料。
- Produce `fastlane/review_assets/taxishift-final-sandbox-purchase.mov`: Apple提出用の実機Sandbox購入録画。Gitには追加しない。

---

### Task 1: 勤務区分パレットをテスト駆動で更新する

**Files:**
- Create: `test/core/theme/shift_colors_test.dart`
- Modify: `lib/core/theme/shift_colors.dart`
- Modify: `docs/DOMAIN_GLOSSARY.md`

**Interfaces:**
- Consumes: `AppColorSchemes.light`、`AppColorSchemes.dark`、既存の `ColorScheme.workDayBg` から `paidLeaveFg` までの12 getter。
- Produces: getter名を変えずに承認済みのLight/Dark配色を返す `ShiftColors`。

- [ ] **Step 1: 設計値とコントラスト比の失敗テストを書く**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taxi_shift_app/core/theme/color_schemes.dart';
import 'package:taxi_shift_app/core/theme/shift_colors.dart';

void main() {
  group('ShiftColors', () {
    test('ライトモードで承認済みの淡色パレットを返す', () {
      final scheme = AppColorSchemes.light;

      expect(scheme.workDayBg, const Color(0xFFE3F1ED));
      expect(scheme.workDayFg, const Color(0xFF245C52));
      expect(scheme.afterDutyBg, const Color(0xFFEDF1EF));
      expect(scheme.afterDutyFg, const Color(0xFF4B5E58));
      expect(scheme.dayOffBg, const Color(0xFFF5ECEE));
      expect(scheme.dayOffFg, const Color(0xFF76545B));
      expect(scheme.extraWorkBg, const Color(0xFFF5F0E2));
      expect(scheme.extraWorkFg, const Color(0xFF6F6037));
      expect(scheme.optionalDayOffBg, const Color(0xFFEDF2E8));
      expect(scheme.optionalDayOffFg, const Color(0xFF52634A));
      expect(scheme.paidLeaveBg, const Color(0xFFE6F1E9));
      expect(scheme.paidLeaveFg, const Color(0xFF3F654B));
    });

    test('ダークモードで承認済みの低彩度パレットを返す', () {
      final scheme = AppColorSchemes.dark;

      expect(scheme.workDayBg, const Color(0xFF213A35));
      expect(scheme.workDayFg, const Color(0xFFC2DDD6));
      expect(scheme.afterDutyBg, const Color(0xFF2A3330));
      expect(scheme.afterDutyFg, const Color(0xFFCBD5D1));
      expect(scheme.dayOffBg, const Color(0xFF433237));
      expect(scheme.dayOffFg, const Color(0xFFE7CCD1));
      expect(scheme.extraWorkBg, const Color(0xFF403A2B));
      expect(scheme.extraWorkFg, const Color(0xFFE4D6AA));
      expect(scheme.optionalDayOffBg, const Color(0xFF333B30));
      expect(scheme.optionalDayOffFg, const Color(0xFFD0D9CB));
      expect(scheme.paidLeaveBg, const Color(0xFF294033));
      expect(scheme.paidLeaveFg, const Color(0xFFC4DDCA));
    });

    test('全勤務区分の文字コントラストがWCAG AAを満たす', () {
      for (final scheme in [AppColorSchemes.light, AppColorSchemes.dark]) {
        for (final pair in _pairs(scheme)) {
          expect(
            _contrastRatio(pair.background, pair.foreground),
            greaterThanOrEqualTo(4.5),
          );
        }
      }
    });
  });
}

List<_ShiftColorPair> _pairs(ColorScheme scheme) => [
  _ShiftColorPair(scheme.workDayBg, scheme.workDayFg),
  _ShiftColorPair(scheme.afterDutyBg, scheme.afterDutyFg),
  _ShiftColorPair(scheme.dayOffBg, scheme.dayOffFg),
  _ShiftColorPair(scheme.extraWorkBg, scheme.extraWorkFg),
  _ShiftColorPair(scheme.optionalDayOffBg, scheme.optionalDayOffFg),
  _ShiftColorPair(scheme.paidLeaveBg, scheme.paidLeaveFg),
];

double _contrastRatio(Color first, Color second) {
  final lighter = [first.computeLuminance(), second.computeLuminance()]
      .reduce((left, right) => left > right ? left : right);
  final darker = [first.computeLuminance(), second.computeLuminance()]
      .reduce((left, right) => left < right ? left : right);
  return (lighter + 0.05) / (darker + 0.05);
}

class _ShiftColorPair {
  const _ShiftColorPair(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
```

- [ ] **Step 2: テストが旧パレットとの差分で失敗することを確認する**

Run:

```bash
flutter test test/core/theme/shift_colors_test.dart
```

Expected: `ライトモードで承認済みの淡色パレットを返す` と `ダークモードで承認済みの低彩度パレットを返す` が旧色との不一致でFAILする。

- [ ] **Step 3: `ShiftColors`の値だけを承認済みパレットへ置き換える**

```dart
import 'package:flutter/material.dart';

extension ShiftColors on ColorScheme {
  Color get workDayBg => brightness == Brightness.light
      ? const Color(0xFFE3F1ED)
      : const Color(0xFF213A35);
  Color get workDayFg => brightness == Brightness.light
      ? const Color(0xFF245C52)
      : const Color(0xFFC2DDD6);

  Color get afterDutyBg => brightness == Brightness.light
      ? const Color(0xFFEDF1EF)
      : const Color(0xFF2A3330);
  Color get afterDutyFg => brightness == Brightness.light
      ? const Color(0xFF4B5E58)
      : const Color(0xFFCBD5D1);

  Color get dayOffBg => brightness == Brightness.light
      ? const Color(0xFFF5ECEE)
      : const Color(0xFF433237);
  Color get dayOffFg => brightness == Brightness.light
      ? const Color(0xFF76545B)
      : const Color(0xFFE7CCD1);

  Color get extraWorkBg => brightness == Brightness.light
      ? const Color(0xFFF5F0E2)
      : const Color(0xFF403A2B);
  Color get extraWorkFg => brightness == Brightness.light
      ? const Color(0xFF6F6037)
      : const Color(0xFFE4D6AA);

  Color get optionalDayOffBg => brightness == Brightness.light
      ? const Color(0xFFEDF2E8)
      : const Color(0xFF333B30);
  Color get optionalDayOffFg => brightness == Brightness.light
      ? const Color(0xFF52634A)
      : const Color(0xFFD0D9CB);

  Color get paidLeaveBg => brightness == Brightness.light
      ? const Color(0xFFE6F1E9)
      : const Color(0xFF294033);
  Color get paidLeaveFg => brightness == Brightness.light
      ? const Color(0xFF3F654B)
      : const Color(0xFFC4DDCA);
}
```

- [ ] **Step 4: 用語集の推奨色を同じ値へ更新する**

`docs/DOMAIN_GLOSSARY.md` の「UI表示色（推奨）」を次のLight値へ置き換え、直後にDark値は設計書を正本とする旨を記載する。

```markdown
| 種別 | 背景色 | 文字色 |
|---|---|---|
| 出番 | #E3F1ED（淡ティール） | #245C52 |
| 明け番 | #EDF1EF（淡緑灰） | #4B5E58 |
| 公休 | #F5ECEE（淡ローズ） | #76545B |
| 公出 | #F5F0E2（淡黄） | #6F6037 |
| 指定公休 | #EDF2E8（淡セージ） | #52634A |
| 有給 | #E6F1E9（淡ミント） | #3F654B |

ダークモードの対応色は `docs/superpowers/specs/2026-07-18-calendar-palette-unification-design.md` を正本とする。
```

- [ ] **Step 5: 配色テストを通す**

Run:

```bash
dart format lib/core/theme/shift_colors.dart test/core/theme/shift_colors_test.dart
flutter test test/core/theme/shift_colors_test.dart
```

Expected: `3 tests passed`、コントラスト比の最小値が4.5未満にならない。

- [ ] **Step 6: 配色変更をコミットする**

```bash
git add lib/core/theme/shift_colors.dart test/core/theme/shift_colors_test.dart docs/DOMAIN_GLOSSARY.md
git commit -m "feat: harmonize calendar shift colors"
```

---

### Task 2: 回帰テストとiPhone/iPad視覚確認を行う

**Files:**
- Test: `test/core/theme/shift_colors_test.dart`
- Test: `test/presentation/screens/calendar/widgets/shift_legend_test.dart`
- Test: `test/presentation/screens/calendar/calendar_screen_test.dart`
- Test: `test/presentation/screens/onboarding/onboarding_screen_test.dart`
- Produce: `/tmp/taxishift-calendar-palette/iphone-light.png`
- Produce: `/tmp/taxishift-calendar-palette/iphone-dark.png`
- Produce: `/tmp/taxishift-calendar-palette/ipad-light.png`
- Produce: `/tmp/taxishift-calendar-palette/ipad-dark.png`

**Interfaces:**
- Consumes: Task 1の `ShiftColors` と既存のカレンダーUI。
- Produces: 配色変更がレイアウト、広告、IAPへ回帰を起こしていないテスト結果と視覚証跡。

- [ ] **Step 1: カレンダー周辺の集中テストを実行する**

Run:

```bash
flutter test \
  test/core/theme/shift_colors_test.dart \
  test/presentation/screens/calendar/widgets/shift_legend_test.dart \
  test/presentation/screens/calendar/calendar_screen_test.dart \
  test/presentation/screens/onboarding/onboarding_screen_test.dart
```

Expected: 全テストPASS、390px幅の凡例が1行内に収まり、RenderFlex overflowがない。

- [ ] **Step 2: リリース検証一式を実行する**

Run:

```bash
bundle exec fastlane ios verify_release
```

Expected: format、`flutter analyze`、全Flutterテスト、RubyのApp Store Connect監査テストがすべて成功する。

- [ ] **Step 3: iPhone 17 Proへビルドを入れてLight/Darkを撮影する**

Run:

```bash
mkdir -p /tmp/taxishift-calendar-palette
flutter build ios --simulator --debug
xcrun simctl install FE930A8C-E110-4BFC-98A0-3487CB603BCE build/ios/iphonesimulator/Runner.app
xcrun simctl ui FE930A8C-E110-4BFC-98A0-3487CB603BCE appearance light
xcrun simctl launch FE930A8C-E110-4BFC-98A0-3487CB603BCE com.sasame.takushiftokun
```

アプリ内で標準サイクルを選択してカレンダーを表示し、セル、凡例、選択日、当日枠、下部広告に重なりがないことを確認して撮影する。

```bash
xcrun simctl io FE930A8C-E110-4BFC-98A0-3487CB603BCE screenshot /tmp/taxishift-calendar-palette/iphone-light.png
xcrun simctl ui FE930A8C-E110-4BFC-98A0-3487CB603BCE appearance dark
xcrun simctl io FE930A8C-E110-4BFC-98A0-3487CB603BCE screenshot /tmp/taxishift-calendar-palette/iphone-dark.png
```

Expected: 6種を文字と淡い色で判別でき、Light/Darkとも濃い原色の並びや文字欠けがない。

- [ ] **Step 4: iPad Pro 13-inchへ同じビルドを入れてLight/Darkを撮影する**

Run:

```bash
xcrun simctl boot B1FE8842-6134-4AFD-AA45-80F3B2C10EB1
open -a Simulator
xcrun simctl install B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 build/ios/iphonesimulator/Runner.app
xcrun simctl ui B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 appearance light
xcrun simctl launch B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 com.sasame.takushiftokun
```

標準サイクルでカレンダーを表示してから撮影する。

```bash
xcrun simctl io B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 screenshot /tmp/taxishift-calendar-palette/ipad-light.png
xcrun simctl ui B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 appearance dark
xcrun simctl io B1FE8842-6134-4AFD-AA45-80F3B2C10EB1 screenshot /tmp/taxishift-calendar-palette/ipad-dark.png
```

Expected: Apple審査端末に近いiPadサイズでセル、凡例、詳細、広告が重ならず、余白と文字サイズが安定する。

- [ ] **Step 5: 4枚を原寸表示して目視判定する**

`view_image`で4枚を確認し、次をすべて満たすことを記録する。

```text
- カレンダーがアプリ全体の緑・グレー基調に馴染む
- 出番、明け番、公休、公出、指定公休、有給休暇を略号でも識別できる
- 選択日と当日の状態が勤務区分色に埋もれない
- Light/Darkのどちらも文字と背景の判別が明確
- iPhone/iPadでテキスト、凡例、広告、ナビゲーションが重ならない
```

---

### Task 3: PRをマージし、最終App Storeビルドをアップロードする

**Files:**
- Modify: `fastlane/review_notes.txt`
- Modify: `pubspec.yaml`
- Output: `build/ios/ipa/TaxiShift.ipa`

**Interfaces:**
- Consumes: Task 2で検証済みのコミット、Fastlane `release_candidate` lane、App Store Connect APIキー。
- Produces: `VALID`になりApp Store version 1.0へ選択された次の未使用ビルド。

- [ ] **Step 1: 審査メモを最終ビルド番号に依存しない表現へ直す**

`fastlane/review_notes.txt` の先頭を次の文に置き換える。購入手順1から7は変更しない。

```text
This build implements Google Mobile Ads banners and the non-consumable In-App Purchase with StoreKit. The app is fully available without signing in.
```

- [ ] **Step 2: 審査メモ変更を検証してコミットする**

Run:

```bash
rg -n "Build 1\.0\.0 \(11\)|Product ID: remove_ads|Purchase steps:" fastlane/review_notes.txt
git add fastlane/review_notes.txt
git commit -m "docs: refresh App Review purchase notes"
```

Expected: 旧Build 11表記は0件、商品IDと購入手順は各1件。コミットが成功する。

- [ ] **Step 3: App Store Connectの提出前状態を取得する**

Run:

```bash
bundle exec fastlane ios asc_status
```

Expected: version 1.0が編集可能、`remove_ads`の価格・配信地域・ローカライズ・IAP審査画像にAPI上の不足がない。現在選択中のBuild番号と最新Build番号を記録する。

- [ ] **Step 4: 次の未使用番号で検証、署名、アップロード、選択まで自動実行する**

Run:

```bash
bundle exec fastlane ios release_candidate
```

Expected: FastlaneがApp Store Connect上の最大Build番号より大きい番号を `pubspec.yaml` に設定し、`TaxiShift.ipa`を作成・アップロードする。処理状態が `VALID`になり、version 1.0へそのBuildが選択される。

- [ ] **Step 5: Release IPAの識別情報を確認する**

Run:

```bash
rm -rf /tmp/taxishift-ipa-audit
mkdir -p /tmp/taxishift-ipa-audit
unzip -q build/ios/ipa/TaxiShift.ipa -d /tmp/taxishift-ipa-audit
plutil -p /tmp/taxishift-ipa-audit/Payload/Runner.app/Info.plist | rg "CFBundleDisplayName|CFBundleIdentifier|CFBundleShortVersionString|CFBundleVersion|GADApplicationIdentifier|NSUserTrackingUsageDescription"
codesign --verify --deep --strict --verbose=2 /tmp/taxishift-ipa-audit/Payload/Runner.app
```

Expected: `TaxiShift`、`com.sasame.takushiftokun`、version `1.0.0`、採番済みBuild、AdMobアプリID、ATT説明が存在し、codesign検証が成功する。

- [ ] **Step 6: 自動採番された `pubspec.yaml` をコミットする**

Run:

```bash
git add pubspec.yaml
git commit -m "chore: bump App Review build"
```

Expected: App Store ConnectへアップロードしたBuild番号とGit上の `version: 1.0.0+N` が一致する。

- [ ] **Step 7: 検証済みブランチをpushし、PRを作成してmainへマージする**

Run:

```bash
git push -u origin codex/unify-calendar-palette
gh pr create \
  --base main \
  --head codex/unify-calendar-palette \
  --title "feat: unify calendar palette" \
  --body "## Summary
- soften calendar shift colors around the app's green and gray theme
- preserve semantic distinction in light and dark mode
- add exact palette and WCAG AA contrast tests

## Verification
- bundle exec fastlane ios verify_release
- iPhone and iPad visual QA in light and dark mode
- signed IPA uploaded and selected in App Store Connect"
gh pr merge --merge --delete-branch
```

Expected: PR checks成功後にmergeされ、GitHubの `main` がApp Store Connectへアップロードした最終Buildのソースと一致する。

---

### Task 4: 実機Sandbox録画を添付してApp Reviewへ提出する

**Files:**
- Produce: `fastlane/review_assets/taxishift-final-sandbox-purchase.mov`
- Read: `fastlane/review_notes.txt`

**Interfaces:**
- Consumes: Task 3で選択済みの最終Build、実機iPhone、Sandbox Apple Account、`remove_ads`、Fastlane提出lane。
- Produces: 完全アップロード済みの実機録画と、App Reviewの審査待ち提出。

- [ ] **Step 1: 最終Buildを実機へ入れ、購入前状態を作る**

TestFlightからTask 3の最終BuildをiPhoneへインストールする。端末内のTaxiShiftを削除してプレミアムのローカル保存を消し、App Store ConnectのSandbox testerで購入履歴をクリアする。アプリ起動後、カレンダーまたはサマリー下部にGoogle公式テストバナーが表示されることを確認する。

Expected: 設定のプレミアム画面で価格と「広告非表示を購入」ボタンが有効で、カレンダーまたはサマリー下部にテスト広告がある。

- [ ] **Step 2: 物理端末でApple指定の全経路を録画する**

実機の画面収録をホーム画面から開始し、次の順序を1本の動画に含める。

```text
1. ホーム画面からTaxiShiftを起動する
2. カレンダーで勤務区分とテスト広告を表示する
3. サマリーなど主要機能を短く表示する
4. 設定 > 広告非表示を開き、App Store価格を表示する
5. 広告非表示を購入し、Sandbox購入完了を表示する
6. カレンダーとサマリーへ戻り、広告と広告用余白が消えたことを表示する
7. 同じ画面に「購入を復元」があることを表示する
```

録画を `fastlane/review_assets/taxishift-final-sandbox-purchase.mov` としてMacへ保存する。

Expected: Debugバナー、個人情報、Sandboxパスワード、通知内容を映さず、購入成功と広告消去を読み取れる。

- [ ] **Step 3: 審査動画をApp Review情報へアップロードする**

Run:

```bash
bundle exec fastlane ios upload_review_video path:fastlane/review_assets/taxishift-final-sandbox-purchase.mov
```

Expected: `審査用動画をアップロードしました` が表示され、添付ファイル状態が `COMPLETE` になる。

- [ ] **Step 4: APIで提出ゲートを通す**

Run:

```bash
ASC_FIRST_IAP_ASSOCIATED=true bundle exec fastlane ios asc_preflight
```

Expected: 最終Buildが `VALID`、`remove_ads`のローカライズ・価格・配信・審査画像が有効、録画が `COMPLETE`、提出条件の問題が0件。

- [ ] **Step 5: アプリと `remove_ads` をApp Reviewへ提出する**

Run:

```bash
ASC_FIRST_IAP_ASSOCIATED=true bundle exec fastlane ios submit_review
```

Expected: `App Reviewへ提出しました` と提出IDが表示され、APIがエラーを返さない。

- [ ] **Step 6: 提出後状態を再取得する**

Run:

```bash
bundle exec fastlane ios asc_status
```

Expected: App Store version 1.0と `remove_ads` を含む提出が審査待ち状態になり、最終Build番号、録画添付、提出IDが確認できる。
