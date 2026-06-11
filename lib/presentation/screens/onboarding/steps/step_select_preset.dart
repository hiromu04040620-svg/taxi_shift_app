import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/constants/shift_cycle_presets.dart';
import '../widgets/preset_card.dart';

class StepSelectPreset extends StatefulWidget {
  const StepSelectPreset({
    super.key,
    required this.onSelected,
    required this.onBack,
  });

  final ValueChanged<ShiftCyclePreset> onSelected;
  final VoidCallback onBack;

  @override
  State<StepSelectPreset> createState() => _StepSelectPresetState();
}

class _StepSelectPresetState extends State<StepSelectPreset> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('サイクル選択'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onBack,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text('一般的なサイクルから選択してください', style: textTheme.bodyLarge),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              itemCount: ShiftCyclePresets.all.length,
              itemBuilder: (context, index) {
                final preset = ShiftCyclePresets.all[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.md),
                  child: PresetCard(
                    preset: preset,
                    isSelected: preset.id == _selectedId,
                    onTap: () {
                      setState(() {
                        _selectedId = preset.id;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(const SnackBar(content: Text('準備中')));
                    },
                    child: const Text('カスタム作成'),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: _selectedId == null
                        ? null
                        : () {
                            final preset = ShiftCyclePresets.all.firstWhere(
                              (p) => p.id == _selectedId,
                            );
                            widget.onSelected(preset);
                          },
                    child: const Text('この設定で進む'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
