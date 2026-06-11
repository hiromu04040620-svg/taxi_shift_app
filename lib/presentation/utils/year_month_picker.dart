import 'package:flutter/material.dart';

Future<({int year, int month})?> showYearMonthPicker({
  required BuildContext context,
  required ({int year, int month}) initial,
}) async {
  final picked = await showDatePicker(
    context: context,
    initialDate: DateTime(initial.year, initial.month),
    firstDate: DateTime(2020),
    lastDate: DateTime(2035, 12, 31),
    locale: const Locale('ja', 'JP'),
    helpText: '年月を選択',
    initialDatePickerMode: DatePickerMode.year,
  );
  if (picked == null) return null;
  return (year: picked.year, month: picked.month);
}
