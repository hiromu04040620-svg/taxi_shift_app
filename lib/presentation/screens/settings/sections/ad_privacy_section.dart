import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../providers/ad_runtime_provider.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class AdPrivacySection extends ConsumerWidget {
  const AdPrivacySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final runtime = ref.watch(adRuntimeControllerProvider);
    if (!runtime.privacyOptionsRequired) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'プライバシー'),
        SettingTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: '広告のプライバシー設定',
          subtitle: '広告に関する同意内容を確認・変更します',
          trailing: const Icon(Icons.chevron_right),
          onTap: runtime.status == AdRuntimeStatus.loading
              ? null
              : () => ref
                    .read(adRuntimeControllerProvider.notifier)
                    .showPrivacyOptions(),
        ),
      ],
    );
  }
}
