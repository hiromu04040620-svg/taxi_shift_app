import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../providers/shift_queries_provider.dart';
import 'calendar_day_cell.dart';

class ShiftCalendar extends ConsumerWidget {
  const ShiftCalendar({
    super.key,
    required this.focusedMonth,
    required this.selectedDate,
    required this.onDaySelected,
    required this.onPageChanged,
  });

  final DateTime focusedMonth;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDaySelected;
  final ValueChanged<DateTime> onPageChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final now = DateTime.now();
    final firstDay = DateTime(focusedMonth.year - 2, focusedMonth.month);
    final lastDay = DateTime(focusedMonth.year + 2, focusedMonth.month, 0);

    final monthArg = (year: focusedMonth.year, month: focusedMonth.month);
    final shiftsAsync = ref.watch(shiftsInMonthProvider(monthArg));

    return Stack(
      children: [
        TableCalendar(
          locale: 'ja_JP',
          firstDay: firstDay,
          lastDay: lastDay,
          focusedDay: focusedMonth,
          headerVisible: false,
          daysOfWeekHeight: AppSpacing.lg + AppSpacing.xs,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle:
                Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
            weekendStyle:
                Theme.of(context).textTheme.bodySmall ?? const TextStyle(),
          ),
          rowHeight: AppTapTarget.min + AppSpacing.sm,
          selectedDayPredicate: (day) => isSameDay(selectedDate, day),
          onDaySelected: (selectedDay, focusedDay) {
            onDaySelected(selectedDay);
          },
          onPageChanged: onPageChanged,
          calendarBuilders: CalendarBuilders<dynamic>(
            dowBuilder: (context, day) {
              final text = DateFormat.E('ja_JP').format(day);
              Color? color;
              if (day.weekday == DateTime.sunday) {
                color = Theme.of(context).colorScheme.error;
              } else if (day.weekday == DateTime.saturday) {
                color = Theme.of(context).colorScheme.primary;
              } else {
                color = Theme.of(context).colorScheme.onSurface;
              }
              return Center(
                child: Text(
                  text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: color),
                ),
              );
            },
            defaultBuilder: (context, day, focusedDay) {
              return CalendarDayCell(
                date: day,
                shiftType:
                    shiftsAsync.value?[DateTime(day.year, day.month, day.day)],
                isOutsideMonth: day.month != focusedDay.month,
              );
            },
            todayBuilder: (context, day, focusedDay) {
              return CalendarDayCell(
                date: day,
                shiftType:
                    shiftsAsync.value?[DateTime(day.year, day.month, day.day)],
                isToday: true,
                isOutsideMonth: day.month != focusedDay.month,
              );
            },
            selectedBuilder: (context, day, focusedDay) {
              return CalendarDayCell(
                date: day,
                shiftType:
                    shiftsAsync.value?[DateTime(day.year, day.month, day.day)],
                isSelected: true,
                isToday: isSameDay(day, now),
                isOutsideMonth: day.month != focusedDay.month,
              );
            },
            outsideBuilder: (context, day, focusedDay) {
              return CalendarDayCell(
                date: day,
                shiftType:
                    shiftsAsync.value?[DateTime(day.year, day.month, day.day)],
                isOutsideMonth: true,
              );
            },
          ),
        ),
        if (shiftsAsync.isLoading)
          Positioned.fill(
            child: ColoredBox(
              color: Theme.of(
                context,
              ).colorScheme.surface.withValues(alpha: 0.5),
              child: const Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
