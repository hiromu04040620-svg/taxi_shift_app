import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../providers/ads_provider.dart';
import '../../widgets/banner_ad_widget.dart';
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
      // 常に月初の1日を保持する
      _focusedMonth = DateTime(focusedDay.year, focusedDay.month);
      // UX向上のため、月送り時に選択日も新しい月の1日にリセットする
      _selectedDate = DateTime(focusedDay.year, focusedDay.month);
    });
  }

  void _resetToToday() {
    setState(() {
      final now = DateTime.now();
      // _focusedMonth は常に月初
      _focusedMonth = DateTime(now.year, now.month);
      _selectedDate = DateTime(now.year, now.month, now.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final headerTitle = DateFormat('yyyy年 M月', 'ja_JP').format(_focusedMonth);

    return Scaffold(
      appBar: AppBar(
        title: Text(headerTitle, style: textTheme.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: _resetToToday,
            tooltip: '今日へ',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              context.push('/settings');
            },
            tooltip: '設定',
          ),
        ],
      ),
      body: Column(
        children: [
          const ShiftLegend(),
          ShiftCalendar(
            focusedMonth: _focusedMonth,
            selectedDate: _selectedDate,
            onDaySelected: _onDaySelected,
            onPageChanged: _onPageChanged,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              child: DayDetailPanel(date: _selectedDate),
            ),
          ),
        ],
      ),
      bottomNavigationBar: ref.watch(adsEnabledProvider)
          ? const BannerAdWidget()
          : null,
    );
  }
}
