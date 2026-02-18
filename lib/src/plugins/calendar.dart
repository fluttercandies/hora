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

void _requireIsoWeekday(String field, int value) {
  if (value < DateTime.monday || value > DateTime.sunday) {
    throw ArgumentError.value(
      value,
      field,
      'Expected ISO weekday in 1..7 (Monday..Sunday).',
    );
  }
}

bool _isAsciiLetterAround(String s, int index) {
  bool isLetter(int i) =>
      i >= 0 &&
      i < s.length &&
      ((s.codeUnitAt(i) >= 65 && s.codeUnitAt(i) <= 90) ||
          (s.codeUnitAt(i) >= 97 && s.codeUnitAt(i) <= 122));
  return isLetter(index - 1) || isLetter(index + 1);
}

String _compactLocalized(String format) =>
    format.replaceAll('MMMM', 'MMM').replaceAll('dddd', 'ddd');

/// Configuration for calendar formatting.
class CalendarConfig {
  const CalendarConfig({
    this.sameDay = '[Today at] LT',
    this.nextDay = '[Tomorrow at] LT',
    this.nextWeek = 'dddd [at] LT',
    this.lastDay = '[Yesterday at] LT',
    this.lastWeek = '[Last] dddd [at] LT',
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

  /// The first day of the week (1 = Monday, 7 = Sunday).
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
    final ref = referenceDate ??
        (isUtc ? Hora.nowUtc(locale: locale) : Hora.now(locale: locale));
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
    // Pre-process special calendar tokens into locale-aware format tokens.
    final formats = locale.formats;
    final buffer = StringBuffer();
    var i = 0;
    while (i < formatStr.length) {
      if (formatStr[i] == '[') {
        final closeIndex = formatStr.indexOf(']', i + 1);
        if (closeIndex == -1) {
          buffer.write(formatStr.substring(i));
          break;
        }
        buffer.write(formatStr.substring(i, closeIndex + 1));
        i = closeIndex + 1;
      } else if (formatStr.startsWith('LLLL', i)) {
        buffer.write(formats.llll);
        i += 4;
      } else if (formatStr.startsWith('LLL', i)) {
        buffer.write(formats.lll);
        i += 3;
      } else if (formatStr.startsWith('LTS', i)) {
        buffer.write(formats.lts);
        i += 3;
      } else if (formatStr.startsWith('LL', i)) {
        buffer.write(formats.ll);
        i += 2;
      } else if (formatStr.startsWith('LT', i)) {
        buffer.write(formats.lt);
        i += 2;
      } else if (formatStr.startsWith('L', i) &&
          !_isAsciiLetterAround(formatStr, i)) {
        buffer.write(formats.l);
        i++;
      } else if (formatStr.startsWith('llll', i)) {
        buffer.write(_compactLocalized(formats.llll));
        i += 4;
      } else if (formatStr.startsWith('lll', i)) {
        buffer.write(_compactLocalized(formats.lll));
        i += 3;
      } else if (formatStr.startsWith('ll', i)) {
        buffer.write(_compactLocalized(formats.ll));
        i += 2;
      } else if (formatStr.startsWith('l', i) &&
          !_isAsciiLetterAround(formatStr, i)) {
        buffer.write(_compactLocalized(formats.l));
        i++;
      } else {
        buffer.write(formatStr[i]);
        i++;
      }
    }

    return format(buffer.toString());
  }

  /// Generates a calendar for the current month.
  ///
  /// [firstDayOfWeek] uses ISO weekday values (1 = Monday, 7 = Sunday).
  MonthCalendar monthCalendar({int firstDayOfWeek = DateTime.monday}) {
    _requireIsoWeekday('firstDayOfWeek', firstDayOfWeek);

    final first = startOf(TemporalUnit.month);
    final last = endOf(TemporalUnit.month);

    // Calculate leading empty days
    final leadingDays = (first.weekday - firstDayOfWeek + 7) % 7;

    final weeks = <List<Hora?>>[];
    var currentWeek = <Hora?>[];

    // Fill leading nulls
    for (var i = 0; i < leadingDays; i++) {
      currentWeek.add(null);
    }

    // Fill days
    for (var day = 1; day <= last.day; day++) {
      currentWeek.add(
        Hora.of(
          year: year,
          month: month,
          day: day,
          utc: isUtc,
          locale: locale,
        ),
      );

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
  ///
  /// [firstDayOfWeek] uses ISO weekday values (1 = Monday, 7 = Sunday).
  YearCalendar yearCalendar({int firstDayOfWeek = DateTime.monday}) {
    final months = <MonthCalendar>[];

    for (var m = 1; m <= 12; m++) {
      final monthStart = Hora.of(
        year: year,
        month: m,
        utc: isUtc,
        locale: locale,
      );
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
    _requireIsoWeekday('weekday', weekday);

    var current = startOf(TemporalUnit.month);
    while (current.weekday != weekday) {
      current = current.add(1, TemporalUnit.day);
    }
    return current;
  }

  /// Gets the last occurrence of a weekday in the current month.
  Hora lastWeekdayInMonth(int weekday) {
    _requireIsoWeekday('weekday', weekday);

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
    _requireIsoWeekday('weekday', weekday);
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

  /// Checks if this is part of a "long" weekend (3+ consecutive non-working days).
  ///
  /// Without [isHoliday], a standard Saturday-Sunday weekend is only 2 days,
  /// so this always returns false. Provide [isHoliday] to include holidays
  /// (e.g., a Friday or Monday holiday creates a 3-day weekend).
  bool isLongWeekend({bool Function(Hora)? isHoliday}) {
    bool isNonWorking(Hora date) {
      if (date.isWeekend) return true;
      return isHoliday?.call(date) ?? false;
    }

    if (!isNonWorking(this)) return false;

    var count = 1;

    var next = add(1, TemporalUnit.day);
    while (isNonWorking(next)) {
      count++;
      if (count >= 3) return true;
      next = next.add(1, TemporalUnit.day);
    }

    var prev = subtract(1, TemporalUnit.day);
    while (isNonWorking(prev)) {
      count++;
      if (count >= 3) return true;
      prev = prev.subtract(1, TemporalUnit.day);
    }

    return false;
  }
}

/// Extension for calendar iteration.
extension CalendarIterationExt on Hora {
  /// Generates all months in the year.
  Iterable<Hora> get monthsInYear sync* {
    for (var m = 1; m <= 12; m++) {
      yield Hora.of(year: year, month: m, utc: isUtc, locale: locale);
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
    _requireIsoWeekday('weekday', weekday);

    final result = <Hora>[];
    var current = firstWeekdayInMonth(weekday);

    while (current.month == month) {
      result.add(current);
      current = current.add(7, TemporalUnit.day);
    }

    return result;
  }
}
