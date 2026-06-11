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

  Future<void> _complete() async {
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
            Text(
              '直近の出番日を選択してください。\nこの日からサイクルが開始されます',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.lg),
            Card(
              child: ListTile(
                title: const Text('選択日'),
                subtitle: Text(
                  DateFormat('yyyy年M月d日 (E)', 'ja_JP').format(_selectedDate),
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
                  label: Text('$index: ${ShiftTypeDisplay.shortLabel(type)}'),
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
            const SizedBox(height: AppSpacing.lg),
            Text('プレビュー', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            CyclePreview(cycle: previewCycle.cast(), startDate: _selectedDate),
            const Spacer(),
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
