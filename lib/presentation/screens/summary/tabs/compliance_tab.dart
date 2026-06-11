import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/improvement_warning.dart';
import '../../../providers/improvement_warnings_provider.dart';
import '../../../providers/selected_month_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../widgets/kpi_card.dart';

class ComplianceTab extends ConsumerWidget {
  const ComplianceTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthArg = ref.watch(selectedMonthProvider);
    final warningsAsync = ref.watch(monthlyWarningsProvider(monthArg));
    final sessionsAsync = ref.watch(workSessionsInMonthProvider(monthArg));

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return warningsAsync.when(
      data: (warnings) {
        final criticalCount = warnings
            .where((w) => w.level == WarningLevel.critical)
            .length;
        final warningCount = warnings
            .where((w) => w.level == WarningLevel.warning)
            .length;

        int totalRestraintMinutes = 0;
        sessionsAsync.whenData((sessions) {
          for (final s in sessions) {
            totalRestraintMinutes += s.totalDurationMinutes;
          }
        });

        final totalRestraintHours = totalRestraintMinutes / 60.0;
        final remaining262 = 262.0 - totalRestraintHours;
        final remaining270 = 270.0 - totalRestraintHours;

        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            // 数値表示
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppSpacing.sm,
              crossAxisSpacing: AppSpacing.sm,
              childAspectRatio: 1.5,
              children: [
                KpiCard(
                  label: '拘束時間合計',
                  value: '${totalRestraintHours.toStringAsFixed(1)}h',
                  icon: Icons.timelapse,
                ),
                KpiCard(
                  label: '262hまでの残り',
                  value: remaining262 >= 0
                      ? '${remaining262.toStringAsFixed(1)}h'
                      : '${(-remaining262).toStringAsFixed(1)}h超過',
                  icon: Icons.speed,
                  accentColor: remaining262 >= 0
                      ? colorScheme.primary
                      : colorScheme.error,
                ),
                KpiCard(
                  label: '270hまでの残り',
                  value: remaining270 >= 0
                      ? '${remaining270.toStringAsFixed(1)}h'
                      : '${(-remaining270).toStringAsFixed(1)}h超過',
                  icon: Icons.warning_amber,
                  accentColor: remaining270 >= 0
                      ? colorScheme.primary
                      : colorScheme.error,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),

            // サマリーカード
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('総警告件数', style: textTheme.labelMedium),
                        Text(
                          '${warnings.length}件',
                          style: textTheme.headlineSmall,
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Critical', style: textTheme.labelMedium),
                        Text(
                          '$criticalCount件',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.error,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text('Warning', style: textTheme.labelMedium),
                        Text(
                          '$warningCount件',
                          style: textTheme.headlineSmall?.copyWith(
                            color: colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            Text('警告一覧', style: textTheme.titleMedium),
            const SizedBox(height: AppSpacing.sm),

            if (warnings.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: AppIconSize.xl,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text('今月は問題ありません', style: textTheme.bodyLarge),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: warnings.length,
                itemBuilder: (context, index) {
                  final warning = warnings[index];
                  final isCritical = warning.level == WarningLevel.critical;
                  final badgeColor = isCritical
                      ? colorScheme.error
                      : colorScheme.tertiary;

                  return Card(
                    margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ListTile(
                      leading: Icon(
                        isCritical ? Icons.error : Icons.warning,
                        color: badgeColor,
                      ),
                      title: Text(warning.message, style: textTheme.bodyMedium),
                      subtitle: Text(
                        '${warning.targetDate != null ? DateFormat('MM/dd').format(warning.targetDate!) : '月次'} - ${warning.code}',
                        style: textTheme.bodySmall,
                      ),
                    ),
                  );
                },
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
