import 'package:flutter/material.dart';

import '../../core/theme/design_tokens.dart';

class ConstrainedListView extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  final double maxWidth;

  const ConstrainedListView({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(AppSpacing.md),
    this.maxWidth = AppLayout.summaryMaxWidth,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: ListView(padding: padding, children: children),
      ),
    );
  }
}
