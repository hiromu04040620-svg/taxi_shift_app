import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../application/providers/theme_provider.dart';
import 'widgets/day_detail_panel.dart';
import 'widgets/shift_calendar.dart';
import 'widgets/shift_legend.dart';

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _onDaySelected(DateTime selectedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  }

  void _onPageChanged(DateTime focusedDay) {
    setState(() {
      _focusedMonth = focusedDay;
    });
  }

  void _resetToToday() {
    setState(() {
      final now = DateTime.now();
      _focusedMonth = DateTime(now.year, now.month);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeControllerProvider);
    final isDark =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            MediaQuery.platformBrightnessOf(context) == Brightness.dark);
    final textTheme = Theme.of(context).textTheme;

    final headerTitle = DateFormat('yyyy年 M月', 'ja_JP').format(_focusedMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(headerTitle, style: textTheme.titleLarge),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              ref
                  .read(themeModeControllerProvider.notifier)
                  .setMode(isDark ? ThemeMode.light : ThemeMode.dark);
            },
            tooltip: 'テーマ切替',
          ),
        ],
      ),
      body: Column(
        children: [
          const ShiftLegend(),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.45,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ShiftCalendar(
                focusedMonth: _focusedMonth,
                selectedDate: _selectedDate,
                onDaySelected: _onDaySelected,
                onPageChanged: _onPageChanged,
              ),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: DayDetailPanel(date: _selectedDate),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _resetToToday,
        tooltip: '今日へ',
        child: const Icon(Icons.today),
      ),
    );
  }
}
