import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../domain/models/app_settings.dart';
import '../../../providers/premium_purchase_provider.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class PremiumSection extends ConsumerWidget {
  final AppSettings settings;

  const PremiumSection({super.key, required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final purchaseState = ref.watch(premiumPurchaseControllerProvider);
    final isPremium =
        settings.isPremium ||
        purchaseState.status == PremiumPurchaseStatus.purchased;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'プレミアム'),
        SettingTile(
          leading: Icon(
            isPremium ? Icons.verified : Icons.workspace_premium_outlined,
            color: isPremium ? colorScheme.primary : null,
          ),
          title: '広告非表示',
          subtitle: isPremium
              ? '有効'
              : purchaseState.product != null
              ? '${purchaseState.product!.price}・買い切り'
              : '価格を確認しています',
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/premium'),
        ),
      ],
    );
  }
}
