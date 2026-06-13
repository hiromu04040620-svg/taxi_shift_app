import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/shift_type.dart';
import '../../../utils/shift_type_display.dart';

enum ShiftChangeAction { override, cycle, cancel }

class ShiftChangeConfirmDialog extends StatelessWidget {
  const ShiftChangeConfirmDialog({
    super.key,
    required this.date,
    required this.selectedType,
  });

  final DateTime date;
  final ShiftType selectedType;

  Future<bool> _showSecondConfirm(BuildContext context) async {
    final dateStr = DateFormat('M月d日', 'ja_JP').format(date);
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('サイクルを変更しますか？'),
        content: Text(
          '$dateStrを新しい起点として、サイクルが再計算されます。\n過去の$dateStr以前のシフト表示も変わる可能性があります。\n個別に変更した日（例外日）は維持されます。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('サイクルを変更'),
          ),
        ],
      ),
    );
    return result == true;
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = DateFormat('M月d日', 'ja_JP').format(date);
    final shiftName = ShiftTypeDisplay.fullLabel(selectedType);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('シフトを変更'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('$dateStrのシフトを「$shiftName」に変更します。\n変更方法を選んでください。'),
          const SizedBox(height: AppSpacing.lg),
          FilledButton(
            onPressed: () => Navigator.pop(context, ShiftChangeAction.override),
            child: const Text('この日だけ変更'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '突発的な休みや代休に',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          FilledButton.tonal(
            onPressed: () async {
              final confirmed = await _showSecondConfirm(context);
              if (confirmed && context.mounted) {
                Navigator.pop(context, ShiftChangeAction.cycle);
              }
            },
            child: const Text('ここからサイクル変更'),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'シフトがずれた場合や恒久的な変更に',
            style: textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, ShiftChangeAction.cancel),
          child: const Text('キャンセル'),
        ),
      ],
    );
  }
}
