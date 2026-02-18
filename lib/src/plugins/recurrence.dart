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
    if (count != null && count! <= 0) return null;
    if (count != null && n >= count!) return null;
    if (end != null && start.isAfter(end!)) return null;
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

  static void validateInterval(int interval) {
    if (interval <= 0) {
      throw ArgumentError.value(
        interval,
        'interval',
        'Must be greater than 0.',
      );
    }
  }

  static void validateCount(int? count) {
    if (count != null && count < 0) {
      throw ArgumentError.value(
        count,
        'count',
        'Must be greater than or equal to 0.',
      );
    }
  }

  static void validateWeekdays(
    Iterable<int> weekdays, {
    required String field,
  }) {
    for (final day in weekdays) {
      if (day < DateTime.monday || day > DateTime.sunday) {
        throw ArgumentError.value(day, field, 'Weekday must be in 1..7.');
      }
    }
  }
}

class _DailyRecurrence extends Recurrence {
  _DailyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
    this.excludeWeekdays,
  }) : super._() {
    Recurrence.validateInterval(interval);
    Recurrence.validateCount(count);
    if (excludeWeekdays != null) {
      Recurrence.validateWeekdays(excludeWeekdays!, field: 'excludeWeekdays');
      if (excludeWeekdays!.length >= 7) {
        throw ArgumentError.value(
          excludeWeekdays,
          'excludeWeekdays',
          'Cannot exclude all weekdays; recurrence would never advance.',
        );
      }
    }
  }

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
    if (date.isSame(start, TemporalUnit.day)) return true;

    var current = start;
    var guard = 0;
    while (current.isBefore(date)) {
      final nextDate = next(current);
      if (nextDate == null) return false;
      if (!nextDate.isAfter(current)) {
        throw StateError(
          'Daily recurrence must move forward. Current: $current, next: $nextDate.',
        );
      }
      current = nextDate;
      if (++guard > 100000) {
        throw StateError(
          'Daily recurrence matching exceeded iteration guard. '
          'Start: $start, target: $date.',
        );
      }
    }

    return current.isSame(date, TemporalUnit.day);
  }
}

class _WeeklyRecurrence extends Recurrence {
  _WeeklyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
    this.daysOfWeek = const {DateTime.monday},
  }) : super._() {
    Recurrence.validateInterval(interval);
    Recurrence.validateCount(count);
    if (daysOfWeek.isEmpty) {
      throw ArgumentError('daysOfWeek must not be empty');
    }
    Recurrence.validateWeekdays(daysOfWeek, field: 'daysOfWeek');
  }

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
    if (date.isSame(start, TemporalUnit.day)) return true;
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
        super._() {
    Recurrence.validateInterval(interval);
    Recurrence.validateCount(count);
    if (this.dayOfMonth < 1 || this.dayOfMonth > 31) {
      throw ArgumentError.value(
        this.dayOfMonth,
        'dayOfMonth',
        'Must be in 1..31.',
      );
    }
    final hasWeekdayRule = weekdayOrdinal != null || weekday != null;
    if (hasWeekdayRule) {
      if (weekdayOrdinal == null || weekday == null) {
        throw ArgumentError(
          'weekdayOrdinal and weekday must be provided together.',
        );
      }
      if (weekdayOrdinal == 0 || weekdayOrdinal! < -5 || weekdayOrdinal! > 5) {
        throw ArgumentError.value(
          weekdayOrdinal,
          'weekdayOrdinal',
          'Must be in -5..-1 or 1..5.',
        );
      }
      Recurrence.validateWeekdays([weekday!], field: 'weekday');
    }
  }

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
    var monthCursor = current;

    while (true) {
      final nextMonth = monthCursor.add(interval, TemporalUnit.month);
      final candidate = switch ((weekdayOrdinal, weekday)) {
        (final int _, final int _) =>
          _findNthWeekdayOrNull(nextMonth.year, nextMonth.month),
        _ => _withStartTime(
            _dayOfMonthInMonth(nextMonth.year, nextMonth.month, dayOfMonth),
          ),
      };

      if (candidate == null || !candidate.isAfter(current)) {
        monthCursor = nextMonth;
        if (end != null &&
            monthCursor.startOf(TemporalUnit.month).isAfter(end!)) {
          return null;
        }
        continue;
      }

      if (end != null && candidate.isAfter(end!)) return null;
      return candidate;
    }
  }

  Hora? _findNthWeekdayOrNull(int year, int month) {
    final firstOfMonth = Hora.of(
      year: year,
      month: month,
      utc: start.isUtc,
      locale: start.locale,
    );
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
      date = date.subtract((-weekdayOrdinal! - 1) * 7, TemporalUnit.day);
    }

    if (date.month != month) return null;
    return _withStartTime(date);
  }

  Hora _dayOfMonthInMonth(int year, int month, int targetDay) {
    final daysInMonth = Hora.of(year: year, month: month).daysInMonth;
    final day = targetDay > daysInMonth ? daysInMonth : targetDay;
    return Hora.of(
      year: year,
      month: month,
      day: day,
      utc: start.isUtc,
      locale: start.locale,
    );
  }

  Hora _withStartTime(Hora date) => date.copyWith(
        hour: start.hour,
        minute: start.minute,
        second: start.second,
        millisecond: start.millisecond,
        microsecond: start.microsecond,
        utc: start.isUtc,
      );

  @override
  bool matches(Hora date) {
    if (date.isBefore(start)) return false;
    if (end != null && date.isAfter(end!)) return false;
    if (date.isSame(start, TemporalUnit.day)) return true;

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
  _YearlyRecurrence({
    required this.start,
    this.end,
    this.count,
    this.interval = 1,
  }) : super._() {
    Recurrence.validateInterval(interval);
    Recurrence.validateCount(count);
  }

  @override
  final Hora start;

  @override
  final Hora? end;

  @override
  final int? count;

  final int interval;

  @override
  Hora? next(Hora current) {
    final targetYear = current.year + interval;
    var targetDay = start.day;
    if (start.month == 2 && start.day == 29) {
      targetDay = Hora.of(year: targetYear, month: 2).isLeapYear ? 29 : 28;
    } else {
      final daysInTargetMonth =
          Hora.of(year: targetYear, month: start.month).daysInMonth;
      if (targetDay > daysInTargetMonth) {
        targetDay = daysInTargetMonth;
      }
    }

    final next = Hora.of(
      year: targetYear,
      month: start.month,
      day: targetDay,
      hour: start.hour,
      minute: start.minute,
      second: start.second,
      millisecond: start.millisecond,
      microsecond: start.microsecond,
      utc: start.isUtc,
      locale: start.locale,
    );

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
  _CustomRecurrence({
    required this.start,
    required this.generator,
    this.end,
    this.count,
  }) : super._() {
    Recurrence.validateCount(count);
  }

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
    var iterations = 0;
    for (final occurrence in this) {
      if (occurrence.isAfter(date)) return false;
      if (occurrence.isSame(date, TemporalUnit.day)) return true;
      if (++iterations > 10000) return false;
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
    if (_recurrence.count != null && _recurrence.count! <= 0) {
      return false;
    }
    if (_recurrence.end != null &&
        _recurrence.start.isAfter(_recurrence.end!)) {
      return false;
    }

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
    if (!next.isAfter(_current)) {
      throw StateError(
        'Recurrence must generate strictly increasing occurrences. '
        'Current: $_current, next: $next.',
      );
    }

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
