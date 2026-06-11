import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/constants/shift_cycle_presets.dart';
import 'cycle_preview.dart';

class PresetCard extends StatelessWidget {
  const PresetCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final ShiftCyclePreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      color: isSelected ? colorScheme.primaryContainer : null,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                preset.name,
                style: textTheme.titleMedium?.copyWith(
                  color: isSelected ? colorScheme.onPrimaryContainer : null,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                preset.description,
                style: textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? colorScheme.onPrimaryContainer
                      : colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              CyclePreview(
                cycle: preset.cycle,
                startDate: DateTime.now(),
                previewDays: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
