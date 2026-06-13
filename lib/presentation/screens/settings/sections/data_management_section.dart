import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/providers/app_settings_controller.dart';
import '../../../providers/improvement_warnings_provider.dart';
import '../../../providers/revenue_queries_provider.dart';
import '../../../providers/shift_queries_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class DataManagementSection extends ConsumerWidget {
  const DataManagementSection({super.key});

  Future<void> _showDeleteConfirmDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('すべてのデータを削除しますか？'),
          content: const Text(
            '勤務記録・売上記録・シフト例外がすべて削除されます。\n'
            'シフトパターンとアプリ設定は保持されます。\n'
            'この操作は元に戻せません。',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('キャンセル'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('次へ'),
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
            title: const Text('本当に削除しますか？'),
            content: const Text('削除を実行すると元に戻せません。'),
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

      if (secondConfirm == true && context.mounted) {
        try {
          await ref
              .read(appSettingsControllerProvider.notifier)
              .deleteAllUserData();

          // Invalidating cached data to refresh UI
          ref.invalidate(workSessionForDateProvider);
          ref.invalidate(workSessionsInMonthProvider);
          ref.invalidate(revenueForDateProvider);
          ref.invalidate(revenuesInMonthProvider);
          ref.invalidate(monthlySummaryProvider);
          ref.invalidate(shiftTypeForDateProvider);
          ref.invalidate(shiftsInMonthProvider);
          ref.invalidate(monthlyWarningsProvider);
          ref.invalidate(sessionWarningsProvider);

          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('すべての勤務・売上・シフト例外を削除しました')),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('削除に失敗しました: $e')));
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'データ管理'),
        SettingTile(
          title: 'データのエクスポート',
          subtitle: 'CSV形式で出力します',
          leading: const Icon(Icons.download),
          onTap: () {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('MVP版ではサポートされていません')));
          },
        ),
        SettingTile(
          title: 'すべてのデータを削除',
          titleColor: Theme.of(context).colorScheme.error,
          leading: Icon(
            Icons.delete_forever,
            color: Theme.of(context).colorScheme.error,
          ),
          onTap: () => _showDeleteConfirmDialog(context, ref),
        ),
      ],
    );
  }
}
