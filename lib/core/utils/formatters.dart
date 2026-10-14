import 'package:flutter/material.dart';

/// Tiny formatters so the project needs no `intl` dependency.
class Fmt {
  Fmt._();

  static const _months = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  /// 10 Aug 2026
  static String date(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

  /// Aug
  static String month(DateTime d) => _months[d.month - 1];

  /// 10 - 08 - 2026 (form field format)
  static String dateField(DateTime d) =>
      '${_two(d.day)} - ${_two(d.month)} - ${d.year}';

  /// 10:00 AM
  static String time(TimeOfDay t) {
    final h = t.hourOfPeriod == 0 ? 12 : t.hourOfPeriod;
    final p = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:${_two(t.minute)} $p';
  }

  static String _two(int n) => n.toString().padLeft(2, '0');
}
