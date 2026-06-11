import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../providers/selected_month_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../widgets/kpi_card.dart';

class WorkTab extends ConsumerWidget {
  const WorkTab({super.key});

  String _formatMinutes(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (minutes == 0) return '$hours時間';
    return '$hours時間$minutes分';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthArg = ref.watch(selectedMonthProvider);
    final sessionsAsync = ref.watch(workSessionsInMonthProvider(monthArg));

    return sessionsAsync.when(
      data: (sessions) {
        if (sessions.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.work_history,
                  size: AppIconSize.xl,
                  color: Colors.grey,
                ),
                SizedBox(height: AppSpacing.md),
                Text('まだ勤務記録がありません'),
              ],
            ),
          );
        }

        int totalRestraint = 0;
        int totalWorking = 0;
        for (final s in sessions) {
          totalRestraint += s.totalDurationMinutes;
          totalWorking += s.workingMinutes;
        }

        final avgRestraint = totalRestraint ~/ sessions.length;

        final sortedSessions = List.of(sessions)
          ..sort((a, b) => a.shiftDate.compareTo(b.shiftDate));

        final restraintSpots = <FlSpot>[];
        final cumulativeWorkingSpots = <FlSpot>[];
        double currentCumulativeWorking = 0;

        for (final s in sortedSessions) {
          final x = s.shiftDate.day.toDouble();
          final restraintHours = s.totalDurationMinutes / 60.0;
          restraintSpots.add(FlSpot(x, restraintHours));

          currentCumulativeWorking += s.workingMinutes / 60.0;
          cumulativeWorkingSpots.add(FlSpot(x, currentCumulativeWorking));
        }

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
              children: [
                KpiCard(
                  label: '月総拘束時間',
                  value: _formatMinutes(totalRestraint),
                  icon: Icons.timer,
                ),
                KpiCard(
                  label: '月総実労働時間',
                  value: _formatMinutes(totalWorking),
                  icon: Icons.work,
                ),
                KpiCard(
                  label: '出勤日数',
                  value: '${sessions.length}日',
                  icon: Icons.event_available,
                ),
                KpiCard(
                  label: '平均拘束時間/日',
                  value: _formatMinutes(avgRestraint),
                  icon: Icons.timelapse,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('日別拘束時間', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}日',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}h',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                  ),
                  minX: 1,
                  maxX: 31,
                  minY: 0,
                  maxY: 24,
                  lineBarsData: [
                    LineChartBarData(
                      spots: restraintSpots,
                      isCurved: true,
                      color: Theme.of(context).colorScheme.primary,
                      barWidth: 3,
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 21,
                        color: Theme.of(context).colorScheme.error,
                        label: HorizontalLineLabel(
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          labelResolver: (line) => '21h',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('実労働時間累計', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 5,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}日',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        interval: 50,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            '${value.toInt()}',
                            style: Theme.of(context).textTheme.labelSmall,
                          );
                        },
                      ),
                    ),
                  ),
                  minX: 1,
                  maxX: 31,
                  minY: 0,
                  maxY: 300,
                  lineBarsData: [
                    LineChartBarData(
                      spots: cumulativeWorkingSpots,
                      color: Theme.of(context).colorScheme.secondary,
                      barWidth: 3,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        color: Theme.of(
                          context,
                        ).colorScheme.secondary.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                  extraLinesData: ExtraLinesData(
                    horizontalLines: [
                      HorizontalLine(
                        y: 262,
                        color: Theme.of(context).colorScheme.error,
                        label: HorizontalLineLabel(
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                          labelResolver: (line) => '262h',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
    );
  }
}
