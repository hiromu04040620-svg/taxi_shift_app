import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/premium_config.dart';
import '../../providers/app_settings_queries_provider.dart';
import 'sections/about_section.dart';
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

    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: appSettingsAsync.when(
        data: (settings) {
          return ListView(
            children: [
              ThemeSettingsSection(settings: settings),
              const Divider(),
              WorkSettingsSection(settings: settings),
              const Divider(),
              RevenueSettingsSection(settings: settings),
              const Divider(),
              if (PremiumConfig.monetizationEnabled) ...[
                PremiumSection(isPremium: settings.isPremium),
                const Divider(),
              ],
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
