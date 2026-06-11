import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../application/providers/app_settings_controller.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../providers/app_settings_queries_provider.dart';
import 'widgets/number_input_dialog.dart';
import 'widgets/percentage_input_dialog.dart';
import 'widgets/setting_tile.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('全データ削除'),
          content: const Text(
            'これまでに入力したすべての勤務実績、売上、シフト例外データが削除されます。\n'
            '※アプリ設定とシフトパターンは保持されます。\n\n'
            '本当によろしいですか？（この操作は元に戻せません）',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('削除する'),
            ),
          ],
        );
      },
    );

    if (confirmed == true && context.mounted) {
      final secondConfirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('最終確認'),
            content: const Text('本当にすべてのデータを削除しますか？'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('キャンセル'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
                child: const Text('完全に削除'),
              ),
            ],
          );
        },
      );

      if (secondConfirm == true && context.mounted) {
        try {
          await ref
              .read(appSettingsControllerProvider.notifier)
              .deleteAllUserData();
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('すべてのデータを削除しました')));
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('削除中にエラーが発生しました: $e')));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsAsync = ref.watch(appSettingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: appSettingsAsync.when(
        data: (settings) {
          final actions = ref.read(appSettingsControllerProvider.notifier);

          return ListView(
            children: [
              _buildSectionHeader(context, '外観'),
              SettingTile(
                title: 'テーマ',
                subtitle: _themeModeString(settings.themeMode),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: AppIconSize.sm,
                ),
                onTap: () async {
                  final result = await showDialog<ThemeMode>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text('テーマを選択'),
                      children: [
                        SimpleDialogOption(
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.system),
                          child: const Text('端末の設定に従う'),
                        ),
                        SimpleDialogOption(
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.light),
                          child: const Text('ライト'),
                        ),
                        SimpleDialogOption(
                          onPressed: () =>
                              Navigator.pop(context, ThemeMode.dark),
                          child: const Text('ダーク'),
                        ),
                      ],
                    ),
                  );
                  if (result != null) {
                    await actions.updateThemeMode(result);
                  }
                },
              ),

              const Divider(),
              _buildSectionHeader(context, '勤務'),
              SwitchListTile(
                title: const Text('改善基準告示の警告'),
                subtitle: const Text('拘束時間や休息期間の違反をチェックします'),
                value: settings.improvementStandardEnabled,
                onChanged: (val) {
                  actions.updateImprovementStandardEnabled(val);
                },
              ),
              SettingTile(
                title: '月締め日',
                subtitle: '${settings.monthlyClosingDay}日',
                trailing: const Icon(Icons.edit, size: AppIconSize.sm),
                onTap: () {
                  showNumberInputDialog(
                    context: context,
                    title: '月締め日',
                    initialValue: settings.monthlyClosingDay,
                    suffixText: '日',
                    validator: (val) {
                      if (val >= 1 && val <= 31) {
                        return null;
                      }
                      return '1から31の間で入力してください';
                    },
                    onSaved: (val) {
                      actions.updateMonthlyClosingDay(val);
                    },
                  );
                },
              ),
              SettingTile(
                title: '月最大出番数',
                subtitle: '${settings.maxMonthlyShifts}出番',
                trailing: const Icon(Icons.edit, size: AppIconSize.sm),
                onTap: () {
                  showNumberInputDialog(
                    context: context,
                    title: '月最大出番数',
                    initialValue: settings.maxMonthlyShifts,
                    suffixText: '出番',
                    onSaved: (val) => actions.updateMaxMonthlyShifts(val),
                  );
                },
              ),
              SettingTile(
                title: '月最大拘束時間',
                subtitle: '${settings.maxMonthlyRestraintHours}時間',
                trailing: const Icon(Icons.edit, size: AppIconSize.sm),
                onTap: () {
                  showNumberInputDialog(
                    context: context,
                    title: '月最大拘束時間',
                    initialValue: settings.maxMonthlyRestraintHours,
                    suffixText: '時間',
                    onSaved: (val) =>
                        actions.updateMaxMonthlyRestraintHours(val),
                  );
                },
              ),

              const Divider(),
              _buildSectionHeader(context, '売上'),
              SettingTile(
                title: '足切り額（税抜）',
                subtitle: '${settings.ashikiriAmount}円',
                trailing: const Icon(Icons.edit, size: AppIconSize.sm),
                onTap: () {
                  showNumberInputDialog(
                    context: context,
                    title: '足切り額（税抜）',
                    initialValue: settings.ashikiriAmount,
                    suffixText: '円',
                    onSaved: (val) => actions.updateAshikiriAmount(val),
                  );
                },
              ),
              SettingTile(
                title: '歩合率',
                subtitle: '${(settings.commissionRate * 100).toInt()}%',
                trailing: const Icon(Icons.edit, size: AppIconSize.sm),
                onTap: () {
                  showPercentageInputDialog(
                    context: context,
                    title: '歩合率',
                    initialRate: settings.commissionRate,
                    onSaved: (val) => actions.updateCommissionRate(val),
                  );
                },
              ),

              const Divider(),
              _buildSectionHeader(context, 'シフトパターン'),
              SettingTile(
                title: 'シフトパターンを編集',
                subtitle: '基本の勤務サイクルを変更します',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: AppIconSize.sm,
                ),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('今後のアップデートで利用可能になります')),
                  );
                },
              ),

              const Divider(),
              _buildSectionHeader(context, 'データ管理'),
              SettingTile(
                title: 'データのエクスポート',
                subtitle: 'CSV形式で出力します',
                leading: const Icon(Icons.download),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('MVP版ではサポートされていません')),
                  );
                },
              ),
              SettingTile(
                title: 'すべてのデータを削除',
                titleColor: Colors.red,
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                onTap: () => _showDeleteConfirmDialog(context, ref),
              ),

              const Divider(),
              _buildSectionHeader(context, 'アプリ情報'),
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) {
                  final version = snapshot.data?.version ?? '';
                  final buildNumber = snapshot.data?.buildNumber ?? '';
                  final versionStr = version.isNotEmpty
                      ? 'v$version ($buildNumber)'
                      : '取得中...';

                  return SettingTile(title: 'バージョン', subtitle: versionStr);
                },
              ),
              SettingTile(
                title: 'ライセンス',
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: AppIconSize.sm,
                ),
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'TaxiShift',
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  'This application is entirely authored by Antigravity and the user.',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _themeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
      case ThemeMode.system:
        return '端末の設定に従う';
    }
  }
}
