import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/config/app_links.dart';
import '../../../../../core/theme/design_tokens.dart';
import '../widgets/setting_tile.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  Future<void> _openUri(
    BuildContext context,
    Uri uri,
    String failedMessage,
  ) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(failedMessage)));
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
          title: 'サポート',
          subtitle: 'お問い合わせ・よくある確認事項',
          trailing: const Icon(Icons.open_in_new, size: AppIconSize.sm),
          onTap: () => _openUri(context, AppLinks.support, 'サポートページを開けませんでした'),
        ),
        SettingTile(
          title: 'お問い合わせ',
          subtitle: 'メールで連絡',
          trailing: const Icon(Icons.mail_outline, size: AppIconSize.sm),
          onTap: () =>
              _openUri(context, AppLinks.supportEmail, 'メールアプリを開けませんでした'),
        ),
        SettingTile(
          title: 'プライバシーポリシー',
          trailing: const Icon(Icons.open_in_new, size: AppIconSize.sm),
          onTap: () =>
              _openUri(context, AppLinks.privacyPolicy, 'プライバシーポリシーを開けませんでした'),
        ),
        SettingTile(
          title: 'ライセンス',
          trailing: const Icon(Icons.arrow_forward_ios, size: AppIconSize.sm),
          onTap: () =>
              showLicensePage(context: context, applicationName: 'TaxiShift'),
        ),
      ],
    );
  }
}
