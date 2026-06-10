import 'package:drift/drift.dart';

class DateOnlyConverter extends TypeConverter<DateTime, String> {
  const DateOnlyConverter();

  @override
  DateTime fromSql(String fromDb) {
    // Expected format: YYYY-MM-DD
    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(fromDb)) {
      throw FormatException(
        'Invalid date format (expected YYYY-MM-DD): $fromDb',
      );
    }
    return DateTime.parse(fromDb);
  }

  @override
  String toSql(DateTime value) {
    return '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';
  }
}
