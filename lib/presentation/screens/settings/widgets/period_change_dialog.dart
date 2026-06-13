import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../domain/models/shift_pattern.dart';
import '../../../providers/shift_queries_provider.dart';

class PeriodChangeDialog extends ConsumerStatefulWidget {
  const PeriodChangeDialog({super.key, required this.pattern});

  final ShiftPattern pattern;

  @override
  ConsumerState<PeriodChangeDialog> createState() => _PeriodChangeDialogState();
}

class _PeriodChangeDialogState extends ConsumerState<PeriodChangeDialog> {
  late DateTime _validFrom;
  DateTime? _validUntil;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _validFrom = widget.pattern.validFrom;
    _validUntil = widget.pattern.validUntil;
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validFrom,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030, 12, 31),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null) {
      setState(() {
        _validFrom = picked;
      });
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _validUntil ?? _validFrom,
      firstDate: _validFrom,
      lastDate: DateTime(2030, 12, 31),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null) {
      setState(() {
        _validUntil = picked;
      });
    }
  }

  Future<void> _save() async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(shiftPatternsRepositoryProvider);
      final updated = widget.pattern.copyWith(
        validFrom: _validFrom,
        startDate: _validFrom, // サイクル起点日も同時に更新する
        validUntil: _validUntil,
      );
      await repo.update(updated);

      ref.invalidate(shiftTypeForDateProvider);
      ref.invalidate(shiftsInMonthProvider);
      ref.invalidate(activeShiftPatternProvider);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy/MM/dd', 'ja_JP');
    return AlertDialog(
      title: const Text('適用期間・開始日の変更'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('サイクルの開始日と終了日を指定します。\n※過去日付のシフト種別も再計算されます。'),
          const SizedBox(height: 16),
          ListTile(
            title: const Text('開始日'),
            subtitle: Text(dateFormat.format(_validFrom)),
            trailing: const Icon(Icons.calendar_today),
            onTap: _pickStartDate,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 8),
          ListTile(
            title: const Text('終了日'),
            subtitle: Text(
              _validUntil != null ? dateFormat.format(_validUntil!) : '無期限',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_validUntil != null)
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => setState(() => _validUntil = null),
                  ),
                const Icon(Icons.calendar_today),
              ],
            ),
            onTap: _pickEndDate,
            shape: RoundedRectangleBorder(
              side: BorderSide(color: Theme.of(context).dividerColor),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(false),
          child: const Text('キャンセル'),
        ),
        FilledButton(
          onPressed: _isLoading ? null : _save,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('変更する'),
        ),
      ],
    );
  }
}
