/// Recurrence plugin for Hora.
///
/// Provides support for recurring date patterns like
/// "every Monday", "first of every month", "every 2 weeks".
///
/// ## Usage
///
/// ```dart
/// import 'package:hora/hora.dart';
/// import 'package:hora/src/plugins/recurrence.dart';
///
/// // Daily recurrence
/// final daily = Recurrence.daily(start: Hora.now());
/// print(daily.take(5).toList());
///
/// // Weekly recurrence (every Monday and Friday)
/// final weekly = Recurrence.weekly(
///   start: Hora.now(),
///   daysOfWeek: [DateTime.monday, DateTime.friday],
/// );
///
/// // Monthly recurrence (15th of each month)
/// final monthly = Recurrence.monthly(start: Hora.now(), dayOfMonth: 15);
///
/// // Custom recurrence pattern
/// final custom = Recurrence.custom(
///   start: Hora.now(),
///   generator: (current) => current.add(3, TemporalUnit.day),
/// );
/// ```
library;

import '../hora.dart';
import '../units.dart';

/// Represents a recurrence rule for generating date sequences.
abstract class Recurrence extends Iterable<Hora> {
  const Recurrence._();

  /// The starting date for the recurrence.
  Hora get start;

  /// The ending date for the recurrence (optional).
  Hora? get end;

  /// The maximum number of occurrences (optional).
  int? get count;

  /// Generates the next occurrence after the given date.
  Hora? next(Hora current);

  /// Creates a daily recurrence.
  static Recurrence daily({
    required Hora start,
    Hora? end,
    int? count,
    int interval = 1,
    Set<int>? excludeWeekdays,
  }) =>
      _DailyRecurrence(
        start: start,
        end: end,
        count: count,
        interval: interval,
        excludeWeekdays: excludeWeekdays,
      );

  /// Creates a weekly recurrence.
  static Recurrence weekly({
    required Hora start,
    Hora? end,
    int? count,
    int interval = 1,
    Set<int> daysOfWeek = const {DateTime.monday},
  }) =>
      _WeeklyRecurrence(
        start: start,
        end: end,
        count: count,
        interval: interval,
        daysOfWeek: daysOfWeek,
      );

  /// Creates a monthly recurrence.
  static Recurrence monthly({
    required Hora start,
    Hora? end,
    int? count,
    int interval = 1,
    int? dayOfMonth,
    int? weekdayOrdinal,
    int? weekday,
  }) =>
      _MonthlyRecurrence(
        start: start,
        end: end,
        count: count,
        interval: interval,
        dayOfMonth: dayOfMonth,
        weekdayOrdinal: weekdayOrdinal,
        weekday: weekday,
      );

  /// Creates a yearly recurrence.
  static Recurrence yearly({
    required Hora start,
    Hora? end,
    int? count,
    int interval = 1,
  }) =>
      _YearlyRecurrence(
        start: start,
        end: end,
        count: count,
        interval: interval,
      );

  /// Creates a custom recurrence with a generator function.
  static Recurrence custom({
    required Hora start,
    required Hora? Function(Hora current) generator,
    Hora? end,
    int? count,
  }) =>
      _CustomRecurrence(
        start: start,
        generator: generator,
        end: end,
        count: count,
      );

  @override
  Iterator<Hora> get iterator => _RecurrenceIterator(this);

  /// Gets the nth occurrence (0-indexed).
  Hora? occurrence(int n) {
    if (n < 0) return null;
    var current = start;
    for (var i = 0; i < n; i++) {
      final next = this.next(current);
      if (next == null) return null;
      current = next;
    }
    return current;
  }

  /// Checks if a date matches this recurrence pattern.
  bool matches(Hora date);

  /// Gets all occurrences within a date range.
  List<Hora> between(Hora rangeStart, Hora rangeEnd) {
    final results = <Hora>[];
    for (final date in this) {
      if (date.isAfter(rangeEnd)) break;
      if (!date.isBefore(rangeStart)) {
        results.add(date);
      }
    }
    return results;
  }
}

class _DailyRecurrence extends Recurrence {
  const _DailyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
    this.excludeWeekdays,
  }) : super._();

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final int interval;
  final Set<int>? excludeWeekdays;

  @override
  Hora? next(Hora current) {
    var next = current.add(interval, TemporalUnit.day);

    if (excludeWeekdays != null) {
      while (excludeWeekdays!.contains(next.weekday)) {
        next = next.add(1, TemporalUnit.day);
      }
    }

    if (end != null && next.isAfter(end!)) return null;
    return next;
  }

  @override
  bool matches(Hora date) {
    if (date.isBefore(start)) return false;
    if (end != null && date.isAfter(end!)) return false;
    if (excludeWeekdays?.contains(date.weekday) ?? false) return false;

    final daysDiff = date.diff(start, TemporalUnit.day).toInt();
    return daysDiff % interval == 0;
  }
}

class _WeeklyRecurrence extends Recurrence {
  const _WeeklyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
    this.daysOfWeek = const {DateTime.monday},
  }) : super._();

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final int interval;
  final Set<int> daysOfWeek;

  @override
  Hora? next(Hora current) {
    var next = current;

    // Find the next matching day of week
    do {
      next = next.add(1, TemporalUnit.day);
    } while (!daysOfWeek.contains(next.weekday));

    // Skip weeks according to interval
    final weeksDiff = next.diff(start, TemporalUnit.week).toInt();
    if (interval > 1 && weeksDiff % interval != 0) {
      final weeksToAdd = interval - (weeksDiff % interval);
      next = next.add(weeksToAdd * 7, TemporalUnit.day);
      // Re-adjust to first matching day in that week
      while (!daysOfWeek.contains(next.weekday)) {
        next = next.add(1, TemporalUnit.day);
      }
    }

    if (end != null && next.isAfter(end!)) return null;
    return next;
  }

  @override
  bool matches(Hora date) {
    if (date.isBefore(start)) return false;
    if (end != null && date.isAfter(end!)) return false;
    if (!daysOfWeek.contains(date.weekday)) return false;

    final weeksDiff = date.diff(start, TemporalUnit.week).toInt();
    return weeksDiff % interval == 0;
  }
}

class _MonthlyRecurrence extends Recurrence {
  _MonthlyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
    int? dayOfMonth,
    this.weekdayOrdinal,
    this.weekday,
  })  : dayOfMonth = dayOfMonth ?? start.day,
        super._();

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final int interval;
  final int dayOfMonth;
  final int? weekdayOrdinal;
  final int? weekday;

  @override
  Hora? next(Hora current) {
    var nextMonth = current.add(interval, TemporalUnit.month);

    if (weekdayOrdinal != null && weekday != null) {
      // Find nth weekday of month
      nextMonth = _findNthWeekday(nextMonth.year, nextMonth.month);
    } else {
      // Use specific day of month
      final daysInMonth =
          Hora.of(year: nextMonth.year, month: nextMonth.month).daysInMonth;
      final targetDay = dayOfMonth > daysInMonth ? daysInMonth : dayOfMonth;
      nextMonth = Hora.of(
        year: nextMonth.year,
        month: nextMonth.month,
        day: targetDay,
        locale: start.locale,
      );
    }

    if (end != null && nextMonth.isAfter(end!)) return null;
    return nextMonth;
  }

  Hora _findNthWeekday(int year, int month) {
    final firstOfMonth =
        Hora.of(year: year, month: month, locale: start.locale);
    var date = firstOfMonth;

    // Find first occurrence of the weekday
    while (date.weekday != weekday) {
      date = date.add(1, TemporalUnit.day);
    }

    // Add weeks for nth occurrence
    if (weekdayOrdinal! > 0) {
      date = date.add((weekdayOrdinal! - 1) * 7, TemporalUnit.day);
    } else {
      // Negative ordinal means from end of month
      final lastOfMonth = firstOfMonth.endOf(TemporalUnit.month);
      date = lastOfMonth;
      while (date.weekday != weekday) {
        date = date.subtract(1, TemporalUnit.day);
      }
      date = date.add((weekdayOrdinal! + 1) * 7, TemporalUnit.day);
    }

    return date;
  }

  @override
  bool matches(Hora date) {
    if (date.isBefore(start)) return false;
    if (end != null && date.isAfter(end!)) return false;

    if (weekdayOrdinal != null && weekday != null) {
      if (date.weekday != weekday) return false;
      final firstOfMonth = date.startOf(TemporalUnit.month);
      final weekOfMonth = ((date.day - 1) ~/ 7) + 1;
      if (weekdayOrdinal! > 0) {
        if (weekOfMonth != weekdayOrdinal) return false;
      } else {
        final weeksFromEnd = (firstOfMonth.daysInMonth - date.day) ~/ 7;
        if (weeksFromEnd != (-weekdayOrdinal! - 1)) return false;
      }
    } else {
      final daysInMonth = date.daysInMonth;
      final expectedDay = dayOfMonth > daysInMonth ? daysInMonth : dayOfMonth;
      if (date.day != expectedDay) return false;
    }

    final monthsDiff = date.diff(start, TemporalUnit.month).toInt();
    return monthsDiff % interval == 0;
  }
}

class _YearlyRecurrence extends Recurrence {
  const _YearlyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
  }) : super._();

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final int interval;

  @override
  Hora? next(Hora current) {
    var next = current.add(interval, TemporalUnit.year);

    // Handle Feb 29 for non-leap years
    if (start.month == 2 && start.day == 29) {
      if (!next.isLeapYear) {
        next = Hora.of(
          year: next.year,
          month: 2,
          day: 28,
          hour: next.hour,
          minute: next.minute,
          second: next.second,
          locale: start.locale,
        );
      }
    }

    if (end != null && next.isAfter(end!)) return null;
    return next;
  }

  @override
  bool matches(Hora date) {
    if (date.isBefore(start)) return false;
    if (end != null && date.isAfter(end!)) return false;

    if (date.month != start.month) return false;
    if (start.month == 2 && start.day == 29) {
      if (date.day != (date.isLeapYear ? 29 : 28)) return false;
    } else {
      if (date.day != start.day) return false;
    }

    final yearsDiff = date.year - start.year;
    return yearsDiff % interval == 0;
  }
}

class _CustomRecurrence extends Recurrence {
  const _CustomRecurrence({
    required this.start,
    required this.generator,
    this.end,
    this.count,
  }) : super._();

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final Hora? Function(Hora current) generator;

  @override
  Hora? next(Hora current) {
    final next = generator(current);
    if (next == null) return null;
    if (end != null && next.isAfter(end!)) return null;
    return next;
  }

  @override
  bool matches(Hora date) {
    for (final occurrence in this) {
      if (occurrence.isAfter(date)) return false;
      if (occurrence.isSame(date, TemporalUnit.day)) return true;
    }
    return false;
  }
}

class _RecurrenceIterator implements Iterator<Hora> {
  _RecurrenceIterator(this._recurrence);

  final Recurrence _recurrence;
  late Hora _current;
  int _generated = 0;
  bool _started = false;

  @override
  Hora get current => _current;

  @override
  bool moveNext() {
    if (!_started) {
      _current = _recurrence.start;
      _started = true;
      _generated = 1;
      return true;
    }

    if (_recurrence.count != null && _generated >= _recurrence.count!) {
      return false;
    }

    final next = _recurrence.next(_current);
    if (next == null) return false;

    _current = next;
    _generated++;
    return true;
  }
}

/// Extension providing recurrence-related utilities for Hora.
extension RecurrenceExt on Hora {
  /// Creates a daily recurrence starting from this date.
  Recurrence daily({
    Hora? end,
    int? count,
    int interval = 1,
    Set<int>? excludeWeekdays,
  }) =>
      Recurrence.daily(
        start: this,
        end: end,
        count: count,
        interval: interval,
        excludeWeekdays: excludeWeekdays,
      );

  /// Creates a weekly recurrence starting from this date.
  Recurrence weekly({
    Hora? end,
    int? count,
    int interval = 1,
    Set<int>? daysOfWeek,
  }) =>
      Recurrence.weekly(
        start: this,
        end: end,
        count: count,
        interval: interval,
        daysOfWeek: daysOfWeek ?? {weekday},
      );

  /// Creates a monthly recurrence starting from this date.
  Recurrence monthly({
    Hora? end,
    int? count,
    int interval = 1,
    int? dayOfMonth,
  }) =>
      Recurrence.monthly(
        start: this,
        end: end,
        count: count,
        interval: interval,
        dayOfMonth: dayOfMonth,
      );

  /// Creates a yearly recurrence starting from this date.
  Recurrence yearly({
    Hora? end,
    int? count,
    int interval = 1,
  }) =>
      Recurrence.yearly(
        start: this,
        end: end,
        count: count,
        interval: interval,
      );

  /// Gets the next occurrence that matches a filter.
  Hora? nextMatching(bool Function(Hora) filter, {int maxDays = 365}) {
    var current = this;
    for (var i = 0; i < maxDays; i++) {
      current = current.add(1, TemporalUnit.day);
      if (filter(current)) return current;
    }
    return null;
  }

  /// Gets the previous occurrence that matches a filter.
  Hora? previousMatching(bool Function(Hora) filter, {int maxDays = 365}) {
    var current = this;
    for (var i = 0; i < maxDays; i++) {
      current = current.subtract(1, TemporalUnit.day);
      if (filter(current)) return current;
    }
    return null;
  }
}
