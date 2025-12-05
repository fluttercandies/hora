/// Calendar plugin for Hora.
///
/// Provides calendar-style formatting and date generation.
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/calendar.dart';
///
/// final h = Hora.now();
///
/// // Calendar format
/// print(h.calendar()); // "Today at 2:30 PM"
///
/// // Reference another date
/// print(h.calendar(referenceDate: someOtherDate));
///
/// // Generate month calendar
/// final calendar = h.monthCalendar();
/// for (final week in calendar.weeks) {
///   print(week.map((d) => d?.day ?? '').join(' '));
/// }
/// ```
library;

import '../hora.dart';
import '../units.dart';

/// Configuration for calendar formatting.
class CalendarConfig {
  const CalendarConfig({
    this.sameDay = 'Today at LT',
    this.nextDay = 'Tomorrow at LT',
    this.nextWeek = 'dddd at LT',
    this.lastDay = 'Yesterday at LT',
    this.lastWeek = 'Last dddd at LT',
    this.sameElse = 'L',
  });

  /// Format for same day.
  final String sameDay;

  /// Format for next day.
  final String nextDay;

  /// Format for dates within the next week.
  final String nextWeek;

  /// Format for yesterday.
  final String lastDay;

  /// Format for dates within the last week.
  final String lastWeek;

  /// Format for all other dates.
  final String sameElse;

  /// Default configuration.
  static const defaultConfig = CalendarConfig();
}

/// Represents a calendar month with weeks.
class MonthCalendar {
  const MonthCalendar._({
    required this.year,
    required this.month,
    required this.weeks,
    required this.firstDayOfWeek,
  });

  /// The year.
  final int year;

  /// The month.
  final int month;

  /// The weeks of the calendar.
  /// Each week is a list of 7 dates (null for days outside the month).
  final List<List<Hora?>> weeks;

  /// The first day of the week (0 = Sunday, 1 = Monday).
  final int firstDayOfWeek;

  /// Gets all days of the month.
  List<Hora> get days => weeks.expand((w) => w.whereType<Hora>()).toList();

  /// Gets the number of weeks.
  int get weekCount => weeks.length;

  @override
  String toString() => 'MonthCalendar($year-$month, $weekCount weeks)';
}

/// Represents a year calendar with months.
class YearCalendar {
  const YearCalendar._({
    required this.year,
    required this.months,
  });

  /// The year.
  final int year;

  /// All months in the year.
  final List<MonthCalendar> months;

  /// Gets a specific month (1-12).
  MonthCalendar month(int m) => months[m - 1];

  @override
  String toString() => 'YearCalendar($year)';
}

/// Extension providing calendar functionality for Hora.
extension CalendarExt on Hora {
  /// Formats this date in calendar style relative to a reference date.
  String calendar({
    Hora? referenceDate,
    CalendarConfig config = CalendarConfig.defaultConfig,
  }) {
    final ref = referenceDate ?? Hora.now(locale: locale);
    final diffDays = startOf(TemporalUnit.day)
        .diff(ref.startOf(TemporalUnit.day), TemporalUnit.day)
        .toInt();

    String formatStr;
    if (diffDays == 0) {
      formatStr = config.sameDay;
    } else if (diffDays == 1) {
      formatStr = config.nextDay;
    } else if (diffDays == -1) {
      formatStr = config.lastDay;
    } else if (diffDays > 1 && diffDays < 7) {
      formatStr = config.nextWeek;
    } else if (diffDays < -1 && diffDays > -7) {
      formatStr = config.lastWeek;
    } else {
      formatStr = config.sameElse;
    }

    return _formatCalendar(formatStr);
  }

  String _formatCalendar(String formatStr) {
    // Handle special tokens
    var result = formatStr;

    // LT = localized time
    result = result.replaceAll('LT', format('h:mm A'));

    // L = localized date
    result = result.replaceAll('L', format('MM/DD/YYYY'));

    // dddd = weekday name
    result = result.replaceAll('dddd', format('dddd'));

    return result;
  }

  /// Generates a calendar for the current month.
  MonthCalendar monthCalendar({int firstDayOfWeek = 0}) {
    final first = startOf(TemporalUnit.month);
    final last = endOf(TemporalUnit.month);

    // Adjust first day's weekday based on firstDayOfWeek
    var firstWeekday = first.weekday - firstDayOfWeek;
    if (firstWeekday < 0) firstWeekday += 7;

    final weeks = <List<Hora?>>[];
    var currentWeek = <Hora?>[];

    // Fill leading nulls
    for (var i = 0; i < firstWeekday; i++) {
      currentWeek.add(null);
    }

    // Fill days
    for (var day = 1; day <= last.day; day++) {
      currentWeek.add(Hora.of(
        year: year,
        month: month,
        day: day,
        locale: locale,
      ),);

      if (currentWeek.length == 7) {
        weeks.add(currentWeek);
        currentWeek = [];
      }
    }

    // Fill trailing nulls
    if (currentWeek.isNotEmpty) {
      while (currentWeek.length < 7) {
        currentWeek.add(null);
      }
      weeks.add(currentWeek);
    }

    return MonthCalendar._(
      year: year,
      month: month,
      weeks: weeks,
      firstDayOfWeek: firstDayOfWeek,
    );
  }

  /// Generates a calendar for the entire year.
  YearCalendar yearCalendar({int firstDayOfWeek = 0}) {
    final months = <MonthCalendar>[];

    for (var m = 1; m <= 12; m++) {
      final monthStart = Hora.of(year: year, month: m, locale: locale);
      months.add(monthStart.monthCalendar(firstDayOfWeek: firstDayOfWeek));
    }

    return YearCalendar._(year: year, months: months);
  }

  /// Gets all days in the current month.
  List<Hora> get daysOfMonth {
    final first = startOf(TemporalUnit.month);
    final days = daysInMonth;
    return List.generate(days, (i) => first.add(i, TemporalUnit.day));
  }

  /// Gets all days in the current year.
  List<Hora> get daysOfYear {
    final first = startOf(TemporalUnit.year);
    final isLeap = isLeapYear;
    final days = isLeap ? 366 : 365;
    return List.generate(days, (i) => first.add(i, TemporalUnit.day));
  }

  /// Gets the first occurrence of a weekday in the current month.
  Hora firstWeekdayInMonth(int weekday) {
    var current = startOf(TemporalUnit.month);
    while (current.weekday != weekday) {
      current = current.add(1, TemporalUnit.day);
    }
    return current;
  }

  /// Gets the last occurrence of a weekday in the current month.
  Hora lastWeekdayInMonth(int weekday) {
    var current = endOf(TemporalUnit.month);
    while (current.weekday != weekday) {
      current = current.subtract(1, TemporalUnit.day);
    }
    return current;
  }

  /// Gets the nth occurrence of a weekday in the current month.
  ///
  /// [n] can be positive (1 = first, 2 = second, etc.)
  /// or negative (-1 = last, -2 = second to last, etc.)
  Hora? nthWeekdayInMonth(int weekday, int n) {
    if (n == 0) return null;

    if (n > 0) {
      var current = firstWeekdayInMonth(weekday);
      for (var i = 1; i < n; i++) {
        current = current.add(7, TemporalUnit.day);
        if (current.month != month) return null;
      }
      return current;
    } else {
      var current = lastWeekdayInMonth(weekday);
      for (var i = -1; i > n; i--) {
        current = current.subtract(7, TemporalUnit.day);
        if (current.month != month) return null;
      }
      return current;
    }
  }

  /// Checks if this is a "long" weekend (3+ consecutive non-working days).
  bool get isLongWeekend {
    // Simple check: Friday + Saturday + Sunday
    // This could be enhanced with holiday calendars
    if (weekday == DateTime.friday) {
      return true;
    }
    if (weekday == DateTime.saturday || weekday == DateTime.sunday) {
      // Check if Friday was part of it (public holiday logic would go here)
      return false;
    }
    return false;
  }
}

/// Extension for calendar iteration.
extension CalendarIterationExt on Hora {
  /// Generates all months in the year.
  Iterable<Hora> get monthsInYear sync* {
    for (var m = 1; m <= 12; m++) {
      yield Hora.of(year: year, month: m, locale: locale);
    }
  }

  /// Generates dates between this and another date.
  Iterable<Hora> daysUntil(Hora end, {bool inclusive = true}) sync* {
    var current = this;
    final target = inclusive ? end.add(1, TemporalUnit.day) : end;

    while (current.isBefore(target)) {
      yield current;
      current = current.add(1, TemporalUnit.day);
    }
  }

  /// Generates months between this and another date.
  Iterable<Hora> monthsUntil(Hora end) sync* {
    var current = startOf(TemporalUnit.month);
    final target = end.startOf(TemporalUnit.month);

    while (!current.isAfter(target)) {
      yield current;
      current = current.add(1, TemporalUnit.month);
    }
  }

  /// Gets all Sundays in the current month.
  List<Hora> get sundaysInMonth => weekdaysInMonth(DateTime.sunday);

  /// Gets all Saturdays in the current month.
  List<Hora> get saturdaysInMonth => weekdaysInMonth(DateTime.saturday);

  /// Gets all occurrences of a weekday in the current month.
  List<Hora> weekdaysInMonth(int weekday) {
    final result = <Hora>[];
    var current = firstWeekdayInMonth(weekday);

    while (current.month == month) {
      result.add(current);
      current = current.add(7, TemporalUnit.day);
    }

    return result;
  }
}
