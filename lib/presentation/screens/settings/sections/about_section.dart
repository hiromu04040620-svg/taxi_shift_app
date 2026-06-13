import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_links.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  Future<void> _openPrivacyPolicy(BuildContext context) async {
    final opened = await launchUrl(
      AppLinks.privacyPolicy,
      mode: LaunchMode.externalApplication,
    );
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('プライバシーポリシーを開けませんでした')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'アプリ情報'),
        FutureBuilder<PackageInfo>(
          future: PackageInfo.fromPlatform(),
          builder: (context, snapshot) {
            final version = snapshot.data?.version ?? '';
            final buildNumber = snapshot.data?.buildNumber ?? '';
            final versionStr = version.isNotEmpty
                ? 'v$version ($buildNumber)'
                : '取得中...';

            return SettingTile(title: 'バージョン', subtitle: versionStr);
          },
        ),
        SettingTile(
          title: 'プライバシーポリシー',
          trailing: const Icon(Icons.open_in_new, size: AppIconSize.sm),
          onTap: () => _openPrivacyPolicy(context),
        ),
        SettingTile(
          title: 'ライセンス',
          trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSize.sm),
          onTap: () =>
              showLicensePage(context: context, applicationName: 'TaxiShift'),
        ),
        const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(
            child: Text(
              'This application is entirely authored by Antigravity and the user.',
              style: TextStyle(color: Colors.grey, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}
