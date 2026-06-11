import 'package:flutter/material.dart';

import '../../../../../core/theme/design_tokens.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class ShiftPatternSettingsSection extends StatelessWidget {
  const ShiftPatternSettingsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'シフトパターン'),
        SettingTile(
          title: 'シフトパターンを編集',
          subtitle: '基本の勤務サイクルを変更します',
          trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSize.sm),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('今後のアップデートで利用可能になります')),
            );
          },
        ),
      ],
    );
  }
}
