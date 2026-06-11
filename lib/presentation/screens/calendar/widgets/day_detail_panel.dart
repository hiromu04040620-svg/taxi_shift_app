import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/design_tokens.dart';
import '../../../../domain/models/improvement_warning.dart';
import '../../../../domain/models/shift_type.dart';
import '../../../providers/improvement_warnings_provider.dart';
import '../../../providers/revenue_queries_provider.dart';
import '../../../providers/shift_queries_provider.dart';
import '../../../providers/work_session_queries_provider.dart';
import '../../../utils/shift_type_display.dart';
import 'shift_override_sheet.dart';

class DayDetailPanel extends ConsumerWidget {
  const DayDetailPanel({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    final dateLabel = DateFormat('yyyy年M月d日 (E)', 'ja_JP').format(date);

    // Watch providers
    final shiftTypeAsync = ref.watch(shiftTypeForDateProvider(date));
    final sessionAsync = ref.watch(workSessionForDateProvider(date));
    final revenueAsync = ref.watch(revenueForDateProvider(date));
    final warningsAsync = ref.watch(sessionWarningsProvider(date));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(dateLabel, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),

          // シフト種別バッジ
          shiftTypeAsync.when(
            data: (type) => _buildShiftBadge(context, type),
            loading: () => const LinearProgressIndicator(),
            error: (e, st) =>
                Text('エラー: $e', style: TextStyle(color: colorScheme.error)),
          ),
          const SizedBox(height: AppSpacing.md),

          // WorkSession 情報
          sessionAsync.when(
            data: (session) {
              if (session == null) {
                return Text('実績未登録', style: textTheme.bodyMedium);
              }
              final startStr = DateFormat.Hm(
                'ja_JP',
              ).format(session.startDateTime);
              final endStr = DateFormat.Hm('ja_JP').format(session.endDateTime);
              return Text(
                '出勤: $startStr  退勤: $endStr  休憩: ${session.restMinutes}分',
                style: textTheme.bodyMedium,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, st) =>
                Text('エラー: $e', style: TextStyle(color: colorScheme.error)),
          ),
          const SizedBox(height: AppSpacing.md),

          // Revenue 情報
          revenueAsync.when(
            data: (revenue) {
              if (revenue == null) {
                return Text('売上未登録', style: textTheme.bodyMedium);
              }
              return Text(
                '総営収: ￥${revenue.grossRevenue}  乗車回数: ${revenue.ridesCount}回',
                style: textTheme.bodyMedium,
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, st) =>
                Text('エラー: $e', style: TextStyle(color: colorScheme.error)),
          ),
          const SizedBox(height: AppSpacing.md),

          // 改善基準警告
          warningsAsync.when(
            data: (warnings) {
              if (warnings.isEmpty) return const SizedBox.shrink();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: warnings.map((w) {
                  final isWarning = w.level == WarningLevel.warning;
                  final bgColor = isWarning
                      ? colorScheme.errorContainer
                      : colorScheme.tertiaryContainer;
                  final fgColor = isWarning
                      ? colorScheme.onErrorContainer
                      : colorScheme.onTertiaryContainer;

                  return Card(
                    color: bgColor,
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.sm),
                      child: Text(
                        w.message,
                        style: textTheme.bodySmall?.copyWith(color: fgColor),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (e, st) => const SizedBox.shrink(),
          ),

          const SizedBox(height: AppSpacing.lg),

          // アクションボタン
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton.icon(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    useSafeArea: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(AppRadius.lg),
                      ),
                    ),
                    builder: (context) => ShiftOverrideSheet(date: date),
                  );
                },
                icon: const Icon(Icons.edit_calendar),
                label: const Text('シフト変更'),
              ),
              const FilledButton.tonal(onPressed: null, child: Text('実績入力')),
              const FilledButton.tonal(onPressed: null, child: Text('売上入力')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShiftBadge(BuildContext context, ShiftType? shiftType) {
    final textTheme = Theme.of(context).textTheme;
    if (shiftType == null) {
      return Text('シフト未設定', style: textTheme.bodyMedium);
    }
    final colorScheme = Theme.of(context).colorScheme;
    final bgColor = ShiftTypeDisplay.backgroundColor(shiftType, colorScheme);
    final fgColor = ShiftTypeDisplay.foregroundColor(shiftType, colorScheme);
    final label = ShiftTypeDisplay.fullLabel(shiftType);

    return Align(
      alignment: Alignment.centerLeft,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          child: Text(
            label,
            style: textTheme.labelMedium?.copyWith(
              color: fgColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
