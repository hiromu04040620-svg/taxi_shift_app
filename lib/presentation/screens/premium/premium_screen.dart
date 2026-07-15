import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../providers/app_settings_queries_provider.dart';
import '../../providers/premium_purchase_provider.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider).value;
    final purchaseState = ref.watch(premiumPurchaseControllerProvider);
    final isPremium =
        settings?.isPremium == true ||
        purchaseState.status == PremiumPurchaseStatus.purchased;

    return Scaffold(
      appBar: AppBar(title: const Text('広告非表示')),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppLayout.contentMaxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _ProductHeader(
                    isPremium: isPremium,
                    purchaseState: purchaseState,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  const _BenefitRow(
                    icon: Icons.calendar_month_outlined,
                    title: 'カレンダーを広く表示',
                    description: '画面下部の広告枠を非表示にします。',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _BenefitRow(
                    icon: Icons.insights_outlined,
                    title: 'サマリーを見やすく',
                    description: '集計画面でも広告枠が表示されません。',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  const _BenefitRow(
                    icon: Icons.all_inclusive,
                    title: '一度の購入で継続利用',
                    description: '月額料金のない買い切りです。',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (purchaseState.message != null) ...[
                    _StatusMessage(
                      message: purchaseState.message!,
                      errorCode: purchaseState.errorCode,
                      isError:
                          purchaseState.errorCode != null ||
                          purchaseState.status == PremiumPurchaseStatus.error ||
                          purchaseState.status ==
                              PremiumPurchaseStatus.unavailable,
                    ),
                    const SizedBox(height: AppSpacing.md),
                  ],
                  if (!isPremium)
                    FilledButton.icon(
                      onPressed: purchaseState.canPurchase
                          ? () => ref
                                .read(
                                  premiumPurchaseControllerProvider.notifier,
                                )
                                .purchase()
                          : null,
                      icon:
                          purchaseState.status ==
                              PremiumPurchaseStatus.purchasing
                          ? const SizedBox.square(
                              dimension: AppIconSize.sm,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.shopping_bag_outlined),
                      label: Text(_purchaseButtonLabel(purchaseState)),
                    ),
                  if (!isPremium) const SizedBox(height: AppSpacing.sm),
                  OutlinedButton.icon(
                    onPressed:
                        purchaseState.status ==
                                PremiumPurchaseStatus.purchasing ||
                            purchaseState.status ==
                                PremiumPurchaseStatus.restoring
                        ? null
                        : () => ref
                              .read(premiumPurchaseControllerProvider.notifier)
                              .restore(),
                    icon:
                        purchaseState.status == PremiumPurchaseStatus.restoring
                        ? const SizedBox.square(
                            dimension: AppIconSize.sm,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.restore),
                    label: Text(
                      purchaseState.status == PremiumPurchaseStatus.restoring
                          ? '購入を復元中'
                          : '購入を復元',
                    ),
                  ),
                  if (!isPremium &&
                      (purchaseState.status == PremiumPurchaseStatus.error ||
                          purchaseState.status ==
                              PremiumPurchaseStatus.unavailable)) ...[
                    const SizedBox(height: AppSpacing.xs),
                    TextButton.icon(
                      onPressed: () => ref
                          .read(premiumPurchaseControllerProvider.notifier)
                          .reload(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('購入情報を再読み込み'),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '購入の確認と決済はApp Storeで行われます。購入済みの場合は「購入を復元」をお試しください。',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _purchaseButtonLabel(PremiumPurchaseState state) {
    if (state.status == PremiumPurchaseStatus.purchasing) {
      return '購入処理中';
    }
    if (state.canPurchase) return '広告非表示を購入';
    return '購入情報を確認中';
  }
}

class _ProductHeader extends StatelessWidget {
  final bool isPremium;
  final PremiumPurchaseState purchaseState;

  const _ProductHeader({required this.isPremium, required this.purchaseState});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: isPremium
              ? colorScheme.primaryContainer
              : colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Icon(
              isPremium ? Icons.verified : Icons.workspace_premium_outlined,
              size: AppIconSize.lg,
              color: isPremium
                  ? colorScheme.onPrimaryContainer
                  : colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('広告非表示', style: textTheme.headlineSmall),
              const SizedBox(height: AppSpacing.xs),
              Text(
                isPremium
                    ? '広告非表示は有効です'
                    : purchaseState.product != null
                    ? '${purchaseState.product!.price}・買い切り'
                    : 'App Storeから価格を取得しています',
                style: textTheme.titleMedium?.copyWith(
                  color: isPremium
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BenefitRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _BenefitRow({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleMedium),
              const SizedBox(height: AppSpacing.xs),
              Text(
                description,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusMessage extends StatelessWidget {
  final String message;
  final String? errorCode;
  final bool isError;

  const _StatusMessage({
    required this.message,
    required this.isError,
    this.errorCode,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: isError
          ? colorScheme.errorContainer
          : colorScheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.info_outline,
              color: isError
                  ? colorScheme.onErrorContainer
                  : colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isError
                          ? colorScheme.onErrorContainer
                          : colorScheme.onPrimaryContainer,
                    ),
                  ),
                  if (errorCode != null) ...[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      'エラーコード: $errorCode',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
