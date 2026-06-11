import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../application/providers/services_provider.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/commission_config.dart';
import '../../../providers/app_settings_queries_provider.dart';
import '../../../providers/revenue_queries_provider.dart';
import '../../../providers/selected_month_provider.dart';
import '../../../widgets/kpi_card.dart';

class RevenueTab extends ConsumerWidget {
  const RevenueTab({super.key});

  BarChartGroupData _buildBarGroup(int x, int y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y.toDouble(),
          color: color,
          width: AppSpacing.lg,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppRadius.sm),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthArg = ref.watch(selectedMonthProvider);
    final summaryAsync = ref.watch(monthlySummaryProvider(monthArg));
    final settingsAsync = ref.watch(appSettingsProvider);

    return summaryAsync.when(
      data: (summary) {
        if (summary.totalShiftsCount == 0) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long,
                  size: AppIconSize.xl,
                  color: Colors.grey,
                ),
                SizedBox(height: AppSpacing.md),
                Text('まだ売上が記録されていません'),
              ],
            ),
          );
        }

        final numberFormat = NumberFormat('#,###');

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
                  label: '総営収',
                  value: '¥${numberFormat.format(summary.totalGrossRevenue)}',
                  icon: Icons.monetization_on,
                ),
                KpiCard(
                  label: '税抜営収',
                  value:
                      '¥${numberFormat.format(summary.totalTaxExcludedRevenue)}',
                  icon: Icons.account_balance_wallet,
                ),
                KpiCard(
                  label: '出番数',
                  value: '${summary.totalShiftsCount}日',
                  icon: Icons.calendar_today,
                ),
                KpiCard(
                  label: '平均営収/出番',
                  value:
                      '¥${numberFormat.format(summary.averageRevenuePerShift.round())}',
                  icon: Icons.analytics,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('内訳', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: const BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const titles = ['現金', 'カード', 'アプリ', 'チケット'];
                          final index = value.toInt();
                          if (index >= 0 && index < titles.length) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                top: AppSpacing.sm,
                              ),
                              child: Text(
                                titles[index],
                                style: Theme.of(context).textTheme.labelSmall,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(),
                    topTitles: const AxisTitles(),
                    rightTitles: const AxisTitles(),
                  ),
                  gridData: const FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    _buildBarGroup(
                      0,
                      summary.paymentBreakdown['cash'] ?? 0,
                      Theme.of(context).colorScheme.primary,
                    ),
                    _buildBarGroup(
                      1,
                      summary.paymentBreakdown['card'] ?? 0,
                      Theme.of(context).colorScheme.secondary,
                    ),
                    _buildBarGroup(
                      2,
                      summary.paymentBreakdown['app'] ?? 0,
                      Theme.of(context).colorScheme.tertiary,
                    ),
                    _buildBarGroup(
                      3,
                      summary.paymentBreakdown['ticket'] ?? 0,
                      Theme.of(context).colorScheme.error,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('実車率', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Column(
                  children: [
                    Text(
                      '${(summary.overallOccupancyRate * 100).toStringAsFixed(1)}%',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '総走行 ${summary.totalDistance.toStringAsFixed(1)}km / 実車 ${summary.totalOccupiedDistance.toStringAsFixed(1)}km',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('歩合試算', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),
            settingsAsync.when(
              data: (settings) {
                if (settings.commissionRate == 0.0) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Center(child: Text('歩合計算は未設定です')),
                    ),
                  );
                }

                final config = CommissionConfig(
                  ashikiriAmount: settings.ashikiriAmount,
                  commissionRate: settings.commissionRate,
                );
                final service = ref.read(revenueSummaryServiceProvider);
                final commissionResult = service.calculateCommission(
                  summary,
                  config,
                );

                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '足切りクリア',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                            Icon(
                              commissionResult.isAboveAshikiri
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: commissionResult.isAboveAshikiri
                                  ? Colors.green
                                  : Theme.of(context).colorScheme.error,
                            ),
                          ],
                        ),
                        const Divider(height: AppSpacing.xl),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('超過額'),
                            Text(
                              '¥${numberFormat.format(commissionResult.excessRevenue)}',
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '歩合金額',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '¥${numberFormat.format(commissionResult.commissionAmount)}',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('設定の読み込みに失敗しました: $err'),
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
