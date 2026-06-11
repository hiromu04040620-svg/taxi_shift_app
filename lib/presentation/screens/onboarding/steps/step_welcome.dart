import 'package:flutter/material.dart';

import '../../../../core/theme/design_tokens.dart';

class StepWelcome extends StatelessWidget {
  const StepWelcome({super.key, required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_taxi,
              size: AppIconSize.xl * 2,
              color: colorScheme.primary,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'TaxiShift へようこそ',
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'まずは勤務サイクルを設定しましょう',
              style: textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(onPressed: onNext, child: const Text('はじめる')),
          ],
        ),
      ),
    );
  }
}
