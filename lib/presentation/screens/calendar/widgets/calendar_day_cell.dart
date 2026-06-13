import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/shift_type.dart';
import '../../../utils/shift_type_display.dart';

class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.date,
    this.shiftType,
    this.isToday = false,
    this.isSelected = false,
    this.isOutsideMonth = false,
  });

  final DateTime date;
  final ShiftType? shiftType;
  final bool isToday;
  final bool isSelected;
  final bool isOutsideMonth;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final bgColor = ShiftTypeDisplay.backgroundColor(shiftType, colorScheme);
    final fgColor = ShiftTypeDisplay.foregroundColor(shiftType, colorScheme);
    final label = ShiftTypeDisplay.shortLabel(shiftType);
    final fullLabel = ShiftTypeDisplay.fullLabel(shiftType);

    Widget cell = Container(
      constraints: const BoxConstraints(minHeight: AppTapTarget.min),
      margin: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: isToday
            ? Border.all(color: colorScheme.primary, width: 2)
            : null,
      ),
      child: Stack(
        children: [
          if (isSelected)
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
              ),
            ),
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: textTheme.bodyMedium?.copyWith(
                      color: fgColor == Colors.transparent ? null : fgColor,
                      fontWeight: isToday ? FontWeight.bold : null,
                    ),
                  ),
                  if (label.isNotEmpty)
                    Text(
                      label,
                      style: textTheme.labelSmall?.copyWith(
                        color: fgColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    if (isOutsideMonth) {
      cell = Opacity(opacity: 0.4, child: cell);
    }

    return Semantics(
      label: '${date.month}月${date.day}日 $fullLabel',
      button: true,
      selected: isSelected,
      child: cell,
    );
  }
}
