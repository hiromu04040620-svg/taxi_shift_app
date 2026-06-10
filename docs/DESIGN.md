# デザインリファレンス

本プロジェクトのデザイン判断・実装で参照すべき公式・準公式リソースのリンク集と、各リソースの活用方針をまとめる。
`UI_UX.md` が「本プロジェクトのデザイン規約」、本ファイルは「その根拠となる外部資料」という関係性。

## 採用するデザインシステム

本アプリは **Material Design 3（M3）** を主軸に採用する。
理由:
- Flutter の公式デフォルトであり、ThemeData の M3 サポートが完成している
- Android では完全準拠、iOS でも Cupertino寄りに調整する余地あり
- 個人開発で独自デザインシステムを作るコストが高い

iOS では一部 Cupertino スタイル（数値ピッカー、Cupertino風スイッチ等）を取り入れて違和感を減らす。

## 公式リファレンス

### Material Design 3（最優先）

| リソース | URL | 用途 |
|---|---|---|
| M3 公式サイト | https://m3.material.io/ | 全コンポーネント・原則の正典 |
| Color システム | https://m3.material.io/styles/color/overview | カラーロール（primary, secondary, tertiary 等）の理解 |
| Material Theme Builder | https://material-foundation.github.io/material-theme-builder/ | シードカラーからテーマ自動生成（**実作業で使用**） |
| Material 3 Design Kit (Figma) | https://www.figma.com/community/file/1035203688168086460/material-3-design-kit | Figmaでのモック作成用 |
| Flutter での Material 適用 | https://docs.flutter.dev/ui/design/material | Flutter固有の実装ガイド |

### Apple Human Interface Guidelines

| リソース | URL | 用途 |
|---|---|---|
| HIG トップ | https://developer.apple.com/design/human-interface-guidelines | iOS固有の挙動確認 |
| Apple Design 全般 | https://developer.apple.com/design/ | デザインリソース |

**本プロジェクトでの使い分け方針**:
- レイアウト・コンポーネント: M3 を採用
- ジェスチャー・触感: iOS では HIG に寄せる（スワイプバック、ハプティクスの強度等）
- セーフエリア・ノッチ対応: HIG に準拠
- フォント: iOS では San Francisco、Android では Roboto をシステム標準として使う

## カラー設計

### シードカラー

本プロジェクトの **シードカラー（Source Color）**: `#1E3A8A`（落ち着いた紺）

タクシー業界らしさ（夜の街、信頼感）と、長時間表示する画面で目が疲れない落ち着きを両立。

### 生成手順

1. Material Theme Builder にアクセス
2. Source Color に `#1E3A8A` を入力
3. Secondary に `#F59E0B`（タクシーイエロー）を Custom Color として追加
4. Light/Dark 両方のスキームを生成
5. 「Export」→ Flutter（Dart）形式でダウンロード
6. `lib/core/theme/color_schemes.dart` として配置

### M3 カラーロール早見表

| ロール | 用途 |
|---|---|
| primary | 主要なアクション、FAB、選択状態 |
| onPrimary | primary 上の文字色 |
| primaryContainer | primary の薄いバリエーション、チップ等 |
| secondary | 補助的なアクセント |
| tertiary | 第3アクセント。本プロジェクトでは「警告未満の注意」に使用 |
| error | エラー、削除 |
| surface | カードや背景 |
| surfaceContainerHighest | 一段強調された背景 |
| outline | ボーダー線 |

## デザインインスピレーション

実装の参考になる UI 集。**そのままパクらず、要素として参照する**。

### カレンダーUI

| リソース | URL | 用途 |
|---|---|---|
| Dribbble - flutter calendar | https://dribbble.com/search/flutter-calendar | カレンダー画面のビジュアル参考 |
| Dribbble - calendar flutter | https://dribbble.com/search/calendar-flutter | 同上 |
| Flutter Gems - Calendar | https://fluttergems.dev/calendar/ | 採用候補ライブラリの比較 |

採用ライブラリは `ARCHITECTURE.md` 通り `table_calendar`。

### モバイルアプリ全般

| リソース | URL | 用途 |
|---|---|---|
| Figma Community - Mobile App Kit (Japanese) | https://www.figma.com/community/file/1519432775641021373/mobile-app-kit-by-figma-japanese | 日本語UI例 |
| Figma Community - Mobile Apps | https://www.figma.com/community/mobile-apps | 全般 |

## アイコン

| リソース | URL | 用途 |
|---|---|---|
| Material Symbols | https://fonts.google.com/icons | M3 公式アイコン。Flutter の `Icons` クラスで利用可 |
| Lucide | https://lucide.dev/ | 必要に応じて補完。`lucide_icons` パッケージあり |

**指針**: 標準で十分。独自SVGは「シフト種別アイコン」程度に留める。

## タイポグラフィ

### システムフォントを使う

- iOS: SF Pro（システム）
- Android: Roboto（システム）
- 日本語: ヒラギノ角ゴ（iOS）/ Noto Sans CJK JP（Android）

Flutter ではフォント指定なしで自動的にシステムフォントが使われる。**カスタムフォントは追加しない**（アプリサイズ削減）。

### M3 タイプスケール

| ロール | サイズ | 用途 |
|---|---|---|
| displayLarge | 57sp | 大型見出し（基本使わない） |
| displayMedium | 45sp | 同上 |
| displaySmall | 36sp | サマリーの主要数値（営収額など） |
| headlineLarge | 32sp | ページタイトル級 |
| headlineMedium | 28sp | セクション見出し |
| headlineSmall | 24sp | サブ見出し |
| titleLarge | 22sp | カードタイトル |
| titleMedium | 16sp | リスト項目タイトル |
| titleSmall | 14sp | 補助タイトル |
| bodyLarge | 16sp | 本文 |
| bodyMedium | 14sp | 補足本文 |
| bodySmall | 12sp | キャプション |
| labelLarge | 14sp | ボタンラベル |
| labelMedium | 12sp | チップ |
| labelSmall | 11sp | 最小ラベル |

`ThemeData` の textTheme でM3デフォルトを使い、必要箇所のみカスタマイズ。

## ジェスチャー・モーション

### Material Motion

| リソース | URL |
|---|---|
| Material Motion | https://m3.material.io/styles/motion/overview |

採用する基本トランジション:
- **Shared axis**: ボトムナビゲーション間（横方向）
- **Container transform**: カレンダー日付タップ→詳細画面
- **Fade through**: モーダル表示

実装は `animations` パッケージ（公式）を使う。

### ハプティクス

| プラットフォーム | パッケージ | 用途 |
|---|---|---|
| 両OS | `flutter` 標準の `HapticFeedback` | 軽い通知 |
| 必要なら | `flutter_haptic_feedback` | 細かい制御 |

保存時に `HapticFeedback.lightImpact()`、エラー時に `HapticFeedback.heavyImpact()`。

## アクセシビリティ

| リソース | URL |
|---|---|
| M3 Accessibility | https://m3.material.io/foundations/accessible-design/overview |
| Apple Accessibility | https://developer.apple.com/accessibility/ |
| WCAG 2.2 | https://www.w3.org/TR/WCAG22/ |

**遵守項目**:
- コントラスト比 4.5:1 以上（通常テキスト）、3:1 以上（大型テキスト・UI要素）
- タップターゲット 最小 48dp（M3）/ 44pt（HIG）
- Semantics ラベル付与
- 動的フォントサイズ対応
- VoiceOver / TalkBack で全機能操作可能

## ローカル参照リポジトリ

プロジェクト内の `references/` 配下に固定スナップショットとして配置される（プロンプト3で実行）。
オフラインでも参照可能。エージェントもファイルパスでアクセスできる。

| パス | 用途 | 元リポジトリ |
|---|---|---|
| `references/material-tokens/` | デザイントークン定義 | https://github.com/material-foundation/material-tokens |
| `references/material-color-utilities/` | M3 カラー生成ロジック | https://github.com/material-foundation/material-color-utilities |
| `references/flutter_material_3_demo/` | M3 コンポーネント実装例 | https://github.com/chayanforyou/flutter_material_3_demo |
| `references/flutter-samples/` | Flutter 公式サンプル | https://github.com/flutter/samples |

### 主な参照場面

- **カラー実装**: `material-color-utilities/` の README とソースを参照し、シードカラーから ColorScheme を構築するロジックを理解する
- **トークン値の取得**: `material-tokens/` の JSON から、サイズ・スペーシング・コーナー半径の正規値を取得
- **コンポーネント実装例**: `flutter_material_3_demo/lib/` 配下で、各 M3 コンポーネント（NavigationBar、SegmentedButton 等）の使い方を確認

## デザイントークンの実装ガイド

Material Theme Builder で生成した `color_schemes.dart` を取り込み、以下の構造で `ThemeData` を構築する。

```dart
// lib/core/theme/app_theme.dart
class AppTheme {
  static ThemeData light(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: _textTheme,
    // ...
  );

  static ThemeData dark(ColorScheme scheme) => ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    textTheme: _textTheme,
    // ...
  );
}
```

シフト種別カラーは `ColorScheme` に乗らない独自値なので、別途 `ShiftColors` クラスで extension として定義:

```dart
// lib/core/theme/shift_colors.dart
extension ShiftColors on ColorScheme {
  Color get workDayBg => ...;
  Color get workDayFg => ...;
  // ... 各シフト種別
}
```

Light/Dark で異なる値を返すよう brightness を見て切り替え。

## 学習リソース

| リソース | URL | 用途 |
|---|---|---|
| Flutter Material 3 from design to deployment | https://www.youtube.com/watch?v=7nrhTdS7dHg | M3対応の実装パターン |
| Material Design YouTube | https://www.youtube.com/@MaterialDesign | 公式チュートリアル |
| Flutter 公式デザインドキュメント | https://docs.flutter.dev/ui/design | Flutter のデザイン全般 |

## やらないこと

- 独自デザインシステム構築（個人開発の範囲を超える）
- スキューモーフィズム・ニューモーフィズム（M3とコンフリクト）
- カスタムフォント導入（アプリサイズ増加、ライセンス管理コスト）
- ダークモード未対応（M3 ではデフォルト対応）
- 過剰なアニメーション（動作の重さ・電池消費の懸念）

## デザインレビューチェックリスト

実装後の自己レビュー用:

- [ ] M3 のカラーロールに沿って色を使っているか（直接色指定していないか）
- [ ] タップターゲットが最小サイズを満たすか
- [ ] ダークモードでも視認性が確保されているか
- [ ] 日本語のフォントレンダリングが崩れていないか
- [ ] セーフエリアを考慮しているか
- [ ] ローディング・空状態・エラー状態が定義されているか
- [ ] Semantics ラベルが付与されているか
- [ ] 動的フォントサイズで崩れないか
