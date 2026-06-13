import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../../core/theme/design_tokens.dart';
import '../../../providers/shift_queries_provider.dart';
import '../../onboarding/widgets/cycle_preview.dart';
import '../widgets/cycle_type_change_dialog.dart';
import '../widgets/period_change_dialog.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class ShiftPatternSettingsSection extends ConsumerWidget {
  const ShiftPatternSettingsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final patternAsync = ref.watch(activeShiftPatternProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'シフトパターン'),
        patternAsync.when(
          data: (pattern) {
            if (pattern == null) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Text('アクティブなシフトパターンがありません'),
              );
            }

            final validFromStr = DateFormat.yMMMd(
              'ja_JP',
            ).format(pattern.validFrom);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '現在のサイクル: ${pattern.name}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      CyclePreview(
                        cycle: pattern.cycle,
                        startDate: pattern.startDate,
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                  ),
                ),
                SettingTile(
                  title: '開始日を変更',
                  subtitle: validFromStr,
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: AppIconSize.sm,
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) =>
                          PeriodChangeDialog(pattern: pattern),
                    );
                  },
                ),
                SettingTile(
                  title: 'サイクル種別を変更',
                  subtitle: pattern.name,
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: AppIconSize.sm,
                  ),
                  onTap: () {
                    showDialog<void>(
                      context: context,
                      builder: (context) =>
                          CycleTypeChangeDialog(pattern: pattern),
                    );
                  },
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Text('エラー: $err'),
        ),
      ],
    );
  }
}
