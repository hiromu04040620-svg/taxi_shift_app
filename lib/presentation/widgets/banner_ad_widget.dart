import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';

class BannerAdWidget extends StatelessWidget {
  const BannerAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return SafeArea(
      top: false,
      child: Material(
        color: colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              Icon(
                Icons.campaign_outlined,
                color: colorScheme.onSurfaceVariant,
                size: AppIconSize.md,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  '広告枠',
                  style: textTheme.labelLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Text(
                '広告非表示で非表示',
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
