import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../application/providers/app_settings_controller.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../../../../../domain/models/app_settings.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class ThemeSettingsSection extends ConsumerWidget {
  final AppSettings settings;

  const ThemeSettingsSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actions = ref.read(appSettingsControllerProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: '外観'),
        SettingTile(
          title: 'テーマ',
          subtitle: _themeModeString(settings.themeMode),
          trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSize.sm),
          onTap: () async {
            final result = await showDialog<ThemeMode>(
              context: context,
              builder: (context) => SimpleDialog(
                title: const Text('テーマを選択'),
                children: [
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, ThemeMode.system),
                    child: const Text('端末の設定に従う'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, ThemeMode.light),
                    child: const Text('ライト'),
                  ),
                  SimpleDialogOption(
                    onPressed: () => Navigator.pop(context, ThemeMode.dark),
                    child: const Text('ダーク'),
                  ),
                ],
              ),
            );
            if (result != null) {
              await actions.updateThemeMode(result);
            }
          },
        ),
      ],
    );
  }

  String _themeModeString(ThemeMode mode) {
    switch (mode) {
      case ThemeMode.light:
        return 'ライト';
      case ThemeMode.dark:
        return 'ダーク';
      case ThemeMode.system:
        return '端末の設定に従う';
    }
  }
}
