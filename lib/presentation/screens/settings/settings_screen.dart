import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/design_tokens.dart';
import '../../providers/ad_runtime_provider.dart';
import '../../providers/app_settings_queries_provider.dart';
import '../../widgets/constrained_list_view.dart';
import 'sections/about_section.dart';
import 'sections/ad_privacy_section.dart';
import 'sections/data_management_section.dart';
import 'sections/premium_section.dart';
import 'sections/revenue_settings_section.dart';
import 'sections/shift_pattern_settings_section.dart';
import 'sections/theme_settings_section.dart';
import 'sections/work_settings_section.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appSettingsAsync = ref.watch(appSettingsProvider);
    final privacyOptionsRequired = ref.watch(
      adRuntimeControllerProvider.select(
        (runtime) => runtime.privacyOptionsRequired,
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: appSettingsAsync.when(
        data: (settings) {
          return ConstrainedListView(
            maxWidth: AppLayout.contentMaxWidth,
            padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
            children: [
              ThemeSettingsSection(settings: settings),
              const Divider(),
              PremiumSection(settings: settings),
              if (privacyOptionsRequired) ...[
                const Divider(),
                const AdPrivacySection(),
              ],
              const Divider(),
              WorkSettingsSection(settings: settings),
              const Divider(),
              RevenueSettingsSection(settings: settings),
              const Divider(),
              const ShiftPatternSettingsSection(),
              const Divider(),
              const DataManagementSection(),
              const Divider(),
              const AboutSection(),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
      ),
    );
  }
}
