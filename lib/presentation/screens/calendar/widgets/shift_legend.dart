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
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: Chip(
              backgroundColor: bgColor,
              side: BorderSide.none,
              labelPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xs,
              ),
              avatar: CircleAvatar(
                backgroundColor: fgColor.withValues(alpha: 0.2),
                child: Text(
                  shortLabel,
                  style: textTheme.labelSmall?.copyWith(
                    color: fgColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              label: Text(
                fullLabel,
                style: textTheme.labelMedium?.copyWith(color: fgColor),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
