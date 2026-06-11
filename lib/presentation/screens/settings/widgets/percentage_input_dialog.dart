import 'package:flutter/material.dart';

import 'number_input_dialog.dart';

Future<void> showPercentageInputDialog({
  required BuildContext context,
  required String title,
  required double initialRate,
  required ValueChanged<double> onSaved,
}) async {
  final initialPercentage = (initialRate * 100).toInt();

  await showNumberInputDialog(
    context: context,
    title: title,
    initialValue: initialPercentage,
    suffixText: '%',
    onSaved: (val) {
      onSaved(val / 100.0);
    },
    validator: (val) {
      if (val < 0 || val > 100) {
        return '0から100の間で入力してください';
      }
      return null;
    },
  );
}
