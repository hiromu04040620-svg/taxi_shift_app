import 'package:flutter/material.dart';

import '../../../../domain/models/shift_type.dart';
import '../../calendar/widgets/calendar_day_cell.dart';

class CyclePreview extends StatelessWidget {
  const CyclePreview({
    super.key,
    required this.cycle,
    required this.startDate,
    this.previewDays = 14,
  });

  final List<ShiftType> cycle;
  final DateTime startDate;
  final int previewDays;

  @override
  Widget build(BuildContext context) {
    if (cycle.isEmpty) return const SizedBox.shrink();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(previewDays, (index) {
          final targetDate = startDate.add(Duration(days: index));
          final shiftType = cycle[index % cycle.length];

          return SizedBox(
            width: 48,
            height: 64,
            child: CalendarDayCell(date: targetDate, shiftType: shiftType),
          );
        }),
      ),
    );
  }
}
