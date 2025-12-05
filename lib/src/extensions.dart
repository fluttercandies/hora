import 'duration.dart';
import 'hora.dart';
import 'locale.dart';
import 'units.dart';

/// Extensions on [DateTime] for easy [Hora] conversion.
extension DateTimeToHora on DateTime {
  /// Converts this [DateTime] to a [Hora] instance.
  Hora toHora({HoraLocale? locale}) => Hora.fromDateTime(this, locale: locale);
}

/// Extensions on [int] for creating durations and timestamps.
extension IntToHora on int {
  /// Creates a [Hora] from this Unix timestamp in seconds.
  Hora get asUnixSeconds => Hora.unix(this);

  /// Creates a [Hora] from this Unix timestamp in milliseconds.
  Hora get asUnixMillis => Hora.unixMillis(this);

  /// Creates a [Hora] from this Unix timestamp in microseconds.
  Hora get asUnixMicros => Hora.unixMicros(this);

  /// Creates a duration of this many microseconds.
  HoraDuration get microseconds => HoraDuration.ofMilliseconds(this);

  /// Creates a duration of this many milliseconds.
  HoraDuration get milliseconds => HoraDuration.ofMilliseconds(this);

  /// Creates a duration of this many seconds.
  HoraDuration get seconds => HoraDuration.ofSeconds(this);

  /// Creates a duration of this many minutes.
  HoraDuration get minutes => HoraDuration.ofMinutes(this);

  /// Creates a duration of this many hours.
  HoraDuration get hours => HoraDuration.ofHours(this);

  /// Creates a duration of this many days.
  HoraDuration get days => HoraDuration.ofDays(this);

  /// Creates a duration of this many weeks.
  HoraDuration get weeks => HoraDuration.ofWeeks(this);

  /// Creates a duration of this many months.
  HoraDuration get months => HoraDuration.ofMonths(this);

  /// Creates a duration of this many years.
  HoraDuration get years => HoraDuration.ofYears(this);
}

/// Extensions on [String] for parsing dates.
extension StringToHora on String {
  /// Parses this string as a [Hora].
  Hora toHora({HoraLocale? locale}) => Hora.parse(this, locale: locale);

  /// Tries to parse this string as a [Hora], returns null if invalid.
  Hora? tryToHora({HoraLocale? locale}) => Hora.tryParse(this, locale: locale);

  /// Parses this string as an ISO 8601 duration.
  HoraDuration toHoraDuration() => HoraDuration.parse(this);

  /// Tries to parse this string as a duration, returns null if invalid.
  HoraDuration? tryToHoraDuration() => HoraDuration.tryParse(this);
}

/// Extensions on [Duration] for [HoraDuration] conversion.
extension DurationToHora on Duration {
  /// Converts this [Duration] to a [HoraDuration].
  HoraDuration toHoraDuration() => HoraDuration.fromDuration(this);
}

/// Extensions for relative time formatting.
extension HoraRelativeTimeExt on Hora {
  /// Returns a relative time string from now (e.g., "3 days ago" for past,
  /// "in 3 days" for future).
  String fromNow({bool withoutSuffix = false}) =>
      _relativeTime(Hora.now(), this, withoutSuffix);

  /// Returns a relative time string to now (e.g., "3 days ago" for future time,
  /// "in 3 days" for past time - inverse of [fromNow]).
  String toNow({bool withoutSuffix = false}) =>
      _relativeTime(this, Hora.now(), withoutSuffix);

  /// Returns a relative time string from another [Hora].
  String from(Hora other, {bool withoutSuffix = false}) =>
      _relativeTime(other, this, withoutSuffix);

  /// Returns a relative time string to another [Hora].
  String to(Hora other, {bool withoutSuffix = false}) =>
      _relativeTime(this, other, withoutSuffix);

  String _relativeTime(Hora from, Hora to, bool withoutSuffix) {
    final diff = to.difference(from);
    // diff is positive when 'to' is after 'from' (future relative to 'from')
    final isFuture = !diff.isNegative;
    final abs = diff.abs();
    final rel = locale.relativeTime;

    String text;
    if (abs.inSeconds < 45) {
      text = rel.s;
    } else if (abs.inSeconds < 90) {
      text = rel.m;
    } else if (abs.inMinutes < 45) {
      text = rel.mm.replaceAll('%d', abs.inMinutes.toString());
    } else if (abs.inMinutes < 90) {
      text = rel.h;
    } else if (abs.inHours < 22) {
      text = rel.hh.replaceAll('%d', abs.inHours.toString());
    } else if (abs.inHours < 36) {
      text = rel.d;
    } else if (abs.inDays < 26) {
      text = rel.dd.replaceAll('%d', abs.inDays.toString());
    } else if (abs.inDays < 46) {
      text = rel.mo;
    } else if (abs.inDays < 320) {
      text = rel.mos.replaceAll('%d', (abs.inDays / 30).round().toString());
    } else if (abs.inDays < 548) {
      text = rel.y;
    } else {
      text = rel.yy.replaceAll('%d', (abs.inDays / 365).round().toString());
    }

    if (withoutSuffix) return text;

    return isFuture
        ? rel.future.replaceAll('%s', text)
        : rel.past.replaceAll('%s', text);
  }
}

/// Extensions for calendar-style formatting.
extension HoraCalendarExt on Hora {
  /// Returns a calendar-style string relative to a reference date.
  ///
  /// Examples:
  /// - Same day: "Today at 2:30 PM"
  /// - Yesterday: "Yesterday at 2:30 PM"
  /// - Tomorrow: "Tomorrow at 2:30 PM"
  /// - This week: "Monday at 2:30 PM"
  /// - Last week: "Last Monday at 2:30 PM"
  /// - Else: "12/25/2023"
  String calendar({
    Hora? reference,
    CalendarFormats? formats,
  }) {
    reference ??= Hora.now();
    formats ??= const CalendarFormats();

    final refStartOfDay = reference.startOf(TemporalUnit.day);
    final diff = startOf(TemporalUnit.day).diff(refStartOfDay, TemporalUnit.day);

    String pattern;
    if (diff.toInt() == 0) {
      pattern = formats.sameDay;
    } else if (diff.toInt() == -1) {
      pattern = formats.lastDay;
    } else if (diff.toInt() == 1) {
      pattern = formats.nextDay;
    } else if (diff > -7 && diff < 0) {
      pattern = formats.lastWeek;
    } else if (diff > 0 && diff < 7) {
      pattern = formats.nextWeek;
    } else {
      pattern = formats.sameElse;
    }

    return format(pattern);
  }
}

/// Configuration for calendar-style formatting.
class CalendarFormats {
  const CalendarFormats({
    this.sameDay = '[Today at] LT',
    this.nextDay = '[Tomorrow at] LT',
    this.nextWeek = 'dddd [at] LT',
    this.lastDay = '[Yesterday at] LT',
    this.lastWeek = '[Last] dddd [at] LT',
    this.sameElse = 'L',
  });

  final String sameDay;
  final String nextDay;
  final String nextWeek;
  final String lastDay;
  final String lastWeek;
  final String sameElse;
}

/// Extensions for min/max operations.
extension HoraMinMaxExt on Iterable<Hora> {
  /// Returns the earliest (minimum) [Hora] in this iterable.
  Hora? get earliest {
    Hora? min;
    for (final h in this) {
      if (!h.isValid) continue;
      if (min == null || h.isBefore(min)) {
        min = h;
      }
    }
    return min;
  }

  /// Returns the latest (maximum) [Hora] in this iterable.
  Hora? get latest {
    Hora? max;
    for (final h in this) {
      if (!h.isValid) continue;
      if (max == null || h.isAfter(max)) {
        max = h;
      }
    }
    return max;
  }

  /// Returns the earliest and latest [Hora] as a range.
  (Hora?, Hora?) get range => (earliest, latest);
}

/// Extensions for generating date ranges.
extension HoraRangeExt on Hora {
  /// Generates a sequence of [Hora] from this to [end].
  ///
  /// [step] defaults to 1, [unit] defaults to days.
  Iterable<Hora> rangeTo(
    Hora end, {
    int step = 1,
    TemporalUnit unit = TemporalUnit.day,
  }) sync* {
    if (step <= 0) {
      throw ArgumentError.value(step, 'step', 'Must be positive');
    }

    final isForward = isBefore(end);
    var current = this;

    while (isForward ? !current.isAfter(end) : !current.isBefore(end)) {
      yield current;
      current = isForward
          ? current.add(step, unit)
          : current.subtract(step, unit);
    }
  }

  /// Generates [count] dates starting from this.
  Iterable<Hora> take(
    int count, {
    int step = 1,
    TemporalUnit unit = TemporalUnit.day,
  }) sync* {
    var current = this;
    for (var i = 0; i < count; i++) {
      yield current;
      current = current.add(step, unit);
    }
  }
}

/// Fluent API for building [Hora] instances.
extension HoraBuilderExt on Hora {
  /// Sets the year.
  Hora setYear(int value) => copyWith(year: value);

  /// Sets the month.
  Hora setMonth(int value) => copyWith(month: value);

  /// Sets the day.
  Hora setDay(int value) => copyWith(day: value);

  /// Sets the hour.
  Hora setHour(int value) => copyWith(hour: value);

  /// Sets the minute.
  Hora setMinute(int value) => copyWith(minute: value);

  /// Sets the second.
  Hora setSecond(int value) => copyWith(second: value);

  /// Sets the millisecond.
  Hora setMillisecond(int value) => copyWith(millisecond: value);

  /// Sets the microsecond.
  Hora setMicrosecond(int value) => copyWith(microsecond: value);

  /// Adds one year.
  Hora get nextYear => add(1, TemporalUnit.year);

  /// Subtracts one year.
  Hora get previousYear => subtract(1, TemporalUnit.year);

  /// Adds one month.
  Hora get nextMonth => add(1, TemporalUnit.month);

  /// Subtracts one month.
  Hora get previousMonth => subtract(1, TemporalUnit.month);

  /// Adds one week.
  Hora get nextWeek => add(1, TemporalUnit.week);

  /// Subtracts one week.
  Hora get previousWeek => subtract(1, TemporalUnit.week);

  /// Adds one day.
  Hora get nextDay => add(1, TemporalUnit.day);

  /// Subtracts one day.
  Hora get previousDay => subtract(1, TemporalUnit.day);

  /// The first day of this year.
  Hora get firstDayOfYear => startOf(TemporalUnit.year);

  /// The last day of this year.
  Hora get lastDayOfYear => endOf(TemporalUnit.year);

  /// The first day of this month.
  Hora get firstDayOfMonth => startOf(TemporalUnit.month);

  /// The last day of this month.
  Hora get lastDayOfMonth => endOf(TemporalUnit.month);

  /// The first day of this week.
  Hora get firstDayOfWeek => startOf(TemporalUnit.week);

  /// The last day of this week.
  Hora get lastDayOfWeek => endOf(TemporalUnit.week);
}
