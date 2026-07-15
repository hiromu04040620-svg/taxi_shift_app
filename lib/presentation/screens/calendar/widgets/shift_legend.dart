import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/shift_type.dart';
import '../../../utils/shift_type_display.dart';

class ShiftLegend extends StatelessWidget {
  const ShiftLegend({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: ShiftType.values.map((type) {
          final bgColor = ShiftTypeDisplay.backgroundColor(type, colorScheme);
          final fgColor = ShiftTypeDisplay.foregroundColor(type, colorScheme);
          final fullLabel = ShiftTypeDisplay.fullLabel(type);

          return Material(
            color: bgColor,
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
                vertical: AppSpacing.xs,
              ),
              child: Text(
                fullLabel,
                style: textTheme.labelMedium?.copyWith(
                  color: fgColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
