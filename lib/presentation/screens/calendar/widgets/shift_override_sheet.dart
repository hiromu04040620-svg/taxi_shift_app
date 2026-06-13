import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/shift_override.dart';
import '../../../../domain/models/shift_type.dart';
import '../../../providers/shift_queries_provider.dart';
import '../../../utils/shift_type_display.dart';
import 'shift_change_confirm_dialog.dart';

class ShiftOverrideSheet extends ConsumerStatefulWidget {
  const ShiftOverrideSheet({super.key, required this.date});

  final DateTime date;

  @override
  ConsumerState<ShiftOverrideSheet> createState() => _ShiftOverrideSheetState();
}

class _ShiftOverrideSheetState extends ConsumerState<ShiftOverrideSheet> {
  ShiftType? _selectedType;
  late TextEditingController _noteController;
  bool _isLoading = false;
  ShiftOverride? _existingOverride;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController();
    _loadExisting();
  }

  Future<void> _loadExisting() async {
    final repo = ref.read(shiftOverridesRepositoryProvider);
    final existing = await repo.getByDate(widget.date);
    if (mounted && existing != null) {
      setState(() {
        _existingOverride = existing;
        _selectedType = existing.shiftType;
        _noteController.text = existing.reason ?? '';
      });
    } else {
      final shiftTypeAsync = ref.read(shiftTypeForDateProvider(widget.date));
      if (mounted) {
        setState(() {
          _selectedType = shiftTypeAsync.value;
        });
      }
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_selectedType == null) return;

    final action = await showDialog<ShiftChangeAction>(
      context: context,
      builder: (context) => ShiftChangeConfirmDialog(
        date: widget.date,
        selectedType: _selectedType!,
      ),
    );

    if (action == null || action == ShiftChangeAction.cancel) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final overridesRepo = ref.read(shiftOverridesRepositoryProvider);
      final patternsRepo = ref.read(shiftPatternsRepositoryProvider);

      if (action == ShiftChangeAction.override) {
        if (_existingOverride != null) {
          final updated = _existingOverride!.copyWith(
            shiftType: _selectedType!,
            reason: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
          );
          await overridesRepo.upsertSingle(updated);
        } else {
          final newOverride = ShiftOverride(
            id: 0,
            date: widget.date,
            shiftType: _selectedType!,
            reason: _noteController.text.trim().isEmpty
                ? null
                : _noteController.text.trim(),
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          await overridesRepo.upsertSingle(newOverride);
        }
      } else if (action == ShiftChangeAction.cycle) {
        final activePattern = await patternsRepo.getActiveAt(widget.date);
        if (activePattern != null) {
          final cycleIndex = activePattern.cycle.indexOf(_selectedType!);
          if (cycleIndex == -1) {
            throw ArgumentError('選択したシフト種類は現在のサイクルに含まれていません。');
          }

          final newStartDate = widget.date.subtract(Duration(days: cycleIndex));
          final updatedPattern = activePattern.copyWith(
            startDate: newStartDate,
          );
          await patternsRepo.update(updatedPattern);

          final existing = await overridesRepo.getByDate(widget.date);
          if (existing != null) {
            await overridesRepo.deleteSingle(existing.id);
          }
        } else {
          throw StateError('有効なシフトパターンが見つかりません。');
        }
      }

      ref.invalidate(shiftTypeForDateProvider(widget.date));
      ref.invalidate(shiftsInMonthProvider);
      ref.invalidate(activeShiftPatternProvider);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('シフトを変更しました')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _reset() async {
    if (_existingOverride == null) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(shiftOverridesRepositoryProvider);
      await repo.deleteSingle(_existingOverride!.id);

      ref.invalidate(shiftTypeForDateProvider(widget.date));
      ref.invalidate(shiftsInMonthProvider);

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('エラーが発生しました: $e')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final dateLabel = DateFormat('M月d日のシフト変更', 'ja_JP').format(widget.date);

    final shiftTypeAsync = ref.watch(shiftTypeForDateProvider(widget.date));
    final patternType = shiftTypeAsync.value;

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.viewInsetsOf(context).bottom,
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(AppRadius.full),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            dateLabel,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          if (patternType != null && _existingOverride == null) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              '元のシフト: ${ShiftTypeDisplay.fullLabel(patternType)}',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          Text('シフト種別', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.sm,
            children: ShiftType.values.map((type) {
              return ChoiceChip(
                label: Text(ShiftTypeDisplay.shortLabel(type)),
                selected: _selectedType == type,
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedType = type;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.md),
          Text('メモ', style: textTheme.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _noteController,
            maxLines: 2,
            decoration: const InputDecoration(
              hintText: '変更理由などを入力',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Row(
            children: [
              if (_existingOverride != null)
                OutlinedButton(
                  onPressed: _isLoading ? null : _reset,
                  child: const Text('リセット'),
                ),
              const Spacer(),
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text('キャンセル'),
              ),
              const SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: _isLoading || _selectedType == null ? null : _save,
                child: _isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('保存'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
