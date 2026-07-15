import 'package:flutter/material.dart';
import '../../core/theme/design_tokens.dart';

class KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? accentColor;

  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final defaultAccent = colorScheme.primary;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: AppIconSize.sm,
                    color: accentColor ?? defaultAccent,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    label,
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    value,
                    style: textTheme.headlineSmall?.copyWith(
                      color: colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
