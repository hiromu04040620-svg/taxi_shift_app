import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/providers/app_settings_controller.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../../../../../domain/models/app_settings.dart';
import '../widgets/number_input_dialog.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class WorkSettingsSection extends ConsumerWidget {
  final AppSettings settings;

  const WorkSettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(appSettingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '勤務'),
        SwitchListTile(
          title: const Text('改善基準告示の警告'),
          subtitle: const Text('拘束時間や休息期間の違反をチェックします'),
          value: settings.improvementStandardEnabled,
          onChanged: (val) {
            actions.updateImprovementStandardEnabled(val);
          },
        ),
        SettingTile(
          title: '月締め日',
          subtitle: '${settings.monthlyClosingDay}日',
          trailing: const Icon(Icons.edit, size: AppIconSize.sm),
          onTap: () {
            showNumberInputDialog(
              context: context,
              title: '月締め日',
              initialValue: settings.monthlyClosingDay,
              suffixText: '日',
              validator: (val) {
                if (val >= 1 && val <= 31) {
                  return null;
                }
                return '1から31の間で入力してください';
              },
              onSaved: (val) {
                actions.updateMonthlyClosingDay(val);
              },
            );
          },
        ),
        SettingTile(
          title: '月最大出番数',
          subtitle: '${settings.maxMonthlyShifts}出番',
          trailing: const Icon(Icons.edit, size: AppIconSize.sm),
          onTap: () {
            showNumberInputDialog(
              context: context,
              title: '月最大出番数',
              initialValue: settings.maxMonthlyShifts,
              suffixText: '出番',
              onSaved: (val) => actions.updateMaxMonthlyShifts(val),
            );
          },
        ),
        SettingTile(
          title: '月最大拘束時間',
          subtitle: '${settings.maxMonthlyRestraintHours}時間',
          trailing: const Icon(Icons.edit, size: AppIconSize.sm),
          onTap: () {
            showNumberInputDialog(
              context: context,
              title: '月最大拘束時間',
              initialValue: settings.maxMonthlyRestraintHours,
              suffixText: '時間',
              onSaved: (val) => actions.updateMaxMonthlyRestraintHours(val),
            );
          },
        ),
      ],
    );
  }
}
