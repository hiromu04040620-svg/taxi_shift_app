import 'package:intl/intl.dart';

class AppNumberFormat {
  AppNumberFormat._();

  static final _currencyFormat = NumberFormat.currency(
    locale: 'ja_JP',
    symbol: '¥',
    decimalDigits: 0,
  );

  static final _integerFormat = NumberFormat.decimalPattern('ja_JP');

  static final _distanceFormat = NumberFormat('#,##0.0', 'ja_JP');

  static String currency(int amount) => _currencyFormat.format(amount);

  static String distance(double km) => '${_distanceFormat.format(km)} km';

  static String integer(int value) => _integerFormat.format(value);

  static int? parseCurrency(String text) {
    if (text.isEmpty) return null;
    final clean = text.replaceAll(RegExp(r'[^0-9-]'), '');
    return int.tryParse(clean);
  }

  static double? parseDistance(String text) {
    if (text.isEmpty) return null;
    final clean = text.replaceAll(RegExp(r'[^0-9.-]'), '');
    return double.tryParse(clean);
  }
}
