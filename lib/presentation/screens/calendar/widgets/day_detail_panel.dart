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
import '../../../utils/number_format.dart';
import '../../../utils/shift_type_display.dart';
import 'daily_entry_sheet.dart';
import 'shift_override_sheet.dart';

class DayDetailPanel extends ConsumerWidget {
  const DayDetailPanel({super.key, required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateLabel = DateFormat('yyyy年M月d日 (E)', 'ja_JP').format(date);
    final shiftTypeAsync = ref.watch(shiftTypeForDateProvider(date));
    final sessionAsync = ref.watch(workSessionForDateProvider(date));
    final revenueAsync = ref.watch(revenueForDateProvider(date));
    final warningsAsync = ref.watch(sessionWarningsProvider(date));

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text(dateLabel, style: textTheme.titleMedium)),
              shiftTypeAsync.when(
                data: (type) => _ShiftBadge(shiftType: type),
                loading: () => const SizedBox.square(
                  dimension: AppIconSize.md,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                error: (_, _) =>
                    Icon(Icons.error_outline, color: colorScheme.error),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          sessionAsync.when(
            data: (session) {
              if (session == null) {
                return const _DetailStatusRow(
                  icon: Icons.schedule_outlined,
                  label: '勤務実績',
                  value: '未登録',
                  isEmpty: true,
                );
              }
              final start = DateFormat.Hm(
                'ja_JP',
              ).format(session.startDateTime);
              final end = DateFormat.Hm('ja_JP').format(session.endDateTime);
              return _DetailStatusRow(
                icon: Icons.schedule_outlined,
                label: '勤務実績',
                value: '$start - $end  休憩 ${session.restMinutes}分',
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const _DetailStatusRow(
              icon: Icons.error_outline,
              label: '勤務実績',
              value: '読み込めませんでした',
              isEmpty: true,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          revenueAsync.when(
            data: (revenue) {
              if (revenue == null) {
                return const _DetailStatusRow(
                  icon: Icons.payments_outlined,
                  label: '売上',
                  value: '未登録',
                  isEmpty: true,
                );
              }
              return _DetailStatusRow(
                icon: Icons.payments_outlined,
                label: '売上',
                value:
                    '${AppNumberFormat.currency(revenue.grossRevenue)}  ${revenue.ridesCount}回',
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (_, _) => const _DetailStatusRow(
              icon: Icons.error_outline,
              label: '売上',
              value: '読み込めませんでした',
              isEmpty: true,
            ),
          ),
          warningsAsync.when(
            data: (warnings) {
              if (warnings.isEmpty) return const SizedBox.shrink();
              return Padding(
                padding: const EdgeInsets.only(top: AppSpacing.md),
                child: Column(
                  children: warnings
                      .map((warning) => _WarningMessage(warning: warning))
                      .toList(),
                ),
              );
            },
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showShiftOverride(context),
                  icon: const Icon(Icons.edit_calendar_outlined),
                  label: const Text('シフト変更'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _showDailyEntry(context),
                  icon: const Icon(Icons.edit_note_outlined),
                  label: const Text('記録する'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showShiftOverride(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: (context) => ShiftOverrideSheet(date: date),
    );
  }

  Future<void> _showDailyEntry(BuildContext context) async {
    await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.md)),
      ),
      builder: (context) => DailyEntrySheet(date: date),
    );
  }
}

class _DetailStatusRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isEmpty;

  const _DetailStatusRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isEmpty = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          children: [
            Icon(icon, color: colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: isEmpty
                          ? colorScheme.onSurfaceVariant
                          : colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShiftBadge extends StatelessWidget {
  final ShiftType? shiftType;

  const _ShiftBadge({required this.shiftType});

  @override
  Widget build(BuildContext context) {
    if (shiftType == null) {
      return Text(
        '未設定',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      );
    }
    final colorScheme = Theme.of(context).colorScheme;
    final background = ShiftTypeDisplay.backgroundColor(shiftType, colorScheme);
    final foreground = ShiftTypeDisplay.foregroundColor(shiftType, colorScheme);

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        child: Text(
          ShiftTypeDisplay.fullLabel(shiftType),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _WarningMessage extends StatelessWidget {
  final ImprovementWarning warning;

  const _WarningMessage({required this.warning});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isCritical = warning.level == WarningLevel.critical;
    final background = isCritical
        ? colorScheme.errorContainer
        : colorScheme.tertiaryContainer;
    final foreground = isCritical
        ? colorScheme.onErrorContainer
        : colorScheme.onTertiaryContainer;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              Icon(Icons.warning_amber, color: foreground),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  warning.message,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: foreground),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
