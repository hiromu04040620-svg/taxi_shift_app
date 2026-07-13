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

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: ShiftType.values.map((type) {
          final bgColor = ShiftTypeDisplay.backgroundColor(type, colorScheme);
          final fgColor = ShiftTypeDisplay.foregroundColor(type, colorScheme);
          final shortLabel = ShiftTypeDisplay.shortLabel(type);
          final fullLabel = ShiftTypeDisplay.fullLabel(type);

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.md),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Material(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(AppRadius.sm),
                  child: SizedBox.square(
                    dimension: AppIconSize.md,
                    child: Center(
                      child: Text(
                        shortLabel,
                        style: textTheme.labelSmall?.copyWith(
                          color: fgColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(fullLabel, style: textTheme.labelMedium),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
