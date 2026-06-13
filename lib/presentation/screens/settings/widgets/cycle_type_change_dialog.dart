import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../application/providers/repositories_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/constants/shift_cycle_presets.dart';
import '../../../../domain/models/shift_pattern.dart';
import '../../../providers/shift_queries_provider.dart';
import '../../onboarding/widgets/preset_card.dart';

class CycleTypeChangeDialog extends ConsumerStatefulWidget {
  const CycleTypeChangeDialog({super.key, required this.pattern});

  final ShiftPattern pattern;

  @override
  ConsumerState<CycleTypeChangeDialog> createState() =>
      _CycleTypeChangeDialogState();
}

class _CycleTypeChangeDialogState extends ConsumerState<CycleTypeChangeDialog> {
  late ShiftCyclePreset _selectedPreset;

  @override
  void initState() {
    super.initState();
    _selectedPreset = ShiftCyclePresets.all.firstWhere(
      (p) => p.name == widget.pattern.name,
      orElse: () => ShiftCyclePresets.all.first,
    );
  }

  Future<void> _confirmAndSave() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('サイクル種別の変更'),
          content: Text(
            'サイクル種別を『${_selectedPreset.name}』に変更します。\n開始日は現在の設定のまま、シフト種別が再計算されます。\nよろしいですか？',
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

    if (confirmed != true || !mounted) return;

    final repo = ref.read(shiftPatternsRepositoryProvider);
    final updated = widget.pattern.copyWith(
      name: _selectedPreset.name,
      cycle: _selectedPreset.cycle,
    );
    await repo.update(updated);

    ref.invalidate(shiftTypeForDateProvider);
    ref.invalidate(shiftsInMonthProvider);
    ref.invalidate(activeShiftPatternProvider);

    if (!mounted) return;
    Navigator.of(context).pop();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('サイクル種別を変更しました')));
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('サイクル種別を選択', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.md),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: ShiftCyclePresets.all.map((preset) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: PresetCard(
                        preset: preset,
                        isSelected: _selectedPreset.id == preset.id,
                        onTap: () {
                          setState(() {
                            _selectedPreset = preset;
                          });
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('キャンセル'),
                ),
                const SizedBox(width: AppSpacing.sm),
                FilledButton(
                  onPressed: _confirmAndSave,
                  child: const Text('次へ'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
