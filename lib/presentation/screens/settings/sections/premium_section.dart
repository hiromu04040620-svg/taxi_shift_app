import 'package:flutter/material.dart';

import '../../../../../core/theme/design_tokens.dart';
import '../../paywall/paywall_sheet.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class PremiumSection extends StatelessWidget {
  const PremiumSection({super.key, required this.isPremium});

  final bool isPremium;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'プレミアム'),
        SettingTile(
          leading: Icon(
            isPremium ? Icons.verified : Icons.workspace_premium,
            color: Theme.of(context).colorScheme.primary,
          ),
          title: isPremium ? '広告非表示は有効です' : '広告を非表示',
          subtitle: isPremium ? 'カレンダーとサマリーの広告は表示されません' : '買い切り予定 300円',
          trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSize.sm),
          onTap: () {
            showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              useSafeArea: true,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              builder: (context) => const PaywallSheet(),
            );
          },
        ),
      ],
    );
  }
}
