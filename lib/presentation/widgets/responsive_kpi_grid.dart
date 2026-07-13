import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';

class ResponsiveKpiGrid extends StatelessWidget {
  final List<Widget> children;

  const ResponsiveKpiGrid({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return GridView.extent(
      maxCrossAxisExtent: AppLayout.kpiMaxExtent,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.sm,
      crossAxisSpacing: AppSpacing.sm,
      childAspectRatio: AppLayout.kpiAspectRatio,
      children: children,
    );
  }
}
