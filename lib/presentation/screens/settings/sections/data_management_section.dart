import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/providers/app_settings_controller.dart';
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
          titleColor: Colors.red,
          leading: const Icon(Icons.delete_forever, color: Colors.red),
          onTap: () => _showDeleteConfirmDialog(context, ref),
        ),
      ],
    );
  }
}
