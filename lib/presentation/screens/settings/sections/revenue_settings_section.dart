import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/providers/app_settings_controller.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../../../../../domain/models/app_settings.dart';
import '../widgets/number_input_dialog.dart';
import '../widgets/percentage_input_dialog.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class RevenueSettingsSection extends ConsumerWidget {
  final AppSettings settings;

  const RevenueSettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '売上'),
        SettingTile(
          title: '足切り額（税抜）',
          subtitle: '${settings.ashikiriAmount}円',
          trailing: const Icon(Icons.edit, size: AppIconSize.sm),
          onTap: () {
            showNumberInputDialog(
              context: context,
              title: '足切り額（税抜）',
              initialValue: settings.ashikiriAmount,
              suffixText: '円',
              onSaved: (val) => ref
                  .read(appSettingsControllerProvider.notifier)
                  .updateAshikiriAmount(val),
            );
          },
        ),
        SettingTile(
          title: '歩合率',
          subtitle: '${(settings.commissionRate * 100).toInt()}%',
          trailing: const Icon(Icons.edit, size: AppIconSize.sm),
          onTap: () {
            showPercentageInputDialog(
              context: context,
              title: '歩合率',
              initialRate: settings.commissionRate,
              onSaved: (val) => ref
                  .read(appSettingsControllerProvider.notifier)
                  .updateCommissionRate(val),
            );
          },
        ),
      ],
    );
  }
}
