import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../domain/models/shift_pattern.dart';
import '../../../providers/shift_queries_provider.dart';

Future<void> showStartDateChangeDialog(
  BuildContext context,
  WidgetRef ref,
  ShiftPattern pattern,
) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: pattern.validFrom,
    firstDate: DateTime(2020),
    lastDate: DateTime(2030, 12, 31),
    locale: const Locale('ja', 'JP'),
  );

  if (picked == null || !context.mounted) return;

  final dateStr = DateFormat('yyyy/MM/dd', 'ja_JP').format(picked);

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('開始日の変更'),
        content: Text(
          '開始日を $dateStr に変更します。\n過去日付のシフト種別が再計算されます（過去の実績・売上データは保持されます）。\nよろしいですか？',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('キャンセル'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('変更する'),
          ),
        ],
      );
    },
  );

  if (confirmed != true || !context.mounted) return;

  final repo = ref.read(shiftPatternsRepositoryProvider);
  final updated = pattern.copyWith(validFrom: picked);
  await repo.update(updated);

  ref.invalidate(shiftTypeForDateProvider);
  ref.invalidate(shiftsInMonthProvider);
  ref.invalidate(activeShiftPatternProvider);

  if (!context.mounted) return;
  ScaffoldMessenger.of(
    context,
  ).showSnackBar(const SnackBar(content: Text('シフトパターンの開始日を変更しました')));
}
