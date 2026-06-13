import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/constants/shift_cycle_presets.dart';
import '../../../../domain/models/shift_pattern.dart';
import '../../../../domain/models/work_style.dart';
import '../../../utils/shift_type_display.dart';
import '../widgets/cycle_preview.dart';

class StepSetStartDate extends ConsumerStatefulWidget {
  const StepSetStartDate({
    super.key,
    required this.selectedPreset,
    required this.onBack,
    required this.onCompleted,
  });

  final ShiftCyclePreset selectedPreset;
  final VoidCallback onBack;
  final VoidCallback onCompleted;

  @override
  ConsumerState<StepSetStartDate> createState() => _StepSetStartDateState();
}

class _StepSetStartDateState extends ConsumerState<StepSetStartDate> {
  late DateTime _selectedDate;
  DateTime? _endDate;
  int _cycleOffsetIndex = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _selectedDate,
      firstDate: _selectedDate,
      lastDate: DateTime(2030, 12, 31),
      locale: const Locale('ja', 'JP'),
    );
    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _complete() async {
    if (_endDate != null && _endDate!.isBefore(_selectedDate)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('終了日は開始日以降の日付を指定してください。')));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(shiftPatternsRepositoryProvider);

      // _selectedDate に cycle[_cycleOffsetIndex] が当たるように startDate を逆算する
      final anchorDate = _selectedDate.subtract(
        Duration(days: _cycleOffsetIndex),
      );

      final pattern = ShiftPattern(
        id: 0,
        name: widget.selectedPreset.name,
        workStyle: WorkStyle.alternateDay,
        cycle: widget.selectedPreset.cycle,
        startDate: anchorDate,
        validFrom: anchorDate,
        validUntil: _endDate,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await repo.create(pattern);
      if (mounted) {
        widget.onCompleted();
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

    // _cycleOffsetIndex に応じて、プレビュー用のサイクルを構築（_selectedDate を起点とするため）
    final previewCycle = <dynamic>[];
    final length = widget.selectedPreset.cycle.length;
    for (int i = 0; i < length; i++) {
      previewCycle.add(
        widget.selectedPreset.cycle[(i + _cycleOffsetIndex) % length],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('開始日の設定'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _isLoading ? null : widget.onBack,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '直近の出番日を選択してください。\nこの日からサイクルが開始されます',
                      style: textTheme.bodyLarge,
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Card(
                      child: ListTile(
                        title: const Text('選択日'),
                        subtitle: Text(
                          DateFormat(
                            'yyyy年M月d日 (E)',
                            'ja_JP',
                          ).format(_selectedDate),
                          style: textTheme.titleMedium,
                        ),
                        trailing: const Icon(Icons.calendar_today),
                        onTap: _isLoading ? null : _selectDate,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('選択日のシフト種別', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      children: List.generate(length, (index) {
                        final type = widget.selectedPreset.cycle[index];
                        return ChoiceChip(
                          label: Text(
                            '$index: ${ShiftTypeDisplay.shortLabel(type)}',
                          ),
                          selected: _cycleOffsetIndex == index,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _cycleOffsetIndex = index;
                              });
                            }
                          },
                        );
                      }),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Text('終了日（任意）', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '退職や転属の予定がある場合は設定してください。空欄の場合は無期限になります。',
                      style: textTheme.bodySmall,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Card(
                      child: ListTile(
                        title: const Text('終了日'),
                        subtitle: Text(
                          _endDate != null
                              ? DateFormat(
                                  'yyyy年M月d日 (E)',
                                  'ja_JP',
                                ).format(_endDate!)
                              : '無期限',
                          style: textTheme.titleMedium,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_endDate != null)
                              IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: _isLoading
                                    ? null
                                    : () => setState(() => _endDate = null),
                              ),
                            const Icon(Icons.calendar_today),
                          ],
                        ),
                        onTap: _isLoading ? null : _selectEndDate,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    Text('プレビュー', style: textTheme.titleMedium),
                    const SizedBox(height: AppSpacing.sm),
                    CyclePreview(
                      cycle: previewCycle.cast(),
                      startDate: _selectedDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  size: 16,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    '※ 開始日、終了日、サイクルパターンは後から「設定」画面でいつでも変更できます。',
                    style: textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton(
              onPressed: _isLoading ? null : _complete,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('完了'),
            ),
          ],
        ),
      ),
    );
  }
}
