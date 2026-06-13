import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../providers/app_settings_queries_provider.dart';

class PaywallSheet extends ConsumerWidget {
  const PaywallSheet({super.key, this.openedAfterSave = false});

  final bool openedAfterSave;

  void _showPurchasePreparingMessage(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('購入処理は App Store Connect の商品登録後に接続します')),
    );
  }

  Widget _buildBenefit(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: AppIconSize.md),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: textTheme.titleSmall),
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final isPremium = ref.watch(appSettingsProvider).value?.isPremium ?? false;
    final title = isPremium ? 'プレミアム有効' : '広告を非表示';
    final lead = openedAfterSave
        ? '記録が保存できました。よく使う画面の広告を非表示にできます。'
        : 'カレンダーとサマリーの広告を非表示にして、記録に集中できます。';

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Align(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppRadius.full),
                  ),
                  child: const SizedBox(
                    width: AppSpacing.xxl,
                    height: AppSpacing.xs,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Icon(
                isPremium ? Icons.verified : Icons.workspace_premium,
                color: colorScheme.primary,
                size: AppIconSize.xl,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                title,
                style: textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                lead,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    children: [
                      Text('買い切り予定', style: textTheme.labelLarge),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        '300円',
                        style: textTheme.headlineMedium?.copyWith(
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _buildBenefit(
                context,
                icon: Icons.block,
                title: '広告なし',
                description: 'カレンダーとサマリー下部のバナー広告を非表示にします。',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildBenefit(
                context,
                icon: Icons.speed,
                title: '毎日の記録を軽く',
                description: '記録、確認、振り返りの流れを邪魔しない画面にします。',
              ),
              const SizedBox(height: AppSpacing.md),
              _buildBenefit(
                context,
                icon: Icons.lock,
                title: 'データは端末内',
                description: '売上や勤務データの保存方針は無料版と同じです。',
              ),
              const SizedBox(height: AppSpacing.xl),
              if (isPremium)
                FilledButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.check),
                  label: const Text('閉じる'),
                )
              else ...[
                FilledButton.icon(
                  onPressed: () => _showPurchasePreparingMessage(context),
                  icon: const Icon(Icons.shopping_bag),
                  label: const Text('購入して広告を非表示'),
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton.icon(
                  onPressed: () => _showPurchasePreparingMessage(context),
                  icon: const Icon(Icons.restore),
                  label: const Text('購入を復元'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('あとで'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
