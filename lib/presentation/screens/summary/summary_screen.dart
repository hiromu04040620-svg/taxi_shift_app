import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../providers/ads_provider.dart';
import '../../providers/selected_month_provider.dart';
import '../../utils/year_month_picker.dart';
import '../../widgets/banner_ad_widget.dart';
import 'tabs/compliance_tab.dart';
import 'tabs/revenue_tab.dart';
import 'tabs/work_tab.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({super.key});

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(selectedMonthProvider);
    final title = '${selectedMonth.year}年${selectedMonth.month}月';

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: InkWell(
            onTap: () async {
              final picked = await showYearMonthPicker(
                context: context,
                initial: selectedMonth,
              );
              if (picked != null) {
                ref.read(selectedMonthProvider.notifier).set(picked);
              }
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Text(title), const Icon(Icons.arrow_drop_down)],
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: '売上'),
              Tab(text: '勤務'),
              Tab(text: '法令'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [RevenueTab(), WorkTab(), ComplianceTab()],
        ),
        bottomNavigationBar: ref.watch(adsEnabledProvider)
            ? const BannerAdWidget()
            : null,
      ),
    );
  }
}
